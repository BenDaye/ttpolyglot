import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';

/// 错误处理中间件
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
    // 生成请求ID用于追踪
    final requestId = request.context['request_id'] ?? 'unknown';

    // 记录错误日志
    log('未处理的异常', error: error, stackTrace: stackTrace, name: 'ErrorHandler');

    // 根据错误类型返回不同的响应
    if (error is ValidationException) {
      return _buildErrorResponse(
        statusCode: 422,
        code: 'VALIDATION_FAILED',
        message: '请求参数验证失败',
        fieldErrors: error.fieldErrors,
        request: request,
        requestId: requestId,
      );
    }

    if (error is AuthenticationException) {
      return _buildErrorResponse(
        statusCode: 401,
        code: error.code,
        message: error.message,
        request: request,
        requestId: requestId,
      );
    }

    if (error is AuthorizationException) {
      return _buildErrorResponse(
        statusCode: 403,
        code: 'AUTH_PERMISSION_DENIED',
        message: '权限不足',
        request: request,
        requestId: requestId,
      );
    }

    if (error is NotFoundException) {
      return _buildErrorResponse(
        statusCode: 404,
        code: 'RESOURCE_NOT_FOUND',
        message: '请求的资源不存在',
        details: error.message,
        request: request,
        requestId: requestId,
      );
    }

    if (error is BusinessException) {
      return _buildErrorResponse(
        statusCode: 400,
        code: error.code,
        message: error.message,
        details: error.details,
        request: request,
        requestId: requestId,
      );
    }

    // 其他未处理的异常
    return _buildErrorResponse(
      statusCode: 500,
      code: 'SYSTEM_INTERNAL_ERROR',
      message: '服务器内部错误',
      details: 'An unexpected error occurred',
      request: request,
      requestId: requestId,
    );
  }

  /// 构建错误响应
  Response _buildErrorResponse({
    required int statusCode,
    required String code,
    required String message,
    String? details,
    List<FieldError>? fieldErrors,
    required Request request,
    required String requestId,
  }) {
    final errorResponse = {
      'error': {
        'code': code,
        'message': message,
        if (details != null) 'details': details,
        if (fieldErrors != null) 'field_errors': fieldErrors.map((e) => e.toJson()).toList(),
        'metadata': {
          'request_id': requestId,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'path': request.requestedUri.path,
          'method': request.method,
          if (request.context['user_id'] != null) 'user_id': request.context['user_id'],
        }
      }
    };

    return Response(
      statusCode,
      headers: {
        'Content-Type': 'application/json',
        'X-Request-ID': requestId,
      },
      body: jsonEncode(errorResponse),
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
class FieldError {
  final String field;
  final String code;
  final String message;

  const FieldError({
    required this.field,
    required this.code,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
        'field': field,
        'code': code,
        'message': message,
      };
}

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
