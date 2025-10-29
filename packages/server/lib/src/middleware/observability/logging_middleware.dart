import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';

/// 结构化日志中间件
Middleware structuredLoggingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();

      // 记录请求开始
      ServerLogger.info(
        '收到请求',
        error: {'request': request},
      );

      try {
        // 处理请求
        final response = await handler(request);

        // 记录请求完成
        final duration = DateTime.now().difference(startTime);
        ServerLogger.info(
          '请求完成',
          error: {'http_status': response.statusCode, 'duration_ms': duration.inMilliseconds},
        );

        return response;
      } catch (error, stackTrace) {
        // 记录请求错误
        final duration = DateTime.now().difference(startTime);
        ServerLogger.error(
          '请求失败',
          error: {'duration_ms': duration.inMilliseconds},
          stackTrace: stackTrace,
        );
        rethrow;
      }
    };
  };
}
