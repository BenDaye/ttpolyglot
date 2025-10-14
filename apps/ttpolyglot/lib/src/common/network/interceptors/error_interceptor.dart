import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:ttpolyglot/src/common/network/models/network_models.dart';
import 'package:ttpolyglot_core/core.dart';

/// 错误统一处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      // 获取请求配置
      final extra = RequestExtra.fromJson(err.requestOptions.extra);

      String errorMessage = '未知错误';

      // 根据错误类型提取错误信息
      if (err.type == DioExceptionType.badResponse) {
        // 服务器返回错误
        final data = err.response?.data;
        if (data is Map<String, dynamic>) {
          errorMessage = data['message'] as String? ?? '服务器错误';
        }
      } else if (err.type == DioExceptionType.connectionTimeout) {
        errorMessage = '连接超时';
      } else if (err.type == DioExceptionType.sendTimeout) {
        errorMessage = '发送超时';
      } else if (err.type == DioExceptionType.receiveTimeout) {
        errorMessage = '接收超时';
      } else if (err.type == DioExceptionType.cancel) {
        errorMessage = '请求已取消';
      } else if (err.type == DioExceptionType.connectionError) {
        errorMessage = '网络连接失败';
      } else {
        errorMessage = err.message ?? '请求失败';
      }

      // 显示错误提示
      if (extra.showErrorToast) {
        _showErrorToast(errorMessage);
      }

      handler.next(err);
    } catch (error, stackTrace) {
      Logger.error('错误拦截器异常', error: error, stackTrace: stackTrace);
      handler.next(err);
    }
  }

  /// 显示错误提示
  void _showErrorToast(String message) {
    try {
      Get.snackbar(
        '错误',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    } catch (error, stackTrace) {
      Logger.error('显示错误提示失败', error: error, stackTrace: stackTrace);
    }
  }
}
