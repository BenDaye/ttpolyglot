import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

/// 请求ID中间件
/// 为每个请求生成唯一ID，用于日志追踪
class RequestIdMiddleware {
  static const _uuid = Uuid();

  /// 创建中间件处理器
  Middleware get handler => (Handler innerHandler) {
        return (Request request) async {
          // 从请求头获取或生成新的请求ID
          var requestId = request.headers['x-request-id'];
          requestId ??= _uuid.v4();

          // 将请求ID添加到请求上下文
          final updatedRequest = request.change(
            context: {
              ...request.context,
              'request_id': requestId,
            },
          );

          // 处理请求
          final response = await innerHandler(updatedRequest);

          // 在响应头中添加请求ID
          return response.change(
            headers: {
              ...response.headers,
              'X-Request-ID': requestId,
            },
          );
        };
      };
}
