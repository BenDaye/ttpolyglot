import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

import 'base_migration.dart';

/// 迁移: 016 - 创建用户设置表
/// 创建时间: 2025-10-22
/// 描述: 创建用户设置表，存储用户的语言设置和通用设置
class Migration016UserSettingsTable extends BaseMigration {
  @override
  String get name => '016_user_settings_table';

  @override
  String get description => '创建用户设置表，存储用户的语言设置和通用设置';

  @override
  String get createdAt => '2025-10-22';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建用户设置表
      await createTable('user_settings', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES ${tablePrefix}users(id) ON DELETE CASCADE,
          language_code VARCHAR(10) DEFAULT 'zh_CN',
          auto_save BOOLEAN DEFAULT TRUE,
          notifications BOOLEAN DEFAULT TRUE,
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          CONSTRAINT unique_user_settings UNIQUE(user_id)
        );
      ''');

      // 创建索引
      await createIndex('user_settings_user_id', 'user_settings', 'user_id');

      // 为用户设置表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}user_settings_updated_at 
          BEFORE UPDATE ON ${tablePrefix}user_settings 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('user_settings', '用户设置表，存储用户的语言设置和通用设置');
      await addColumnComment('user_settings', 'id', '设置ID，主键（UUID）');
      await addColumnComment('user_settings', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('user_settings', 'language_code', '应用语言代码（如: zh_CN, en_US）');
      await addColumnComment('user_settings', 'auto_save', '是否启用自动保存');
      await addColumnComment('user_settings', 'notifications', '是否启用通知');
      await addColumnComment('user_settings', 'created_at', '创建时间');
      await addColumnComment('user_settings', 'updated_at', '更新时间');

      LoggerUtils.info('迁移执行成功: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('迁移执行失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      LoggerUtils.info('开始回滚迁移: $name');

      // 删除表
      await dropTable('user_settings');

      LoggerUtils.info('迁移回滚成功: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('迁移回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
