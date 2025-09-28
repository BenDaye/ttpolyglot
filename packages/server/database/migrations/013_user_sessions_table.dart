import 'dart:developer';

import 'base_migration.dart';

/// 迁移: 013 - 创建用户会话表
/// 创建时间: 2024-12-26
/// 描述: 创建用户会话表，存储用户会话信息
class Migration013UserSessionsTable extends BaseMigration {
  @override
  String get name => '013_user_sessions_table';

  @override
  String get description => '创建用户会话表，存储用户会话信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  String get tablePrefix => 'tt_';

  @override
  Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration013UserSessionsTable');

      // 创建用户会话表
      await createTable('user_sessions', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          user_id INTEGER NOT NULL,
          session_token VARCHAR(255) UNIQUE NOT NULL,
          refresh_token VARCHAR(255) UNIQUE,
          ip_address INET,
          user_agent TEXT,
          expires_at TIMESTAMP NOT NULL,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          last_accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey('user_sessions_user_id', 'user_sessions', 'user_id', 'users', 'id');

      // 创建索引
      await createIndex('user_sessions_user_id', 'user_sessions', 'user_id');
      await createIndex('user_sessions_session_token', 'user_sessions', 'session_token');
      await createIndex('user_sessions_refresh_token', 'user_sessions', 'refresh_token');
      await createIndex('user_sessions_expires_at', 'user_sessions', 'expires_at');
      await createIndex('user_sessions_is_active', 'user_sessions', 'is_active');
      await createIndex('user_sessions_last_accessed_at', 'user_sessions', 'last_accessed_at');

      // 添加表注释
      await addTableComment('user_sessions', '用户会话表，存储用户会话信息');
      await addColumnComment('user_sessions', 'id', '会话ID，主键');
      await addColumnComment('user_sessions', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('user_sessions', 'session_token', '会话令牌，唯一标识');
      await addColumnComment('user_sessions', 'refresh_token', '刷新令牌，唯一标识');
      await addColumnComment('user_sessions', 'ip_address', 'IP地址');
      await addColumnComment('user_sessions', 'user_agent', '用户代理');
      await addColumnComment('user_sessions', 'expires_at', '过期时间');
      await addColumnComment('user_sessions', 'is_active', '是否激活');
      await addColumnComment('user_sessions', 'created_at', '创建时间');
      await addColumnComment('user_sessions', 'last_accessed_at', '最后访问时间');

      log('迁移完成: $name', name: 'Migration013UserSessionsTable');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration013UserSessionsTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration013UserSessionsTable');

      // 删除用户会话表
      await dropTable('user_sessions');

      log('回滚完成: $name', name: 'Migration013UserSessionsTable');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration013UserSessionsTable');
      rethrow;
    }
  }
}
