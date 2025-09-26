import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../middleware/auth_middleware.dart';
import '../models/api_error.dart';
import '../services/project_service.dart';
import '../utils/response_builder.dart';
import '../utils/validator.dart';

/// 项目管理控制器
class ProjectController {
  final ProjectService _projectService;

  ProjectController({
    required ProjectService projectService,
  }) : _projectService = projectService;

  Router get router {
    final router = Router();
    router.get('/', _getProjects);
    router.post('/', _createProject);
    router.get('/<id>', _getProjectById);
    router.put('/<id>', _updateProject);
    router.delete('/<id>', _deleteProject);
    router.get('/<id>/members', _getProjectMembers);
    router.post('/<id>/members', _addProjectMember);
    router.delete('/<id>/members/<userId>', _removeProjectMember);
    router.get('/stats', _getProjectStats);
    return router;
  }

  // 公共方法用于路由配置
  Future<Response> Function(Request) get getProjects => _getProjects;
  Future<Response> Function(Request) get createProject => _createProject;
  Future<Response> Function(Request, String) get getProject => _getProjectById;
  Future<Response> Function(Request, String) get updateProject => _updateProject;
  Future<Response> Function(Request, String) get deleteProject => _deleteProject;
  Future<Response> Function(Request, String) get getProjectMembers => _getProjectMembers;
  Future<Response> Function(Request, String) get addProjectMember => _addProjectMember;
  Future<Response> Function(Request, String, String) get removeProjectMember => _removeProjectMember;
  Future<Response> Function(Request, String) get archiveProject => _archiveProject;
  Future<Response> Function(Request, String) get restoreProject => _restoreProject;
  Future<Response> Function(Request, String, String) get updateMemberRole => _updateMemberRole;
  Future<Response> Function(Request, String) get getProjectLanguages => _getProjectLanguages;
  Future<Response> Function(Request, String) get addProjectLanguage => _addProjectLanguage;
  Future<Response> Function(Request, String, String) get removeProjectLanguage => _removeProjectLanguage;
  Future<Response> Function(Request, String) get updateLanguageSettings => _updateLanguageSettings;
  Future<Response> Function(Request, String) get getProjectStatistics => _getProjectStatistics;
  Future<Response> Function(Request, String) get getProjectActivity => _getProjectActivity;
  Future<Response> Function(Request) get stats => _getProjectStats;

  Future<Response> _getProjects(Request request) async {
    try {
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = int.tryParse(params['limit'] ?? '20') ?? 20;

      if (page < 1 || limit < 1 || limit > 100) {
        return ResponseBuilder.error(code: 'VALIDATION_INVALID_PAGINATION', message: '分页参数无效', statusCode: 400);
      }

      final result = await _projectService.getProjects(
          page: page,
          limit: limit,
          search: params['search'],
          status: params['status'],
          userId: getCurrentUserId(request));

      return ResponseBuilder.paginated(
          data: result['projects'],
          page: page,
          limit: limit,
          total: result['pagination']['total'],
          message: '获取项目列表成功');
    } catch (error, stackTrace) {
      log('获取项目列表失败', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'GET_PROJECTS_FAILED', message: '获取项目列表失败', statusCode: 500);
    }
  }

  Future<Response> _createProject(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final name = Validator.validateString(data['name'], 'name', minLength: 2, maxLength: 100);
      final primaryLanguageCode = Validator.validateString(data['primary_language_code'], 'primary_language_code');
      final ownerId = getCurrentUserId(request);

      if (ownerId == null) {
        return ResponseBuilder.authError(code: 'AUTH_USER_NOT_FOUND', message: '用户信息不存在');
      }

      final project = await _projectService.createProject(
          name: name,
          ownerId: ownerId,
          primaryLanguageCode: primaryLanguageCode,
          description: data['description'] as String?,
          slug: data['slug'] as String?,
          visibility: Validator.validateEnum(data['visibility'], 'visibility', ['public', 'private', 'internal'],
              required: false),
          settings: data.containsKey('settings')
              ? Validator.validateJson(data['settings'], 'settings', required: false)
              : null);

      return ResponseBuilder.created(message: '项目创建成功', data: project);
    } catch (error, stackTrace) {
      log('创建项目失败', error: error, stackTrace: stackTrace, name: 'ProjectController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }
      if (error is BusinessException) {
        return ResponseBuilder.errorFromRequest(
            request: request, code: error.code, message: error.message, statusCode: 400);
      }

      return ResponseBuilder.errorFromRequest(
          request: request, code: 'CREATE_PROJECT_FAILED', message: '创建项目失败', statusCode: 500);
    }
  }

  Future<Response> _getProjectById(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      final project = await _projectService.getProjectById(id, userId: getCurrentUserId(request));

      if (project == null) {
        return ResponseBuilder.notFound(message: '项目不存在');
      }

      return ResponseBuilder.success(message: '获取项目详情成功', data: project);
    } catch (error, stackTrace) {
      log('获取项目详情失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }

      return ResponseBuilder.errorFromRequest(
          request: request, code: 'GET_PROJECT_FAILED', message: '获取项目详情失败', statusCode: 500);
    }
  }

