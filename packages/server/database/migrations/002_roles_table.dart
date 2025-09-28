import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 002 - 创建角色表
/// 创建时间: 2024-12-26
/// 描述: 创建角色表，存储系统角色信息
class Migration002RolesTable extends BaseMigration {
  @override
  String get name => '002_roles_table';

  @override
  String get description => '创建角色表，存储系统角色信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration002RolesTable');

      // 创建角色表
      await createTable('roles', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          name VARCHAR(50) UNIQUE NOT NULL,
          display_name VARCHAR(100) NOT NULL,
          description TEXT,
          is_system_role BOOLEAN DEFAULT false,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建索引
      await createIndex('roles_name', 'roles', 'name');
      await createIndex('roles_is_system_role', 'roles', 'is_system_role');
      await createIndex('roles_is_active', 'roles', 'is_active');

      // 为角色表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_tt_roles_updated_at 
          BEFORE UPDATE ON tt_roles 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('roles', '角色表，存储系统角色信息');
      await addColumnComment('roles', 'id', '角色ID，主键');
      await addColumnComment('roles', 'name', '角色名称，唯一标识');
      await addColumnComment('roles', 'display_name', '角色显示名称');
      await addColumnComment('roles', 'description', '角色描述');
      await addColumnComment('roles', 'is_system_role', '是否为系统角色');
      await addColumnComment('roles', 'is_active', '是否激活');
      await addColumnComment('roles', 'created_at', '创建时间');
      await addColumnComment('roles', 'updated_at', '更新时间');

      log('迁移完成: $name', name: 'Migration002RolesTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration002RolesTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration002RolesTable');

      // 删除角色表
      await dropTable('roles');

      log('回滚完成: $name', name: 'Migration002RolesTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration002RolesTable');
      rethrow;
    }
  }
}
