import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'config/server_config.dart';
import 'middleware/middleware.dart';
import 'routes/api_routes.dart';
import 'services/services.dart';

/// TTPolyglot 服务器主类
class TTPolyglotServer {
  late final ServerConfig _config;
  late final DatabaseService _databaseService;
  late final RedisService _redisService;
  late final MigrationService _migrationService;
  late final AuthService _authService;
  late final UserService _userService;
  late final ProjectService _projectService;
  late final PermissionService _permissionService;
  HttpServer? _server;

  /// 初始化服务器
  TTPolyglotServer() {
    _config = ServerConfig();
  }

  /// 启动服务器
  Future<void> start() async {
    try {
      // 初始化配置
      await _config.load();
      log('服务器配置加载完成', name: 'TTPolyglotServer');

      // 初始化数据库连接
      _databaseService = DatabaseService(_config);
      await _databaseService.initialize();
      log('数据库连接初始化完成', name: 'TTPolyglotServer');

      // 运行数据库迁移
      _migrationService = MigrationService(_databaseService, _config);
      await _migrationService.runMigrations();
      log('数据库迁移完成', name: 'TTPolyglotServer');

      // 运行种子数据
      await _migrationService.runSeeds();
      log('种子数据初始化完成', name: 'TTPolyglotServer');

      // 初始化Redis连接
      _redisService = RedisService(_config);
      await _redisService.initialize();
      log('Redis连接初始化完成', name: 'TTPolyglotServer');

      // 初始化业务服务
      _permissionService = PermissionService(
        databaseService: _databaseService,
        redisService: _redisService,
      );
      log('权限服务初始化完成', name: 'TTPolyglotServer');

      _authService = AuthService(
        databaseService: _databaseService,
        redisService: _redisService,
        config: _config,
      );
      log('认证服务初始化完成', name: 'TTPolyglotServer');

      _userService = UserService(
        databaseService: _databaseService,
        redisService: _redisService,
        config: _config,
      );
      log('用户服务初始化完成', name: 'TTPolyglotServer');

      _projectService = ProjectService(
        databaseService: _databaseService,
        redisService: _redisService,
        config: _config,
      );
      log('项目服务初始化完成', name: 'TTPolyglotServer');

      // 创建中间件管道
      final handler = _createHandler();

      // 启动HTTP服务器
      _server = await shelf_io.serve(
        handler,
        _config.host,
        _config.port,
      );

      log('服务器启动成功 - http://${_config.host}:${_config.port}', name: 'TTPolyglotServer');
    } catch (error, stackTrace) {
      log('服务器启动失败', error: error, stackTrace: stackTrace, name: 'TTPolyglotServer');
      rethrow;
    }
  }

  /// 停止服务器
  Future<void> stop() async {
    try {
      // 关闭HTTP服务器
      if (_server != null) {
        await _server!.close();
        log('HTTP服务器已关闭', name: 'TTPolyglotServer');
      }

      // 关闭Redis连接
      await _redisService.close();
      log('Redis连接已关闭', name: 'TTPolyglotServer');

      // 关闭数据库连接
      await _databaseService.close();
      log('数据库连接已关闭', name: 'TTPolyglotServer');

      log('服务器已优雅关闭', name: 'TTPolyglotServer');
    } catch (error, stackTrace) {
      log('服务器关闭时出错', error: error, stackTrace: stackTrace, name: 'TTPolyglotServer');
    }
  }

  /// 创建请求处理器
  Handler _createHandler() {
    final router = Router();

    // 健康检查端点
    router.get('/health', _healthCheck);
    router.get('/health/db', _dbHealthCheck);
    router.get('/health/ready', _readyCheck);

    // API路由
    final apiRoutes = ApiRoutes(
      databaseService: _databaseService,
      redisService: _redisService,
      config: _config,
      authService: _authService,
      userService: _userService,
      projectService: _projectService,
      permissionService: _permissionService,
    );
    router.mount('/api/v1/', apiRoutes.handler);

    // 404处理
    router.all('/<ignored|.*>', _notFoundHandler);

    // 创建中间件管道
    final pipeline = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(corsHeaders())
        .addMiddleware(ErrorHandlerMiddleware().handler)
        .addMiddleware(RequestIdMiddleware().handler)
        .addMiddleware(RateLimitMiddleware(_redisService, _config).handler);

    return pipeline.addHandler(router);
  }

  /// 健康检查端点
  Response _healthCheck(Request request) {
    return Response.ok('{"status": "healthy", "timestamp": "${DateTime.now().toIso8601String()}"}',
        headers: {'Content-Type': 'application/json'});
  }

  /// 数据库健康检查
  Future<Response> _dbHealthCheck(Request request) async {
    try {
      final isHealthy = await _databaseService.isHealthy();
      if (isHealthy) {
        return Response.ok('{"status": "healthy", "database": "connected"}',
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response.internalServerError(
            body: '{"status": "unhealthy", "database": "disconnected"}', headers: {'Content-Type': 'application/json'});
      }
    } catch (error) {
      return Response.internalServerError(
          body: '{"status": "error", "message": "${error.toString()}"}', headers: {'Content-Type': 'application/json'});
    }
  }

  /// 服务就绪检查
  Future<Response> _readyCheck(Request request) async {
    try {
      final dbHealthy = await _databaseService.isHealthy();
      final redisHealthy = await _redisService.isHealthy();

      if (dbHealthy && redisHealthy) {
        return Response.ok('{"status": "ready", "services": {"database": true, "redis": true}}',
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response(503,
            body: '{"status": "not_ready", "services": {"database": $dbHealthy, "redis": $redisHealthy}}',
            headers: {'Content-Type': 'application/json'});
      }
    } catch (error) {
      return Response.internalServerError(
          body: '{"status": "error", "message": "${error.toString()}"}', headers: {'Content-Type': 'application/json'});
    }
  }

  /// 404处理器
  Response _notFoundHandler(Request request) {
    return Response.notFound(
        '{"error": {"code": "RESOURCE_NOT_FOUND", "message": "请求的资源不存在", "path": "${request.requestedUri.path}"}}',
        headers: {'Content-Type': 'application/json'});
  }
}
