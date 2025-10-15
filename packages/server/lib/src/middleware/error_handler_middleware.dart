import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';

import '../models/api_error.dart';
import '../utils/response_builder.dart';
import '../utils/structured_logger.dart';

/// 错误处理中间件
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
    // 生成请求ID用于追踪
    final requestId = (request.context['request_id'] ?? 'unknown').toString();

    // 记录错误日志
    _logger.error('未处理的异常', error: error, context: LogContext().field('request_id', requestId));

    // 根据错误类型返回不同的响应
    if (error is ValidationException) {
      return _buildErrorResponse(
        code: ApiResponseCode.unprocessableEntity,
        message: error.message,
        fieldErrors: error.fieldErrors,
        request: request,
        requestId: requestId,
      );
    }

    if (error is AuthenticationException) {
      return _buildErrorResponse(
        code: ApiResponseCode.unauthorized,
        message: error.message,
        request: request,
        requestId: requestId,
      );
    }

    if (error is AuthorizationException) {
      return _buildErrorResponse(
        code: ApiResponseCode.forbidden,
        message: error.message,
        request: request,
        requestId: requestId,
      );
    }

    if (error is NotFoundException) {
      return _buildErrorResponse(
        code: ApiResponseCode.notFound,
        message: error.message,
        request: request,
        requestId: requestId,
      );
    }

    if (error is BusinessException) {
      return _buildErrorResponse(
        code: ApiResponseCode.badRequest,
        message: error.message,
        details: error.details,
        request: request,
        requestId: requestId,
      );
    }

    // 其他未处理的异常
    return _buildErrorResponse(
      code: ApiResponseCode.internalServerError,
      message: '服务器内部错误',
      details: 'An unexpected error occurred',
      request: request,
      requestId: requestId,
    );
  }

  /// 构建错误响应
  Response _buildErrorResponse({
    required ApiResponseCode code,
    required String message,
    String? details,
    List<FieldError>? fieldErrors,
    required Request request,
    required String requestId,
  }) {
    // 构建错误详情数据
    final Map<String, dynamic> errorData = {
      if (details != null) 'details': details,
      if (fieldErrors != null && fieldErrors.isNotEmpty) 'field_errors': fieldErrors.map((e) => e.toJson()).toList(),
      'metadata': {
        'request_id': requestId,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      }
    };

    return ResponseBuilder.error(
      code: code,
      message: message,
      data: errorData,
      headers: {'X-Request-ID': requestId},
    );
  }
}

/// 验证异常
class ValidationException implements Exception {
  final String message;
  final List<FieldError> fieldErrors;

  const ValidationException(this.message, this.fieldErrors);

  @override
  String toString() => 'ValidationException: $message';
}

/// 字段错误

/// 认证异常
class AuthenticationException implements Exception {
  final String code;
  final String message;

  const AuthenticationException(this.code, this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// 授权异常
class AuthorizationException implements Exception {
  final String message;

  const AuthorizationException(this.message);

  @override
  String toString() => 'AuthorizationException: $message';
}

/// 资源未找到异常
class NotFoundException implements Exception {
  final String message;

  const NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// 业务逻辑异常
class BusinessException implements Exception {
  final String code;
  final String message;
  final String? details;

  const BusinessException(this.code, this.message, [this.details]);

  @override
  String toString() => 'BusinessException: $message';
}
