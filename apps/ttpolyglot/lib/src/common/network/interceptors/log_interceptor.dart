import 'dart:developer';

import 'package:dio/dio.dart';

/// 日志拦截器
class LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '请求: ${options.method} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Data: ${options.data}',
      name: 'HttpClient',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '响应: ${response.statusCode} ${response.requestOptions.uri}\n'
      'Data: ${response.data}',
      name: 'HttpClient',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '错误: ${err.type} ${err.requestOptions.uri}\n'
      'Message: ${err.message}',
      error: err,
      stackTrace: err.stackTrace,
      name: 'HttpClient',
    );
    handler.next(err);
  }
}
