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
          project_id UUID NOT NULL,
          key VARCHAR(500),
          entry_key VARCHAR(500) NOT NULL,
          source_language VARCHAR(20),
          target_language VARCHAR(20),
          source_text TEXT,
          target_text TEXT,
          status VARCHAR(20) DEFAULT 'pending',
          
          -- 审核字段
          translated_by UUID,
          reviewed_by UUID,
          
          -- 附加信息字段
          context TEXT,
          comment TEXT,
          
          -- 软删除
          deleted_at TIMESTAMPTZ,
          
          -- 时间戳
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          
          UNIQUE(project_id, entry_key, target_language)
        );
      ''');

      // 创建外键约束
      await addForeignKey('translation_entries_project_id', 'translation_entries', 'project_id', 'projects', 'uuid');
      await addForeignKey('translation_entries_translated_by', 'translation_entries', 'translated_by', 'users', 'uuid',
          onDelete: 'SET NULL');
      await addForeignKey('translation_entries_reviewed_by', 'translation_entries', 'reviewed_by', 'users', 'uuid',
          onDelete: 'SET NULL');

      // 初始化 entry_key 字段（如果为空则使用 key）
      await connection.execute('''
        UPDATE ${tablePrefix}translation_entries 
        SET entry_key = COALESCE(key, '') 
        WHERE entry_key IS NULL OR entry_key = '';
      ''');

      // 创建基础索引
      await createIndex('translation_entries_uuid', 'translation_entries', 'uuid');
      await createIndex('translation_entries_project_id', 'translation_entries', 'project_id');
      await createIndex('translation_entries_source_language', 'translation_entries', 'source_language');
      await createIndex('translation_entries_target_language', 'translation_entries', 'target_language');
      await createIndex('translation_entries_status', 'translation_entries', 'status');
      await createIndex('translation_entries_translated_by', 'translation_entries', 'translated_by');
      await createIndex('translation_entries_reviewed_by', 'translation_entries', 'reviewed_by');

      // 创建优化索引
      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_entry_key 
        ON ${tablePrefix}translation_entries(entry_key) 
        WHERE deleted_at IS NULL;
      ''');

      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_updated_at_desc 
        ON ${tablePrefix}translation_entries(updated_at DESC, id DESC) 
        WHERE deleted_at IS NULL;
      ''');

      // 创建复合索引优化常见查询
      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_project_lang_status 
        ON ${tablePrefix}translation_entries(project_id, target_language, status) 
        WHERE deleted_at IS NULL;
      ''');

      // 创建全文搜索索引
      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_translation_entries_fulltext 
        ON ${tablePrefix}translation_entries 
        USING GIN (to_tsvector('simple', coalesce(source_text, '') || ' ' || coalesce(target_text, ''))) 
        WHERE deleted_at IS NULL;
      ''');

      // 创建触发器函数：自动设置 entry_key
      await connection.execute('''
        CREATE OR REPLACE FUNCTION update_translation_entry_fields()
        RETURNS TRIGGER AS \$\$
        BEGIN
          -- 确保 entry_key 有值，如果没有则使用 key
          IF NEW.entry_key IS NULL OR NEW.entry_key = '' THEN
            NEW.entry_key = COALESCE(NEW.key, '');
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
      await addColumnComment('translation_entries', 'project_id', '项目UUID，外键关联projects表');
      await addColumnComment('translation_entries', 'key', '原始翻译键名');
      await addColumnComment('translation_entries', 'entry_key', '翻译条目键（必填）');
      await addColumnComment('translation_entries', 'source_language', '源语言代码');
      await addColumnComment('translation_entries', 'target_language', '目标语言代码');
      await addColumnComment('translation_entries', 'source_text', '源文本');
      await addColumnComment('translation_entries', 'target_text', '目标文本');
      await addColumnComment('translation_entries', 'status', '翻译状态：pending/completed/reviewing/approved');
      await addColumnComment('translation_entries', 'translated_by', '翻译者UUID，外键关联users表');
      await addColumnComment('translation_entries', 'reviewed_by', '审核者UUID，外键关联users表');
      await addColumnComment('translation_entries', 'context', '上下文信息');
      await addColumnComment('translation_entries', 'comment', '备注信息');
      await addColumnComment('translation_entries', 'deleted_at', '软删除时间');
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
