import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 项目成员管理控制器
class ProjectMemberController extends BaseController {
  final ProjectMemberService _projectMemberService;
  final ProjectService _projectService;

  ProjectMemberController({
    required ProjectMemberService projectMemberService,
    required ProjectService projectService,
  })  : _projectMemberService = projectMemberService,
        _projectService = projectService,
        super('ProjectMemberController');

  // 公共方法用于路由配置
  Future<Response> Function(Request, String) get generateInvite => _generateInvite;
  Future<Response> Function(Request, String) get getProjectInvites => _getProjectInvites;
  Future<Response> Function(Request, String, String) get revokeInvite => _revokeInvite;
  Future<Response> Function(Request, String) get getInviteInfo => _getInviteInfo;
  Future<Response> Function(Request, String) get acceptInvite => _acceptInvite;

  /// 生成邀请链接（需要 owner/admin 权限）
  Future<Response> _generateInvite(Request request, String projectId) async {
    return execute(
      () async {
        final projectIdInt = int.tryParse(projectId);
        if (projectIdInt == null) {
          return ResponseUtils.error(message: '项目ID格式无效');
        }

        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '用户信息不存在');
        }

        // 验证操作者权限
        final callerRole = await _projectService.getUserRoleInProject(userId, projectId);
        if (callerRole != 'owner' && callerRole != 'admin') {
          return ResponseUtils.error(message: '只有项目所有者或管理员可以生成邀请链接');
        }

        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final role = data['role'] as String? ?? 'member';
        final expiresIn = data['expires_in'] is int
            ? data['expires_in'] as int
            : (data['expires_in'] != null ? int.tryParse(data['expires_in'].toString()) : null);
        final maxUses = data['max_uses'] is int
            ? data['max_uses'] as int
            : (data['max_uses'] != null ? int.tryParse(data['max_uses'].toString()) : null);

        // 验证角色值是否有效（不允许通过邀请链接设置 owner 角色）
        final validRoles = ['admin', 'member', 'viewer'];
        if (!validRoles.contains(role)) {
          return ResponseUtils.error(message: '无效的角色类型');
        }

        final invite = await _projectMemberService.generateInvite(
          projectId: projectIdInt,
          invitedBy: userId,
          role: role,
          expiresInDays: expiresIn,
          maxUses: maxUses,
        );

        // 构建邀请URL
        final inviteUrl = _buildInviteUrl(invite.inviteCode!);

        // 返回数据包含完整的邀请信息
        final response = {
          'id': invite.id,
          'invite_code': invite.inviteCode,
          'invite_url': inviteUrl,
          'role': invite.role.name,
          'expires_at': invite.expiresAt?.toIso8601String(),
          'max_uses': invite.maxUses,
          'used_count': invite.usedCount,
          'status': invite.status.name,
          'created_at': invite.createdAt.toIso8601String(),
        };

        return ResponseUtils.success<Map<String, dynamic>>(
          message: '邀请链接生成成功',
          data: response,
        );
      },
      operationName: 'generateInvite',
    );
  }

  /// 获取项目的所有邀请链接（需要 owner/admin 权限）
  Future<Response> _getProjectInvites(Request request, String projectId) async {
    return execute(
      () async {
        final projectIdInt = int.tryParse(projectId);
        if (projectIdInt == null) {
          return ResponseUtils.error(message: '项目ID格式无效');
        }

        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '用户信息不存在');
        }

        // 验证操作者权限
        final callerRole = await _projectService.getUserRoleInProject(userId, projectId);
        if (callerRole != 'owner' && callerRole != 'admin') {
          return ResponseUtils.error(message: '只有项目所有者或管理员可以查看邀请链接');
        }

        final invites = await _projectMemberService.getProjectInvites(projectIdInt);

        return ResponseUtils.success<List<ProjectMemberModel>>(
          message: '获取邀请链接列表成功',
          data: invites,
        );
      },
      operationName: 'getProjectInvites',
    );
  }

  /// 撤销邀请链接（需要 owner/admin 权限）
  Future<Response> _revokeInvite(Request request, String projectId, String inviteId) async {
    return execute(
      () async {
        final projectIdInt = int.tryParse(projectId);
        if (projectIdInt == null) {
          return ResponseUtils.error(message: '项目ID格式无效');
        }

        final inviteIdInt = int.tryParse(inviteId);
        if (inviteIdInt == null) {
          return ResponseUtils.error(message: '邀请ID格式无效');
        }

        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '用户信息不存在');
        }

        // 验证操作者权限
        final callerRole = await _projectService.getUserRoleInProject(userId, projectId);
        if (callerRole != 'owner' && callerRole != 'admin') {
          return ResponseUtils.error(message: '只有项目所有者或管理员可以撤销邀请链接');
        }

        await _projectMemberService.revokeInvite(
          projectId: projectIdInt,
          inviteId: inviteIdInt,
        );

        return ResponseUtils.success(message: '邀请链接已撤销');
      },
      operationName: 'revokeInvite',
    );
  }

  /// 获取邀请信息（公开，无需认证）
  Future<Response> _getInviteInfo(Request request, String inviteCode) async {
    return execute(
      () async {
        final inviteInfo = await _projectMemberService.getInviteInfo(inviteCode);

        if (inviteInfo == null) {
          return ResponseUtils.error(message: '邀请链接不存在或已失效');
        }

        return ResponseUtils.success<InviteInfoModel>(
          message: '获取邀请信息成功',
          data: inviteInfo,
        );
      },
      operationName: 'getInviteInfo',
    );
  }

  /// 接受邀请（需要认证）
  Future<Response> _acceptInvite(Request request, String inviteCode) async {
    return execute(
      () async {
        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '请先登录');
        }

        final member = await _projectMemberService.acceptInviteByCode(
          inviteCode: inviteCode,
          userId: userId,
        );

        return ResponseUtils.success<ProjectMemberModel>(
          message: '成功加入项目',
          data: member,
        );
      },
      operationName: 'acceptInvite',
    );
  }

  /// 构建邀请URL
  String _buildInviteUrl(String inviteCode) {
    final siteUrl = ServerConfig.siteUrl.isNotEmpty ? ServerConfig.siteUrl : 'https://app.ttpolyglot.com';
    return '$siteUrl/join/$inviteCode';
  }
}
