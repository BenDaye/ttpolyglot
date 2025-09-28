import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 004 - 创建角色权限关联表
/// 创建时间: 2024-12-26
/// 描述: 创建角色权限关联表，存储角色和权限的关联关系
class Migration004RolePermissionsTable extends BaseMigration {
  @override
  String get name => '004_role_permissions_table';

  @override
  String get description => '创建角色权限关联表，存储角色和权限的关联关系';

  @override
  String get createdAt => '2024-12-26';

  @override
  String get tablePrefix => 'tt_';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration004RolePermissionsTable');

      // 创建角色权限关联表
      await createTable('role_permissions', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          role_id INTEGER NOT NULL,
          permission_id INTEGER NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(role_id, permission_id)
        );
      ''');

      // 创建外键约束
      await addForeignKey('role_permissions_role_id', 'role_permissions', 'role_id', 'roles', 'id');
      await addForeignKey('role_permissions_permission_id', 'role_permissions', 'permission_id', 'permissions', 'id');

      // 创建索引
      await createIndex('role_permissions_role_id', 'role_permissions', 'role_id');
      await createIndex('role_permissions_permission_id', 'role_permissions', 'permission_id');

      // 添加表注释
      await addTableComment('role_permissions', '角色权限关联表，存储角色和权限的关联关系');
      await addColumnComment('role_permissions', 'id', '关联ID，主键');
      await addColumnComment('role_permissions', 'role_id', '角色ID，外键关联roles表');
      await addColumnComment('role_permissions', 'permission_id', '权限ID，外键关联permissions表');
      await addColumnComment('role_permissions', 'created_at', '创建时间');

      log('迁移完成: $name', name: 'Migration004RolePermissionsTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration004RolePermissionsTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration004RolePermissionsTable');

      // 删除角色权限关联表
      await dropTable('role_permissions');

      log('回滚完成: $name', name: 'Migration004RolePermissionsTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration004RolePermissionsTable');
      rethrow;
    }
  }
}
