import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:ttpolyglot_model/model.dart';

import 'config/server_config.dart';
import 'di/di.dart';
import 'middleware/middleware.dart';
import 'routes/api_routes.dart';
import 'services/services.dart';
import 'utils/http/response_utils.dart';

/// TTPolyglot 服务器主类
class TTPolyglotServer {
  late final DatabaseService _databaseService;
  late final RedisService _redisService;
  late final MultiLevelCacheService _cacheService;
  late final AuthService _authService;
  late final UserService _userService;
  late final UserSettingsService _userSettingsService;
  late final ProjectService _projectService;
  late final ProjectMemberService _projectMemberService;
  late final PermissionService _permissionService;
  late final FileUploadService _fileUploadService;
  HttpServer? _server;
  late final DateTime _startTime;

  /// 从依赖注入容器初始化服务
  void _initializeFromDI() {
    _databaseService = serviceRegistry.get<DatabaseService>();
    _redisService = serviceRegistry.get<RedisService>();
    _cacheService = serviceRegistry.get<MultiLevelCacheService>();
    _authService = serviceRegistry.get<AuthService>();
    _userService = serviceRegistry.get<UserService>();
    _userSettingsService = serviceRegistry.get<UserSettingsService>();
    _projectService = serviceRegistry.get<ProjectService>();
    _projectMemberService = serviceRegistry.get<ProjectMemberService>();
    _permissionService = serviceRegistry.get<PermissionService>();
    _fileUploadService = serviceRegistry.get<FileUploadService>();
  }

