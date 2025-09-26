import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../middleware/error_handler_middleware.dart';

/// 响应构建器工具类
class ResponseBuilder {
  static const String _contentTypeJson = 'application/json';
  static const _uuid = Uuid();

  /// 成功响应
  static Response success({
    String? message,
    dynamic data,
    int statusCode = 200,
    Map<String, String>? headers,
  }) {
    final responseData = <String, dynamic>{};

    if (data != null) {
      responseData['data'] = data;
    }

    if (message != null) {
      responseData['message'] = message;
    }

    responseData['metadata'] = {
      'request_id': _uuid.v4(),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'status': 'success',
    };

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': responseData['metadata']['request_id'],
      ...?headers,
    };

    return Response(
      statusCode,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }

  /// 分页数据响应
  static Response paginated({
    required List<dynamic> data,
    required int page,
    required int limit,
    required int total,
    String? message,
    int statusCode = 200,
    Map<String, String>? headers,
  }) {
    final totalPages = (total / limit).ceil();

    final responseData = {
      'data': data,
      'pagination': {
        'page': page,
        'limit': limit,
        'total': total,
        'pages': totalPages,
        'has_next': page < totalPages,
        'has_prev': page > 1,
      },
      'metadata': {
        'request_id': _uuid.v4(),
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'status': 'success',
      },
    };

    if (message != null) {
      responseData['message'] = message;
    }

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': responseData['metadata']['request_id'],
      ...?headers,
    };

    return Response(
      statusCode,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }

  /// 批量操作响应
  static Response batch({
    required int total,
    required int success,
    required int failed,
    required List<Map<String, dynamic>> results,
    String? message,
    int statusCode = 200,
    Map<String, String>? headers,
  }) {
    final responseData = {
      'data': {
        'total': total,
        'success': success,
        'failed': failed,
        'results': results,
      },
      'metadata': {
        'request_id': _uuid.v4(),
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'status': 'success',
      },
    };

    if (message != null) {
      responseData['message'] = message;
    }

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': responseData['metadata']['request_id'],
      ...?headers,
    };

    return Response(
      statusCode,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }

  /// 错误响应
  static Response error({
    required String code,
    required String message,
    String? details,
    int statusCode = 400,
    Map<String, String>? headers,
    String? userId,
    String? path,
    String? method,
  }) {
    final requestId = _uuid.v4();

    final errorResponse = {
      'error': {
        'code': code,
        'message': message,
        if (details != null) 'details': details,
        'metadata': {
          'request_id': requestId,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          if (path != null) 'path': path,
          if (method != null) 'method': method,
          if (userId != null) 'user_id': userId,
        },
      },
    };

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      statusCode,
      headers: responseHeaders,
      body: jsonEncode(errorResponse),
    );
  }

  /// 验证错误响应
  static Response validationError(
    List<FieldError> fieldErrors, {
    String? message,
    int statusCode = 422,
    Map<String, String>? headers,
    String? userId,
    String? path,
    String? method,
  }) {
    final requestId = _uuid.v4();

    final errorResponse = {
      'error': {
        'code': 'VALIDATION_FAILED',
        'message': message ?? '请求参数验证失败',
        'field_errors': fieldErrors.map((e) => e.toJson()).toList(),
        'metadata': {
          'request_id': requestId,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          if (path != null) 'path': path,
          if (method != null) 'method': method,
          if (userId != null) 'user_id': userId,
        },
      },
    };

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      statusCode,
      headers: responseHeaders,
      body: jsonEncode(errorResponse),
    );
  }

  /// 认证错误响应
  static Response authError({
    required String code,
    required String message,
    String? details,
    int statusCode = 401,
    Map<String, String>? headers,
  }) {
    final responseHeaders = <String, String>{
      'WWW-Authenticate': 'Bearer realm="TTPolyglot API"',
      ...?headers,
    };

    return error(
      code: code,
      message: message,
      details: details,
      statusCode: statusCode,
      headers: responseHeaders,
    );
  }

  /// 权限错误响应
  static Response permissionError({
    String? message,
    String? details,
    Map<String, String>? headers,
  }) {
    return error(
      code: 'AUTH_PERMISSION_DENIED',
      message: message ?? '权限不足',
      details: details,
      statusCode: 403,
      headers: headers,
    );
  }

  /// 资源未找到响应
  static Response notFound({
    String? message,
    String? details,
    Map<String, String>? headers,
  }) {
    return error(
      code: 'RESOURCE_NOT_FOUND',
      message: message ?? '请求的资源不存在',
      details: details,
      statusCode: 404,
      headers: headers,
    );
  }

  /// 服务器内部错误响应
  static Response internalError({
    String? message,
    String? details,
    Map<String, String>? headers,
  }) {
    return error(
      code: 'SYSTEM_INTERNAL_ERROR',
      message: message ?? '服务器内部错误',
      details: details,
      statusCode: 500,
      headers: headers,
    );
  }

  /// 请求频率限制响应
  static Response rateLimitError({
    required int retryAfter,
    required int limit,
    required int windowMinutes,
    Map<String, String>? headers,
  }) {
    final responseHeaders = <String, String>{
      'Retry-After': retryAfter.toString(),
      'X-RateLimit-Limit': limit.toString(),
      'X-RateLimit-Window': '${windowMinutes}m',
      ...?headers,
    };

    return error(
      code: 'SYSTEM_RATE_LIMIT_EXCEEDED',
      message: '请求频率过高',
      details: '您在${windowMinutes}分钟内的请求次数已达上限，请稍后重试',
      statusCode: 429,
      headers: responseHeaders,
    );
  }

  /// 维护模式响应
  static Response maintenanceError({
    String? message,
    String? details,
    Map<String, String>? headers,
  }) {
    return error(
      code: 'SYSTEM_MAINTENANCE_MODE',
      message: message ?? '系统维护中',
      details: details ?? '系统正在进行维护升级，请稍后访问',
      statusCode: 503,
      headers: headers,
    );
  }

  /// 无内容响应（用于DELETE操作）
  static Response noContent({
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();

    final responseHeaders = <String, String>{
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      204,
      headers: responseHeaders,
    );
  }

  /// 重定向响应
  static Response redirect({
    required String location,
    int statusCode = 302,
    Map<String, String>? headers,
  }) {
    final responseHeaders = <String, String>{
      'Location': location,
      ...?headers,
    };

    return Response(
      statusCode,
      headers: responseHeaders,
    );
  }

  /// 从请求中提取通用信息的辅助方法
  static Map<String, String?> extractRequestInfo(Request request) {
    return {
      'path': request.requestedUri.path,
      'method': request.method,
      'user_id': request.context['user_id'] as String?,
    };
  }

  /// 基于请求构建错误响应
  static Response errorFromRequest({
    required Request request,
    required String code,
    required String message,
    String? details,
    int statusCode = 400,
    Map<String, String>? headers,
  }) {
    final requestInfo = extractRequestInfo(request);

    return error(
      code: code,
      message: message,
      details: details,
      statusCode: statusCode,
      headers: headers,
      userId: requestInfo['user_id'],
      path: requestInfo['path'],
      method: requestInfo['method'],
    );
  }

  /// 基于请求构建验证错误响应
  static Response validationErrorFromRequest({
    required Request request,
    required List<FieldError> fieldErrors,
    String? message,
    int statusCode = 422,
    Map<String, String>? headers,
  }) {
    final requestInfo = extractRequestInfo(request);

    return validationError(
      fieldErrors,
      message: message,
      statusCode: statusCode,
      headers: headers,
      userId: requestInfo['user_id'],
      path: requestInfo['path'],
      method: requestInfo['method'],
    );
  }
}
