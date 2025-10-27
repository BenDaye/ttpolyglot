import 'dart:developer';

import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

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

      final result = Utils.toModel(
        response.data,
        (json) => PagerModel.fromJson(json, (data) => ProjectModel.fromJson(data as Map<String, dynamic>)),
      );
      if (result == null) {
        Logger.error('获取项目列表响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[getProjects]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 获取项目详情
  Future<ProjectModel?> getProject(int projectId) async {
    try {
      log('[getProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.get('/projects/$projectId');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('获取项目详情响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[getProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
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
      log(
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
        Logger.error('创建项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[createProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
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

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('更新项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[updateProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 删除项目
  Future<bool?> deleteProject(int projectId) async {
    try {
      log('[deleteProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.delete('/projects/$projectId');

      final result = Utils.toModel(
        response.data,
        (json) => json['code'] == DataCodeEnum.success,
      );
      if (result == null) {
        Logger.error('删除项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[deleteProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 检查项目名称是否可用
  Future<bool?> checkProjectNameAvailable(String name, {int? excludeProjectId}) async {
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

      final result = Utils.toModel(
        response.data,
        (json) => json['available'] as bool,
      );
      if (result == null) {
        Logger.error('检查项目名称是否可用响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[checkProjectNameAvailable]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 获取项目统计信息
  Future<ProjectStatisticsModel?> getProjectStats(int projectId) async {
    try {
      log('[getProjectStats] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.get('/projects/$projectId/stats');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectStatisticsModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('获取项目统计信息响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[getProjectStats]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 归档项目
  Future<ProjectModel?> archiveProject(int projectId) async {
    try {
      log('[archiveProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.post('/projects/$projectId/archive');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('归档项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[archiveProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      rethrow;
    }
  }

  /// 恢复项目
  Future<ProjectModel?> restoreProject(int projectId) async {
    try {
      log('[restoreProject] projectId=$projectId', name: 'ProjectApi');

      final response = await HttpClient.post('/projects/$projectId/restore');

      final result = Utils.toModel(
        response.data,
        (json) => ProjectModel.fromJson(json),
      );
      if (result == null) {
        Logger.error('恢复项目响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      log('[restoreProject]', error: error, stackTrace: stackTrace, name: 'ProjectApi');
      return null;
    }
  }
}
