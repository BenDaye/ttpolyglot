import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/common.dart';

/// 错误统一处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Logger.talker.info('Response Error -> $err');
    // 如果已经处理过了
    if (err.error is ApiResponse) {
      return super.onError(err, handler);
    }
    // 构造返回错误体
    final result = switch (err.type) {
      DioExceptionType.connectionTimeout => ApiResponse.of(
          ApiResponseCode.connectionTimeout,
        ),
      DioExceptionType.sendTimeout => ApiResponse.of(ApiResponseCode.sendTimeout),
      DioExceptionType.receiveTimeout => ApiResponse.of(
          ApiResponseCode.receiveTimeout,
        ),
      DioExceptionType.badCertificate => ApiResponse.of(
          ApiResponseCode.badCertificate,
        ),
      DioExceptionType.badResponse => ApiResponse.of(
          ApiResponseCode.fromValue(err.response?.statusCode ?? 400),
        ),
      DioExceptionType.cancel => ApiResponse.of(ApiResponseCode.cancelRequest),
      DioExceptionType.connectionError => ApiResponse.of(
          ApiResponseCode.networkError,
        ),
      DioExceptionType.unknown => _unknown(err),
    };
    // 返回错误
    return handler.reject(err.copyWith(error: result, message: result.message));
  }

  // 处理未知异常
  ApiResponse _unknown(DioException err) {
    Object? error = err.error;
    if (error is HandshakeException) {
      return ApiResponse.of(ApiResponseCode.domainError);
    }
    return ApiResponse.of(ApiResponseCode.unknown);
  }
}
