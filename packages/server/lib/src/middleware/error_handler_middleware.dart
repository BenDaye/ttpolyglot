import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';

import '../exceptions/exceptions.dart';
import '../utils/response_builder.dart';
import '../utils/structured_logger.dart';

// 导出异常类供外部使用
export '../exceptions/exceptions.dart';

/// 错误处理中间件
/// 统一处理所有未捕获的异常并返回规范化的错误响应
class ErrorHandlerMiddleware {
  static final _logger = LoggerFactory.getLogger('ErrorHandler');

  /// 创建中间件处理器
  Middleware get handler => (Handler innerHandler) {
        return (Request request) async {
          try {
            return await innerHandler(request);
          } catch (error, stackTrace) {
            return _handleError(error, stackTrace, request);
          }
        };
      };

  /// 处理错误
  Response _handleError(dynamic error, StackTrace stackTrace, Request request) {
    // 生成或获取请求ID用于追踪
    final requestId = (request.context['request_id'] ?? 'unknown').toString();

    // 如果是 ServerException，直接使用 ResponseBuilder 构建响应
    if (error is ServerException) {
      _logger.error(
        '服务器异常: ${error.message}',
        error: error,
        stackTrace: stackTrace,
        context: LogContext().field('request_id', requestId).field('error_code', error.code.value),
      );

      return ResponseBuilder.fromException(
        error,
        requestId: requestId,
      );
    }

    // 记录未知错误日志
    _logger.error(
      '未处理的异常',
      error: error,
      stackTrace: stackTrace,
      context: LogContext().field('request_id', requestId).field('error_type', error.runtimeType.toString()),
    );

    // 包装未知异常为 BusinessException
    final wrappedException = BusinessException(
      code: ApiResponseCode.internalServerError,
      message: '服务器内部错误',
      details: error.toString(),
      stackTrace: stackTrace,
    );

    return ResponseBuilder.fromException(
      wrappedException,
      requestId: requestId,
    );
  }
}
