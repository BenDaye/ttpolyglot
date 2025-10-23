import 'dart:developer';

import 'package:ttpolyglot_model/model.dart';

import '../base_service.dart';
import '../infrastructure/database_service.dart';
import '../infrastructure/redis_service.dart';

/// 项目成员服务
class ProjectMemberService extends BaseService {
  final DatabaseService _databaseService;
  final RedisService _redisService;

  ProjectMemberService({
    required DatabaseService databaseService,
    required RedisService redisService,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        super('ProjectMemberService');

  /// 获取项目成员列表
  Future<ApiResponsePagerModel<ProjectMemberModel>> getProjectMembers({
    required int projectId,
    int page = 1,
    int limit = 50,
    String? role,
    String? status,
  }) async {
    try {
      log('[getProjectMembers]', name: 'ProjectMemberService');

      // 构建查询条件
      final conditions = <String>['pm.project_id = @project_id'];
      final parameters = <String, dynamic>{'project_id': projectId};

      if (role != null && role.isNotEmpty) {
        conditions.add('pm.role = @role');
        parameters['role'] = role;
      }

      if (status != null && status.isNotEmpty) {
        conditions.add('pm.status = @status');
        parameters['status'] = status;
      }

      // 计算总数
      final countSql = '''
        SELECT COUNT(*) FROM {project_members} pm
        WHERE ${conditions.join(' AND ')}
      ''';

      final countResult = await _databaseService.query(countSql, parameters);
      final total = countResult.first[0] as int;

      // 获取分页数据
      final offset = (page - 1) * limit;
      parameters['limit'] = limit;
      parameters['offset'] = offset;

      final membersSql = '''
        SELECT 
          pm.*,
          u.username,
          u.display_name,
          u.avatar_url,
          u.email,
          inv.username as inviter_username,
          inv.display_name as inviter_display_name
        FROM {project_members} pm
        LEFT JOIN {users} u ON pm.user_id = u.id
        LEFT JOIN {users} inv ON pm.invited_by = inv.id
        WHERE ${conditions.join(' AND ')}
        ORDER BY 
          CASE pm.role
            WHEN 'owner' THEN 1
            WHEN 'admin' THEN 2
            WHEN 'member' THEN 3
            WHEN 'viewer' THEN 4
            ELSE 5
          END,
          pm.joined_at DESC NULLS LAST,
          pm.invited_at DESC
        LIMIT @limit OFFSET @offset
      ''';

      final membersResult = await _databaseService.query(membersSql, parameters);

      final members = membersResult.map((row) {
        return ProjectMemberModel.fromJson(row.toColumnMap());
      }).toList();

      return ApiResponsePagerModel<ProjectMemberModel>(
        page: page,
        pageSize: limit,
        totalSize: total,
        totalPage: (total / limit).ceil(),
        items: members,
      );
    } catch (error, stackTrace) {
      log('[getProjectMembers]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 邀请成员
  Future<ProjectMemberModel> inviteMember({
    required int projectId,
    required String userId,
    required String invitedBy,
    String role = 'member',
  }) async {
    try {
      log('[inviteMember] projectId=$projectId, userId=$userId, role=$role', name: 'ProjectMemberService');

      // 检查项目是否存在
      final projectExists = await _isProjectExists(projectId);
      if (!projectExists) {
        throwNotFound('项目不存在');
      }

      // 检查用户是否已是成员
      final existingMember = await _getMemberByUserId(projectId, userId);
      if (existingMember != null) {
        if (existingMember.status == MemberStatusEnum.active) {
          throwBusiness('用户已是项目成员');
        } else if (existingMember.status == MemberStatusEnum.pending) {
          throwBusiness('用户已有待处理的邀请');
        }
      }

      // 在事务中创建成员记录
      late int memberId;
      await _databaseService.transaction(() async {
        final result = await _databaseService.query('''
          INSERT INTO {project_members} (
            project_id, user_id, role, invited_by, status
          ) VALUES (
            @project_id, @user_id, @role, @invited_by, 'pending'
          ) RETURNING id
        ''', {
          'project_id': projectId,
          'user_id': userId,
          'role': role,
          'invited_by': invitedBy,
        });

        memberId = result.first[0] as int;

        // 更新项目成员数量
        await _updateProjectMemberCount(projectId);
      });

      // 清除缓存
      await _clearProjectMemberCache(projectId);

      // 获取创建的成员信息
      final member = await _getMemberById(memberId);

      log('[inviteMember] 成员邀请成功: $memberId', name: 'ProjectMemberService');

      return member!;
    } catch (error, stackTrace) {
      log('[inviteMember]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 接受邀请
  Future<ProjectMemberModel> acceptInvitation({
    required int projectId,
    required String userId,
  }) async {
    try {
      log('[acceptInvitation] projectId=$projectId, userId=$userId', name: 'ProjectMemberService');

      final member = await _getMemberByUserId(projectId, userId);
      if (member == null) {
        throwNotFound('未找到邀请记录');
      }

      if (member.status != MemberStatusEnum.pending) {
        throwBusiness('邀请状态无效');
      }

      // 更新状态
      await _databaseService.query('''
        UPDATE {project_members}
        SET status = 'active',
            joined_at = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP
        WHERE project_id = @project_id AND user_id = @user_id
      ''', {
        'project_id': projectId,
        'user_id': userId,
      });

      // 更新项目成员数量
      await _updateProjectMemberCount(projectId);

      // 清除缓存
      await _clearProjectMemberCache(projectId);

      // 获取更新后的成员信息
      final updatedMember = await _getMemberByUserId(projectId, userId);

      log('[acceptInvitation] 邀请接受成功', name: 'ProjectMemberService');

      return updatedMember!;
    } catch (error, stackTrace) {
      log('[acceptInvitation]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 移除成员
  Future<void> removeMember({
    required int projectId,
    required String userId,
  }) async {
    try {
      log('[removeMember] projectId=$projectId, userId=$userId', name: 'ProjectMemberService');

      final member = await _getMemberByUserId(projectId, userId);
      if (member == null) {
        throwNotFound('成员不存在');
      }

      if (member.role == ProjectRoleEnum.owner) {
        throwBusiness('不能移除项目所有者');
      }

      // 在事务中删除成员
      await _databaseService.transaction(() async {
        await _databaseService.query('''
          DELETE FROM {project_members}
          WHERE project_id = @project_id AND user_id = @user_id
        ''', {
          'project_id': projectId,
          'user_id': userId,
        });

        // 更新项目成员数量
        await _updateProjectMemberCount(projectId);
      });

      // 清除缓存
      await _clearProjectMemberCache(projectId);

      log('[removeMember] 成员移除成功', name: 'ProjectMemberService');
    } catch (error, stackTrace) {
      log('[removeMember]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 更新成员角色
  Future<ProjectMemberModel> updateMemberRole({
    required int projectId,
    required String userId,
    required String newRole,
  }) async {
    try {
      log('[updateMemberRole] projectId=$projectId, userId=$userId, newRole=$newRole', name: 'ProjectMemberService');

      final member = await _getMemberByUserId(projectId, userId);
      if (member == null) {
        throwNotFound('成员不存在');
      }

      if (member.role == ProjectRoleEnum.owner && newRole != ProjectRoleEnum.owner.value) {
        throwBusiness('不能修改所有者角色，请先转移所有权');
      }

      // 更新角色
      await _databaseService.query('''
        UPDATE {project_members}
        SET role = @role,
            updated_at = CURRENT_TIMESTAMP
        WHERE project_id = @project_id AND user_id = @user_id
      ''', {
        'project_id': projectId,
        'user_id': userId,
        'role': newRole,
      });

      // 清除缓存
      await _clearProjectMemberCache(projectId);

      // 获取更新后的成员信息
      final updatedMember = await _getMemberByUserId(projectId, userId);

      log('[updateMemberRole] 角色更新成功', name: 'ProjectMemberService');

      return updatedMember!;
    } catch (error, stackTrace) {
      log('[updateMemberRole]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 检查用户是否为项目成员
  Future<bool> isMember({
    required int projectId,
    required String userId,
  }) async {
    try {
      final member = await _getMemberByUserId(projectId, userId);
      return member != null && member.status == MemberStatusEnum.active;
    } catch (error, stackTrace) {
      log('[isMember]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      return false;
    }
  }

  /// 获取用户在项目中的角色
  Future<String?> getMemberRole({
    required int projectId,
    required String userId,
  }) async {
    try {
      final member = await _getMemberByUserId(projectId, userId);
      if (member != null && member.status == MemberStatusEnum.active) {
        return member.role.value;
      }
      return null;
    } catch (error, stackTrace) {
      log('[getMemberRole]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      return null;
    }
  }

  // ========== 辅助方法 ==========

  /// 检查项目是否存在
  Future<bool> _isProjectExists(int projectId) async {
    final result = await _databaseService.query('''
      SELECT 1 FROM {projects} WHERE id = @project_id
    ''', {'project_id': projectId});
    return result.isNotEmpty;
  }

  /// 根据用户ID获取成员
  Future<ProjectMemberModel?> _getMemberByUserId(int projectId, String userId) async {
    final result = await _databaseService.query('''
      SELECT 
        pm.*,
        u.username,
        u.display_name,
        u.avatar_url,
        u.email
      FROM {project_members} pm
      LEFT JOIN {users} u ON pm.user_id = u.id
      WHERE pm.project_id = @project_id AND pm.user_id = @user_id
    ''', {
      'project_id': projectId,
      'user_id': userId,
    });

    if (result.isEmpty) {
      return null;
    }

    return ProjectMemberModel.fromJson(result.first.toColumnMap());
  }

  /// 根据ID获取成员
  Future<ProjectMemberModel?> _getMemberById(int memberId) async {
    final result = await _databaseService.query('''
      SELECT 
        pm.*,
        u.username,
        u.display_name,
        u.avatar_url,
        u.email,
        inv.username as inviter_username,
        inv.display_name as inviter_display_name
      FROM {project_members} pm
      LEFT JOIN {users} u ON pm.user_id = u.id
      LEFT JOIN {users} inv ON pm.invited_by = inv.id
      WHERE pm.id = @id
    ''', {'id': memberId});

    if (result.isEmpty) {
      return null;
    }

    return ProjectMemberModel.fromJson(result.first.toColumnMap());
  }

  /// 更新项目成员数量
  Future<void> _updateProjectMemberCount(int projectId) async {
    await _databaseService.query('''
      UPDATE {projects}
      SET members_count = (
        SELECT COUNT(*) FROM {project_members}
        WHERE project_id = @project_id AND status = 'active'
      )
      WHERE id = @project_id
    ''', {'project_id': projectId});
  }

  /// 清除项目成员缓存
  Future<void> _clearProjectMemberCache(int projectId) async {
    await _redisService.deleteByPattern('project:members:$projectId:*');
    await _redisService.delete('project:details:$projectId');
  }
}
