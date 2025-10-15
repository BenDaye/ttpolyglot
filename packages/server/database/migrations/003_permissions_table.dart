import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 003 - 创建权限表
/// 创建时间: 2024-12-26
/// 描述: 创建权限表，存储系统权限信息
class Migration003PermissionsTable extends BaseMigration {
  @override
  String get name => '003_permissions_table';

  @override
  String get description => '创建权限表，存储系统权限信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration003PermissionsTable');

      // 创建权限表
      await createTable('permissions', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          name VARCHAR(100) UNIQUE NOT NULL,
          display_name VARCHAR(150) NOT NULL,
          description TEXT,
          resource VARCHAR(100) NOT NULL,
          action VARCHAR(50) NOT NULL,
          is_system_permission BOOLEAN DEFAULT false,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建索引
      await createIndex('permissions_name', 'permissions', 'name');
      await createIndex('permissions_resource', 'permissions', 'resource');
      await createIndex('permissions_action', 'permissions', 'action');
      await createIndex('permissions_is_system_permission', 'permissions', 'is_system_permission');
      await createIndex('permissions_is_active', 'permissions', 'is_active');

      // 为权限表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}permissions_updated_at 
          BEFORE UPDATE ON ${tablePrefix}permissions 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('permissions', '权限表，存储系统权限信息');
      await addColumnComment('permissions', 'id', '权限ID，主键');
      await addColumnComment('permissions', 'name', '权限名称，唯一标识');
      await addColumnComment('permissions', 'display_name', '权限显示名称');
      await addColumnComment('permissions', 'description', '权限描述');
      await addColumnComment('permissions', 'resource', '资源名称');
      await addColumnComment('permissions', 'action', '操作名称');
      await addColumnComment('permissions', 'is_system_permission', '是否为系统权限');
      await addColumnComment('permissions', 'is_active', '是否激活');
      await addColumnComment('permissions', 'created_at', '创建时间');
      await addColumnComment('permissions', 'updated_at', '更新时间');

      log('迁移完成: $name', name: 'Migration003PermissionsTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration003PermissionsTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration003PermissionsTable');

      // 删除权限表
      await dropTable('permissions');

      log('回滚完成: $name', name: 'Migration003PermissionsTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration003PermissionsTable');
      rethrow;
    }
  }
}
