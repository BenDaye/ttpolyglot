import 'package:shelf/shelf.dart';

import '../services/metrics_service.dart';
import '../utils/structured_logger.dart';

/// 指标中间件
class MetricsMiddleware {
  static final _logger = LoggerFactory.getLogger('MetricsMiddleware');
  final MetricsService _metricsService;

  MetricsMiddleware({MetricsService? metricsService}) : _metricsService = metricsService ?? MetricsService();

  /// 创建指标中间件
  Middleware call() {
    return (Handler handler) {
      return (Request request) async {
        final startTime = DateTime.now();

        try {
          // 记录请求开始
          _recordRequestStart(request);

          // 处理请求
          final response = await handler(request);

          // 记录请求完成
          final duration = DateTime.now().difference(startTime).inSeconds.toDouble();
          _recordRequestComplete(request, response, duration);

          return response;
        } catch (error, stackTrace) {
          // 记录请求错误
          final duration = DateTime.now().difference(startTime).inSeconds.toDouble();
          _recordRequestError(request, error, duration);

          _logger.error(
            '请求处理错误',
            error: error,
            stackTrace: stackTrace,
            context: LogContext().request(request.method, request.url.path),
          );
          rethrow;
        }
      };
    };
  }

  /// 记录请求开始
  void _recordRequestStart(Request request) {
    // 这里可以记录正在处理的请求数
    // 由于Prometheus的gauge类型，我们需要在请求结束时减少计数
    // 所以这里暂时不记录，在请求完成时统一处理
  }

  /// 记录请求完成
  void _recordRequestComplete(Request request, Response response, double duration) {
    final method = request.method;
    final path = _normalizePath(request.url.path);
    final statusCode = response.statusCode;

    _metricsService.recordHttpRequest(method, path, statusCode, duration);

    _logger.debug('记录HTTP指标: $method $path $statusCode ${duration}s');
  }

  /// 记录请求错误
  void _recordRequestError(Request request, dynamic error, double duration) {
    final method = request.method;
    final path = _normalizePath(request.url.path);

    // 记录为500错误
    _metricsService.recordHttpRequest(method, path, 500, duration);

    _logger.debug('记录HTTP错误指标: $method $path 500 ${duration}s');
  }

  /// 标准化路径（移除动态参数）
  String _normalizePath(String path) {
    // 移除UUID和数字ID
    String normalized = path
        .replaceAll(RegExp(r'/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'), '/{uuid}')
        .replaceAll(RegExp(r'/\d+'), '/{id}')
        .replaceAll(RegExp(r'/\d+$'), '/{id}');

    // 限制路径长度
    if (normalized.length > 100) {
      normalized = normalized.substring(0, 100) + '...';
    }

    return normalized;
  }
}

/// 创建指标中间件
Middleware metricsMiddleware({MetricsService? metricsService}) {
  return MetricsMiddleware(metricsService: metricsService).call();
}
