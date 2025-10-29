import 'package:ttpolyglot_model/model.dart';

import 'base_migration.dart';

/// 迁移: 014 - 创建通知表
/// 创建时间: 2024-12-26
/// 描述: 创建通知表，存储系统通知信息
class Migration014NotificationsTable extends BaseMigration {
  @override
  String get name => '014_notifications_table';

  @override
  String get description => '创建通知表，存储系统通知信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      ServerLogger.info('开始执行迁移: $name');

      // 创建通知表
      await createTable('notifications', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          user_id UUID NOT NULL,
          title VARCHAR(200) NOT NULL,
          message TEXT NOT NULL,
          type VARCHAR(50) NOT NULL,
          priority VARCHAR(20) DEFAULT 'normal',
          is_read BOOLEAN DEFAULT false,
          is_system BOOLEAN DEFAULT false,
          action_url TEXT,
          metadata JSONB,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          read_at TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey('notifications_user_id', 'notifications', 'user_id', 'users', 'id');

      // 创建索引
      await createIndex('notifications_user_id', 'notifications', 'user_id');
      await createIndex('notifications_type', 'notifications', 'type');
      await createIndex('notifications_priority', 'notifications', 'priority');
      await createIndex('notifications_is_read', 'notifications', 'is_read');
      await createIndex('notifications_is_system', 'notifications', 'is_system');
      await createIndex('notifications_created_at', 'notifications', 'created_at');
      await createIndex('notifications_read_at', 'notifications', 'read_at');

      // 添加表注释
      await addTableComment('notifications', '通知表，存储系统通知信息');
      await addColumnComment('notifications', 'id', '通知ID，主键');
      await addColumnComment('notifications', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('notifications', 'title', '通知标题');
      await addColumnComment('notifications', 'message', '通知内容');
      await addColumnComment('notifications', 'type', '通知类型');
      await addColumnComment('notifications', 'priority', '通知优先级');
      await addColumnComment('notifications', 'is_read', '是否已读');
      await addColumnComment('notifications', 'is_system', '是否为系统通知');
      await addColumnComment('notifications', 'action_url', '操作URL');
      await addColumnComment('notifications', 'metadata', '元数据，JSON格式');
      await addColumnComment('notifications', 'created_at', '创建时间');
      await addColumnComment('notifications', 'read_at', '阅读时间');

      ServerLogger.info('迁移完成: $name');
    } catch (error, stackTrace) {
      ServerLogger.error('迁移失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      ServerLogger.info('开始回滚迁移: $name');

      // 删除通知表
      await dropTable('notifications');

      ServerLogger.info('回滚完成: $name');
    } catch (error, stackTrace) {
      ServerLogger.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
