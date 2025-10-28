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
  Future<PagerModel<ProjectMemberModel>> getProjectMembers({
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
      // COUNT(*) 返回的可能是 int 或 bigint，需要安全转换
      final totalRaw = countResult.first[0];
      final total = (totalRaw is int) ? totalRaw : int.parse(totalRaw.toString());

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

      return PagerModel<ProjectMemberModel>(
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

        // project_members.id 是 SERIAL 类型（INTEGER），需要安全转换
        final rawMemberId = result.first[0];
        memberId = (rawMemberId is int) ? rawMemberId : int.parse(rawMemberId.toString());

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

  // ========== 邀请链接相关方法 ==========

  /// 生成邀请链接
  Future<ProjectMemberModel> generateInvite({
    required int projectId,
    required String invitedBy,
    required String role,
    int? expiresInDays,
    int? maxUses,
  }) async {
    try {
      log('[generateInvite] projectId=$projectId, role=$role', name: 'ProjectMemberService');

      // 检查项目是否存在
      final projectExists = await _isProjectExists(projectId);
      if (!projectExists) {
        throwNotFound('项目不存在');
      }

      // 检查项目成员上限
      await _checkMemberLimit(projectId);

      // 生成UUID作为邀请码
      final inviteCode = _generateUuid();

      // 计算过期时间
      DateTime? expiresAt;
      if (expiresInDays != null && expiresInDays > 0) {
        expiresAt = DateTime.now().add(Duration(days: expiresInDays));
      }

      // 创建邀请记录（user_id 为 NULL，invite_code 有值）
      late int inviteId;
      await _databaseService.transaction(() async {
        final result = await _databaseService.query('''
          INSERT INTO {project_members} (
            project_id, user_id, role, invited_by, invite_code,
            expires_at, max_uses, status
          ) VALUES (
            @project_id, NULL, @role, @invited_by, @invite_code,
            @expires_at, @max_uses, 'active'
          ) RETURNING id
        ''', {
          'project_id': projectId,
          'role': role,
          'invited_by': invitedBy,
          'invite_code': inviteCode,
          'expires_at': expiresAt?.toIso8601String(),
          'max_uses': maxUses,
        });

        final rawInviteId = result.first[0];
        inviteId = (rawInviteId is int) ? rawInviteId : int.parse(rawInviteId.toString());
      });

      // 获取创建的邀请信息
      final invite = await _getMemberById(inviteId);

      log('[generateInvite] 邀请链接生成成功: $inviteId', name: 'ProjectMemberService');

      return invite!;
    } catch (error, stackTrace) {
      log('[generateInvite]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 获取邀请信息（通过邀请码）
  Future<InviteInfoModel?> getInviteInfo(String inviteCode) async {
    try {
      log('[getInviteInfo] inviteCode=$inviteCode', name: 'ProjectMemberService');

      final sql = '''
        SELECT 
          pm.invite_code,
          pm.role,
          pm.expires_at,
          pm.max_uses,
          pm.used_count,
          pm.status,
          p.id as project_id,
          p.name as project_name,
          p.description as project_description,
          p.members_count as current_member_count,
          p.member_limit,
          u.id as inviter_id,
          u.username as inviter_username,
          u.display_name as inviter_display_name
        FROM {project_members} pm
        INNER JOIN {projects} p ON pm.project_id = p.id
        INNER JOIN {users} u ON pm.invited_by = u.id
        WHERE pm.invite_code = @invite_code AND pm.user_id IS NULL
      ''';

      final result = await _databaseService.query(sql, {'invite_code': inviteCode});

      if (result.isEmpty) {
        return null;
      }

      final row = result.first.toColumnMap();

      // 检查是否过期
      final expiresAt = row['expires_at'] != null ? DateTime.parse(row['expires_at'].toString()) : null;
      final isExpired = expiresAt != null && DateTime.now().isAfter(expiresAt);

      // 检查是否达到使用次数上限
      final maxUses = row['max_uses'] as int?;
      final usedCount = row['used_count'] as int? ?? 0;
      final isUsesExhausted = maxUses != null && usedCount >= maxUses;

      // 检查项目是否已达成员上限
      final currentMemberCount = row['current_member_count'] as int? ?? 0;
      final memberLimit = row['member_limit'] as int? ?? 10;
      final isMemberLimitReached = currentMemberCount >= memberLimit;

      // 检查状态
      final status = row['status'] as String?;
      final isActive = status == 'active';

      // 判断是否可用
      final isAvailable = isActive && !isExpired && !isUsesExhausted && !isMemberLimitReached;

      // 计算剩余使用次数
      int? remainingUses;
      if (maxUses != null) {
        remainingUses = maxUses - usedCount;
        if (remainingUses < 0) remainingUses = 0;
      }

      // 构建返回模型
      return InviteInfoModel(
        inviteCode: row['invite_code'] as String,
        project: InviteProjectInfo(
          id: row['project_id'] as int,
          name: row['project_name'] as String,
          description: row['project_description'] as String?,
          currentMemberCount: currentMemberCount,
          memberLimit: memberLimit,
        ),
        inviter: InviteUserInfo(
          id: row['inviter_id'] as String,
          username: row['inviter_username'] as String,
          displayName: row['inviter_display_name'] as String?,
        ),
        role: ProjectRoleEnumConverter().fromJson(row['role'] as String),
        expiresAt: expiresAt,
        isExpired: isExpired,
        isAvailable: isAvailable,
        remainingUses: remainingUses,
      );
    } catch (error, stackTrace) {
      log('[getInviteInfo]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 接受邀请（通过邀请码）
  Future<ProjectMemberModel> acceptInviteByCode({
    required String inviteCode,
    required String userId,
  }) async {
    try {
      log('[acceptInviteByCode] inviteCode=$inviteCode, userId=$userId', name: 'ProjectMemberService');

      // 获取邀请信息
      final inviteInfo = await getInviteInfo(inviteCode);

      if (inviteInfo == null) {
        throwNotFound('邀请链接不存在或已失效');
      }

      if (!inviteInfo.isAvailable) {
        if (inviteInfo.isExpired) {
          throwBusiness('邀请链接已过期');
        }
        if (inviteInfo.remainingUses != null && inviteInfo.remainingUses! <= 0) {
          throwBusiness('邀请链接使用次数已达上限');
        }
        if (inviteInfo.project.currentMemberCount >= inviteInfo.project.memberLimit) {
          throwBusiness('项目成员已达上限');
        }
        throwBusiness('邀请链接不可用');
      }

      final projectId = inviteInfo.project.id;

      // 检查用户是否已是成员
      final existingMember = await _getMemberByUserId(projectId, userId);
      if (existingMember != null) {
        throwBusiness('您已是项目成员');
      }

      // 在事务中创建成员记录并更新邀请使用次数
      late int memberId;
      await _databaseService.transaction(() async {
        // 创建成员记录
        final result = await _databaseService.query('''
          INSERT INTO {project_members} (
            project_id, user_id, role, invited_by, status, joined_at
          ) 
          SELECT project_id, @user_id, role, invited_by, 'active', CURRENT_TIMESTAMP
          FROM {project_members}
          WHERE invite_code = @invite_code AND user_id IS NULL
          RETURNING id
        ''', {
          'user_id': userId,
          'invite_code': inviteCode,
        });

        final rawMemberId = result.first[0];
        memberId = (rawMemberId is int) ? rawMemberId : int.parse(rawMemberId.toString());

        // 增加邀请使用次数
        await _databaseService.query('''
          UPDATE {project_members}
          SET used_count = used_count + 1
          WHERE invite_code = @invite_code AND user_id IS NULL
        ''', {'invite_code': inviteCode});

        // 更新项目成员数量
        await _updateProjectMemberCount(projectId);

        // TODO: 记录邀请日志到 project_member_invite_logs 表
      });

      // 清除缓存
      await _clearProjectMemberCache(projectId);

      // 获取创建的成员信息
      final member = await _getMemberById(memberId);

      log('[acceptInviteByCode] 邀请接受成功: $memberId', name: 'ProjectMemberService');

      return member!;
    } catch (error, stackTrace) {
      log('[acceptInviteByCode]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 获取项目的所有邀请链接
  Future<List<ProjectMemberModel>> getProjectInvites(int projectId) async {
    try {
      log('[getProjectInvites] projectId=$projectId', name: 'ProjectMemberService');

      final sql = '''
        SELECT 
          pm.*,
          u.username as inviter_username,
          u.display_name as inviter_display_name
        FROM {project_members} pm
        LEFT JOIN {users} u ON pm.invited_by = u.id
        WHERE pm.project_id = @project_id AND pm.user_id IS NULL
        ORDER BY pm.created_at DESC
      ''';

      final result = await _databaseService.query(sql, {'project_id': projectId});

      return result.map((row) {
        return ProjectMemberModel.fromJson(row.toColumnMap());
      }).toList();
    } catch (error, stackTrace) {
      log('[getProjectInvites]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 撤销邀请链接
  Future<void> revokeInvite({
    required int projectId,
    required int inviteId,
  }) async {
    try {
      log('[revokeInvite] projectId=$projectId, inviteId=$inviteId', name: 'ProjectMemberService');

      // 检查邀请是否存在
      final result = await _databaseService.query('''
        SELECT 1 FROM {project_members}
        WHERE id = @invite_id AND project_id = @project_id AND user_id IS NULL
      ''', {
        'invite_id': inviteId,
        'project_id': projectId,
      });

      if (result.isEmpty) {
        throwNotFound('邀请链接不存在');
      }

      // 更新状态为 revoked
      await _databaseService.query('''
        UPDATE {project_members}
        SET status = 'revoked', updated_at = CURRENT_TIMESTAMP
        WHERE id = @invite_id AND project_id = @project_id
      ''', {
        'invite_id': inviteId,
        'project_id': projectId,
      });

      log('[revokeInvite] 邀请链接已撤销', name: 'ProjectMemberService');
    } catch (error, stackTrace) {
      log('[revokeInvite]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 直接添加成员（包含成员上限检查）
  Future<ProjectMemberModel> addMember({
    required int projectId,
    required String userId,
    required String invitedBy,
    String role = 'member',
  }) async {
    try {
      log('[addMember] projectId=$projectId, userId=$userId, role=$role', name: 'ProjectMemberService');

      // 检查项目是否存在
      final projectExists = await _isProjectExists(projectId);
      if (!projectExists) {
        throwNotFound('项目不存在');
      }

      // 检查成员上限
      await _checkMemberLimit(projectId);

      // 检查用户是否已是成员
      final existingMember = await _getMemberByUserId(projectId, userId);
      if (existingMember != null) {
        throwBusiness('用户已是项目成员');
      }

      // 在事务中创建成员记录
      late int memberId;
      await _databaseService.transaction(() async {
        final result = await _databaseService.query('''
          INSERT INTO {project_members} (
            project_id, user_id, role, invited_by, status, joined_at
          ) VALUES (
            @project_id, @user_id, @role, @invited_by, 'active', CURRENT_TIMESTAMP
          ) RETURNING id
        ''', {
          'project_id': projectId,
          'user_id': userId,
          'role': role,
          'invited_by': invitedBy,
        });

        final rawMemberId = result.first[0];
        memberId = (rawMemberId is int) ? rawMemberId : int.parse(rawMemberId.toString());

        // 更新项目成员数量
        await _updateProjectMemberCount(projectId);
      });

      // 清除缓存
      await _clearProjectMemberCache(projectId);

      // 获取创建的成员信息
      final member = await _getMemberById(memberId);

      log('[addMember] 成员添加成功: $memberId', name: 'ProjectMemberService');

      return member!;
    } catch (error, stackTrace) {
      log('[addMember]', error: error, stackTrace: stackTrace, name: 'ProjectMemberService');
      rethrow;
    }
  }

  /// 检查项目成员上限
  Future<void> _checkMemberLimit(int projectId) async {
    final result = await _databaseService.query('''
      SELECT members_count, member_limit
      FROM {projects}
      WHERE id = @project_id
    ''', {'project_id': projectId});

    if (result.isEmpty) {
      throwNotFound('项目不存在');
    }

    final row = result.first.toColumnMap();
    final membersCount = row['members_count'] as int? ?? 0;
    final memberLimit = row['member_limit'] as int? ?? 10;

    if (membersCount >= memberLimit) {
      throwBusiness('项目成员已达上限 ($memberLimit)');
    }
  }

  /// 生成UUID
  String _generateUuid() {
    // 使用 Dart 的 UUID 生成库
    // 这里简化实现，实际应该使用 uuid package
    return '${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecond}';
  }
}
