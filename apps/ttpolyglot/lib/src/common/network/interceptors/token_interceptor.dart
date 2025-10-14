import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:ttpolyglot/src/common/services/services.dart';

/// Token 自动注入拦截器
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // 获取 TokenStorageService
      if (Get.isRegistered<TokenStorageService>()) {
        final tokenStorage = Get.find<TokenStorageService>();
        final token = tokenStorage.getAccessToken();

        // 如果存在 token 且请求头中没有 authorization，则自动注入
        if (token != null &&
            token.isNotEmpty &&
            (options.headers['authorization'] == null || options.headers['authorization'].toString().isEmpty)) {
          options.headers['authorization'] = 'Bearer $token';
        }
      }

      handler.next(options);
    } catch (error, stackTrace) {
      log('Token 拦截器异常', error: error, stackTrace: stackTrace, name: 'TokenInterceptor');
      handler.next(options);
    }
  }
}
