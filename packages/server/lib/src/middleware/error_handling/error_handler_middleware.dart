import 'package:shelf/shelf.dart';

import '../../exceptions/exceptions.dart';
import '../../utils/http/response_utils.dart';
import '../../utils/logging/logger_utils.dart';

// 导出异常类供外部使用
export '../../exceptions/exceptions.dart';

/// 错误处理中间件
/// 统一处理所有未捕获的异常并返回规范化的错误响应
class ErrorHandlerMiddleware {
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
    // 如果是 ServerException，直接使用 ResponseUtils 构建响应
    if (error is ServerException) {
      LoggerUtils.error(
        '服务器异常: ${error.message}',
        error: error,
        stackTrace: stackTrace,
      );

      return ResponseUtils.fromException(
        error,
      );
    }

    // 记录未知错误日志
    LoggerUtils.error(
      '未处理的异常',
      error: error,
      stackTrace: stackTrace,
    );

    // 包装未知异常为 BusinessException
    final wrappedException = BusinessException(
      message: '服务器内部错误',
      details: error.toString(),
      stackTrace: stackTrace,
    );

    return ResponseUtils.fromException(
      wrappedException,
    );
  }
}
