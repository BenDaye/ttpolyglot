import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

import 'base_migration.dart';

/// 迁移: 015 - 创建审计日志表
/// 创建时间: 2024-12-26
/// 描述: 创建审计日志表，存储系统审计日志
class Migration015AuditLogsTable extends BaseMigration {
  @override
  String get name => '015_audit_logs_table';

  @override
  String get description => '创建审计日志表，存储系统审计日志';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建审计日志表
      await createTable('audit_logs', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          user_id UUID,
          action VARCHAR(100) NOT NULL,
          resource_type VARCHAR(50) NOT NULL,
          resource_id INTEGER,
          old_values JSONB,
          new_values JSONB,
          ip_address INET,
          user_agent TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey('audit_logs_user_id', 'audit_logs', 'user_id', 'users', 'id', onDelete: 'SET NULL');

      // 创建索引
      await createIndex('audit_logs_user_id', 'audit_logs', 'user_id');
      await createIndex('audit_logs_action', 'audit_logs', 'action');
      await createIndex('audit_logs_resource_type', 'audit_logs', 'resource_type');
      await createIndex('audit_logs_resource_id', 'audit_logs', 'resource_id');
      await createIndex('audit_logs_created_at', 'audit_logs', 'created_at');

      // 添加表注释
      await addTableComment('audit_logs', '审计日志表，存储系统审计日志');
      await addColumnComment('audit_logs', 'id', '日志ID，主键');
      await addColumnComment('audit_logs', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('audit_logs', 'action', '操作类型');
      await addColumnComment('audit_logs', 'resource_type', '资源类型');
      await addColumnComment('audit_logs', 'resource_id', '资源ID');
      await addColumnComment('audit_logs', 'old_values', '旧值，JSON格式');
      await addColumnComment('audit_logs', 'new_values', '新值，JSON格式');
      await addColumnComment('audit_logs', 'ip_address', 'IP地址');
      await addColumnComment('audit_logs', 'user_agent', '用户代理');
      await addColumnComment('audit_logs', 'created_at', '创建时间');

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

      // 删除审计日志表
      await dropTable('audit_logs');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
