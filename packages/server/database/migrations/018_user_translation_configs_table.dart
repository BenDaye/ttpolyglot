import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

import 'base_migration.dart';

/// 迁移: 018 - 创建用户翻译配置表
/// 创建时间: 2025-10-22
/// 描述: 创建用户翻译配置表，存储用户的翻译接口配置和高级设置
class Migration018UserTranslationConfigsTable extends BaseMigration {
  @override
  String get name => '018_user_translation_configs_table';

  @override
  String get description => '创建用户翻译配置表，存储用户的翻译接口配置和高级设置';

  @override
  String get createdAt => '2025-10-22';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建用户翻译配置表
      await createTable('user_translation_configs', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES ${tablePrefix}users(id) ON DELETE CASCADE,
          providers JSONB DEFAULT '[]'::jsonb,
          max_retries INTEGER DEFAULT 3 CHECK (max_retries >= 0 AND max_retries <= 10),
          timeout_seconds INTEGER DEFAULT 30 CHECK (timeout_seconds >= 5 AND timeout_seconds <= 300),
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          CONSTRAINT unique_user_translation_config UNIQUE(user_id)
        );
      ''');

      // 创建索引
      await createIndex('user_translation_configs_user_id', 'user_translation_configs', 'user_id');

      // 为 JSONB providers 字段创建 GIN 索引，支持高效的 JSONB 查询
      await connection.execute('''
        CREATE INDEX idx_${tablePrefix}user_translation_configs_providers 
          ON ${tablePrefix}user_translation_configs 
          USING GIN (providers);
      ''');

      // 为用户翻译配置表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}user_translation_configs_updated_at 
          BEFORE UPDATE ON ${tablePrefix}user_translation_configs 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('user_translation_configs', '用户翻译配置表，存储用户的翻译接口配置和高级设置');
      await addColumnComment('user_translation_configs', 'id', '配置ID，主键（UUID）');
      await addColumnComment('user_translation_configs', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('user_translation_configs', 'providers', '翻译接口配置列表（JSONB格式）');
      await addColumnComment('user_translation_configs', 'max_retries', '最大重试次数（0-10）');
      await addColumnComment('user_translation_configs', 'timeout_seconds', '超时时间，单位秒（5-300）');
      await addColumnComment('user_translation_configs', 'created_at', '创建时间');
      await addColumnComment('user_translation_configs', 'updated_at', '更新时间');

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
      await dropTable('user_translation_configs');

      LoggerUtils.info('迁移回滚成功: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('迁移回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
