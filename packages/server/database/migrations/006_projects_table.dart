import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

import 'base_migration.dart';

/// 迁移: 006 - 创建项目表
/// 创建时间: 2024-12-26
/// 描述: 创建项目表，存储翻译项目信息
class Migration006ProjectsTable extends BaseMigration {
  @override
  String get name => '006_projects_table';

  @override
  String get description => '创建项目表，存储翻译项目信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建项目表
      await createTable('projects', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          name VARCHAR(200) NOT NULL,
          slug VARCHAR(200) NOT NULL UNIQUE,
          description TEXT,
          owner_id UUID NOT NULL,
          status VARCHAR(50) DEFAULT 'active',
          visibility VARCHAR(50) DEFAULT 'private',
          primary_language_id INTEGER,
          total_keys INTEGER DEFAULT 0,
          translated_keys INTEGER DEFAULT 0,
          languages_count INTEGER DEFAULT 0,
          members_count INTEGER DEFAULT 1,
          member_limit INTEGER DEFAULT 10 NOT NULL CHECK (member_limit > 0 AND member_limit <= 1000),
          is_public BOOLEAN DEFAULT false,
          is_active BOOLEAN DEFAULT true,
          settings JSONB,
          last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey('projects_owner_id', 'projects', 'owner_id', 'users', 'id');

      // 创建外键约束（语言）
      await addForeignKey('projects_primary_language_id', 'projects', 'primary_language_id', 'languages', 'id',
          onDelete: 'SET NULL');

      // 创建索引
      await createIndex('projects_slug', 'projects', 'slug');
      await createIndex('projects_owner_id', 'projects', 'owner_id');
      await createIndex('projects_status', 'projects', 'status');
      await createIndex('projects_visibility', 'projects', 'visibility');
      await createIndex('projects_primary_language_id', 'projects', 'primary_language_id');
      await createIndex('projects_is_public', 'projects', 'is_public');
      await createIndex('projects_is_active', 'projects', 'is_active');
      await createIndex('projects_last_activity_at', 'projects', 'last_activity_at');
      await createIndex('projects_created_at', 'projects', 'created_at');

      // 为项目表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}projects_updated_at 
          BEFORE UPDATE ON ${tablePrefix}projects 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('projects', '项目表，存储翻译项目信息');
      await addColumnComment('projects', 'id', '项目ID，主键');
      await addColumnComment('projects', 'name', '项目名称');
      await addColumnComment('projects', 'slug', '项目唯一标识符，用于URL');
      await addColumnComment('projects', 'description', '项目描述');
      await addColumnComment('projects', 'owner_id', '项目所有者ID，外键关联users表');
      await addColumnComment('projects', 'status', '项目状态：active/archived/paused');
      await addColumnComment('projects', 'visibility', '可见性：private/public/team');
      await addColumnComment('projects', 'primary_language_id', '主语言ID，外键关联languages表');
      await addColumnComment('projects', 'total_keys', '总翻译条目数');
      await addColumnComment('projects', 'translated_keys', '已翻译条目数');
      await addColumnComment('projects', 'languages_count', '语言数量');
      await addColumnComment('projects', 'members_count', '成员数量');
      await addColumnComment('projects', 'member_limit', '成员上限，范围1-1000，默认10');
      await addColumnComment('projects', 'is_public', '是否公开（废弃，使用visibility）');
      await addColumnComment('projects', 'is_active', '是否激活');
      await addColumnComment('projects', 'settings', '项目设置，JSON格式');
      await addColumnComment('projects', 'last_activity_at', '最后活动时间');
      await addColumnComment('projects', 'created_at', '创建时间');
      await addColumnComment('projects', 'updated_at', '更新时间');

      LoggerUtils.info('迁移完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('迁移失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      LoggerUtils.info('开始回滚迁移: $name');

      // 删除项目表
      await dropTable('projects');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
