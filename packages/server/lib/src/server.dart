import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'config/server_config.dart';
import 'di/di.dart';
import 'middleware/middleware.dart';
import 'routes/api_routes.dart';
import 'services/services.dart';
import 'utils/logging/logger_utils.dart';

/// TTPolyglot 服务器主类
class TTPolyglotServer {
  late final DatabaseService _databaseService;
  late final RedisService _redisService;
  late final MultiLevelCacheService _cacheService;
  late final AuthService _authService;
  late final UserService _userService;
  late final ProjectService _projectService;
  late final PermissionService _permissionService;
  late final FileUploadService _fileUploadService;
  HttpServer? _server;
  late final DateTime _startTime;
  late final StructuredLogger _logger;

  /// 初始化服务器
  TTPolyglotServer() {
    // 初始化日志记录器
    _logger = LoggerFactory.getLogger('TTPolyglotServer');
  }

  /// 从依赖注入容器初始化服务
  void _initializeFromDI() {
    _databaseService = serviceRegistry.get<DatabaseService>();
    _redisService = serviceRegistry.get<RedisService>();
    _cacheService = serviceRegistry.get<MultiLevelCacheService>();
    _authService = serviceRegistry.get<AuthService>();
    _userService = serviceRegistry.get<UserService>();
    _projectService = serviceRegistry.get<ProjectService>();
    _permissionService = serviceRegistry.get<PermissionService>();
    _fileUploadService = serviceRegistry.get<FileUploadService>();
  }

  /// 启动服务器
  Future<void> start() async {
    try {
      _startTime = DateTime.now();
      _logger.info('开始启动服务器');

      // 第一阶段：注册所有服务
      await serviceRegistry.registerAllServices();

      // 第二阶段：初始化所有服务
      await serviceRegistry.initializeAllServices();

      // 第三阶段：从DI容器获取服务实例
      _initializeFromDI();

      // 第四阶段：启动HTTP服务器
      await _startHttpServer();

      final duration = DateTime.now().difference(_startTime);
      _logger.info(
        '服务器启动完成',
        context: LogContext()
            .performance('startup_time', duration.inMilliseconds.toDouble(), unit: 'ms')
            .field('host', ServerConfig.host)
            .field('port', ServerConfig.port),
      );
    } catch (error, stackTrace) {
      _logger.error(
        '服务器启动失败',
        context: LogContext().error(error, stackTrace: stackTrace),
      );
      rethrow;
    }
  }

  /// 启动HTTP服务器
  Future<void> _startHttpServer() async {
    _logger.info('启动HTTP服务器');

    // 创建中间件管道
    final handler = _createHandler();

    // 启动HTTP服务器
    _server = await shelf_io.serve(
      handler,
      ServerConfig.host,
      ServerConfig.port,
    );

    _logger.info(
      'HTTP服务器启动成功',
      context: LogContext()
          .field('url', 'http://${ServerConfig.host}:${ServerConfig.port}')
          .field('host', ServerConfig.host)
          .field('port', ServerConfig.port),
    );
  }

