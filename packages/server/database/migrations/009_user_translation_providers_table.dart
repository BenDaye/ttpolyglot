

import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';
import 'base_migration.dart';

/// 迁移: 009 - 创建用户翻译接口配置表
/// 创建时间: 2024-12-26
/// 描述: 创建用户翻译接口配置表，存储用户配置的翻译接口信息
class Migration009UserTranslationProvidersTable extends BaseMigration {
  @override
  String get name => '009_user_translation_providers_table';

  @override
  String get description => '创建用户翻译接口配置表，存储用户配置的翻译接口信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建用户翻译接口配置表
      await createTable('user_translation_providers', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          user_id UUID NOT NULL,
          provider_name VARCHAR(50) NOT NULL,
          api_key VARCHAR(500),
          api_secret VARCHAR(500),
          base_url VARCHAR(255),
          config JSONB,
          is_active BOOLEAN DEFAULT true,
          is_default BOOLEAN DEFAULT false,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey('user_translation_providers_user_id', 'user_translation_providers', 'user_id', 'users', 'id');

      // 创建索引
      await createIndex('user_translation_providers_user_id', 'user_translation_providers', 'user_id');
      await createIndex('user_translation_providers_provider_name', 'user_translation_providers', 'provider_name');
      await createIndex('user_translation_providers_is_active', 'user_translation_providers', 'is_active');
      await createIndex('user_translation_providers_is_default', 'user_translation_providers', 'is_default');

      // 为用户翻译接口配置表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}user_translation_providers_updated_at 
          BEFORE UPDATE ON ${tablePrefix}user_translation_providers 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('user_translation_providers', '用户翻译接口配置表，存储用户配置的翻译接口信息');
      await addColumnComment('user_translation_providers', 'id', '配置ID，主键');
      await addColumnComment('user_translation_providers', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('user_translation_providers', 'provider_name', '翻译接口名称');
      await addColumnComment('user_translation_providers', 'api_key', 'API密钥');
      await addColumnComment('user_translation_providers', 'api_secret', 'API密钥');
      await addColumnComment('user_translation_providers', 'base_url', '基础URL');
      await addColumnComment('user_translation_providers', 'config', '配置信息，JSON格式');
      await addColumnComment('user_translation_providers', 'is_active', '是否激活');
      await addColumnComment('user_translation_providers', 'is_default', '是否为默认接口');
      await addColumnComment('user_translation_providers', 'created_at', '创建时间');
      await addColumnComment('user_translation_providers', 'updated_at', '更新时间');

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

      // 删除用户翻译接口配置表
      await dropTable('user_translation_providers');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
