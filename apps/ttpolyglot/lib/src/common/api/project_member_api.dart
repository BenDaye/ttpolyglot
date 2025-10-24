import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目成员管理 API
class ProjectMemberApi {
  /// 获取项目成员列表
  Future<PagerModel<ProjectMemberModel>> getProjectMembers({
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

      final data = response.data as Map<String, dynamic>;
      return PagerModel<ProjectMemberModel>.fromJson(
        data,
        (json) => ProjectMemberModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (error, stackTrace) {
      Logger.error('[getProjectMembers] 获取项目成员失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 邀请成员
  Future<ProjectMemberModel> inviteMember({
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

      final data = response.data as Map<String, dynamic>;
      return ProjectMemberModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('[inviteMember] 邀请成员失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 接受邀请
  Future<ProjectMemberModel> acceptInvitation({
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

      final data = response.data as Map<String, dynamic>;
      return ProjectMemberModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('[acceptInvitation] 接受邀请失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新成员角色
  Future<ProjectMemberModel> updateMemberRole({
    required int projectId,
    required String userId,
    required String role,
  }) async {
    try {
      final response = await HttpClient.put<Map<String, dynamic>>(
        '/projects/$projectId/members/$userId',
        data: {
          'role': role,
        },
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return ProjectMemberModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('[updateMemberRole] 更新成员角色失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 移除成员
  Future<void> removeMember({
    required int projectId,
    required String userId,
  }) async {
    try {
      await HttpClient.delete(
        '/projects/$projectId/members/$userId',
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );
    } catch (error, stackTrace) {
      Logger.error('[removeMember] 移除成员失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查是否为项目成员
  Future<bool> isMember({
    required int projectId,
  }) async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>(
        '/projects/$projectId/members/check',
      );

      final data = response.data as Map<String, dynamic>;
      return data['is_member'] as bool? ?? false;
    } catch (error, stackTrace) {
      Logger.error('[isMember] 检查成员状态失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 获取成员角色
  Future<String?> getMemberRole({
    required int projectId,
  }) async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>(
        '/projects/$projectId/members/role',
      );

      final data = response.data as Map<String, dynamic>;
      return data['role'] as String?;
    } catch (error, stackTrace) {
      Logger.error('[getMemberRole] 获取成员角色失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
