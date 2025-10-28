import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

import 'base_migration.dart';

/// 迁移: 020 - 创建项目成员邀请日志表
/// 创建时间: 2025-10-28
/// 描述: 创建项目成员邀请日志表，记录邀请链接的使用历史
class Migration020ProjectMemberInviteLogsTable extends BaseMigration {
  @override
  String get name => '020_project_member_invite_logs_table';

  @override
  String get description => '创建项目成员邀请日志表，记录邀请链接的使用历史';

  @override
  String get createdAt => '2025-10-28';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建项目成员邀请日志表
      await createTable('project_member_invite_logs', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          member_id INTEGER NOT NULL,
          user_id UUID NOT NULL,
          accepted BOOLEAN DEFAULT false,
          accepted_at TIMESTAMPTZ,
          ip_address VARCHAR(45),
          user_agent TEXT,
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey(
          'project_member_invite_logs_member_id', 'project_member_invite_logs', 'member_id', 'project_members', 'id',
          onDelete: 'CASCADE');
      await addForeignKey('project_member_invite_logs_user_id', 'project_member_invite_logs', 'user_id', 'users', 'id',
          onDelete: 'CASCADE');

      // 创建索引
      await createIndex('project_member_invite_logs_member_id', 'project_member_invite_logs', 'member_id');
      await createIndex('project_member_invite_logs_user_id', 'project_member_invite_logs', 'user_id');
      await createIndex('project_member_invite_logs_accepted', 'project_member_invite_logs', 'accepted');
      await createIndex('project_member_invite_logs_created_at', 'project_member_invite_logs', 'created_at');

      // 添加表注释
      await addTableComment('project_member_invite_logs', '项目成员邀请日志表，记录邀请链接的使用历史');
      await addColumnComment('project_member_invite_logs', 'id', '日志ID，主键');
      await addColumnComment('project_member_invite_logs', 'member_id', '邀请链接ID，外键关联project_members表');
      await addColumnComment('project_member_invite_logs', 'user_id', '使用邀请的用户ID，外键关联users表');
      await addColumnComment('project_member_invite_logs', 'accepted', '是否接受邀请');
      await addColumnComment('project_member_invite_logs', 'accepted_at', '接受时间');
      await addColumnComment('project_member_invite_logs', 'ip_address', 'IP地址');
      await addColumnComment('project_member_invite_logs', 'user_agent', '用户代理');
      await addColumnComment('project_member_invite_logs', 'created_at', '创建时间');

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

      // 删除项目成员邀请日志表
      await dropTable('project_member_invite_logs');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
