import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

import 'base_migration.dart';

/// 迁移: 012 - 创建用户会话表
/// 创建时间: 2024-12-26
/// 描述: 创建用户会话表，存储用户会话信息
class Migration012UserSessionsTable extends BaseMigration {
  @override
  String get name => '012_user_sessions_table';

  @override
  String get description => '创建用户会话表，存储用户会话信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建用户会话表
      await createTable('user_sessions', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          user_id UUID NOT NULL,
          token_hash VARCHAR(255) NOT NULL,
          refresh_token_hash VARCHAR(255) UNIQUE,
          device_id VARCHAR(255),
          device_name VARCHAR(100),
          device_type VARCHAR(50),
          ip_address INET,
          user_agent TEXT,
          location_info JSONB,
          last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          expires_at TIMESTAMPTZ NOT NULL,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey('user_sessions_user_id', 'user_sessions', 'user_id', 'users', 'id');

      // 创建索引
      await createIndex('user_sessions_user_id', 'user_sessions', 'user_id');
      await createIndex('user_sessions_token_hash', 'user_sessions', 'token_hash');
      await createIndex('user_sessions_refresh_token_hash', 'user_sessions', 'refresh_token_hash');
      await createIndex('user_sessions_device_id', 'user_sessions', 'device_id');
      await createIndex('user_sessions_expires_at', 'user_sessions', 'expires_at');
      await createIndex('user_sessions_is_active', 'user_sessions', 'is_active');
      await createIndex('user_sessions_last_activity_at', 'user_sessions', 'last_activity_at');

      // 创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}user_sessions_updated_at 
          BEFORE UPDATE ON ${tablePrefix}user_sessions 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('user_sessions', '用户会话表，存储用户会话信息');
      await addColumnComment('user_sessions', 'id', '会话ID，主键');
      await addColumnComment('user_sessions', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('user_sessions', 'token_hash', '访问令牌哈希值');
      await addColumnComment('user_sessions', 'refresh_token_hash', '刷新令牌哈希值');
      await addColumnComment('user_sessions', 'device_id', '设备ID');
      await addColumnComment('user_sessions', 'device_name', '设备名称');
      await addColumnComment('user_sessions', 'device_type', '设备类型');
      await addColumnComment('user_sessions', 'ip_address', 'IP地址');
      await addColumnComment('user_sessions', 'user_agent', '用户代理');
      await addColumnComment('user_sessions', 'location_info', '位置信息（JSON）');
      await addColumnComment('user_sessions', 'last_activity_at', '最后活动时间');
      await addColumnComment('user_sessions', 'expires_at', '过期时间');
      await addColumnComment('user_sessions', 'is_active', '是否激活');
      await addColumnComment('user_sessions', 'created_at', '创建时间');
      await addColumnComment('user_sessions', 'updated_at', '更新时间');

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

      // 删除用户会话表
      await dropTable('user_sessions');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
