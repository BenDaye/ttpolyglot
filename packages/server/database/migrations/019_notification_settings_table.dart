import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

import 'base_migration.dart';

/// 迁移: 019 - 创建通知设置表
/// 创建时间: 2025-10-23
/// 描述: 创建通知设置表，存储用户的通知偏好设置
class Migration019NotificationSettingsTable extends BaseMigration {
  @override
  String get name => '019_notification_settings_table';

  @override
  String get description => '创建通知设置表，存储用户的通知偏好设置';

  @override
  String get createdAt => '2025-10-23';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建通知设置表
      await createTable('notification_settings', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          user_id UUID NOT NULL,
          project_id INTEGER,
          notification_type VARCHAR(100) NOT NULL,
          channel VARCHAR(50) NOT NULL,
          is_enabled BOOLEAN DEFAULT true,
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(user_id, project_id, notification_type, channel)
        );
      ''');

      // 创建外键约束
      await addForeignKey('notification_settings_user_id', 'notification_settings', 'user_id', 'users', 'id',
          onDelete: 'CASCADE');
      await addForeignKey('notification_settings_project_id', 'notification_settings', 'project_id', 'projects', 'id',
          onDelete: 'CASCADE');

      // 创建索引
      await createIndex('notification_settings_user_id', 'notification_settings', 'user_id');
      await createIndex('notification_settings_project_id', 'notification_settings', 'project_id');
      await createIndex('notification_settings_notification_type', 'notification_settings', 'notification_type');
      await createIndex('notification_settings_channel', 'notification_settings', 'channel');
      await createIndex('notification_settings_is_enabled', 'notification_settings', 'is_enabled');

      // 为通知设置表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}notification_settings_updated_at 
          BEFORE UPDATE ON ${tablePrefix}notification_settings 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('notification_settings', '通知设置表，存储用户的通知偏好设置');
      await addColumnComment('notification_settings', 'id', '设置ID，主键');
      await addColumnComment('notification_settings', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('notification_settings', 'project_id', '项目ID，外键关联projects表，NULL表示全局设置');
      await addColumnComment('notification_settings', 'notification_type', '通知类型：project.created/member.invited等');
      await addColumnComment('notification_settings', 'channel', '通知渠道：email/in_app');
      await addColumnComment('notification_settings', 'is_enabled', '是否启用');
      await addColumnComment('notification_settings', 'created_at', '创建时间');
      await addColumnComment('notification_settings', 'updated_at', '更新时间');

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

      // 删除通知设置表
      await dropTable('notification_settings');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