  Future<Response> _updateProject(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final updateData = <String, dynamic>{};

      if (data.containsKey('name')) {
        updateData['name'] =
            Validator.validateString(data['name'], 'name', minLength: 2, maxLength: 100, required: false);
      }
      if (data.containsKey('description')) {
        updateData['description'] =
            Validator.validateString(data['description'], 'description', maxLength: 1000, required: false);
      }
      if (data.containsKey('status')) {
        updateData['status'] =
            Validator.validateEnum(data['status'], 'status', ['active', 'archived', 'suspended'], required: false);
      }
      if (data.containsKey('visibility')) {
        updateData['visibility'] = Validator.validateEnum(
            data['visibility'], 'visibility', ['public', 'private', 'internal'],
            required: false);
      }

      final updatedProject = await _projectService.updateProject(id, updateData, updatedBy: getCurrentUserId(request));

      return ResponseBuilder.success(message: '项目信息更新成功', data: updatedProject);
    } catch (error, stackTrace) {
      log('更新项目信息失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }
      if (error is BusinessException) {
        return ResponseBuilder.errorFromRequest(
            request: request, code: error.code, message: error.message, statusCode: 400);
      }

      return ResponseBuilder.errorFromRequest(
          request: request, code: 'UPDATE_PROJECT_FAILED', message: '更新项目信息失败', statusCode: 500);
    }
  }

  Future<Response> _deleteProject(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      await _projectService.deleteProject(id, deletedBy: getCurrentUserId(request));
      return ResponseBuilder.noContent();
    } catch (error, stackTrace) {
      log('删除项目失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }
      if (error is NotFoundException) {
        return ResponseBuilder.notFound(message: '项目不存在');
      }

      return ResponseBuilder.errorFromRequest(
          request: request, code: 'DELETE_PROJECT_FAILED', message: '删除项目失败', statusCode: 500);
    }
  }

  Future<Response> _getProjectMembers(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      final members = await _projectService.getProjectMembers(id);
      return ResponseBuilder.success(message: '获取项目成员成功', data: {'members': members});
    } catch (error, stackTrace) {
      log('获取项目成员失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'GET_PROJECT_MEMBERS_FAILED', message: '获取项目成员失败', statusCode: 500);
    }
  }

  Future<Response> _addProjectMember(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final userId = Validator.validateUuid(data['user_id'], 'user_id');
      final roleId = Validator.validateUuid(data['role_id'], 'role_id');
      final grantedBy = getCurrentUserId(request);

      if (grantedBy == null) {
        return ResponseBuilder.authError(code: 'AUTH_USER_NOT_FOUND', message: '用户信息不存在');
      }

      DateTime? expiresAt;
      if (data.containsKey('expires_at') && data['expires_at'] != null) {
        expiresAt = Validator.validateDateTime(data['expires_at'], 'expires_at', required: false);
      }

      await _projectService.addProjectMember(
          projectId: id, userId: userId, roleId: roleId, grantedBy: grantedBy, expiresAt: expiresAt);

      return ResponseBuilder.created(message: '项目成员添加成功');
    } catch (error, stackTrace) {
      log('添加项目成员失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }
      if (error is BusinessException) {
        return ResponseBuilder.errorFromRequest(
            request: request, code: error.code, message: error.message, statusCode: 400);
      }

      return ResponseBuilder.errorFromRequest(
          request: request, code: 'ADD_PROJECT_MEMBER_FAILED', message: '添加项目成员失败', statusCode: 500);
    }
  }

  Future<Response> _removeProjectMember(Request request, String id, String userId) async {
    try {
      Validator.validateUuid(id, 'project_id');
      Validator.validateUuid(userId, 'user_id');
      await _projectService.removeProjectMember(id, userId);
      return ResponseBuilder.noContent();
    } catch (error, stackTrace) {
      log('移除项目成员失败: $id, user: $userId', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'REMOVE_PROJECT_MEMBER_FAILED', message: '移除项目成员失败', statusCode: 500);
    }
  }

  Future<Response> _getProjectStats(Request request) async {
    try {
      final stats = await _projectService.getProjectStats();
      return ResponseBuilder.success(message: '获取项目统计信息成功', data: stats);
    } catch (error, stackTrace) {
      log('获取项目统计信息失败', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'GET_PROJECT_STATS_FAILED', message: '获取统计信息失败', statusCode: 500);
    }
  }

  /// 归档项目
  Future<Response> _archiveProject(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      await _projectService.archiveProject(id);
      return ResponseBuilder.success(message: '项目已归档');
    } catch (error, stackTrace) {
      log('归档项目失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'ARCHIVE_PROJECT_FAILED', message: '归档项目失败', statusCode: 500);
    }
  }

