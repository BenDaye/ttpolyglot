import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 012 - 创建系统配置表
/// 创建时间: 2024-12-26
/// 描述: 创建系统配置表，存储系统配置信息
class Migration012SystemConfigsTable extends BaseMigration {
  @override
  String get name => '012_system_configs_table';

  @override
  String get description => '创建系统配置表，存储系统配置信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration012SystemConfigsTable');

      // 创建系统配置表
      await createTable('system_configs', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          key VARCHAR(100) UNIQUE NOT NULL,
          value TEXT,
          type VARCHAR(20) DEFAULT 'string',
          description TEXT,
          is_public BOOLEAN DEFAULT false,
          is_encrypted BOOLEAN DEFAULT false,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建索引
      await createIndex('system_configs_key', 'system_configs', 'key');
      await createIndex('system_configs_type', 'system_configs', 'type');
      await createIndex('system_configs_is_public', 'system_configs', 'is_public');
      await createIndex('system_configs_is_encrypted', 'system_configs', 'is_encrypted');

      // 为系统配置表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_tt_system_configs_updated_at 
          BEFORE UPDATE ON tt_system_configs 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('system_configs', '系统配置表，存储系统配置信息');
      await addColumnComment('system_configs', 'id', '配置ID，主键');
      await addColumnComment('system_configs', 'key', '配置键名，唯一标识');
      await addColumnComment('system_configs', 'value', '配置值');
      await addColumnComment('system_configs', 'type', '配置类型');
      await addColumnComment('system_configs', 'description', '配置描述');
      await addColumnComment('system_configs', 'is_public', '是否公开');
      await addColumnComment('system_configs', 'is_encrypted', '是否加密');
      await addColumnComment('system_configs', 'created_at', '创建时间');
      await addColumnComment('system_configs', 'updated_at', '更新时间');

      log('迁移完成: $name', name: 'Migration012SystemConfigsTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration012SystemConfigsTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration012SystemConfigsTable');

      // 删除系统配置表
      await dropTable('system_configs');

      log('回滚完成: $name', name: 'Migration012SystemConfigsTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration012SystemConfigsTable');
      rethrow;
    }
  }
}
