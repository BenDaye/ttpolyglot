import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

/// API响应构建器
class ResponseBuilder {
  static const String _contentTypeJson = 'application/json; charset=utf-8';
  static const _uuid = Uuid();

  /// 构建成功响应
  static Response success({
    required String message,
    dynamic data,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final responseData = <String, dynamic>{
      'success': true,
      'message': message,
      'data': data,
      'metadata': {
        'request_id': requestId,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'status': 'success',
      },
    };

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      200,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }

  /// 构建分页成功响应
  static Response paginated({
    required dynamic data,
    required int page,
    required int limit,
    required int total,
    String? message,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final responseData = <String, dynamic>{
      'success': true,
      'data': data,
      'pagination': {
        'page': page,
        'limit': limit,
        'total': total,
        'pages': (total / limit).ceil(),
        'has_next': page * limit < total,
        'has_prev': page > 1,
      },
      'metadata': {
        'request_id': requestId,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'status': 'success',
      },
    };

    if (message != null) {
      responseData['message'] = message;
    }

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      200,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }

  /// 构建错误响应
  static Response error({
    required String code,
    required String message,
    String? details,
    int statusCode = 400,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final responseData = <String, dynamic>{
      'error': {
        'code': code,
        'message': message,
        'details': details,
        'metadata': {
          'request_id': requestId,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'status': 'error',
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
      body: jsonEncode(responseData),
    );
  }

  /// 从请求上下文构建错误响应
  static Response errorFromRequest({
    required Request request,
    required String code,
    required String message,
    String? details,
    int statusCode = 400,
    Map<String, String>? headers,
  }) {
    final requestId = request.headers['x-request-id'] ?? _uuid.v4();
    final userId = request.context['userId'] as String?;

    final responseData = <String, dynamic>{
      'error': {
        'code': code,
        'message': message,
        'details': details,
        'metadata': {
          'request_id': requestId,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'path': request.requestedUri.path,
          'method': request.method,
          'status': 'error',
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
      body: jsonEncode(responseData),
    );
  }

  /// 构建验证错误响应
  static Response validationError({
    required String message,
    required List<FieldError> fieldErrors,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final responseData = <String, dynamic>{
      'error': {
        'code': 'VALIDATION_FAILED',
        'message': message,
        'field_errors': fieldErrors.map((e) => e.toJson()).toList(),
        'metadata': {
          'request_id': requestId,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'status': 'validation_error',
        },
      },
    };

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      422,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }

  /// 从请求上下文构建验证错误响应
  static Response validationErrorFromRequest({
    required Request request,
    required List<FieldError> fieldErrors,
    Map<String, String>? headers,
  }) {
    final requestId = request.headers['x-request-id'] ?? _uuid.v4();
    final userId = request.context['userId'] as String?;

    final responseData = <String, dynamic>{
      'error': {
        'code': 'VALIDATION_FAILED',
        'message': '请求参数验证失败',
        'field_errors': fieldErrors.map((e) => e.toJson()).toList(),
        'metadata': {
          'request_id': requestId,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'path': request.requestedUri.path,
          'method': request.method,
          'status': 'validation_error',
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
      422,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }

  /// 构建未找到响应
  static Response notFound({
    String message = '请求的资源不存在',
    Map<String, String>? headers,
  }) {
    return error(
      code: 'RESOURCE_NOT_FOUND',
      message: message,
      statusCode: 404,
      headers: headers,
    );
  }

  /// 构建未授权响应
  static Response authError({
    required String code,
    required String message,
    Map<String, String>? headers,
  }) {
    return error(
      code: code,
      message: message,
      statusCode: 401,
      headers: headers,
    );
  }

  /// 构建无内容响应
  static Response noContent({Map<String, String>? headers}) {
    return Response(
      204,
      headers: headers,
    );
  }

  /// 构建创建成功响应
  static Response created({
    required String message,
    dynamic data,
    String? location,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final responseData = <String, dynamic>{
      'success': true,
      'message': message,
      'data': data,
      'metadata': {
        'request_id': requestId,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'status': 'created',
      },
    };

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      if (location != null) 'Location': location,
      ...?headers,
    };

    return Response(
      201,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }

  /// 构建服务不可用响应
  static Response serviceUnavailable({
    String message = '服务暂时不可用，请稍后重试',
    Map<String, String>? headers,
  }) {
    return error(
      code: 'SYSTEM_SERVICE_UNAVAILABLE',
      message: message,
      statusCode: 503,
      headers: headers,
    );
  }

  /// 构建内部服务器错误响应
  static Response internalServerError({
    String message = '服务器内部错误',
    String? details,
    Map<String, String>? headers,
  }) {
    return error(
      code: 'SYSTEM_INTERNAL_ERROR',
      message: message,
      details: details,
      statusCode: 500,
      headers: headers,
    );
  }

  /// 构建批量操作响应
  static Response batch({
    required String message,
    required List<Map<String, dynamic>> results,
    required int total,
    required int success,
    required int failed,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final responseData = <String, dynamic>{
      'success': true,
      'message': message,
      'data': {
        'total': total,
        'success': success,
        'failed': failed,
        'results': results,
      },
      'metadata': {
        'request_id': requestId,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'status': 'batch_completed',
      },
    };

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      200,
      headers: responseHeaders,
      body: jsonEncode(responseData),
    );
  }
}