  /// 恢复项目
  Future<Response> _restoreProject(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      await _projectService.restoreProject(id);
      return ResponseBuilder.success(message: '项目已恢复');
    } catch (error, stackTrace) {
      log('恢复项目失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'RESTORE_PROJECT_FAILED', message: '恢复项目失败', statusCode: 500);
    }
  }

  /// 更新项目成员角色
  Future<Response> _updateMemberRole(Request request, String id, String userId) async {
    try {
      Validator.validateUuid(id, 'project_id');
      Validator.validateUuid(userId, 'user_id');

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final roleId = data['role_id'] as String?;

      if (roleId == null) {
        return ResponseBuilder.validationErrorFromRequest(
            request: request, fieldErrors: [FieldError(field: 'role_id', code: 'REQUIRED', message: '角色ID不能为空')]);
      }

      await _projectService.updateProjectMemberRole(id, userId, roleId);
      return ResponseBuilder.success(message: '成员角色已更新');
    } catch (error, stackTrace) {
      log('更新成员角色失败: $id, user: $userId', error: error, stackTrace: stackTrace, name: 'ProjectController');
      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'UPDATE_MEMBER_ROLE_FAILED', message: '更新成员角色失败', statusCode: 500);
    }
  }

  /// 获取项目语言
  Future<Response> _getProjectLanguages(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      final languages = await _projectService.getProjectLanguages(id);
      return ResponseBuilder.success(message: '获取项目语言成功', data: languages);
    } catch (error, stackTrace) {
      log('获取项目语言失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'GET_PROJECT_LANGUAGES_FAILED', message: '获取项目语言失败', statusCode: 500);
    }
  }

  /// 添加项目语言
  Future<Response> _addProjectLanguage(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final languageCode = data['language_code'] as String?;

      if (languageCode == null) {
        return ResponseBuilder.validationErrorFromRequest(
            request: request, fieldErrors: [FieldError(field: 'language_code', code: 'REQUIRED', message: '语言代码不能为空')]);
      }

      await _projectService.addProjectLanguage(id, languageCode);
      return ResponseBuilder.created(message: '语言已添加到项目');
    } catch (error, stackTrace) {
      log('添加项目语言失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');
      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'ADD_PROJECT_LANGUAGE_FAILED', message: '添加项目语言失败', statusCode: 500);
    }
  }

  /// 移除项目语言
  Future<Response> _removeProjectLanguage(Request request, String id, String languageCode) async {
    try {
      Validator.validateUuid(id, 'project_id');
      await _projectService.removeProjectLanguage(id, languageCode);
      return ResponseBuilder.success(message: '语言已从项目中移除');
    } catch (error, stackTrace) {
      log('移除项目语言失败: $id, language: $languageCode', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'REMOVE_PROJECT_LANGUAGE_FAILED', message: '移除项目语言失败', statusCode: 500);
    }
  }

  /// 更新语言设置
  Future<Response> _updateLanguageSettings(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final languageCode = data['language_code'] as String?;
      final settings = data['settings'] as Map<String, dynamic>?;

      if (languageCode == null) {
        return ResponseBuilder.validationErrorFromRequest(
            request: request, fieldErrors: [FieldError(field: 'language_code', code: 'REQUIRED', message: '语言代码不能为空')]);
      }

      await _projectService.updateLanguageSettings(id, languageCode, settings ?? {});
      return ResponseBuilder.success(message: '语言设置已更新');
    } catch (error, stackTrace) {
      log('更新语言设置失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');
      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'UPDATE_LANGUAGE_SETTINGS_FAILED', message: '更新语言设置失败', statusCode: 500);
    }
  }

  /// 获取项目统计信息
  Future<Response> _getProjectStatistics(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      final stats = await _projectService.getProjectStatistics(id);
      return ResponseBuilder.success(message: '获取项目统计信息成功', data: stats);
    } catch (error, stackTrace) {
      log('获取项目统计信息失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'GET_PROJECT_STATISTICS_FAILED', message: '获取项目统计信息失败', statusCode: 500);
    }
  }

  /// 获取项目活动日志
  Future<Response> _getProjectActivity(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'project_id');
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = int.tryParse(params['limit'] ?? '20') ?? 20;

      final activity = await _projectService.getProjectActivity(id, page: page, limit: limit);
      return ResponseBuilder.paginated(
        message: '获取项目活动成功',
        data: activity,
        page: page,
        limit: limit,
        total: activity.length, // 这里需要从服务层获取总数
      );
    } catch (error, stackTrace) {
      log('获取项目活动失败: $id', error: error, stackTrace: stackTrace, name: 'ProjectController');
      return ResponseBuilder.errorFromRequest(
          request: request, code: 'GET_PROJECT_ACTIVITY_FAILED', message: '获取项目活动失败', statusCode: 500);
    }
  }
}
