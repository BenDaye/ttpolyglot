import 'package:shelf/shelf.dart';

import '../../utils/logging/logger_utils.dart';

/// 结构化日志中间件
Middleware structuredLoggingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();

      // 记录请求开始
      LoggerUtils.info(
        '收到请求',
        context: LogContext.fromRequest(request),
      );

      try {
        // 处理请求
        final response = await handler(request);

        // 记录请求完成
        final duration = DateTime.now().difference(startTime);
        LoggerUtils.info(
          '请求完成',
          context: LogContext.fromRequest(
            request,
            extra: {
              'http_status': response.statusCode,
              'duration_ms': duration.inMilliseconds,
            },
          ),
        );

        return response;
      } catch (error, stackTrace) {
        // 记录请求错误
        final duration = DateTime.now().difference(startTime);
        LoggerUtils.error(
          '请求失败',
          error: error,
          stackTrace: stackTrace,
          context: LogContext.fromRequest(
            request,
            extra: {
              'duration_ms': duration.inMilliseconds,
            },
          ),
        );
        rethrow;
      }
    };
  };
}
