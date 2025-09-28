import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 005 - 创建语言表
/// 创建时间: 2024-12-26
/// 描述: 创建语言表，存储支持的语言信息
class Migration005LanguagesTable extends BaseMigration {
  @override
  String get name => '005_languages_table';

  @override
  String get description => '创建语言表，存储支持的语言信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  String get tablePrefix => 'tt_';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration005LanguagesTable');

      // 创建语言表
      await createTable('languages', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          code VARCHAR(10) UNIQUE NOT NULL,
          name VARCHAR(100) NOT NULL,
          native_name VARCHAR(100),
          flag_emoji VARCHAR(10),
          is_active BOOLEAN DEFAULT true,
          is_rtl BOOLEAN DEFAULT false,
          sort_order INTEGER DEFAULT 0,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建索引
      await createIndex('languages_code', 'languages', 'code');
      await createIndex('languages_is_active', 'languages', 'is_active');
      await createIndex('languages_is_rtl', 'languages', 'is_rtl');
      await createIndex('languages_sort_order', 'languages', 'sort_order');

      // 为语言表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_tt_languages_updated_at 
          BEFORE UPDATE ON tt_languages 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('languages', '语言表，存储支持的语言信息');
      await addColumnComment('languages', 'id', '语言ID，主键');
      await addColumnComment('languages', 'code', '语言代码，唯一标识');
      await addColumnComment('languages', 'name', '语言名称');
      await addColumnComment('languages', 'native_name', '本地语言名称');
      await addColumnComment('languages', 'flag_emoji', '国旗表情符号');
      await addColumnComment('languages', 'is_active', '是否激活');
      await addColumnComment('languages', 'is_rtl', '是否为从右到左语言');
      await addColumnComment('languages', 'sort_order', '排序顺序');
      await addColumnComment('languages', 'created_at', '创建时间');
      await addColumnComment('languages', 'updated_at', '更新时间');

      log('迁移完成: $name', name: 'Migration005LanguagesTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration005LanguagesTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration005LanguagesTable');

      // 删除语言表
      await dropTable('languages');

      log('回滚完成: $name', name: 'Migration005LanguagesTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration005LanguagesTable');
      rethrow;
    }
  }
}
