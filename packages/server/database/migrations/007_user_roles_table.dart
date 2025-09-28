import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 007 - 创建用户角色关联表
/// 创建时间: 2024-12-26
/// 描述: 创建用户角色关联表，存储用户和角色的关联关系
class Migration007UserRolesTable extends BaseMigration {
  @override
  String get name => '007_user_roles_table';

  @override
  String get description => '创建用户角色关联表，存储用户和角色的关联关系';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration007UserRolesTable');

      // 创建用户角色关联表
      await createTable('user_roles', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          user_id INTEGER NOT NULL,
          role_id INTEGER NOT NULL,
          assigned_by INTEGER,
          assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          expires_at TIMESTAMP,
          is_active BOOLEAN DEFAULT true,
          UNIQUE(user_id, role_id)
        );
      ''');

      // 创建外键约束
      await addForeignKey('user_roles_user_id', 'user_roles', 'user_id', 'users', 'id');
      await addForeignKey('user_roles_role_id', 'user_roles', 'role_id', 'roles', 'id');
      await addForeignKey('user_roles_assigned_by', 'user_roles', 'assigned_by', 'users', 'id', onDelete: 'SET NULL');

      // 创建索引
      await createIndex('user_roles_user_id', 'user_roles', 'user_id');
      await createIndex('user_roles_role_id', 'user_roles', 'role_id');
      await createIndex('user_roles_assigned_by', 'user_roles', 'assigned_by');
      await createIndex('user_roles_is_active', 'user_roles', 'is_active');
      await createIndex('user_roles_expires_at', 'user_roles', 'expires_at');

      // 添加表注释
      await addTableComment('user_roles', '用户角色关联表，存储用户和角色的关联关系');
      await addColumnComment('user_roles', 'id', '关联ID，主键');
      await addColumnComment('user_roles', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('user_roles', 'role_id', '角色ID，外键关联roles表');
      await addColumnComment('user_roles', 'assigned_by', '分配者ID，外键关联users表');
      await addColumnComment('user_roles', 'assigned_at', '分配时间');
      await addColumnComment('user_roles', 'expires_at', '过期时间');
      await addColumnComment('user_roles', 'is_active', '是否激活');

      log('迁移完成: $name', name: 'Migration007UserRolesTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration007UserRolesTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration007UserRolesTable');

      // 删除用户角色关联表
      await dropTable('user_roles');

      log('回滚完成: $name', name: 'Migration007UserRolesTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration007UserRolesTable');
      rethrow;
    }
  }
}
