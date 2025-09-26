import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../middleware/auth_middleware.dart';
import '../middleware/error_handler_middleware.dart';
import '../services/project_service.dart';
import '../utils/response_builder.dart';
import '../utils/validator.dart';

/// 项目管理控制器
class ProjectController {
  final ProjectService _projectService;

  ProjectController(this._projectService);

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

      return ResponseBuilder.success(message: '项目创建成功', data: project, statusCode: 201);
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

      return ResponseBuilder.success(message: '项目成员添加成功', statusCode: 201);
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
}
