import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 001 - 创建用户表
/// 创建时间: 2024-12-26
/// 描述: 创建用户表，存储用户基本信息和认证数据
class Migration001UsersTable extends BaseMigration {
  @override
  String get name => '001_users_table';

  @override
  String get description => '创建用户表，存储用户基本信息和认证数据';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration001UsersTable');

      // 创建用户表
      await createTable('users', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          username VARCHAR(50) UNIQUE NOT NULL,
          email VARCHAR(255) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          first_name VARCHAR(100),
          last_name VARCHAR(100),
          avatar_url TEXT,
          is_active BOOLEAN DEFAULT true,
          is_verified BOOLEAN DEFAULT false,
          last_login_at TIMESTAMP,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建索引
      await createIndex('users_username', 'users', 'username');
      await createIndex('users_email', 'users', 'email');
      await createIndex('users_is_active', 'users', 'is_active');
      await createIndex('users_created_at', 'users', 'created_at');

      // 创建触发器函数（如果不存在）
      await connection.execute('''
        CREATE OR REPLACE FUNCTION update_updated_at_column()
        RETURNS TRIGGER AS \$\$
        BEGIN
          NEW.updated_at = CURRENT_TIMESTAMP;
          RETURN NEW;
        END;
        \$\$ language 'plpgsql';
      ''');

      // 为用户表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}users_updated_at 
          BEFORE UPDATE ON ${tablePrefix}users 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('users', '用户表，存储用户基本信息和认证数据');
      await addColumnComment('users', 'id', '用户ID，主键');
      await addColumnComment('users', 'username', '用户名，唯一标识');
      await addColumnComment('users', 'email', '邮箱地址，唯一标识');
      await addColumnComment('users', 'password_hash', '密码哈希值');
      await addColumnComment('users', 'first_name', '名字');
      await addColumnComment('users', 'last_name', '姓氏');
      await addColumnComment('users', 'avatar_url', '头像URL');
      await addColumnComment('users', 'is_active', '是否激活');
      await addColumnComment('users', 'is_verified', '是否已验证邮箱');
      await addColumnComment('users', 'last_login_at', '最后登录时间');
      await addColumnComment('users', 'created_at', '创建时间');
      await addColumnComment('users', 'updated_at', '更新时间');

      log('迁移完成: $name', name: 'Migration001UsersTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration001UsersTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration001UsersTable');

      // 删除用户表
      await dropTable('users');

      log('回滚完成: $name', name: 'Migration001UsersTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration001UsersTable');
      rethrow;
    }
  }
}