  /// 停止服务器
  Future<void> stop() async {
    try {
      _logger.info('开始关闭服务器');

      // 关闭HTTP服务器
      if (_server != null) {
        await _server!.close();
        _logger.info('HTTP服务器已关闭');
      }

      // 使用DI容器清理所有服务
      await serviceRegistry.dispose();

      _logger.info('服务器已优雅关闭');
    } catch (error, stackTrace) {
      _logger.error(
        '服务器关闭时出错',
        context: LogContext().error(error, stackTrace: stackTrace),
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
      projectService: _projectService,
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
        // 2. 指标收集（记录所有请求指标）
        .addMiddleware(metricsMiddleware(metricsService: serviceRegistry.get<MetricsService>()))
        // 3. 结构化日志（记录详细请求信息）
        .addMiddleware(structuredLoggingMiddleware(logger: _logger))
        // 4. CORS处理（处理跨域，避免后续中间件处理被拒绝的请求）
        .addMiddleware(corsMiddleware(allowedOrigins: ServerConfig.corsOrigins))
        // 5. 速率限制（早期拒绝，保护系统资源）
        .addMiddleware(RateLimitMiddleware(_redisService).handler)
        // 6. 请求大小限制（防止大请求消耗资源）
        .addMiddleware(_createRequestSizeLimitMiddleware())
        // 7. 安全头设置（增强安全性）
        .addMiddleware(_createSecurityHeadersMiddleware())
        // 8. 重试机制（处理临时失败）
        .addMiddleware(retryMiddleware())
        // 9. 错误处理（最后，捕获所有错误）
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
    try {
      final healthStatus = await _getComprehensiveHealthStatus();
      final statusCode = healthStatus['status'] == 'healthy' ? 200 : 503;

      return Response(
        statusCode,
        body: jsonEncode(healthStatus),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (error, stackTrace) {
      _logger.error('健康检查失败', error: error, stackTrace: stackTrace);

      return Response(
        503,
        body: jsonEncode({
          'status': 'unhealthy',
          'error': '健康检查失败',
          'timestamp': DateTime.now().toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
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

  /// 获取综合健康状态
  Future<Map<String, dynamic>> _getComprehensiveHealthStatus() async {
    final healthStatus = <String, dynamic>{
      'status': 'healthy',
      'timestamp': DateTime.now().toIso8601String(),
      'uptime_seconds': DateTime.now().difference(_startTime).inSeconds,
      'version': '1.0.0',
      'services': <String, dynamic>{},
      'performance': <String, dynamic>{},
    };

    try {
      // 并行检查所有服务
      final serviceChecks = await Future.wait([
        _checkDatabaseHealth(),
        _checkRedisHealth(),
        _checkCacheHealth(),
        _checkHttpServerHealth(),
      ]);

      // 处理服务检查结果
      healthStatus['services']['database'] = serviceChecks[0];
      healthStatus['services']['redis'] = serviceChecks[1];
      healthStatus['services']['cache'] = serviceChecks[2];
      healthStatus['services']['http'] = serviceChecks[3];

      // 计算性能指标
      healthStatus['performance'] = await _getPerformanceMetrics();

      // 计算整体健康状态
      final services = healthStatus['services'] as Map<String, dynamic>;
      final unhealthyServices = services.values.where((service) => service['status'] == 'unhealthy').length;

      if (unhealthyServices > 0) {
        healthStatus['status'] = 'degraded';
        healthStatus['unhealthy_services'] = unhealthyServices;
      }

      // 检查关键服务
      final criticalServices = ['database', 'redis'];
      final criticalUnhealthy = criticalServices.where((service) => services[service]?['status'] == 'unhealthy').length;

      if (criticalUnhealthy > 0) {
        healthStatus['status'] = 'unhealthy';
      }
    } catch (error, stackTrace) {
      healthStatus['status'] = 'unhealthy';
      healthStatus['error'] = error.toString();
      _logger.error('健康检查异常', error: error, stackTrace: stackTrace);
    }

    return healthStatus;
  }

  /// 检查数据库健康状态
  Future<Map<String, dynamic>> _checkDatabaseHealth() async {
    try {
      final startTime = DateTime.now();
      final isHealthy = await _databaseService.isHealthy();
      final responseTime = DateTime.now().difference(startTime).inMilliseconds;

      return {
        'status': isHealthy ? 'healthy' : 'unhealthy',
        'response_time_ms': responseTime,
        'connection_pool': 'active',
      };
    } catch (error) {
      return {
        'status': 'unhealthy',
        'error': error.toString(),
        'response_time_ms': -1,
      };
    }
  }

  /// 检查Redis健康状态
  Future<Map<String, dynamic>> _checkRedisHealth() async {
    try {
      final startTime = DateTime.now();
      final isHealthy = await _redisService.isHealthy();
      final responseTime = DateTime.now().difference(startTime).inMilliseconds;

      return {
        'status': isHealthy ? 'healthy' : 'unhealthy',
        'response_time_ms': responseTime,
        'connection': 'active',
      };
    } catch (error) {
      return {
        'status': 'unhealthy',
        'error': error.toString(),
        'response_time_ms': -1,
      };
    }
  }

  /// 检查缓存健康状态
  Future<Map<String, dynamic>> _checkCacheHealth() async {
    try {
      final cacheStats = _cacheService.getStats();
      final overall = cacheStats['overall'] as Map<String, dynamic>;

      return {
        'status': 'healthy',
        'l1_hit_rate': overall['l1_hit_rate'],
        'l2_hit_rate': overall['l2_hit_rate'],
        'overall_hit_rate': overall['hit_rate'],
        'l1_size': cacheStats['l1_cache']['size'],
        'l1_max_size': cacheStats['l1_cache']['max_size'],
      };
    } catch (error) {
      return {
        'status': 'unhealthy',
        'error': error.toString(),
      };
    }
  }

  /// 检查HTTP服务器健康状态
  Future<Map<String, dynamic>> _checkHttpServerHealth() async {
    return {
      'status': _server != null ? 'healthy' : 'unhealthy',
      'port': ServerConfig.port,
      'host': ServerConfig.host,
      'uptime_seconds': DateTime.now().difference(_startTime).inSeconds,
    };
  }

  /// 获取性能指标
  Future<Map<String, dynamic>> _getPerformanceMetrics() async {
    try {
      return {
        'memory_usage': 'normal',
        'cpu_usage': 'normal',
        'active_connections': 0,
        'cache_performance': _cacheService.getStats(),
      };
    } catch (error) {
      return {
        'error': '无法获取性能指标: ${error.toString()}',
      };
    }
  }

  /// 指标端点（Prometheus格式）
  Future<Response> _metricsEndpoint(Request request) async {
    try {
      final metricsService = serviceRegistry.get<MetricsService>();

      // 更新系统指标
      final uptime = DateTime.now().difference(_startTime).inSeconds.toDouble();
      metricsService.recordSystemMetrics(
        uptimeSeconds: uptime,
        memoryUsageBytes: 0.0, // 这里可以添加实际内存使用量
        cpuUsagePercent: 0.0, // 这里可以添加实际CPU使用率
      );

      // 获取Prometheus格式的指标
      final prometheusMetrics = metricsService.getPrometheusMetrics();

      return Response.ok(
        prometheusMetrics,
        headers: {
          'Content-Type': 'text/plain; version=0.0.4; charset=utf-8',
        },
      );
    } catch (error, stackTrace) {
      _logger.error('获取指标失败', error: error, stackTrace: stackTrace);

      return Response.internalServerError(
        body: '# 指标获取失败\n',
        headers: {
          'Content-Type': 'text/plain; charset=utf-8',
        },
      );
    }
  }
}
