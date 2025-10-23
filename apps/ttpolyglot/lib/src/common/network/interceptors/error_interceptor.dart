import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/common.dart';

/// 错误统一处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Logger.talker.info('Response Error -> $err');
    // 如果已经处理过了
    if (err.error is ApiResponseModel) {
      return super.onError(err, handler);
    }
    // 构造返回错误体
    final result = switch (err.type) {
      DioExceptionType.connectionTimeout => ApiResponseModel.of(
          DataCodeEnum.connectionTimeout,
        ),
      DioExceptionType.sendTimeout => ApiResponseModel.of(DataCodeEnum.sendTimeout),
      DioExceptionType.receiveTimeout => ApiResponseModel.of(
          DataCodeEnum.receiveTimeout,
        ),
      DioExceptionType.badCertificate => ApiResponseModel.of(
          DataCodeEnum.badCertificate,
        ),
      DioExceptionType.badResponse => ApiResponseModel.of(
          DataCodeEnum.fromValue(err.response?.statusCode ?? 400),
        ),
      DioExceptionType.cancel => ApiResponseModel.of(DataCodeEnum.cancelRequest),
      DioExceptionType.connectionError => ApiResponseModel.of(
          DataCodeEnum.networkError,
        ),
      DioExceptionType.unknown => _unknown(err),
    };
    // 返回错误
    return handler.reject(err.copyWith(error: result, message: result.message));
  }

  // 处理未知异常
  ApiResponseModel _unknown(DioException err) {
    Object? error = err.error;
    if (error is HandshakeException) {
      return ApiResponseModel.of(DataCodeEnum.domainError);
    }
    return ApiResponseModel.of(DataCodeEnum.unknown);
  }
}
