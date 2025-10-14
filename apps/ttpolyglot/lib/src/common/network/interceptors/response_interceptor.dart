import 'dart:developer';

import 'package:dio/dio.dart';

/// 响应统一处理拦截器
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final data = response.data;

      // 只处理 JSON 数据
      if (data is Map<String, dynamic>) {
        // 检查业务状态码
        final code = data['code'] as int?;
        final message = data['message'] as String?;

        if (code != null) {
          // 成功响应
          if (code == 200) {
            // 直接传递原始数据，让上层自行解析
            handler.resolve(response);
            return;
          }

          // 业务错误，转换为 DioException
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              error: data,
              message: message ?? '请求失败',
              type: DioExceptionType.badResponse,
            ),
          );
          return;
        }
      }

      // 其他情况，直接返回
      handler.resolve(response);
    } catch (error, stackTrace) {
      log('响应拦截器异常', error: error, stackTrace: stackTrace, name: 'ResponseInterceptor');
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: error,
          message: '响应数据解析失败',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
