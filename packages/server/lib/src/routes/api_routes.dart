import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/server_config.dart';
import '../controllers/controllers.dart';
import '../middleware/auth_middleware.dart';
import '../services/services.dart';
import '../utils/jwt_utils.dart';

/// API路由配置
class ApiRoutes {
  final DatabaseService databaseService;
  final RedisService redisService;
  final MultiLevelCacheService cacheService;
  final AuthService authService;
  final UserService userService;
  final ProjectService projectService;
  final PermissionService permissionService;
  final FileUploadService fileUploadService;
  final DateTime startTime;

  late final Router _router;
  late final Middleware _authMiddleware;

  ApiRoutes({
    required this.databaseService,
    required this.redisService,
    required this.cacheService,
    required this.authService,
    required this.userService,
    required this.projectService,
    required this.permissionService,
    required this.fileUploadService,
    required this.startTime,
  }) {
    _router = Router();
    final jwtUtils = JwtUtils();
    _authMiddleware = AuthMiddleware(
      authService: authService,
      jwtUtils: jwtUtils,
      redisService: redisService,
    )();
    _setupRoutes();
  }

  /// 获取路由处理器
  Handler get handler => _router;

  /// 应用认证中间件到处理器
  Handler _withAuth(Handler handler) {
    return Pipeline().addMiddleware(_authMiddleware).addHandler(handler);
  }

  /// 设置所有路由
  void _setupRoutes() {
    // 系统信息端点
    _router.get('/version', _versionHandler);
    _router.get('/status', _statusHandler);

    // 认证相关路由
    _setupAuthRoutes();

    // 用户管理路由
    _setupUserRoutes();

    // 项目管理路由
    _setupProjectRoutes();

    // 翻译管理路由
    _setupTranslationRoutes();

    // 语言管理路由
    _setupLanguageRoutes();

    // 角色权限管理路由
    _setupRolePermissionRoutes();

    // 系统配置管理路由
    _setupConfigRoutes();

    // 文件管理路由
    _setupFileRoutes();

    // 通知管理路由
    _setupNotificationRoutes();
  }

  /// 设置认证路由
  void _setupAuthRoutes() {
    final authController = AuthController(
      authService: authService,
    );

    _router.post('/auth/login', authController.login);
    _router.post('/auth/logout', authController.logout);
    _router.post('/auth/refresh', authController.refresh);
    _router.post('/auth/register', authController.register);
    _router.post('/auth/forgot-password', authController.forgotPassword);
    _router.post('/auth/reset-password', authController.resetPassword);
    _router.get('/auth/verify-email', authController.verifyEmail);
    _router.post('/auth/resend-verification', authController.resendVerification);
  }

  /// 设置用户路由
  void _setupUserRoutes() {
    final userController = UserController(
      userService: userService,
      fileUploadService: fileUploadService,
    );

    // 创建用户子路由器
    // ⚠️ 重要：更具体的路由必须先注册！
    final userRouter = Router();
    userRouter.get('/', userController.getUsers);
    // 先注册 /me 相关路由（更具体）
    userRouter.get('/me', userController.getCurrentUser);
    userRouter.put('/me', userController.updateCurrentUser);
    userRouter.post('/me/avatar', userController.uploadAvatar);
    userRouter.delete('/me/avatar', userController.deleteAvatar);
    userRouter.get('/me/sessions', userController.getUserSessions);
    userRouter.delete('/me/sessions/<sessionId>', userController.deleteSession);
    userRouter.post('/me/change-password', userController.changePassword);
    // 后注册 /<id> 路由（更通用）
    userRouter.get('/<id>', userController.getUser);
    userRouter.put('/<id>', userController.updateUser);
    userRouter.delete('/<id>', userController.deleteUser);

    // 挂载用户路由并应用认证中间件
    _router.mount('/users', _withAuth(userRouter));
  }

