import 'dart:developer';

import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目 API
class ProjectApi {
  /// 获取项目列表
  Future<List<ProjectModel>> getProjects({
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

      final data = response.data as Map<String, dynamic>;
      log('[getProjects] 服务器响应: $data', name: 'ProjectApi');

      // 检查 data 字段是否存在
      if (data['data'] == null) {
        log('[getProjects] data["data"] 为 null，返回空列表', name: 'ProjectApi');
        return [];
      }

      final pagerData = data['data'] as Map<String, dynamic>;
      final items =
          (pagerData['items'] as List?)?.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList() ?? [];

      log('[getProjects] 获取到 ${items.length} 个项目', name: 'ProjectApi');

      return items;
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
  Future<ProjectModel> createProject({
    required String name,
    required String description,
    required String primaryLanguageCode,
    required List<String> targetLanguageCodes,
    String status = 'active',
    String visibility = 'private',
    Map<String, dynamic>? settings,
  }) async {
    try {
      log('[createProject] name=$name, primaryLanguage=$primaryLanguageCode', name: 'ProjectApi');

      final requestData = {
        'name': name,
        'description': description,
        'primary_language': primaryLanguageCode,
        'target_languages': targetLanguageCodes,
        'status': status,
        'visibility': visibility,
        'settings': settings ?? {},
      };

      final response = await HttpClient.post(
        '/projects',
        data: requestData,
      );

      final data = response.data as Map<String, dynamic>;
      final project = ProjectModel.fromJson(data['data'] as Map<String, dynamic>);

      log('[createProject] 项目创建成功: id=${project.id}', name: 'ProjectApi');

      return project;
    } catch (error, stackTrace) {
      log('[createProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 更新项目
  Future<ProjectModel> updateProject({
    required int projectId,
    String? name,
    String? description,
    List<String>? targetLanguageCodes,
    String? status,
    String? visibility,
    Map<String, dynamic>? settings,
  }) async {
    try {
      log('[updateProject] projectId=$projectId', name: 'ProjectApi');

      final requestData = <String, dynamic>{};

      if (name != null) requestData['name'] = name;
      if (description != null) requestData['description'] = description;
      if (targetLanguageCodes != null) requestData['target_languages'] = targetLanguageCodes;
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
      final available = data['data']['available'] as bool;

      return available;
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
