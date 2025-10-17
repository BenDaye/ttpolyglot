import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../middleware/auth/auth_middleware.dart';
import '../services/services.dart';
import '../utils/http/response_utils.dart';
import '../utils/security/jwt_utils.dart';
import 'modules/modules.dart';

/// API路由配置
///
/// 此类负责组装所有功能模块的路由，提供统一的路由入口
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
  Handler get handler => _router.call;

  /// 应用认证中间件到处理器
  Handler _withAuth(Handler handler) {
    return Pipeline().addMiddleware(_authMiddleware).addHandler(handler);
  }

  /// 设置所有路由
  void _setupRoutes() {
    // 系统信息端点
    _router.get('/version', (Request request) {
      return ResponseUtils.version();
    });
    _router.get('/status', (Request request) {
      return ResponseUtils.status(
        databaseService: databaseService,
        redisService: redisService,
        startTime: startTime,
      );
    });

    // 挂载各功能模块路由
    _mountModuleRoutes();
  }

  /// 挂载各功能模块的路由
  void _mountModuleRoutes() {
    // 认证路由模块（认证路由内部自行处理认证）
    final authRoutes = AuthRoutes(
      authService: authService,
      withAuth: _withAuth,
    );
    _router.mount('/', authRoutes.configure().call);

    // 用户路由模块（内部已处理认证）
    final userRoutes = UserRoutes(
      userService: userService,
      fileUploadService: fileUploadService,
      withAuth: _withAuth,
    );
    _router.mount('/', userRoutes.configure().call);

    // 项目路由模块（整体应用认证）
    final projectRoutes = ProjectRoutes(
      projectService: projectService,
      withAuth: _withAuth,
    );
    _router.mount('/', _withAuth(projectRoutes.configure().call));

    // 翻译路由模块（整体应用认证）
    final translationRoutes = TranslationRoutes(
      databaseService: databaseService,
      redisService: redisService,
      withAuth: _withAuth,
    );
    _router.mount('/', _withAuth(translationRoutes.configure().call));

    // 语言路由模块（整体应用认证）
    final languageRoutes = LanguageRoutes(
      databaseService: databaseService,
      redisService: redisService,
      withAuth: _withAuth,
    );
    _router.mount('/', _withAuth(languageRoutes.configure().call));

    // 角色权限路由模块（整体应用认证）
    final rolePermissionRoutes = RolePermissionRoutes(
      databaseService: databaseService,
      redisService: redisService,
      withAuth: _withAuth,
    );
    _router.mount('/', _withAuth(rolePermissionRoutes.configure().call));

    // 系统配置路由模块（内部自行处理认证，部分公开）
    final configRoutes = ConfigRoutes(
      databaseService: databaseService,
      redisService: redisService,
      withAuth: _withAuth,
    );
    _router.mount('/', configRoutes.configure().call);

    // 文件路由模块（整体应用认证）
    final fileRoutes = FileRoutes(
      databaseService: databaseService,
      redisService: redisService,
      withAuth: _withAuth,
    );
    _router.mount('/', _withAuth(fileRoutes.configure().call));

    // 通知路由模块（整体应用认证）
    final notificationRoutes = NotificationRoutes(
      databaseService: databaseService,
      redisService: redisService,
      withAuth: _withAuth,
    );
    _router.mount('/', _withAuth(notificationRoutes.configure().call));
  }
}
