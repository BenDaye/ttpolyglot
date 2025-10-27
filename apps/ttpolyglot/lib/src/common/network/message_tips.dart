import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot_core/core.dart';

final class MessageTips {
  MessageTips._();

  // 标记是否正在显示鉴权弹窗
  static bool _isShowingAuthDialog = false;

  static void showSuccessTips({
    required String message,
    required DataMessageTipsEnum type,
    ExtraModel? extra,
  }) {
    if (extra?.showSuccessToast == false || message.isEmpty) return;
    switch (type) {
      case DataMessageTipsEnum.showDialog:
        DialogManager.showSuccess(message);
        break;
      case DataMessageTipsEnum.showToast:
        Toast.showSuccess(message);
        break;
      case DataMessageTipsEnum.showSnackBar:
        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
        }
        break;
    }
  }

  static void showFailTips({
    required String message,
    required DataMessageTipsEnum type,
    int? statusCode,
    DataCodeEnum? status,
    ExtraModel? extra,
  }) {
    // 鉴权失败处理，并且路由不能等于登录页
    if (status == DataCodeEnum.unauthorized) {
      // 如果当前路由等于登录页，则不处理
      if ([Routes.signIn, Routes.signUp].contains(Get.currentRoute)) return;
      // 如果已经显示了鉴权弹窗，则不重复显示
      if (_isShowingAuthDialog) return;
      // 标记正在显示鉴权弹窗
      _isShowingAuthDialog = true;
      // 其他路由
      DialogManager.showError(
        message,
        onConfirm: () async {
          // 执行退出
          await Get.find<AuthService>().logout();
          // 跳转到登录页面
          Get.offAllNamed(Routes.signIn);
          // 重置标志
          _isShowingAuthDialog = false;
          return true;
        },
      );
      return;
    }
    // 其他错误
    if (extra?.showErrorToast == false || message.isEmpty) return;
    // 错误消息
    final msg = statusCode != null && statusCode >= 400 ? 'E-$statusCode: $message' : message;
    switch (type) {
      case DataMessageTipsEnum.showDialog:
        DialogManager.showError(msg);
        break;
      case DataMessageTipsEnum.showToast:
        Toast.showError(msg);
        break;
      case DataMessageTipsEnum.showSnackBar:
        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: Text(msg),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
    }
  }
}
