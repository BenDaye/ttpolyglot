import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 项目 API
class ProjectApi {
  /// 获取项目列表
  Future<PagerModel<ProjectModel>?> getProjects({
    int page = 1,
    int limit = 50,
    String? search,
    String? status,
  }) async {
    try {
      LoggerUtils.info('[getProjects] page=$page, limit=$limit, search=$search, status=$status', name: 'ProjectApi');

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await HttpClient.get(
        '/projects',
        query: queryParams,
      );

      final result = Utils.toModel(
        response.data,
        (json) => PagerModel.fromJson(json, (data) => ProjectModel.fromJson(data as Map<String, dynamic>)),
      );
      if (result == null) {
        LoggerUtils.error('获取项目列表响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[getProjects]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 获取项目详情
  Future<ProjectDetailModel?> getProject(int projectId) async {
    try {
      LoggerUtils.info('[getProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.get('/projects/$projectId');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectDetailModel.fromJson(json),
      );
      if (result == null) {
        LoggerUtils.error('获取项目详情响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[getProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 创建项目
  Future<ProjectModel?> createProject({
    required String name,
    String? description,
    required int primaryLanguageId,
    String? slug,
    String visibility = 'private',
    Map<String, dynamic>? settings,
    List<int>? targetLanguageIds,
  }) async {
    try {
      LoggerUtils.info(
        '[createProject] name=$name, primaryLanguageId=$primaryLanguageId, targetLanguages=$targetLanguageIds',
        name: 'ProjectApi',
      );

      final requestData = {
        'name': name,
        'description': description,
        'primary_language_id': primaryLanguageId,
        'slug': slug ?? name.toLowerCase().replaceAll(' ', '-'),
        'visibility': visibility,
        'settings': settings ?? {},
        if (targetLanguageIds != null && targetLanguageIds.isNotEmpty) 'target_language_ids': targetLanguageIds,
      };

      final response = await HttpClient.post(
        '/projects',
        data: requestData,
      );

      if (response.data == null) {
        return null;
      }

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        LoggerUtils.error('创建项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[createProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      return null;
    }
  }

  /// 更新项目
  Future<ProjectModel?> updateProject({
    required int projectId,
    String? name,
    String? description,
    String? status,
    String? visibility,
    Map<String, dynamic>? settings,
  }) async {
    try {
      LoggerUtils.info('[updateProject] projectId=$projectId', name: 'ProjectApi');

      final requestData = <String, dynamic>{};

      if (name != null) requestData['name'] = name;
      if (description != null) requestData['description'] = description;
      if (status != null) requestData['status'] = status;
      if (visibility != null) requestData['visibility'] = visibility;
      if (settings != null) requestData['settings'] = settings;

      final response = await HttpClient.put(
        '/projects/$projectId',
        data: requestData,
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        LoggerUtils.error('更新项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[updateProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 删除项目
  Future<bool?> deleteProject(int projectId) async {
    try {
      LoggerUtils.info('[deleteProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.delete('/projects/$projectId');

      final result = Utils.toModel(
        response.data,
        (json) => json['code'] == DataCodeEnum.success,
      );
      if (result == null) {
        LoggerUtils.error('删除项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[deleteProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 检查项目名称是否可用
  Future<bool?> checkProjectNameAvailable(String name, {int? excludeProjectId}) async {
    try {
      LoggerUtils.info('[checkProjectNameAvailable] name=$name', name: 'ProjectApi');

      final queryParams = <String, dynamic>{
        'name': name,
      };

      if (excludeProjectId != null) {
        queryParams['exclude_id'] = excludeProjectId;
      }

      final response = await HttpClient.get(
        '/projects/check-name',
        query: queryParams,
      );

      final result = Utils.toModel(
        response.data,
        (json) => json['available'] as bool,
      );
      if (result == null) {
        LoggerUtils.error('检查项目名称是否可用响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[checkProjectNameAvailable]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 获取项目统计信息
  Future<ProjectStatisticsModel?> getProjectStats(int projectId) async {
    try {
      LoggerUtils.info('[getProjectStats] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.get('/projects/$projectId/stats');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectStatisticsModel.fromJson(json),
      );
      if (result == null) {
        LoggerUtils.error('获取项目统计信息响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[getProjectStats]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 归档项目
  Future<ProjectModel?> archiveProject(int projectId) async {
    try {
      LoggerUtils.info('[archiveProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.post('/projects/$projectId/archive');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        LoggerUtils.error('归档项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[archiveProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 恢复项目
  Future<ProjectModel?> restoreProject(int projectId) async {
    try {
      LoggerUtils.info('[restoreProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.post('/projects/$projectId/restore');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        LoggerUtils.error('恢复项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[restoreProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      return null;
    }
  }

  /// 添加项目语言
  Future<bool> addProjectLanguage({
    required int projectId,
    required int languageId,
  }) async {
    try {
      LoggerUtils.info('[addProjectLanguage] projectId=$projectId, languageId=$languageId', name: 'ProjectApi');

      final response = await HttpClient.post(
        '/projects/$projectId/languages',
        data: {'language_id': languageId},
      );

      return response.code == DataCodeEnum.success;
    } catch (error, stackTrace) {
      LoggerUtils.error('[addProjectLanguage]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 更新项目成员上限
  Future<ProjectModel?> updateMemberLimit({
    required int projectId,
    required int memberLimit,
  }) async {
    try {
      LoggerUtils.info('[updateMemberLimit] projectId=$projectId, memberLimit=$memberLimit', name: 'ProjectApi');

      final response = await HttpClient.patch(
        '/projects/$projectId/member-limit',
        data: {'member_limit': memberLimit},
      );

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        LoggerUtils.error('更新成员上限响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[updateMemberLimit]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  // ========== 邀请链接相关 API ==========

  /// 生成邀请链接
  Future<Map<String, dynamic>?> generateInviteLink({
    required int projectId,
    required String role,
    int? expiresInDays,
    int? maxUses,
  }) async {
    try {
      LoggerUtils.info('[generateInviteLink] projectId=$projectId, role=$role', name: 'ProjectApi');

      final response = await HttpClient.post(
        '/projects/$projectId/invites',
        data: {
          'role': role,
          if (expiresInDays != null) 'expires_in': expiresInDays,
          if (maxUses != null) 'max_uses': maxUses,
        },
      );

      return response.data as Map<String, dynamic>?;
    } catch (error, stackTrace) {
      LoggerUtils.error('[generateInviteLink]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 获取项目的所有邀请链接
  Future<List<ProjectMemberModel>?> getProjectInvites(int projectId) async {
    try {
      LoggerUtils.info('[getProjectInvites] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.get('/projects/$projectId/invites');

      final result = Utils.toModelArray(
        response.data,
        (json) => ProjectMemberModel.fromJson(json),
      );
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[getProjectInvites]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 撤销邀请链接
  Future<bool> revokeInvite({
    required int projectId,
    required int inviteId,
  }) async {
    try {
      LoggerUtils.info('[revokeInvite] projectId=$projectId, inviteId=$inviteId', name: 'ProjectApi');

      final response = await HttpClient.delete('/projects/$projectId/invites/$inviteId');

      return response.code == DataCodeEnum.success;
    } catch (error, stackTrace) {
      LoggerUtils.error('[revokeInvite]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 获取邀请信息（公开接口，无需认证）
  Future<InviteInfoModel?> getInviteInfo(String inviteCode) async {
    try {
      LoggerUtils.info('[getInviteInfo] inviteCode=$inviteCode', name: 'ProjectApi');

      final response = await HttpClient.get('/projects/invites/$inviteCode/info');

      final result = Utils.toModel(
        response.data,
        (json) => InviteInfoModel.fromJson(json),
      );
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[getInviteInfo]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 接受邀请
  Future<ProjectMemberModel?> acceptInvite(String inviteCode) async {
    try {
      LoggerUtils.info('[acceptInvite] inviteCode=$inviteCode', name: 'ProjectApi');

      final response = await HttpClient.post('/projects/invites/$inviteCode/accept');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectMemberModel.fromJson(json),
      );
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[acceptInvite]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  // ========== 成员管理相关 API ==========

  /// 直接添加成员
  Future<bool> addProjectMember({
    required int projectId,
    required String userId,
    required String role,
  }) async {
    try {
      LoggerUtils.info('[addProjectMember] projectId=$projectId, userId=$userId, role=$role', name: 'ProjectApi');

      final response = await HttpClient.post(
        '/projects/$projectId/members',
        data: {
          'user_id': userId,
          'role': role,
        },
      );

      return response.code == DataCodeEnum.success;
    } catch (error, stackTrace) {
      LoggerUtils.error('[addProjectMember]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 移除成员
  Future<bool> removeProjectMember({
    required int projectId,
    required String userId,
  }) async {
    try {
      LoggerUtils.info('[removeProjectMember] projectId=$projectId, userId=$userId', name: 'ProjectApi');

      final response = await HttpClient.delete('/projects/$projectId/members/$userId');

      return response.code == DataCodeEnum.success;
    } catch (error, stackTrace) {
      LoggerUtils.error('[removeProjectMember]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 更新成员角色
  Future<bool> updateMemberRole({
    required int projectId,
    required String userId,
    required String role,
  }) async {
    try {
      LoggerUtils.info('[updateMemberRole] projectId=$projectId, userId=$userId, role=$role', name: 'ProjectApi');

      final response = await HttpClient.put(
        '/projects/$projectId/members/$userId',
        data: {'role': role},
      );

      return response.code == DataCodeEnum.success;
    } catch (error, stackTrace) {
      LoggerUtils.error('[updateMemberRole]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 删除项目语言
  Future<bool> removeProjectLanguage({
    required int projectId,
    required int languageId,
  }) async {
    try {
      LoggerUtils.info('[removeProjectLanguage] projectId=$projectId, languageId=$languageId', name: 'ProjectApi');

      final response = await HttpClient.delete('/projects/$projectId/languages/$languageId');

      return response.code == DataCodeEnum.success;
    } catch (error, stackTrace) {
      LoggerUtils.error('[removeProjectLanguage]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }
}
