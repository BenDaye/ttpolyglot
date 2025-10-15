import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:uuid/uuid.dart';

/// API响应构建器
class ResponseBuilder {
  static const String _contentTypeJson = 'application/json; charset=utf-8';
  static const _uuid = Uuid();

  /// 根据 ApiResponseCode 获取 HTTP 状态码
  static int _getHttpStatusCode(ApiResponseCode code) {
    // 对于自定义业务错误码，统一返回 400
    if (code.value <= 0) {
      return 400;
    }

    return code.value;
  }

  /// 构建成功响应
  static Response success({
    String? message,
    dynamic data,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final apiResponse = ApiResponse<dynamic>(
      code: ApiResponseCode.success,
      message: message ?? ApiResponseCode.success.message,
      type: type,
      data: data,
    );

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      200,
      headers: responseHeaders,
      body: jsonEncode(apiResponse.toJson((data) => data)),
    );
  }

  /// 构建错误响应
  static Response error({
    ApiResponseCode? code,
    String? message,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
    Map<String, String>? headers,
  }) {
    code ??= ApiResponseCode.error;
    final requestId = _uuid.v4();
    final apiResponse = ApiResponse<dynamic>(
      code: code,
      message: message ?? code.message,
      type: type,
      data: null,
    );

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      _getHttpStatusCode(code),
      headers: responseHeaders,
      body: jsonEncode(apiResponse.toJson((data) => data)),
    );
  }

  /// 构建分页成功响应
  static Response paginated({
    required dynamic data,
    required int page,
    required int limit,
    required int total,
    String? message,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();

    // 构建包含分页信息的数据
    final paginatedData = {
      'items': data,
      'pagination': {
        'page': page,
        'limit': limit,
        'total': total,
        'pages': (total / limit).ceil(),
        'has_next': page * limit < total,
        'has_prev': page > 1,
      },
    };

    final apiResponse = ApiResponse<dynamic>(
      code: ApiResponseCode.success,
      message: message ?? ApiResponseCode.success.message,
      type: type,
      data: paginatedData,
    );

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      200,
      headers: responseHeaders,
      body: jsonEncode(apiResponse.toJson((data) => data)),
    );
  }
}
