import 'package:ttpolyglot_model/model.dart';

import 'base_migration.dart';

/// 迁移: 009 - 创建翻译条目表（优化版）
/// 创建时间: 2024-12-26
/// 更新时间: 2025-10-31
/// 描述: 创建翻译条目表，存储翻译条目内容，包含性能优化字段和索引
class Migration009TranslationEntriesTable extends BaseMigration {
  @override
  String get name => '009_translation_entries_table';

  @override
  String get description => '创建翻译条目表，存储翻译条目内容（优化版）';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      ServerLogger.info('开始执行迁移: $name');

      // 创建翻译条目表（优化版）
      await createTable('translation_entries', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          uuid UUID DEFAULT gen_random_uuid(),
          project_id INTEGER NOT NULL,
          key VARCHAR(500) NOT NULL,
          entry_key VARCHAR(500),
          source_language_id INTEGER NOT NULL,
          target_language_id INTEGER NOT NULL,
          source_text TEXT NOT NULL,
          source_text_hash VARCHAR(64),
          target_text TEXT,
          target_text_hash VARCHAR(64),
          status VARCHAR(20) DEFAULT 'pending',
          
          -- 统计字段
          source_char_count INTEGER DEFAULT 0,
          target_char_count INTEGER DEFAULT 0,
          source_word_count INTEGER DEFAULT 0,
          target_word_count INTEGER DEFAULT 0,
          
          -- 审核字段
          translated_by UUID,
          translated_at TIMESTAMPTZ,
          reviewed_by UUID,
          reviewed_at TIMESTAMPTZ,
          
          -- 版本控制
          version INTEGER DEFAULT 1,
          
          -- 软删除
          is_deleted BOOLEAN DEFAULT false,
          deleted_at TIMESTAMPTZ,
          deleted_by UUID,
          
          -- 时间戳
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          
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

      // 初始化 entry_key 字段（等于 key）
      await connection.execute('''
        UPDATE ${tablePrefix}translation_entries 
        SET entry_key = key 
        WHERE entry_key IS NULL;
      ''');

      // 创建基础索引
      await createIndex('translation_entries_uuid', 'translation_entries', 'uuid');
      await createIndex('translation_entries_project_id', 'translation_entries', 'project_id');
      await createIndex('translation_entries_source_language_id', 'translation_entries', 'source_language_id');
      await createIndex('translation_entries_target_language_id', 'translation_entries', 'target_language_id');
      await createIndex('translation_entries_status', 'translation_entries', 'status');
      await createIndex('translation_entries_translated_by', 'translation_entries', 'translated_by');
      await createIndex('translation_entries_reviewed_by', 'translation_entries', 'reviewed_by');

      // 创建优化索引（带 WHERE 条件的部分索引）
      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_entry_key 
        ON ${tablePrefix}translation_entries(entry_key) 
        WHERE is_deleted = false;
      ''');

      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_source_hash 
        ON ${tablePrefix}translation_entries(source_text_hash) 
        WHERE is_deleted = false;
      ''');

      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_updated_at_desc 
        ON ${tablePrefix}translation_entries(updated_at DESC, id DESC) 
        WHERE is_deleted = false;
      ''');

      // 创建复合索引优化常见查询
      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_project_lang_status 
        ON ${tablePrefix}translation_entries(project_id, target_language_id, status) 
        WHERE is_deleted = false;
      ''');

      // 创建全文搜索索引
      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_fulltext 
        ON ${tablePrefix}translation_entries 
        USING GIN (to_tsvector('simple', coalesce(source_text, '') || ' ' || coalesce(target_text, ''))) 
        WHERE is_deleted = false;
      ''');

      // 创建触发器函数：自动更新 hash 和统计字段
      await connection.execute('''
        CREATE OR REPLACE FUNCTION update_translation_entry_fields()
        RETURNS TRIGGER AS \$\$
        BEGIN
          -- 更新 hash 值
          NEW.source_text_hash = md5(NEW.source_text);
          NEW.target_text_hash = CASE WHEN NEW.target_text IS NOT NULL THEN md5(NEW.target_text) ELSE NULL END;
          
          -- 更新字符统计
          NEW.source_char_count = length(NEW.source_text);
          NEW.target_char_count = CASE WHEN NEW.target_text IS NOT NULL THEN length(NEW.target_text) ELSE 0 END;
          
          -- 更新单词统计（简单实现，按空格分割）
          NEW.source_word_count = array_length(regexp_split_to_array(trim(NEW.source_text), E'\\\\s+'), 1);
          NEW.target_word_count = CASE WHEN NEW.target_text IS NOT NULL 
            THEN array_length(regexp_split_to_array(trim(NEW.target_text), E'\\\\s+'), 1) 
            ELSE 0 END;
          
          -- 确保 entry_key 有值
          IF NEW.entry_key IS NULL THEN
            NEW.entry_key = NEW.key;
          END IF;
          
          RETURN NEW;
        END;
        \$\$ LANGUAGE plpgsql;
      ''');

      // 创建触发器：在插入或更新时自动更新字段
      await connection.execute('''
        CREATE TRIGGER trigger_update_translation_entry_fields
          BEFORE INSERT OR UPDATE ON ${tablePrefix}translation_entries
          FOR EACH ROW
          EXECUTE FUNCTION update_translation_entry_fields();
      ''');

      // 创建触发器：自动更新 updated_at
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}translation_entries_updated_at 
          BEFORE UPDATE ON ${tablePrefix}translation_entries 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('translation_entries', '翻译条目表，存储翻译条目内容（优化版）');
      await addColumnComment('translation_entries', 'id', '翻译条目ID，主键');
      await addColumnComment('translation_entries', 'uuid', 'UUID，用于分布式场景');
      await addColumnComment('translation_entries', 'project_id', '项目ID，外键关联projects表');
      await addColumnComment('translation_entries', 'key', '翻译键名');
      await addColumnComment('translation_entries', 'entry_key', '翻译条目键（优化字段）');
      await addColumnComment('translation_entries', 'source_language_id', '源语言ID，外键关联languages表');
      await addColumnComment('translation_entries', 'target_language_id', '目标语言ID，外键关联languages表');
      await addColumnComment('translation_entries', 'source_text', '源文本');
      await addColumnComment('translation_entries', 'source_text_hash', '源文本MD5哈希值，用于快速查找重复内容');
      await addColumnComment('translation_entries', 'target_text', '目标文本');
      await addColumnComment('translation_entries', 'target_text_hash', '目标文本MD5哈希值');
      await addColumnComment('translation_entries', 'status', '翻译状态：pending/completed/reviewing/approved');
      await addColumnComment('translation_entries', 'source_char_count', '源文本字符数');
      await addColumnComment('translation_entries', 'target_char_count', '目标文本字符数');
      await addColumnComment('translation_entries', 'source_word_count', '源文本单词数');
      await addColumnComment('translation_entries', 'target_word_count', '目标文本单词数');
      await addColumnComment('translation_entries', 'translated_by', '翻译者ID，外键关联users表');
      await addColumnComment('translation_entries', 'translated_at', '翻译完成时间');
      await addColumnComment('translation_entries', 'reviewed_by', '审核者ID，外键关联users表');
      await addColumnComment('translation_entries', 'reviewed_at', '审核完成时间');
      await addColumnComment('translation_entries', 'version', '版本号，用于乐观锁');
      await addColumnComment('translation_entries', 'is_deleted', '是否软删除');
      await addColumnComment('translation_entries', 'deleted_at', '删除时间');
      await addColumnComment('translation_entries', 'deleted_by', '删除者ID');
      await addColumnComment('translation_entries', 'created_at', '创建时间');
      await addColumnComment('translation_entries', 'updated_at', '更新时间');

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

      // 删除触发器
      await connection.execute('''
        DROP TRIGGER IF EXISTS trigger_update_translation_entry_fields 
        ON ${tablePrefix}translation_entries;
      ''');

      await connection.execute('''
        DROP TRIGGER IF EXISTS update_${tablePrefix}translation_entries_updated_at 
        ON ${tablePrefix}translation_entries;
      ''');

      // 删除触发器函数
      await connection.execute('''
        DROP FUNCTION IF EXISTS update_translation_entry_fields();
      ''');

      // 删除翻译条目表
      await dropTable('translation_entries');

      ServerLogger.info('回滚完成: $name');
    } catch (error, stackTrace) {
      ServerLogger.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
