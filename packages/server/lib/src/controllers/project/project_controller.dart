import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 项目管理控制器
class ProjectController extends BaseController {
  final ProjectService _projectService;

  ProjectController({
    required ProjectService projectService,
  })  : _projectService = projectService,
        super('ProjectController');

  Router get router {
    final router = Router();
    router.get('/', _getProjects);
    router.post('/', _createProject);
    // 具体路径必须在通配符路由之前定义
    router.get('/check-name', _checkProjectName);
    router.get('/stats', _getProjectStats);
    // 通配符路由放在最后
    router.get('/<id>', _getProjectById);
    router.put('/<id>', _updateProject);
    router.delete('/<id>', _deleteProject);
    router.get('/<id>/members', _getProjectMembers);
    router.post('/<id>/members', _addProjectMember);
    router.delete('/<id>/members/<userId>', _removeProjectMember);
    router.patch('/<id>/member-limit', _updateMemberLimit);
    return router;
  }

  // 公共方法用于路由配置
  Future<Response> Function(Request) get getProjects => _getProjects;
  Future<Response> Function(Request) get createProject => _createProject;
  Future<Response> Function(Request) get checkProjectName => _checkProjectName;
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
  Future<Response> Function(Request, String, String) get updateLanguageSettings => _updateLanguageSettings;
  Future<Response> Function(Request, String) get getProjectStatistics => _getProjectStatistics;
  Future<Response> Function(Request, String) get getProjectActivity => _getProjectActivity;
  Future<Response> Function(Request) get stats => _getProjectStats;
  Future<Response> Function(Request, String) get updateMemberLimit => _updateMemberLimit;

  Future<Response> _getProjects(Request request) async {
    try {
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = int.tryParse(params['limit'] ?? '20') ?? 20;

      if (page < 1 || limit < 1 || limit > 100) {
        return ResponseUtils.error(message: '分页参数无效');
      }

      final projects = await _projectService.getProjects(
        page: page,
        limit: limit,
        search: params['search'],
        status: params['status'],
        userId: getCurrentUserId(request),
      );

      return ResponseUtils.success<PagerModel<ProjectModel>>(
        data: projects,
        message: '获取项目列表成功',
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目列表失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '获取项目列表失败');
    }
  }

