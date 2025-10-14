import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:ttpolyglot/src/common/network/loading_manager.dart';
import 'package:ttpolyglot/src/common/network/models/network_models.dart';
import 'package:ttpolyglot_core/core.dart';

/// Loading 状态管理拦截器
class LoadingInterceptor extends Interceptor {
  // 使用全局单例管理 Loading
  final LoadingManager _loadingManager = LoadingManager();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final extra = RequestExtra.fromJson(options.extra);

      if (extra.showLoading) {
        _loadingManager.show();
      }

      handler.next(options);
    } catch (error, stackTrace) {
      Logger.error('Loading 拦截器请求异常', error: error, stackTrace: stackTrace);
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    RequestExtra? extra;
    bool shouldHideLoading = false;

    try {
      extra = RequestExtra.fromJson(response.requestOptions.extra);
      shouldHideLoading = extra.showLoading;

      // 显示成功提示
      if (extra.showSuccessToast) {
        final message = (response.data as Map<String, dynamic>?)?['message'] as String? ?? '操作成功';
        _showSuccessToast(message);
      }
    } catch (error, stackTrace) {
      Logger.error('Loading 拦截器响应异常', error: error, stackTrace: stackTrace);
    } finally {
      // 确保在 finally 中关闭 loading
      if (shouldHideLoading) {
        _loadingManager.hide();
      }
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    bool shouldHideLoading = false;

    try {
      final extra = RequestExtra.fromJson(err.requestOptions.extra);
      shouldHideLoading = extra.showLoading;
    } catch (error, stackTrace) {
      Logger.error('Loading 拦截器错误异常', error: error, stackTrace: stackTrace);
    } finally {
      // 确保在 finally 中关闭 loading
      if (shouldHideLoading) {
        _loadingManager.hide();
      }
      handler.next(err);
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
      Logger.error('显示成功提示失败', error: error, stackTrace: stackTrace);
    }
  }
}
