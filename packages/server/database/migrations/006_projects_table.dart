import 'dart:developer';

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
  String get tablePrefix => 'tt_';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration006ProjectsTable');

      // 创建项目表
      await createTable('projects', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          name VARCHAR(200) NOT NULL,
          description TEXT,
          owner_id INTEGER NOT NULL,
          is_public BOOLEAN DEFAULT false,
          is_active BOOLEAN DEFAULT true,
          settings JSONB,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey('projects_owner_id', 'projects', 'owner_id', 'users', 'id');

      // 创建索引
      await createIndex('projects_owner_id', 'projects', 'owner_id');
      await createIndex('projects_is_public', 'projects', 'is_public');
      await createIndex('projects_is_active', 'projects', 'is_active');
      await createIndex('projects_created_at', 'projects', 'created_at');

      // 为项目表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_tt_projects_updated_at 
          BEFORE UPDATE ON tt_projects 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('projects', '项目表，存储翻译项目信息');
      await addColumnComment('projects', 'id', '项目ID，主键');
      await addColumnComment('projects', 'name', '项目名称');
      await addColumnComment('projects', 'description', '项目描述');
      await addColumnComment('projects', 'owner_id', '项目所有者ID，外键关联users表');
      await addColumnComment('projects', 'is_public', '是否公开');
      await addColumnComment('projects', 'is_active', '是否激活');
      await addColumnComment('projects', 'settings', '项目设置，JSON格式');
      await addColumnComment('projects', 'created_at', '创建时间');
      await addColumnComment('projects', 'updated_at', '更新时间');

      log('迁移完成: $name', name: 'Migration006ProjectsTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration006ProjectsTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration006ProjectsTable');

      // 删除项目表
      await dropTable('projects');

      log('回滚完成: $name', name: 'Migration006ProjectsTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration006ProjectsTable');
      rethrow;
    }
  }
}