  /// 设置项目路由
  void _setupProjectRoutes() {
    final projectController = ProjectController(
      projectService: projectService,
    );

    _router.get('/projects', projectController.getProjects);
    _router.post('/projects', projectController.createProject);
    _router.get('/projects/<id>', projectController.getProject);
    _router.put('/projects/<id>', projectController.updateProject);
    _router.delete('/projects/<id>', projectController.deleteProject);
    _router.post('/projects/<id>/archive', projectController.archiveProject);
    _router.post('/projects/<id>/restore', projectController.restoreProject);

    // 项目成员管理
    _router.get('/projects/<id>/members', projectController.getProjectMembers);
    _router.post('/projects/<id>/members', projectController.addProjectMember);
    _router.put('/projects/<id>/members/<userId>', projectController.updateMemberRole);
    _router.delete('/projects/<id>/members/<userId>', projectController.removeProjectMember);

    // 项目语言管理
    _router.get('/projects/<id>/languages', projectController.getProjectLanguages);
    _router.post('/projects/<id>/languages', projectController.addProjectLanguage);
    _router.put('/projects/<id>/languages/<code>', projectController.updateLanguageSettings);
    _router.delete('/projects/<id>/languages/<code>', projectController.removeProjectLanguage);

    // 项目统计
    _router.get('/projects/<id>/statistics', projectController.getProjectStatistics);
    _router.get('/projects/<id>/activity', projectController.getProjectActivity);
  }

  /// 设置翻译路由
  void _setupTranslationRoutes() {
    final translationController = TranslationController(
      databaseService: databaseService,
      redisService: redisService,
    );

    // 翻译条目 CRUD
    _router.get('/projects/<projectId>/translations', translationController.getTranslations);
    _router.post('/projects/<projectId>/translations', translationController.createTranslation);
    _router.get('/projects/<projectId>/translations/<entryId>', translationController.getTranslation);
    _router.put('/projects/<projectId>/translations/<entryId>', translationController.updateTranslation);
    _router.patch('/projects/<projectId>/translations/<entryId>', translationController.patchTranslation);
    _router.delete('/projects/<projectId>/translations/<entryId>', translationController.deleteTranslation);

    // 批量操作
    _router.post('/projects/<projectId>/translations/batch', translationController.batchOperations);
    _router.delete('/projects/<projectId>/translations/batch', translationController.batchDelete);
    _router.post('/projects/<projectId>/translations/batch/translate', translationController.batchTranslate);
    _router.post('/projects/<projectId>/translations/batch/approve', translationController.batchApprove);

    // 翻译历史和版本
    _router.get('/projects/<projectId>/translations/<entryId>/history', translationController.getTranslationHistory);
    _router.get('/projects/<projectId>/translations/<entryId>/versions', translationController.getTranslationVersions);
    _router.post('/projects/<projectId>/translations/<entryId>/revert', translationController.revertTranslation);

    // 翻译状态管理
    _router.post('/projects/<projectId>/translations/<entryId>/assign', translationController.assignTranslator);
    _router.post('/projects/<projectId>/translations/<entryId>/submit', translationController.submitTranslation);
    _router.post('/projects/<projectId>/translations/<entryId>/review', translationController.reviewTranslation);
    _router.post('/projects/<projectId>/translations/<entryId>/approve', translationController.approveTranslation);
    _router.post('/projects/<projectId>/translations/<entryId>/reject', translationController.rejectTranslation);

    // 翻译搜索和过滤
    _router.get('/projects/<projectId>/translations/search', translationController.searchTranslations);
    _router.get('/projects/<projectId>/translations/filter', translationController.filterTranslations);
  }

  /// 设置语言路由
  void _setupLanguageRoutes() {
    final languageController = LanguageController(
      databaseService: databaseService,
      redisService: redisService,
    );

    _router.get('/languages', languageController.getLanguages);
    _router.post('/languages', languageController.createLanguage);
    _router.get('/languages/<code>', languageController.getLanguage);
    _router.put('/languages/<code>', languageController.updateLanguage);
    _router.delete('/languages/<code>', languageController.deleteLanguage);
  }

