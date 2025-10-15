import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 010 - 创建翻译条目表
/// 创建时间: 2024-12-26
/// 描述: 创建翻译条目表，存储翻译条目内容
class Migration010TranslationEntriesTable extends BaseMigration {
  @override
  String get name => '010_translation_entries_table';

  @override
  String get description => '创建翻译条目表，存储翻译条目内容';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration010TranslationEntriesTable');

      // 创建翻译条目表
      await createTable('translation_entries', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          project_id INTEGER NOT NULL,
          key VARCHAR(500) NOT NULL,
          source_language_id INTEGER NOT NULL,
          target_language_id INTEGER NOT NULL,
          source_text TEXT NOT NULL,
          target_text TEXT,
          status VARCHAR(20) DEFAULT 'pending',
          translated_by UUID,
          translated_at TIMESTAMP,
          reviewed_by UUID,
          reviewed_at TIMESTAMP,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(project_id, key, target_language_id)
        );
      ''');

      // 创建外键约束
      await addForeignKey('translation_entries_project_id', 'translation_entries', 'project_id', 'projects', 'id');
      await addForeignKey(
          'translation_entries_source_language_id', 'translation_entries', 'source_language_id', 'languages', 'id');
      await addForeignKey(
          'translation_entries_target_language_id', 'translation_entries', 'target_language_id', 'languages', 'id');
      await addForeignKey('translation_entries_translated_by', 'translation_entries', 'translated_by', 'users', 'id',
          onDelete: 'SET NULL');
      await addForeignKey('translation_entries_reviewed_by', 'translation_entries', 'reviewed_by', 'users', 'id',
          onDelete: 'SET NULL');

      // 创建索引
      await createIndex('translation_entries_project_id', 'translation_entries', 'project_id');
      await createIndex('translation_entries_key', 'translation_entries', 'key');
      await createIndex('translation_entries_source_language_id', 'translation_entries', 'source_language_id');
      await createIndex('translation_entries_target_language_id', 'translation_entries', 'target_language_id');
      await createIndex('translation_entries_status', 'translation_entries', 'status');
      await createIndex('translation_entries_translated_by', 'translation_entries', 'translated_by');
      await createIndex('translation_entries_reviewed_by', 'translation_entries', 'reviewed_by');
      await createIndex('translation_entries_created_at', 'translation_entries', 'created_at');

      // 为翻译条目表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}translation_entries_updated_at 
          BEFORE UPDATE ON ${tablePrefix}translation_entries 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('translation_entries', '翻译条目表，存储翻译条目内容');
      await addColumnComment('translation_entries', 'id', '翻译条目ID，主键');
      await addColumnComment('translation_entries', 'project_id', '项目ID，外键关联projects表');
      await addColumnComment('translation_entries', 'key', '翻译键名');
      await addColumnComment('translation_entries', 'source_language_id', '源语言ID，外键关联languages表');
      await addColumnComment('translation_entries', 'target_language_id', '目标语言ID，外键关联languages表');
      await addColumnComment('translation_entries', 'source_text', '源文本');
      await addColumnComment('translation_entries', 'target_text', '目标文本');
      await addColumnComment('translation_entries', 'status', '翻译状态');
      await addColumnComment('translation_entries', 'translated_by', '翻译者ID，外键关联users表');
      await addColumnComment('translation_entries', 'translated_at', '翻译时间');
      await addColumnComment('translation_entries', 'reviewed_by', '审核者ID，外键关联users表');
      await addColumnComment('translation_entries', 'reviewed_at', '审核时间');
      await addColumnComment('translation_entries', 'created_at', '创建时间');
      await addColumnComment('translation_entries', 'updated_at', '更新时间');

      log('迁移完成: $name', name: 'Migration010TranslationEntriesTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration010TranslationEntriesTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration010TranslationEntriesTable');

      // 删除翻译条目表
      await dropTable('translation_entries');

      log('回滚完成: $name', name: 'Migration010TranslationEntriesTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration010TranslationEntriesTable');
      rethrow;
    }
  }
}
