import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 011 - 创建翻译历史表
/// 创建时间: 2024-12-26
/// 描述: 创建翻译历史表，存储翻译历史记录
class Migration011TranslationHistoryTable extends BaseMigration {
  @override
  String get name => '011_translation_history_table';

  @override
  String get description => '创建翻译历史表，存储翻译历史记录';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration011TranslationHistoryTable');

      // 创建翻译历史表
      await createTable('translation_history', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          entry_id INTEGER NOT NULL,
          old_target_text TEXT,
          new_target_text TEXT NOT NULL,
          action VARCHAR(20) NOT NULL,
          changed_by INTEGER NOT NULL,
          changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          reason TEXT,
          metadata JSONB
        );
      ''');

      // 创建外键约束
      await addForeignKey(
          'translation_history_entry_id', 'translation_history', 'entry_id', 'translation_entries', 'id');
      await addForeignKey('translation_history_changed_by', 'translation_history', 'changed_by', 'users', 'id');

      // 创建索引
      await createIndex('translation_history_entry_id', 'translation_history', 'entry_id');
      await createIndex('translation_history_changed_by', 'translation_history', 'changed_by');
      await createIndex('translation_history_action', 'translation_history', 'action');
      await createIndex('translation_history_changed_at', 'translation_history', 'changed_at');

      // 添加表注释
      await addTableComment('translation_history', '翻译历史表，存储翻译历史记录');
      await addColumnComment('translation_history', 'id', '历史记录ID，主键');
      await addColumnComment('translation_history', 'entry_id', '翻译条目ID，外键关联translation_entries表');
      await addColumnComment('translation_history', 'old_target_text', '旧的目标文本');
      await addColumnComment('translation_history', 'new_target_text', '新的目标文本');
      await addColumnComment('translation_history', 'action', '操作类型');
      await addColumnComment('translation_history', 'changed_by', '修改者ID，外键关联users表');
      await addColumnComment('translation_history', 'changed_at', '修改时间');
      await addColumnComment('translation_history', 'reason', '修改原因');
      await addColumnComment('translation_history', 'metadata', '元数据，JSON格式');

      log('迁移完成: $name', name: 'Migration011TranslationHistoryTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration011TranslationHistoryTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration011TranslationHistoryTable');

      // 删除翻译历史表
      await dropTable('translation_history');

      log('回滚完成: $name', name: 'Migration011TranslationHistoryTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration011TranslationHistoryTable');
      rethrow;
    }
  }
}
