

import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';
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
      LoggerUtils.info('开始执行迁移: $name');

      // 启用 UUID 扩展
      await connection.execute('CREATE EXTENSION IF NOT EXISTS "pgcrypto";');

      // 创建用户表
      await createTable('users', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          username VARCHAR(50) UNIQUE NOT NULL,
          email VARCHAR(255) UNIQUE NOT NULL,
          email_encrypted TEXT,
          password_hash CHAR(60) NOT NULL,
          display_name VARCHAR(100),
          avatar_url TEXT,
          phone VARCHAR(20),
          timezone VARCHAR(50) DEFAULT 'UTC',
          locale VARCHAR(10) DEFAULT 'en-US',
          is_active BOOLEAN DEFAULT TRUE,
          is_email_verified BOOLEAN DEFAULT FALSE,
          email_verified_at TIMESTAMPTZ,
          last_login_at TIMESTAMPTZ,
          last_login_ip INET,
          login_attempts INTEGER DEFAULT 0,
          locked_until TIMESTAMPTZ,
          password_changed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建索引
      await createIndex('users_username', 'users', 'username');
      await createIndex('users_email', 'users', 'email');
      await createIndex('users_is_active', 'users', 'is_active');
      await createIndex('users_is_email_verified', 'users', 'is_email_verified');
      await createIndex('users_created_at', 'users', 'created_at');
      await createIndex('users_last_login_at', 'users', 'last_login_at');

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
      await addColumnComment('users', 'id', '用户ID，主键（UUID）');
      await addColumnComment('users', 'username', '用户名，唯一标识');
      await addColumnComment('users', 'email', '邮箱地址，唯一标识');
      await addColumnComment('users', 'email_encrypted', '加密存储的邮箱（可选）');
      await addColumnComment('users', 'password_hash', '密码哈希值（bcrypt，固定60字符）');
      await addColumnComment('users', 'display_name', '显示名称');
      await addColumnComment('users', 'avatar_url', '头像URL');
      await addColumnComment('users', 'phone', '电话号码');
      await addColumnComment('users', 'timezone', '用户时区');
      await addColumnComment('users', 'locale', '用户语言偏好');
      await addColumnComment('users', 'is_active', '是否激活');
      await addColumnComment('users', 'is_email_verified', '是否已验证邮箱');
      await addColumnComment('users', 'email_verified_at', '邮箱验证时间');
      await addColumnComment('users', 'last_login_at', '最后登录时间');
      await addColumnComment('users', 'last_login_ip', '最后登录IP');
      await addColumnComment('users', 'login_attempts', '登录尝试次数');
      await addColumnComment('users', 'locked_until', '账户锁定时间');
      await addColumnComment('users', 'password_changed_at', '密码修改时间');
      await addColumnComment('users', 'created_at', '创建时间');
      await addColumnComment('users', 'updated_at', '更新时间');

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

      // 删除用户表
      await dropTable('users');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
