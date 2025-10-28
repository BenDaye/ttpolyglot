import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目成员管理 API
class ProjectMemberApi {
  /// 获取项目成员列表
  Future<PagerModel<ProjectMemberModel>?> getProjectMembers({
    required int projectId,
    int page = 1,
    int limit = 50,
    String? role,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (role != null) {
        queryParameters['role'] = role;
      }

      if (status != null) {
        queryParameters['status'] = status;
      }

      final response = await HttpClient.get<Map<String, dynamic>>(
        '/projects/$projectId/members',
        query: queryParameters,
      );

      final result = Utils.toModel(
        response.data,
        (json) => PagerModel.fromJson(json, (data) => ProjectMemberModel.fromJson(data as Map<String, dynamic>)),
      );
      if (result == null) {
        Logger.error('获取项目成员列表响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[getProjectMembers] 获取项目成员失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 邀请成员
  Future<ProjectMemberModel?> inviteMember({
    required int projectId,
    required String userId,
    String role = 'member',
  }) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/projects/$projectId/members',
        data: {
          'userId': userId,
          'role': role,
        },
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectMemberModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('邀请成员响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[inviteMember] 邀请成员失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 接受邀请
  Future<ProjectMemberModel?> acceptInvitation({
    required int projectId,
  }) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/projects/$projectId/members/accept',
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectMemberModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('接受邀请响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[acceptInvitation] 接受邀请失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新成员角色
  Future<ProjectMemberModel?> updateMemberRole({
    required int projectId,
    required int memberId,
    required String role,
  }) async {
    try {
      final response = await HttpClient.put<Map<String, dynamic>>(
        '/projects/$projectId/members/$memberId',
        data: {
          'role': role,
        },
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectMemberModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('更新成员角色响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[updateMemberRole] 更新成员角色失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 移除成员
  Future<bool?> removeMember({
    required int projectId,
    required int memberId,
  }) async {
    try {
      final response = await HttpClient.delete(
        '/projects/$projectId/members/$memberId',
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final result = Utils.toModel(
        response.data,
        (json) => json['code'] == DataCodeEnum.success,
      );
      if (result == null) {
        Logger.error('移除成员响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[removeMember] 移除成员失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查是否为项目成员
  Future<bool?> isMember({
    required int projectId,
  }) async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>(
        '/projects/$projectId/members/check',
      );

      final result = Utils.toModel(
        response.data,
        (json) => json['is_member'] as bool? ?? false,
      );
      if (result == null) {
        Logger.error('检查是否为项目成员响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[isMember] 检查成员状态失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 获取成员角色
  Future<ProjectRoleEnum?> getMemberRole({
    required int projectId,
  }) async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>(
        '/projects/$projectId/members/role',
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectRoleEnum.fromValue(json['role'] as String),
      );
      if (result == null) {
        Logger.error('获取成员角色响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[getMemberRole] 获取成员角色失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  // ========== 邀请链接相关 API ==========

  /// 生成邀请链接
  Future<ProjectMemberModel?> generateInviteLink({
    required int projectId,
    required String role,
    int? expiresIn,
    int? maxUses,
  }) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/projects/$projectId/invites',
        data: {
          'role': role,
          if (expiresIn != null) 'expires_in': expiresIn,
          if (maxUses != null) 'max_uses': maxUses,
        },
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectMemberModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('生成邀请链接响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[generateInviteLink] 生成邀请链接失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目的所有邀请链接
  Future<List<ProjectMemberModel>?> getProjectInvites(int projectId) async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>(
        '/projects/$projectId/invites',
      );

      final result = Utils.toModel(
        response.data,
        (json) {
          final items = json as List;
          return items.map((item) => ProjectMemberModel.fromJson(item as Map<String, dynamic>)).toList();
        },
      );
      if (result == null) {
        Logger.error('获取邀请链接列表响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[getProjectInvites] 获取邀请链接列表失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取邀请信息
  Future<InviteInfoModel?> getInviteInfo(String inviteCode) async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>(
        '/invites/$inviteCode',
      );

      final result = Utils.toModel(
        response.data,
        (json) => InviteInfoModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('获取邀请信息响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[getInviteInfo] 获取邀请信息失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 接受邀请（通过邀请码）
  Future<ProjectMemberModel?> acceptInviteByCode(String inviteCode) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/invites/$inviteCode/accept',
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectMemberModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('接受邀请响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[acceptInviteByCode] 接受邀请失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 撤销邀请链接
  Future<bool?> revokeInvite({
    required int projectId,
    required int inviteId,
  }) async {
    try {
      final response = await HttpClient.delete(
        '/projects/$projectId/invites/$inviteId',
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final result = Utils.toModel(
        response.data,
        (json) => json['code'] == DataCodeEnum.success,
      );
      if (result == null) {
        Logger.error('撤销邀请链接响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[revokeInvite] 撤销邀请链接失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 直接添加成员
  Future<ProjectMemberModel?> addMember({
    required int projectId,
    required String userId,
    required String role,
  }) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/projects/$projectId/members/add',
        data: {
          'user_id': userId,
          'role': role,
        },
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectMemberModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('添加成员响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[addMember] 添加成员失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
