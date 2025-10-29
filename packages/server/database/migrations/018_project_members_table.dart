import 'package:ttpolyglot_utils/utils.dart';

import 'base_migration.dart';

/// 迁移: 018 - 创建项目成员表
/// 创建时间: 2025-10-23
/// 描述: 创建项目成员表，存储项目成员关系和角色
class Migration018ProjectMembersTable extends BaseMigration {
  @override
  String get name => '018_project_members_table';

  @override
  String get description => '创建项目成员表，存储项目成员关系和角色';

  @override
  String get createdAt => '2025-10-23';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建项目成员表
      await createTable('project_members', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          project_id INTEGER NOT NULL,
          user_id UUID,
          role VARCHAR(50) DEFAULT 'member',
          invited_by UUID,
          invited_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          joined_at TIMESTAMPTZ,
          status VARCHAR(50) DEFAULT 'pending',
          is_active BOOLEAN DEFAULT true,
          invite_code UUID UNIQUE,
          expires_at TIMESTAMPTZ,
          max_uses INTEGER,
          used_count INTEGER DEFAULT 0,
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(project_id, user_id),
          CHECK (
            (user_id IS NOT NULL AND invite_code IS NULL) OR 
            (user_id IS NULL AND invite_code IS NOT NULL)
          )
        );
      ''');

      // 创建外键约束
      await addForeignKey('project_members_project_id', 'project_members', 'project_id', 'projects', 'id',
          onDelete: 'CASCADE');
      await addForeignKey('project_members_user_id', 'project_members', 'user_id', 'users', 'id', onDelete: 'CASCADE');
      await addForeignKey('project_members_invited_by', 'project_members', 'invited_by', 'users', 'id',
          onDelete: 'SET NULL');

      // 创建索引
      await createIndex('project_members_project_id', 'project_members', 'project_id');
      await createIndex('project_members_user_id', 'project_members', 'user_id');
      await createIndex('project_members_role', 'project_members', 'role');
      await createIndex('project_members_status', 'project_members', 'status');
      await createIndex('project_members_is_active', 'project_members', 'is_active');
      await createIndex('project_members_invited_by', 'project_members', 'invited_by');
      await createIndex('project_members_invite_code', 'project_members', 'invite_code');
      await createIndex('project_members_expires_at', 'project_members', 'expires_at');

      // 为项目成员表创建触发器
      await connection.execute('''
        CREATE TRIGGER update_${tablePrefix}project_members_updated_at 
          BEFORE UPDATE ON ${tablePrefix}project_members 
          FOR EACH ROW 
          EXECUTE FUNCTION update_updated_at_column();
      ''');

      // 添加表注释
      await addTableComment('project_members', '项目成员表，存储项目成员关系和邀请链接');
      await addColumnComment('project_members', 'id', '成员关系ID，主键');
      await addColumnComment('project_members', 'project_id', '项目ID，外键关联projects表');
      await addColumnComment('project_members', 'user_id', '用户ID，外键关联users表（邀请链接记录为NULL）');
      await addColumnComment('project_members', 'role', '项目角色：owner/admin/member/viewer');
      await addColumnComment('project_members', 'invited_by', '邀请人ID，外键关联users表');
      await addColumnComment('project_members', 'invited_at', '邀请时间');
      await addColumnComment('project_members', 'joined_at', '加入时间');
      await addColumnComment('project_members', 'status', '状态：pending/active/inactive/expired/revoked');
      await addColumnComment('project_members', 'is_active', '是否激活');
      await addColumnComment('project_members', 'invite_code', '邀请码UUID，仅邀请链接记录有值');
      await addColumnComment('project_members', 'expires_at', '过期时间，NULL表示永久有效');
      await addColumnComment('project_members', 'max_uses', '最大使用次数，NULL表示无限次');
      await addColumnComment('project_members', 'used_count', '已使用次数');
      await addColumnComment('project_members', 'created_at', '创建时间');
      await addColumnComment('project_members', 'updated_at', '更新时间');

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

      // 删除项目成员表
      await dropTable('project_members');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
