import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:uuid/uuid.dart';

import '../../config/server_config.dart';
import '../../middleware/error_handling/error_handler_middleware.dart';
import '../../services/services.dart';

/// API响应构建器
/// 提供统一的响应格式构建方法
class ResponseUtils {
  static const String _contentTypeJson = 'application/json; charset=utf-8';
  static const _uuid = Uuid();

  /// 根据 ApiResponseCode 获取 HTTP 状态码
  static int _getHttpStatusCode(ApiResponseCode code) {
    // 对于自定义业务错误码，统一返回 200
    if (code.value <= 0) {
      return 200;
    }

    return code.value;
  }

  /// 将数据转换为可 JSON 序列化的格式
  static dynamic _toJsonValue(dynamic data) {
    if (data == null) {
      return null;
    }

    // 如果是基本类型，直接返回
    if (data is String || data is num || data is bool) {
      return data;
    }

    // 如果是 Map，直接返回
    if (data is Map) {
      return data;
    }

    // 如果是 List，递归处理每个元素
    if (data is List) {
      return data.map((item) => _toJsonValue(item)).toList();
    }

    // 如果对象有 toJson 方法，调用它
    try {
      final dynamic obj = data;
      // 尝试调用 toJson 方法
      return obj.toJson();
    } catch (error) {
      // 如果没有 toJson 方法或调用失败，直接返回原数据
      return data;
    }
  }

  /// 构建成功响应
  static Response success<T>({
    String? message,
    T? data,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
    Map<String, String>? headers,
  }) {
    final requestId = _uuid.v4();
    final apiResponse = ApiResponse<T>(
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
      body: jsonEncode(apiResponse.toJson((data) => _toJsonValue(data))),
    );
  }

  /// 构建错误响应
  static Response error<T>({
    ApiResponseCode? code,
    T? data,
    String? message,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
    Map<String, String>? headers,
  }) {
    code ??= ApiResponseCode.error;
    final requestId = _uuid.v4();
    final apiResponse = ApiResponse<T>(
      code: code,
      message: message ?? code.message,
      type: type,
      data: data,
    );

    final responseHeaders = <String, String>{
      'Content-Type': _contentTypeJson,
      'X-Request-ID': requestId,
      ...?headers,
    };

    return Response(
      _getHttpStatusCode(code),
      headers: responseHeaders,
      body: jsonEncode(apiResponse.toJson((data) => _toJsonValue(data))),
    );
  }

  /// 构建分页成功响应
  static Response paginated<T>({
    required List<T> data,
    required int page,
    required int limit,
    required int total,
    String? message,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
    Map<String, String>? headers,
  }) {
    // 使用 ApiResponsePager 模型构建分页数据
    final paginatedData = ApiResponsePager<T>(
      page: page,
      pageSize: limit,
      totalSize: total,
      totalPage: (total / limit).ceil(),
      items: data,
    );

    return success(
      message: message,
      data: paginatedData,
      type: type,
      headers: headers,
    );
  }

  /// 从异常构建错误响应
  static Response fromException(
    ServerException exception, {
    Map<String, String>? headers,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
  }) {
    return error<Map<String, dynamic>>(
      code: exception.code,
      message: exception.message,
      data: exception.toMap(),
      type: type,
      headers: headers,
    );
  }

  /// 构建无内容响应（204）
  static Response noContent({
    Map<String, String>? headers,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
  }) {
    return error<Map<String, dynamic>>(
      code: ApiResponseCode.noContent,
      message: ApiResponseCode.noContent.message,
      data: {},
      type: type,
      headers: headers,
    );
  }

  /// 构建创建成功响应
  static Response created<T>({
    String? message,
    T? data,
    String? location,
    Map<String, String>? headers,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
  }) {
    return success(
      message: message ?? '创建成功',
      data: data,
      type: type,
      headers: headers,
    );
  }

  /// 构建接受响应
  static Response accepted<T>({
    String? message,
    T? data,
    Map<String, String>? headers,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
  }) {
    return success(
      message: message ?? '请求已接受',
      data: data,
      type: type,
      headers: headers,
    );
  }

  /// 版本信息响应
  static Response version({
    String? version,
    String? apiVersion,
    String? serverName,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
  }) {
    return success<Map<String, dynamic>>(
      message: ApiResponseCode.success.message,
      data: {
        'version': version ?? '1.0.0',
        'api_version': apiVersion ?? 'v1',
        'server': serverName ?? 'TTPolyglot Server',
        'environment': ServerConfig.isDevelopment ? 'development' : 'production',
        'timestamp': DateTime.now().toIso8601String(),
      },
      type: type,
    );
  }

  /// 状态信息响应
  static Future<Response> status({
    required DatabaseService databaseService,
    required RedisService redisService,
    required DateTime startTime,
    ApiResponseTipsType type = ApiResponseTipsType.showToast,
  }) async {
    try {
      final dbHealthy = await databaseService.isHealthy();
      final redisHealthy = await redisService.isHealthy();

      return success<Map<String, dynamic>>(
        message: ApiResponseCode.success.message,
        data: {
          'status': dbHealthy && redisHealthy ? 'healthy' : 'degraded',
          'services': {
            'database': dbHealthy ? 'healthy' : 'unhealthy',
            'redis': redisHealthy ? 'healthy' : 'unhealthy',
          },
          'timestamp': DateTime.now().toIso8601String(),
          'uptime': DateTime.now().difference(startTime).inSeconds,
        },
        type: type,
      );
    } catch (err) {
      return error<Map<String, dynamic>>(
        code: ApiResponseCode.internalServerError,
        message: '状态检查失败',
        data: {
          'error': err.toString(),
        },
      );
    }
  }
}
