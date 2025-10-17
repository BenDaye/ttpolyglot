import 'package:shelf/shelf.dart';

import '../../utils/infrastructure/retry_utils.dart';
import '../../utils/logging/logger_utils.dart';

/// 重试中间件
class RetryMiddleware {
  final RetryConfig _config;

  RetryMiddleware({
    RetryConfig? config,
  }) : _config = config ??
            const RetryConfig(
              maxAttempts: 3,
              initialDelay: Duration(milliseconds: 100),
              maxDelay: Duration(seconds: 2),
              strategy: RetryStrategy.exponential,
            );

  /// 创建重试中间件
  Middleware call() {
    return (Handler handler) {
      return (Request request) async {
        // 只对特定路径和方法的请求进行重试
        if (!_shouldRetry(request)) {
          return await handler(request);
        }

        try {
          return await RetryUtils.retry<Response>(
            () async => await handler(request),
            config: _config,
            operationName: 'http_request_${request.method}_${request.url.path}',
          );
        } catch (error, stackTrace) {
          LoggerUtils.error('重试中间件失败', error: error, stackTrace: stackTrace);
          rethrow;
        }
      };
    };
  }

  /// 判断是否应该重试请求
  bool _shouldRetry(Request request) {
    // 只对GET和POST请求进行重试
    if (request.method != 'GET' && request.method != 'POST') {
      return false;
    }

    // 不对健康检查端点进行重试
    if (request.url.path.startsWith('/health') || request.url.path.startsWith('/metrics')) {
      return false;
    }

    // 不对大文件上传进行重试
    final contentLength = request.headers['content-length'];
    if (contentLength != null) {
      final size = int.tryParse(contentLength) ?? 0;
      if (size > 10 * 1024 * 1024) {
        // 10MB
        return false;
      }
    }

    return true;
  }
}

/// 创建重试中间件
Middleware retryMiddleware({RetryConfig? config}) {
  return RetryMiddleware(config: config).call();
}
