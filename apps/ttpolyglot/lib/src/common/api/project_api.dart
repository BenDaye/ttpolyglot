import 'dart:developer';

import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目 API
class ProjectApi {
  /// 获取项目列表
  Future<ApiResponsePagerModel<ProjectModel>> getProjects({
    int page = 1,
    int limit = 50,
    String? search,
    String? status,
  }) async {
    try {
      log('[getProjects] page=$page, limit=$limit, search=$search, status=$status', name: 'ProjectApi');

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

      return ApiResponsePagerModel.fromJson(
        response.data as Map<String, dynamic>,
        (json) => ProjectModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (error, stackTrace) {
      log('[getProjects]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 获取项目详情
  Future<ProjectModel> getProject(int projectId) async {
    try {
      log('[getProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.get('/projects/$projectId');

      final data = response.data as Map<String, dynamic>;
      final project = ProjectModel.fromJson(data['data'] as Map<String, dynamic>);

      return project;
    } catch (error, stackTrace) {
      log('[getProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 创建项目
  Future<ProjectModel?> createProject({
    required String name,
    String? description,
    required String primaryLanguageCode,
    String? slug,
    String visibility = 'private',
    Map<String, dynamic>? settings,
    List<int>? targetLanguageIds,
  }) async {
    try {
      log(
        '[createProject] name=$name, primaryLanguage=$primaryLanguageCode, targetLanguages=$targetLanguageIds',
        name: 'ProjectApi',
      );

      final requestData = {
        'name': name,
        'description': description,
        'primary_language_code': primaryLanguageCode,
        'slug': slug ?? name.toLowerCase().replaceAll(' ', '-'),
        'visibility': visibility,
        'settings': settings ?? {},
        if (targetLanguageIds != null && targetLanguageIds.isNotEmpty) 'target_language_ids': targetLanguageIds,
      };

      final response = await HttpClient.post(
        '/projects',
        data: requestData,
      );

      final data = response.data as Map<String, dynamic>;
      if (data['data'] == null) {
        return null;
      }
      final project = ProjectModel.fromJson(data['data'] as Map<String, dynamic>);

      log('[createProject] 项目创建成功: id=${data['data']['id']}', name: 'ProjectApi');

      return project;
    } catch (error, stackTrace) {
      log('[createProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      return null;
    }
  }

  /// 更新项目
  Future<ProjectModel> updateProject({
    required int projectId,
    String? name,
    String? description,
    String? status,
    String? visibility,
    Map<String, dynamic>? settings,
  }) async {
    try {
      log('[updateProject] projectId=$projectId', name: 'ProjectApi');

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

      final data = response.data as Map<String, dynamic>;
      final project = ProjectModel.fromJson(data['data'] as Map<String, dynamic>);

      log('[updateProject] 项目更新成功', name: 'ProjectApi');

      return project;
    } catch (error, stackTrace) {
      log('[updateProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 删除项目
  Future<void> deleteProject(int projectId) async {
    try {
      log('[deleteProject] projectId=$projectId', name: 'ProjectApi');

      await HttpClient.delete('/projects/$projectId');

      log('[deleteProject] 项目删除成功', name: 'ProjectApi');
    } catch (error, stackTrace) {
      log('[deleteProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 检查项目名称是否可用
  Future<bool> checkProjectNameAvailable(String name, {int? excludeProjectId}) async {
    try {
      log('[checkProjectNameAvailable] name=$name', name: 'ProjectApi');

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

      final data = response.data as Map<String, dynamic>;
      if (data['available'] == null) {
        return false;
      }
      return data['available'] == true;
    } catch (error, stackTrace) {
      log('[checkProjectNameAvailable]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 获取项目统计信息
  Future<Map<String, dynamic>> getProjectStats(int projectId) async {
    try {
      log('[getProjectStats] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.get('/projects/$projectId/stats');

      final data = response.data as Map<String, dynamic>;
      return data['data'] as Map<String, dynamic>;
    } catch (error, stackTrace) {
      log('[getProjectStats]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 归档项目
  Future<ProjectModel> archiveProject(int projectId) async {
    try {
      log('[archiveProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.post('/projects/$projectId/archive');

      final data = response.data as Map<String, dynamic>;
      final project = ProjectModel.fromJson(data['data'] as Map<String, dynamic>);

      log('[archiveProject] 项目归档成功', name: 'ProjectApi');

      return project;
    } catch (error, stackTrace) {
      log('[archiveProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 恢复项目
  Future<ProjectModel> restoreProject(int projectId) async {
    try {
      log('[restoreProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.post('/projects/$projectId/restore');

      final data = response.data as Map<String, dynamic>;
      final project = ProjectModel.fromJson(data['data'] as Map<String, dynamic>);

      log('[restoreProject] 项目恢复成功', name: 'ProjectApi');

      return project;
    } catch (error, stackTrace) {
      log('[restoreProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }
}
