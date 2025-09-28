import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 008 - 创建项目语言关联表
/// 创建时间: 2024-12-26
/// 描述: 创建项目语言关联表，存储项目和语言的关联关系
class Migration008ProjectLanguagesTable extends BaseMigration {
  @override
  String get name => '008_project_languages_table';

  @override
  String get description => '创建项目语言关联表，存储项目和语言的关联关系';

  @override
  String get createdAt => '2024-12-26';

  @override
  String get tablePrefix => 'tt_';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration008ProjectLanguagesTable');

      // 创建项目语言关联表
      await createTable('project_languages', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          project_id INTEGER NOT NULL,
          language_id INTEGER NOT NULL,
          is_primary BOOLEAN DEFAULT false,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(project_id, language_id)
        );
      ''');

      // 创建外键约束
      await addForeignKey('project_languages_project_id', 'project_languages', 'project_id', 'projects', 'id');
      await addForeignKey('project_languages_language_id', 'project_languages', 'language_id', 'languages', 'id');

      // 创建索引
      await createIndex('project_languages_project_id', 'project_languages', 'project_id');
      await createIndex('project_languages_language_id', 'project_languages', 'language_id');
      await createIndex('project_languages_is_primary', 'project_languages', 'is_primary');
      await createIndex('project_languages_is_active', 'project_languages', 'is_active');

      // 添加表注释
      await addTableComment('project_languages', '项目语言关联表，存储项目和语言的关联关系');
      await addColumnComment('project_languages', 'id', '关联ID，主键');
      await addColumnComment('project_languages', 'project_id', '项目ID，外键关联projects表');
      await addColumnComment('project_languages', 'language_id', '语言ID，外键关联languages表');
      await addColumnComment('project_languages', 'is_primary', '是否为主要语言');
      await addColumnComment('project_languages', 'is_active', '是否激活');
      await addColumnComment('project_languages', 'created_at', '创建时间');

      log('迁移完成: $name', name: 'Migration008ProjectLanguagesTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration008ProjectLanguagesTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration008ProjectLanguagesTable');

      // 删除项目语言关联表
      await dropTable('project_languages');

      log('回滚完成: $name', name: 'Migration008ProjectLanguagesTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration008ProjectLanguagesTable');
      rethrow;
    }
  }
}
