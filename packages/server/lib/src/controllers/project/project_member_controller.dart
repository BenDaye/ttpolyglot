import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 项目成员管理控制器
class ProjectMemberController extends BaseController {
  final ProjectMemberService _projectMemberService;

  ProjectMemberController({
    required ProjectMemberService projectMemberService,
  })  : _projectMemberService = projectMemberService,
        super('ProjectMemberController');

  Router get router {
    final router = Router();

    // 邀请链接相关路由
    router.post('/<projectId>/invites', _generateInvite);
    router.get('/<projectId>/invites', _getProjectInvites);
    router.delete('/<projectId>/invites/<inviteId>', _revokeInvite);

    // 公开路由（无需认证）
    router.get('/invites/<inviteCode>/info', _getInviteInfo);
    router.post('/invites/<inviteCode>/accept', _acceptInvite);

    return router;
  }

  /// 生成邀请链接
  Future<Response> _generateInvite(Request request, String projectId) async {
    try {
      final projectIdInt = int.tryParse(projectId);
      if (projectIdInt == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }

      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '用户信息不存在');
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

      // 验证角色值是否有效
      final validRoles = ['owner', 'admin', 'member', 'viewer'];
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
    } catch (error, stackTrace) {
      log('[_generateInvite]', error: error, stackTrace: stackTrace, name: 'ProjectMemberController');

      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      if (error is BusinessException) {
        return ResponseUtils.error(message: error.message);
      }
      if (error is NotFoundException) {
        return ResponseUtils.error(message: '项目不存在');
      }

      return ResponseUtils.error(message: '生成邀请链接失败');
    }
  }

  /// 获取项目的所有邀请链接
  Future<Response> _getProjectInvites(Request request, String projectId) async {
    try {
      final projectIdInt = int.tryParse(projectId);
      if (projectIdInt == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }

      final invites = await _projectMemberService.getProjectInvites(projectIdInt);

      return ResponseUtils.success<List<ProjectMemberModel>>(
        message: '获取邀请链接列表成功',
        data: invites,
      );
    } catch (error, stackTrace) {
      log('[_getProjectInvites]', error: error, stackTrace: stackTrace, name: 'ProjectMemberController');
      return ResponseUtils.error(message: '获取邀请链接列表失败');
    }
  }

  /// 撤销邀请链接
  Future<Response> _revokeInvite(Request request, String projectId, String inviteId) async {
    try {
      final projectIdInt = int.tryParse(projectId);
      if (projectIdInt == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }

      final inviteIdInt = int.tryParse(inviteId);
      if (inviteIdInt == null) {
        return ResponseUtils.error(message: '邀请ID格式无效');
      }

      await _projectMemberService.revokeInvite(
        projectId: projectIdInt,
        inviteId: inviteIdInt,
      );

      return ResponseUtils.success(message: '邀请链接已撤销');
    } catch (error, stackTrace) {
      log('[_revokeInvite]', error: error, stackTrace: stackTrace, name: 'ProjectMemberController');

      if (error is NotFoundException) {
        return ResponseUtils.error(message: '邀请链接不存在');
      }

      return ResponseUtils.error(message: '撤销邀请链接失败');
    }
  }

  /// 获取邀请信息（公开，无需认证）
  Future<Response> _getInviteInfo(Request request, String inviteCode) async {
    try {
      final inviteInfo = await _projectMemberService.getInviteInfo(inviteCode);

      if (inviteInfo == null) {
        return ResponseUtils.error(message: '邀请链接不存在或已失效');
      }

      return ResponseUtils.success<InviteInfoModel>(
        message: '获取邀请信息成功',
        data: inviteInfo,
      );
    } catch (error, stackTrace) {
      log('[_getInviteInfo]', error: error, stackTrace: stackTrace, name: 'ProjectMemberController');
      return ResponseUtils.error(message: '获取邀请信息失败');
    }
  }

  /// 接受邀请（需要认证）
  Future<Response> _acceptInvite(Request request, String inviteCode) async {
    try {
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
    } catch (error, stackTrace) {
      log('[_acceptInvite]', error: error, stackTrace: stackTrace, name: 'ProjectMemberController');

      if (error is NotFoundException) {
        return ResponseUtils.error(message: '邀请链接不存在或已失效');
      }
      if (error is BusinessException) {
        return ResponseUtils.error(message: error.message);
      }

      return ResponseUtils.error(message: '接受邀请失败');
    }
  }

  /// 构建邀请URL
  String _buildInviteUrl(String inviteCode) {
    // 这里应该使用配置的前端地址
    // 暂时硬编码，实际应从环境变量或配置文件读取
    const frontendUrl = 'https://app.ttpolyglot.com';
    return '$frontendUrl/join/$inviteCode';
  }
}