  /// 设置角色权限路由
  void _setupRolePermissionRoutes() {
    final roleController = RoleController(
      databaseService: databaseService,
      redisService: redisService,
    );

    final permissionController = PermissionController(
      databaseService: databaseService,
      redisService: redisService,
    );

    // 角色管理
    _router.get('/roles', roleController.getRoles);
    _router.post('/roles', roleController.createRole);
    _router.get('/roles/<id>', roleController.getRole);
    _router.put('/roles/<id>', roleController.updateRole);
    _router.delete('/roles/<id>', roleController.deleteRole);

    // 权限管理
    _router.get('/permissions', permissionController.getPermissions);
    _router.get('/permissions/<id>', permissionController.getPermission);

    // 角色权限关联
    _router.get('/roles/<id>/permissions', roleController.getRolePermissions);
    _router.post('/roles/<id>/permissions', roleController.assignPermissions);
    _router.delete('/roles/<id>/permissions/<permissionId>', roleController.revokePermission);

    // 用户角色管理
    _router.get('/users/<userId>/roles', roleController.getUserRoles);
    _router.post('/users/<userId>/roles', roleController.assignUserRole);
    _router.delete('/users/<userId>/roles/<roleId>', roleController.revokeUserRole);
  }

  /// 设置系统配置路由
  void _setupConfigRoutes() {
    final configController = ConfigController(
      databaseService: databaseService,
      redisService: redisService,
    );

    _router.get('/configs', configController.getConfigs);
    _router.get('/configs/public', configController.getPublicConfigs);
    _router.get('/configs/<key>', configController.getConfig);
    _router.put('/configs/<key>', configController.updateConfig);
    _router.post('/configs', configController.createConfig);
    _router.delete('/configs/<key>', configController.deleteConfig);
    _router.get('/configs/categories', configController.getConfigCategories);
    _router.post('/configs/batch', configController.batchUpdateConfigs);
    _router.post('/configs/reset/<key>', configController.resetConfig);
  }

  /// 设置文件管理路由
  void _setupFileRoutes() {
    final fileController = FileController(
      databaseService: databaseService,
      redisService: redisService,
    );

    _router.post('/files/upload', fileController.uploadFile);
    _router.get('/files/<id>', fileController.getFile);
    _router.get('/files/<id>/download', fileController.downloadFile);
    _router.delete('/files/<id>', fileController.deleteFile);

    // 项目文件导入导出
    _router.post('/projects/<id>/import', fileController.importTranslations);
    _router.post('/projects/<id>/export', fileController.exportTranslations);
    _router.get('/projects/<id>/export/<taskId>', fileController.getExportStatus);
  }

  /// 设置通知路由
  void _setupNotificationRoutes() {
    final notificationController = NotificationController(
      databaseService: databaseService,
      redisService: redisService,
    );

    _router.get('/notifications', notificationController.getNotifications);
    _router.get('/notifications/<id>', notificationController.getNotification);
    _router.put('/notifications/<id>/read', notificationController.markAsRead);
    _router.post('/notifications/mark-all-read', notificationController.markAllAsRead);
    _router.delete('/notifications/<id>', notificationController.deleteNotification);
  }

  /// 版本信息处理器
  Response _versionHandler(Request request) {
    final version = {
      'version': '1.0.0',
      'api_version': 'v1',
      'server': 'TTPolyglot Server',
      'environment': ServerConfig.isDevelopment ? 'development' : 'production',
      'timestamp': DateTime.now().toIso8601String(),
    };

    return Response.ok(
      '{"data": ${_encodeJson(version)}}',
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// 状态信息处理器
  Future<Response> _statusHandler(Request request) async {
    try {
      final dbHealthy = await databaseService.isHealthy();
      final redisHealthy = await redisService.isHealthy();

      final status = {
        'status': dbHealthy && redisHealthy ? 'healthy' : 'degraded',
        'services': {
          'database': dbHealthy ? 'healthy' : 'unhealthy',
          'redis': redisHealthy ? 'healthy' : 'unhealthy',
        },
        'timestamp': DateTime.now().toIso8601String(),
        'uptime': DateTime.now().difference(startTime).inSeconds,
      };

      final statusCode = dbHealthy && redisHealthy ? 200 : 503;
      return Response(
        statusCode,
        headers: {'Content-Type': 'application/json'},
        body: '{"data": ${_encodeJson(status)}}',
      );
    } catch (error) {
      return Response.internalServerError(
        body: '{"error": {"code": "SYSTEM_ERROR", "message": "状态检查失败"}}',
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// JSON编码辅助方法
  String _encodeJson(dynamic object) {
    try {
      return jsonEncode(object);
    } catch (e) {
      return jsonEncode({'error': 'Failed to encode JSON: $e'});
    }
  }
}