  /// 启动服务器
  Future<void> start() async {
    try {
      _startTime = DateTime.now();
      ServerLogger.info('开始启动服务器');

      // 第一阶段：注册所有服务
      await serviceRegistry.registerAllServices();

      // 第二阶段：初始化所有服务
      await serviceRegistry.initializeAllServices();

      // 第三阶段：从DI容器获取服务实例
      _initializeFromDI();

      // 第四阶段：启动HTTP服务器
      await _startHttpServer();

      final duration = DateTime.now().difference(_startTime);
      ServerLogger.info(
        '服务器启动完成',
        error: {
          'startup_time': duration.inMilliseconds.toDouble(),
          'host': ServerConfig.host,
          'port': ServerConfig.port,
        },
      );
    } catch (error, stackTrace) {
      ServerLogger.error(
        '服务器启动失败',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 启动HTTP服务器
  Future<void> _startHttpServer() async {
    ServerLogger.info('启动HTTP服务器');

    // 创建中间件管道
    final handler = _createHandler();

    // 启动HTTP服务器
    _server = await shelf_io.serve(
      handler,
      ServerConfig.host,
      ServerConfig.port,
    );

    ServerLogger.info(
      'HTTP服务器启动成功',
      error: {
        'url': 'http://${ServerConfig.host}:${ServerConfig.port}',
        'host': ServerConfig.host,
        'port': ServerConfig.port,
      },
    );
  }

  /// 停止服务器
  Future<void> stop() async {
    try {
      ServerLogger.info('开始关闭服务器');

      // 关闭HTTP服务器
      if (_server != null) {
        await _server!.close();
        ServerLogger.info('HTTP服务器已关闭');
      }

      // 使用DI容器清理所有服务
      await serviceRegistry.dispose();

      ServerLogger.info('服务器已优雅关闭');
    } catch (error, stackTrace) {
      ServerLogger.error(
        '服务器关闭时出错',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// 创建请求处理器
  Handler _createHandler() {
    final router = Router();

    // 健康检查端点
    router.get('/health', _healthCheck);
    router.get('/health/db', _dbHealthCheck);
    router.get('/health/ready', _readyCheck);

    // 指标端点
    router.get('/metrics', _metricsEndpoint);

    // API路由
    final apiRoutes = ApiRoutes(
      databaseService: _databaseService,
      redisService: _redisService,
      cacheService: _cacheService,
      authService: _authService,
      userService: _userService,
      userSettingsService: _userSettingsService,
      projectService: _projectService,
      projectMemberService: _projectMemberService,
      permissionService: _permissionService,
      fileUploadService: _fileUploadService,
      startTime: _startTime,
    );
    router.mount('/api/v1/', apiRoutes.handler);

    // 404处理
    router.all('/<ignored|.*>', _notFoundHandler);

    // 创建优化的中间件管道
    final pipeline = _createOptimizedPipeline();
    return pipeline.addHandler(router);
  }

  /// 创建优化的中间件管道
  Pipeline _createOptimizedPipeline() {
    return Pipeline()
        // 1. 请求ID生成（最早，为后续中间件提供追踪）
        .addMiddleware(RequestIdMiddleware().handler)
        // 2. 结构化日志（记录详细请求信息）
        .addMiddleware(structuredLoggingMiddleware())
        // 3. CORS处理（处理跨域，避免后续中间件处理被拒绝的请求）
        .addMiddleware(corsMiddleware(allowedOrigins: ServerConfig.corsOrigins))
        // 4. 速率限制（早期拒绝，保护系统资源）
        .addMiddleware(RateLimitMiddleware(_redisService).handler)
        // 5. 请求大小限制（防止大请求消耗资源）
        .addMiddleware(_createRequestSizeLimitMiddleware())
        // 6. 安全头设置（增强安全性）
        .addMiddleware(_createSecurityHeadersMiddleware())
        // 7. 重试机制（处理临时失败）
        .addMiddleware(retryMiddleware())
        // 8. 错误处理（最后，捕获所有错误）
        .addMiddleware(ErrorHandlerMiddleware().handler);
  }

  /// 创建请求大小限制中间件
  Middleware _createRequestSizeLimitMiddleware() {
    const maxRequestSize = 10 * 1024 * 1024; // 10MB

    return (Handler handler) {
      return (Request request) async {
        final contentLength = request.headers['content-length'];
        if (contentLength != null) {
          final size = int.tryParse(contentLength) ?? 0;
          if (size > maxRequestSize) {
            return Response(
              413,
              body: '{"error": "请求体过大", "max_size": "$maxRequestSize"}',
              headers: {'Content-Type': 'application/json'},
            );
          }
        }

        return await handler(request);
      };
    };
  }

  /// 创建安全头中间件
  Middleware _createSecurityHeadersMiddleware() {
    return (Handler handler) {
      return (Request request) async {
        final response = await handler(request);

        return response.change(headers: {
          ...response.headers,
          'X-Content-Type-Options': 'nosniff',
          'X-Frame-Options': 'DENY',
          'X-XSS-Protection': '1; mode=block',
          'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
          'Referrer-Policy': 'strict-origin-when-cross-origin',
          'Permissions-Policy': 'geolocation=(), microphone=(), camera=()',
        });
      };
    };
  }

  /// 健康检查端点
  Future<Response> _healthCheck(Request request) async {
    return ResponseUtils.healthCheck(
      databaseService: _databaseService,
      redisService: _redisService,
      cacheService: _cacheService,
      startTime: _startTime,
    );
  }

  /// 数据库健康检查
  Future<Response> _dbHealthCheck(Request request) async {
    return ResponseUtils.dbHealthCheck(
      databaseService: _databaseService,
    );
  }

  /// 服务就绪检查
  Future<Response> _readyCheck(Request request) async {
    return ResponseUtils.readyCheck(
      databaseService: _databaseService,
      redisService: _redisService,
    );
  }

  /// 404处理器
  Response _notFoundHandler(Request request) {
    return ResponseUtils.notFound();
  }

  /// 指标端点（Prometheus格式）
  Future<Response> _metricsEndpoint(Request request) async {
    final metricsService = serviceRegistry.get<MetricsService>();
    return ResponseUtils.metricsEndpoint(
      metricsService: metricsService,
      startTime: _startTime,
    );
  }
}
