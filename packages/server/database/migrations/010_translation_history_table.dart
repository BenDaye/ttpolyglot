import 'package:ttpolyglot_model/model.dart';

import 'base_migration.dart';

/// 迁移: 010 - 创建翻译历史表（按时间分区）
/// 创建时间: 2024-12-26
/// 更新时间: 2025-10-31
/// 描述: 创建翻译历史表，存储翻译历史记录，按月分区以提升查询性能
class Migration010TranslationHistoryTable extends BaseMigration {
  @override
  String get name => '010_translation_history_table';

  @override
  String get description => '创建翻译历史表（按时间分区），存储翻译历史记录';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      ServerLogger.info('开始执行迁移: $name');

      final tableName = '${tablePrefix}translation_history';

      // 创建翻译历史分区表
      ServerLogger.info('创建翻译历史分区表: $tableName');
      await connection.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          id BIGSERIAL,
          entry_id INTEGER NOT NULL,
          entry_uuid UUID,
          project_id INTEGER NOT NULL,
          old_target_text TEXT,
          new_target_text TEXT NOT NULL,
          old_status VARCHAR(20),
          new_status VARCHAR(20),
          action VARCHAR(20) NOT NULL,
          changed_by UUID NOT NULL,
          changed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          reason TEXT,
          metadata JSONB,
          
          PRIMARY KEY (id, changed_at)
        ) PARTITION BY RANGE (changed_at);
      ''');

      // 创建分区（从 2025年10月 到 2026年4月，共7个月）
      final partitions = [
        {'year': 2025, 'month': 10},
        {'year': 2025, 'month': 11},
        {'year': 2025, 'month': 12},
        {'year': 2026, 'month': 1},
        {'year': 2026, 'month': 2},
        {'year': 2026, 'month': 3},
        {'year': 2026, 'month': 4},
      ];

      for (final partition in partitions) {
        final year = partition['year'] as int;
        final month = partition['month'] as int;
        final nextMonth = month == 12 ? 1 : month + 1;
        final nextYear = month == 12 ? year + 1 : year;

        final partitionName = '${tableName}_${year}_${month.toString().padLeft(2, '0')}';
        final monthStr = month.toString().padLeft(2, '0');
        final nextMonthStr = nextMonth.toString().padLeft(2, '0');

        ServerLogger.info('创建分区: $partitionName');
        await connection.execute('''
          CREATE TABLE IF NOT EXISTS $partitionName 
          PARTITION OF $tableName
          FOR VALUES FROM ('$year-$monthStr-01') TO ('$nextYear-$nextMonthStr-01');
        ''');
      }

      // 创建外键约束
      await addForeignKey(
          'translation_history_entry_id', 'translation_history', 'entry_id', 'translation_entries', 'id',
          onDelete: 'CASCADE');
      await addForeignKey('translation_history_changed_by', 'translation_history', 'changed_by', 'users', 'id');

      // 创建索引
      await createIndex('translation_history_entry_id', 'translation_history', 'entry_id, changed_at DESC');
      await createIndex('translation_history_entry_uuid', 'translation_history', 'entry_uuid, changed_at DESC');
      await createIndex('translation_history_project_id', 'translation_history', 'project_id, changed_at DESC');
      await createIndex('translation_history_changed_by', 'translation_history', 'changed_by');
      await createIndex('translation_history_action', 'translation_history', 'action');

      // 添加表注释
      await addTableComment('translation_history', '翻译历史表（按时间分区），存储翻译历史记录');
      await addColumnComment('translation_history', 'id', '历史记录ID');
      await addColumnComment('translation_history', 'entry_id', '翻译条目ID，外键关联translation_entries表');
      await addColumnComment('translation_history', 'entry_uuid', '翻译条目UUID，用于关联');
      await addColumnComment('translation_history', 'project_id', '项目ID，冗余字段便于查询');
      await addColumnComment('translation_history', 'old_target_text', '旧的目标文本');
      await addColumnComment('translation_history', 'new_target_text', '新的目标文本');
      await addColumnComment('translation_history', 'old_status', '旧的翻译状态');
      await addColumnComment('translation_history', 'new_status', '新的翻译状态');
      await addColumnComment('translation_history', 'action', '操作类型：create/update/delete/review等');
      await addColumnComment('translation_history', 'changed_by', '修改者ID，外键关联users表');
      await addColumnComment('translation_history', 'changed_at', '修改时间（分区键）');
      await addColumnComment('translation_history', 'reason', '修改原因');
      await addColumnComment('translation_history', 'metadata', '元数据，JSON格式，存储额外信息');

      ServerLogger.info('迁移完成: $name');
    } catch (error, stackTrace) {
      ServerLogger.error('迁移失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      ServerLogger.info('开始回滚迁移: $name');

      // 删除所有分区（PostgreSQL 会自动级联删除分区）
      // 删除翻译历史表
      await dropTable('translation_history');

      ServerLogger.info('回滚完成: $name');
    } catch (error, stackTrace) {
      ServerLogger.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
