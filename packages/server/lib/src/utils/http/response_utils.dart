import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:uuid/uuid.dart';

import '../../config/server_config.dart';
import '../../middleware/error_handling/error_handler_middleware.dart';
import '../../services/services.dart';

/// API响应构建器
/// 提供统一的响应格式构建方法
class ResponseUtils {
  static const String _contentTypeJson = 'application/json; charset=utf-8';
  static const _uuid = Uuid();

  /// 根据 DataCodeEnum 获取 HTTP 状态码
  static int _getHttpStatusCode(DataCodeEnum code) {
    // 对于自定义业务错误码，统一返回 200
    if (code.value <= 0) {
      return 200;
    }

    return code.value;
  }

  /// 构建成功响应
  static Response success<T>({
    String? message,
    T? data,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final apiResponse = BaseModel<T>(
      code: DataCodeEnum.success,
      message: message ?? DataCodeEnum.success.message,
      type: type,
      data: data,
    );

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      200,
      headers: responseHeaders,
      body: jsonEncode(
        apiResponse.toJson((data) => ModelUtils.toJsonValue(data)),
      ),
    );
  }

  /// 构建错误响应
  static Response error<T>({
    DataCodeEnum? code,
    T? data,
    String? message,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
    Map<String, String>? headers,
  }) {
    code ??= DataCodeEnum.error;
    final requestId = _uuid.v4();
    final apiResponse = BaseModel<T>(
      code: code,
      message: message ?? code.message,
      type: type,
      data: data,
    );

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      _getHttpStatusCode(code),
      headers: responseHeaders,
      body: jsonEncode(
        apiResponse.toJson((data) => ModelUtils.toJsonValue(data)),
      ),
    );
  }

  /// 从异常构建错误响应
  static Response fromException(
    ServerException exception, {
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) {
    return error(data: exception.toString(), type: type);
  }

  /// 构建无内容响应（204）
  static Response noContent({
    Map<String, String>? headers,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) {
    return error(
      code: DataCodeEnum.noContent,
      type: type,
      headers: headers,
    );
  }

  /// 构建创建成功响应
  static Response created<T>({
    String? message,
    T? data,
    String? location,
    Map<String, String>? headers,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) {
    return success(
      message: message ?? '创建成功',
      data: data,
      type: type,
      headers: headers,
    );
  }

  /// 构建接受响应
  static Response accepted<T>({
    String? message,
    T? data,
    Map<String, String>? headers,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) {
    return success(
      message: message ?? '请求已接受',
      data: data,
      type: type,
      headers: headers,
    );
  }

  /// 版本信息响应
  static Response version({
    String? version,
    String? apiVersion,
    String? serverName,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) {
    final data = {
      'version': version ?? '1.0.0',
      'api_version': apiVersion ?? 'v1',
      'server': serverName ?? 'TTPolyglot Server',
      'environment': ServerConfig.isDevelopment ? 'development' : 'production',
      'timestamp': DateTime.now().toIso8601String(),
    };

    return success(data: data);
  }

  /// 状态信息响应
  static Future<Response> status({
    required DatabaseService databaseService,
    required RedisService redisService,
    required DateTime startTime,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) async {
    try {
      final dbHealthy = await databaseService.isHealthy();
      final redisHealthy = await redisService.isHealthy();

      final data = {
        'status': dbHealthy && redisHealthy ? 'healthy' : 'degraded',
        'services': {
          'database': dbHealthy ? 'healthy' : 'unhealthy',
          'redis': redisHealthy ? 'healthy' : 'unhealthy',
        },
        'timestamp': DateTime.now().toIso8601String(),
        'uptime': DateTime.now().difference(startTime).inSeconds,
      };

      return success(data: data);
    } catch (err) {
      return error(code: DataCodeEnum.serviceUnavailable, message: '状态检查失败');
    }
  }

  /// 404处理器
  static Response notFound({
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) {
    return error(
      code: DataCodeEnum.notFound,
      type: type,
      message: '请求的资源不存在',
    );
  }

  /// 健康检查端点
  static Future<Response> healthCheck({
    required DatabaseService databaseService,
    required RedisService redisService,
    required MultiLevelCacheService cacheService,
    required DateTime startTime,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) async {
    try {
      final healthStatus = await _getComprehensiveHealthStatus(
        databaseService: databaseService,
        redisService: redisService,
        cacheService: cacheService,
        startTime: startTime,
      );

      final isHealthy = healthStatus['status'] == 'healthy';

      return success(data: healthStatus, type: type, message: isHealthy ? '系统健康' : '系统不健康');
    } catch (err, stackTrace) {
      ServerLogger.error(
        'healthCheck',
        error: err,
        stackTrace: stackTrace,
      );

      return error(code: DataCodeEnum.internalServerError, message: '健康检查失败');
    }
  }

  /// 数据库健康检查
  static Future<Response> dbHealthCheck({
    required DatabaseService databaseService,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) async {
    try {
      final isHealthy = await databaseService.isHealthy();

      return success(
        data: {
          'status': isHealthy ? 'healthy' : 'unhealthy',
          'database': isHealthy ? 'connected' : 'disconnected',
        },
        type: type,
        message: isHealthy ? '数据库连接正常' : '数据库连接失败',
      );
    } catch (err, stackTrace) {
      ServerLogger.error(
        'dbHealthCheck',
        error: err,
        stackTrace: stackTrace,
      );

      return error(code: DataCodeEnum.internalServerError, message: '数据库检查出错');
    }
  }

  /// 服务就绪检查
  static Future<Response> readyCheck({
    required DatabaseService databaseService,
    required RedisService redisService,
    DataMessageTipsEnum type = DataMessageTipsEnum.showToast,
  }) async {
    try {
      final dbHealthy = await databaseService.isHealthy();
      final redisHealthy = await redisService.isHealthy();

      return success(data: {
        'status': 'not_ready',
        'services': {
          'database': dbHealthy,
          'redis': redisHealthy,
        },
      }, type: type, message: '服务未就绪');
    } catch (err, stackTrace) {
      ServerLogger.error(
        'readyCheck',
        error: err,
        stackTrace: stackTrace,
      );

      return error(code: DataCodeEnum.internalServerError, message: '就绪检查出错');
    }
  }

  /// 指标端点（Prometheus格式）
  static Future<Response> metricsEndpoint({
    required MetricsService metricsService,
    required DateTime startTime,
  }) async {
    try {
      // 更新系统指标
      final uptime = DateTime.now().difference(startTime).inSeconds.toDouble();
      metricsService.recordSystemMetrics(
        uptimeSeconds: uptime,
        memoryUsageBytes: 0.0, // 这里可以添加实际内存使用量
        cpuUsagePercent: 0.0, // 这里可以添加实际CPU使用率
      );

      // 获取Prometheus格式的指标
      final prometheusMetrics = metricsService.getPrometheusMetrics();

      return success(data: prometheusMetrics);
    } catch (err, stackTrace) {
      ServerLogger.error(
        'metricsEndpoint',
        error: err,
        stackTrace: stackTrace,
      );

      return error(code: DataCodeEnum.internalServerError, message: '指标获取失败', type: DataMessageTipsEnum.showToast);
    }
  }

  /// 获取综合健康状态
  static Future<Map<String, dynamic>> _getComprehensiveHealthStatus({
    required DatabaseService databaseService,
    required RedisService redisService,
    required MultiLevelCacheService cacheService,
    required DateTime startTime,
  }) async {
    final healthStatus = <String, dynamic>{
      'status': 'healthy',
      'timestamp': DateTime.now().toIso8601String(),
      'uptime_seconds': DateTime.now().difference(startTime).inSeconds,
      'version': '1.0.0',
      'services': <String, dynamic>{},
      'performance': <String, dynamic>{},
    };

    try {
      // 并行检查所有服务
      final serviceChecks = await Future.wait([
        _checkDatabaseHealth(databaseService),
        _checkRedisHealth(redisService),
        _checkCacheHealth(cacheService),
        _checkHttpServerHealth(startTime),
      ]);

      // 处理服务检查结果
      healthStatus['services']['database'] = serviceChecks[0];
      healthStatus['services']['redis'] = serviceChecks[1];
      healthStatus['services']['cache'] = serviceChecks[2];
      healthStatus['services']['http'] = serviceChecks[3];

      // 计算性能指标
      healthStatus['performance'] = await _getPerformanceMetrics(cacheService);

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
      ServerLogger.error(
        '_getComprehensiveHealthStatus',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return healthStatus;
  }

  /// 检查数据库健康状态
  static Future<Map<String, dynamic>> _checkDatabaseHealth(DatabaseService databaseService) async {
    try {
      final startTime = DateTime.now();
      final isHealthy = await databaseService.isHealthy();
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
  static Future<Map<String, dynamic>> _checkRedisHealth(RedisService redisService) async {
    try {
      final startTime = DateTime.now();
      final isHealthy = await redisService.isHealthy();
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
  static Future<Map<String, dynamic>> _checkCacheHealth(MultiLevelCacheService cacheService) async {
    try {
      final cacheStats = cacheService.getStats();
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
  static Future<Map<String, dynamic>> _checkHttpServerHealth(DateTime startTime) async {
    return {
      'status': 'healthy',
      'port': ServerConfig.port,
      'host': ServerConfig.host,
      'uptime_seconds': DateTime.now().difference(startTime).inSeconds,
    };
  }

  /// 获取性能指标
  static Future<Map<String, dynamic>> _getPerformanceMetrics(MultiLevelCacheService cacheService) async {
    try {
      return {
        'memory_usage': 'normal',
        'cpu_usage': 'normal',
        'active_connections': 0,
        'cache_performance': cacheService.getStats(),
      };
    } catch (error) {
      return {
        'error': '无法获取性能指标: ${error.toString()}',
      };
    }
  }
}