  Future<Response> _createProject(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final name = ValidatorUtils.validateString(data['name'], 'name', minLength: 2, maxLength: 100);

      // 解析主语言ID
      final primaryLanguageId = data['primary_language_id'];
      if (primaryLanguageId == null) {
        return ResponseUtils.error(message: '主语言ID不能为空');
      }
      final primaryLanguageIdInt =
          primaryLanguageId is int ? primaryLanguageId : int.parse(primaryLanguageId.toString());

      final ownerId = getCurrentUserId(request);

      if (ownerId == null) {
        return ResponseUtils.error(message: '用户信息不存在');
      }

      // 解析目标语言列表
      List<int>? targetLanguageIds;
      if (data.containsKey('target_language_ids') && data['target_language_ids'] != null) {
        final targetLangs = data['target_language_ids'];
        if (targetLangs is List) {
          targetLanguageIds = targetLangs.map((e) => e is int ? e : int.parse(e.toString())).toList();
        }
      }

      final project = await _projectService.createProject(
          name: name,
          ownerId: ownerId,
          primaryLanguageId: primaryLanguageIdInt,
          description: data['description'] as String?,
          slug: data['slug'] as String?,
          visibility: ValidatorUtils.validateEnum(data['visibility'], 'visibility', ['public', 'private', 'internal'],
              required: false),
          settings: data.containsKey('settings')
              ? ValidatorUtils.validateJson(data['settings'], 'settings', required: false)
              : null,
          targetLanguageIds: targetLanguageIds);

      return ResponseUtils.success(message: '项目创建成功', data: project);
    } catch (error, stackTrace) {
      LoggerUtils.error('创建项目失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      if (error is BusinessException) {
        return ResponseUtils.error(message: error.message);
      }

      return ResponseUtils.error(message: '创建项目失败');
    }
  }

  Future<Response> _checkProjectName(Request request) async {
    try {
      final params = request.url.queryParameters;
      final name = params['name'];

      LoggerUtils.info('_checkProjectName 被调用: name=$name, params=$params');

      if (name == null || name.trim().isEmpty) {
        return ResponseUtils.error(message: '项目名称不能为空');
      }

      final excludeIdStr = params['exclude_id'];
      final excludeId = excludeIdStr != null ? int.tryParse(excludeIdStr) : null;

      final isAvailable = await _projectService.checkProjectNameAvailable(name, excludeProjectId: excludeId);

      LoggerUtils.info('_checkProjectName 检查结果: available=$isAvailable');

      return ResponseUtils.success<Map<String, bool>>(
        message: '检查项目名称成功',
        data: {'available': isAvailable},
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('检查项目名称失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '检查项目名称失败');
    }
  }

  Future<Response> _getProjectById(Request request, String id) async {
    try {
      LoggerUtils.info('_getProjectById 被调用: id=$id');

      final projectId = int.tryParse(id);
      if (projectId == null) {
        LoggerUtils.error('_getProjectById: 无效的项目ID格式: $id');
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      final projectDetail = await _projectService.getProjectById(id, userId: getCurrentUserId(request));

      if (projectDetail == null) {
        return ResponseUtils.error(message: '项目不存在');
      }

      return ResponseUtils.success<ProjectDetailModel>(message: '获取项目详情成功', data: projectDetail);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目详情失败: $id', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }

      return ResponseUtils.error(message: '获取项目详情失败');
    }
  }

  Future<Response> _updateProject(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final updateData = <String, dynamic>{};

      if (data.containsKey('name')) {
        updateData['name'] =
            ValidatorUtils.validateString(data['name'], 'name', minLength: 2, maxLength: 100, required: false);
      }
      if (data.containsKey('description')) {
        updateData['description'] =
            ValidatorUtils.validateString(data['description'], 'description', maxLength: 1000, required: false);
      }
      if (data.containsKey('status')) {
        updateData['status'] =
            ValidatorUtils.validateEnum(data['status'], 'status', ['active', 'archived', 'suspended'], required: false);
      }
      if (data.containsKey('visibility')) {
        updateData['visibility'] = ValidatorUtils.validateEnum(
            data['visibility'], 'visibility', ['public', 'private', 'internal'],
            required: false);
      }

      final updatedProject = await _projectService.updateProject(id, updateData, updatedBy: getCurrentUserId(request));

      return ResponseUtils.success<ProjectModel>(message: '项目信息更新成功', data: updatedProject);
    } catch (error, stackTrace) {
      LoggerUtils.error('更新项目信息失败: $id', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      if (error is BusinessException) {
        return ResponseUtils.error(message: error.message);
      }

      return ResponseUtils.error(message: '更新项目信息失败');
    }
  }

  Future<Response> _deleteProject(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      await _projectService.deleteProject(id, deletedBy: getCurrentUserId(request));
      return ResponseUtils.success<ProjectModel>(message: '项目删除成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('删除项目失败: $id', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      if (error is NotFoundException) {
        return ResponseUtils.error(message: '项目不存在');
      }

      return ResponseUtils.error(message: '删除项目失败');
    }
  }

  Future<Response> _getProjectMembers(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      final members = await _projectService.getProjectMembers(id);
      return ResponseUtils.success<List<ProjectMemberModel>>(message: '获取项目成员成功', data: members);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目成员失败: $id', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '获取项目成员失败');
    }
  }

  Future<Response> _addProjectMember(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final userId = ValidatorUtils.validateUuid(data['user_id'], 'user_id');
      final role = data['role'] as String?;
      final invitedBy = getCurrentUserId(request);

      if (invitedBy == null) {
        return ResponseUtils.error(message: '用户信息不存在');
      }

      if (role == null || role.isEmpty) {
        return ResponseUtils.error(message: '角色不能为空');
      }

      // 验证角色值是否有效
      final validRoles = ['owner', 'admin', 'member', 'viewer'];
      if (!validRoles.contains(role)) {
        return ResponseUtils.error(message: '无效的角色类型');
      }

      await _projectService.addProjectMember(projectId: id, userId: userId, role: role, invitedBy: invitedBy);

      return ResponseUtils.success<ProjectMemberModel>(message: '项目成员添加成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('添加项目成员失败: $id', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      if (error is BusinessException) {
        return ResponseUtils.error(message: error.message);
      }

      return ResponseUtils.error(message: '添加项目成员失败');
    }
  }

  Future<Response> _removeProjectMember(Request request, String id, String userId) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      ValidatorUtils.validateUuid(userId, 'user_id');
      await _projectService.removeProjectMember(id, userId);
      return ResponseUtils.success<ProjectMemberModel>(message: '项目成员删除成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('移除项目成员失败: $id, user: $userId', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '移除项目成员失败');
    }
  }

  Future<Response> _getProjectStats(Request request) async {
    try {
      final stats = await _projectService.getProjectStats();
      return ResponseUtils.success<ProjectStatisticsModel>(message: '获取项目统计信息成功', data: stats);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目统计信息失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '获取统计信息失败');
    }
  }

  /// 归档项目
  Future<Response> _archiveProject(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      await _projectService.archiveProject(id);
      return ResponseUtils.success<ProjectModel>(message: '项目已归档');
    } catch (error, stackTrace) {
      LoggerUtils.error('归档项目失败: $id', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '归档项目失败');
    }
  }

  /// 恢复项目
  Future<Response> _restoreProject(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      await _projectService.restoreProject(id);
      return ResponseUtils.success<ProjectModel>(message: '项目已恢复');
    } catch (error, stackTrace) {
      LoggerUtils.error('恢复项目失败: $id', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '恢复项目失败');
    }
  }

  /// 更新项目成员角色
  Future<Response> _updateMemberRole(Request request, String id, String userId) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      ValidatorUtils.validateUuid(userId, 'user_id');

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final role = data['role'] as String?;

      if (role == null || role.isEmpty) {
        return ResponseUtils.error(message: '角色不能为空');
      }

      // 验证角色值是否有效
      final validRoles = ['owner', 'admin', 'member', 'viewer'];
      if (!validRoles.contains(role)) {
        return ResponseUtils.error(message: '无效的角色类型');
      }

      await _projectService.updateProjectMemberRole(id, userId, role);
      return ResponseUtils.success<ProjectMemberModel>(message: '成员角色已更新');
    } catch (error, stackTrace) {
      LoggerUtils.error('更新成员角色失败: $id, user: $userId', error: error, stackTrace: stackTrace);
      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      return ResponseUtils.error(message: '更新成员角色失败');
    }
  }

  /// 获取项目语言
  Future<Response> _getProjectLanguages(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      final languages = await _projectService.getProjectLanguages(id);
      return ResponseUtils.success<List<LanguageModel>>(message: '获取项目语言成功', data: languages);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目语言失败: $id', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '获取项目语言失败');
    }
  }

  /// 添加项目语言
  Future<Response> _addProjectLanguage(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final languageId = data['language_id'];

      if (languageId == null) {
        return ResponseUtils.error(message: '语言ID不能为空');
      }

      final languageIdInt = languageId is int ? languageId : int.parse(languageId.toString());

      await _projectService.addProjectLanguage(id, languageIdInt);
      return ResponseUtils.success(message: '语言已添加到项目');
    } catch (error, stackTrace) {
      LoggerUtils.error('添加项目语言失败: $id', error: error, stackTrace: stackTrace);
      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      return ResponseUtils.error(message: '添加项目语言失败');
    }
  }

  /// 移除项目语言
  Future<Response> _removeProjectLanguage(Request request, String id, String languageIdStr) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }

      final languageId = int.tryParse(languageIdStr);
      if (languageId == null) {
        return ResponseUtils.error(message: '语言ID格式无效');
      }

      await _projectService.removeProjectLanguage(id, languageId);
      return ResponseUtils.success(message: '语言已从项目中移除');
    } catch (error, stackTrace) {
      LoggerUtils.error('移除项目语言失败: $id, language: $languageIdStr', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '移除项目语言失败');
    }
  }

  /// 更新语言设置
  Future<Response> _updateLanguageSettings(Request request, String id, String languageIdStr) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }

      final languageId = int.tryParse(languageIdStr);
      if (languageId == null) {
        return ResponseUtils.error(message: '语言ID格式无效');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final settings = data['settings'] as Map<String, dynamic>?;

      await _projectService.updateLanguageSettings(id, languageId, settings ?? {});
      return ResponseUtils.success(message: '语言设置已更新');
    } catch (error, stackTrace) {
      LoggerUtils.error('更新语言设置失败: $id, language: $languageIdStr', error: error, stackTrace: stackTrace);
      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      return ResponseUtils.error(message: '更新语言设置失败');
    }
  }

  /// 获取项目统计信息
  Future<Response> _getProjectStatistics(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      final stats = await _projectService.getProjectStatistics(id);
      return ResponseUtils.success<ProjectStatisticsModel>(message: '获取项目统计信息成功', data: stats);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目统计信息失败: $id', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '获取项目统计信息失败');
    }
  }

  /// 获取项目活动日志
  Future<Response> _getProjectActivity(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = int.tryParse(params['limit'] ?? '20') ?? 20;

      final activity = await _projectService.getProjectActivity(id, page: page, limit: limit);
      return ResponseUtils.success<PagerModel<TranslationEntryModel>>(
        message: '获取项目活动成功',
        data: activity,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目活动失败: $id', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: '获取项目活动失败');
    }
  }

  /// 更新项目成员上限
  Future<Response> _updateMemberLimit(Request request, String id) async {
    try {
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }

      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '用户信息不存在');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final memberLimit = data['member_limit'] ?? data['memberLimit'];
      if (memberLimit == null) {
        return ResponseUtils.error(message: '成员上限不能为空');
      }

      final newLimit = memberLimit is int ? memberLimit : int.tryParse(memberLimit.toString());
      if (newLimit == null) {
        return ResponseUtils.error(message: '成员上限格式无效');
      }

      final updatedProject = await _projectService.updateMemberLimit(
        projectId: id,
        userId: userId,
        newLimit: newLimit,
      );

      return ResponseUtils.success<ProjectModel>(
        message: '成员上限已更新',
        data: updatedProject,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新成员上限失败: $id', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(message: error.message);
      }
      if (error is BusinessException) {
        return ResponseUtils.error(message: error.message);
      }
      if (error is NotFoundException) {
        return ResponseUtils.error(message: '项目不存在');
      }

      return ResponseUtils.error(message: '更新成员上限失败');
    }
  }
}
