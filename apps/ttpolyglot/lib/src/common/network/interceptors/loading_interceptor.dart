import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:ttpolyglot/src/common/network/models/network_models.dart';

/// Loading 状态管理拦截器
class LoadingInterceptor extends Interceptor {
  // Loading 引用计数
  int _loadingCount = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final extra = RequestExtra.fromJson(options.extra);

      if (extra.showLoading) {
        _showLoading();
      }

      handler.next(options);
    } catch (error, stackTrace) {
      log('Loading 拦截器请求异常', error: error, stackTrace: stackTrace, name: 'LoadingInterceptor');
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final extra = RequestExtra.fromJson(response.requestOptions.extra);

      if (extra.showLoading) {
        _hideLoading();
      }

      // 显示成功提示
      if (extra.showSuccessToast) {
        final message = (response.data as Map<String, dynamic>?)?['message'] as String? ?? '操作成功';
        _showSuccessToast(message);
      }

      handler.next(response);
    } catch (error, stackTrace) {
      log('Loading 拦截器响应异常', error: error, stackTrace: stackTrace, name: 'LoadingInterceptor');
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      final extra = RequestExtra.fromJson(err.requestOptions.extra);

      if (extra.showLoading) {
        _hideLoading();
      }

      handler.next(err);
    } catch (error, stackTrace) {
      log('Loading 拦截器错误异常', error: error, stackTrace: stackTrace, name: 'LoadingInterceptor');
      handler.next(err);
    }
  }

  /// 显示 Loading
  void _showLoading() {
    if (_loadingCount == 0) {
      try {
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
          name: 'loading_dialog',
        );
      } catch (error, stackTrace) {
        log('显示 Loading 失败', error: error, stackTrace: stackTrace, name: 'LoadingInterceptor');
      }
    }
    _loadingCount++;
  }

  /// 隐藏 Loading
  void _hideLoading() {
    _loadingCount--;
    if (_loadingCount <= 0) {
      _loadingCount = 0;
      try {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      } catch (error, stackTrace) {
        log('隐藏 Loading 失败', error: error, stackTrace: stackTrace, name: 'LoadingInterceptor');
      }
    }
  }

  /// 显示成功提示
  void _showSuccessToast(String message) {
    try {
      Get.snackbar(
        '成功',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    } catch (error, stackTrace) {
      log('显示成功提示失败', error: error, stackTrace: stackTrace, name: 'LoadingInterceptor');
    }
  }
}
