import 'dart:developer';

import 'package:ttpolyglot_model/model.dart';

import 'base_migration.dart';

/// 迁移: 021 - 创建项目翻译统计缓存表
/// 创建时间: 2025-10-31
/// 描述: 创建项目翻译统计缓存表，用于存储预计算的项目统计数据，提升查询性能
class Migration021ProjectTranslationStatsTable extends BaseMigration {
  @override
  String get name => '021_project_translation_stats_table';

  @override
  String get description => '创建项目翻译统计缓存表，用于存储预计算的项目统计数据';

  @override
  String get createdAt => '2025-10-31';

  @override
  Future<void> up() async {
    try {
      ServerLogger.info('开始执行迁移: $name');

      // 创建项目翻译统计表
      await createTable('project_translation_stats', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          project_id INTEGER PRIMARY KEY,
          total_entries INTEGER DEFAULT 0,
          pending_count INTEGER DEFAULT 0,
          completed_count INTEGER DEFAULT 0,
          reviewing_count INTEGER DEFAULT 0,
          approved_count INTEGER DEFAULT 0,
          
          total_source_chars BIGINT DEFAULT 0,
          total_target_chars BIGINT DEFAULT 0,
          
          -- 按语言统计（JSON格式）
          stats_by_language JSONB DEFAULT '{}'::jsonb,
          
          -- 进度百分比
          completion_rate DECIMAL(5,2) DEFAULT 0.00,
          
          last_updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          
          CONSTRAINT valid_completion_rate CHECK (completion_rate >= 0 AND completion_rate <= 100),
          CONSTRAINT fk_pts_project FOREIGN KEY (project_id) REFERENCES ${tablePrefix}projects(id) ON DELETE CASCADE
        );
      ''');

      // 创建索引
      await createIndex('pts_completion_rate', 'project_translation_stats', 'completion_rate');
      await createIndex('pts_updated_at', 'project_translation_stats', 'last_updated_at');

      // 为 JSONB stats_by_language 字段创建 GIN 索引
      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_pts_stats_by_language 
        ON ${tablePrefix}project_translation_stats 
        USING GIN (stats_by_language);
      ''');

      // 创建触发器函数：当翻译条目变更时通知更新统计
      await connection.execute('''
        CREATE OR REPLACE FUNCTION notify_project_stats_update()
        RETURNS TRIGGER AS \$\$
        BEGIN
          -- 使用 pg_notify 通知应用层更新统计
          PERFORM pg_notify('project_stats_update', 
            json_build_object('project_id', COALESCE(NEW.project_id, OLD.project_id))::text
          );
          RETURN COALESCE(NEW, OLD);
        END;
        \$\$ LANGUAGE plpgsql;
      ''');

      // 创建触发器：在翻译条目变更时触发
      await connection.execute('''
        CREATE TRIGGER trigger_notify_project_stats_update
          AFTER INSERT OR UPDATE OR DELETE ON ${tablePrefix}translation_entries
          FOR EACH ROW
          EXECUTE FUNCTION notify_project_stats_update();
      ''');

      // 添加表注释
      await addTableComment('project_translation_stats', '项目翻译统计缓存表，存储预计算的统计数据');
      await addColumnComment('project_translation_stats', 'project_id', '项目ID，主键，外键关联projects表');
      await addColumnComment('project_translation_stats', 'total_entries', '总条目数');
      await addColumnComment('project_translation_stats', 'pending_count', '待翻译条目数');
      await addColumnComment('project_translation_stats', 'completed_count', '已完成条目数');
      await addColumnComment('project_translation_stats', 'reviewing_count', '审核中条目数');
      await addColumnComment('project_translation_stats', 'approved_count', '已批准条目数');
      await addColumnComment('project_translation_stats', 'total_source_chars', '源文本总字符数');
      await addColumnComment('project_translation_stats', 'total_target_chars', '目标文本总字符数');
      await addColumnComment('project_translation_stats', 'stats_by_language', '按语言统计的详细数据，JSON格式');
      await addColumnComment('project_translation_stats', 'completion_rate', '完成率百分比（0-100）');
      await addColumnComment('project_translation_stats', 'last_updated_at', '最后更新时间');

      ServerLogger.info('迁移完成: $name');
    } catch (error, stackTrace) {
      log('[Migration021ProjectTranslationStatsTable]',
          error: error, stackTrace: stackTrace, name: 'Migration021ProjectTranslationStatsTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      ServerLogger.info('开始回滚迁移: $name');

      // 删除触发器
      await connection.execute('''
        DROP TRIGGER IF EXISTS trigger_notify_project_stats_update 
        ON ${tablePrefix}translation_entries;
      ''');

      // 删除触发器函数
      await connection.execute('''
        DROP FUNCTION IF EXISTS notify_project_stats_update();
      ''');

      // 删除项目翻译统计表
      await dropTable('project_translation_stats');

      ServerLogger.info('回滚完成: $name');
    } catch (error, stackTrace) {
      log('[Migration021ProjectTranslationStatsTable]',
          error: error, stackTrace: stackTrace, name: 'Migration021ProjectTranslationStatsTable');
      rethrow;
    }
  }
}
