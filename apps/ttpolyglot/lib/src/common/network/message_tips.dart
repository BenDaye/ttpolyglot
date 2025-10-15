import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

final class MessageTips {
  MessageTips._();

  static void showSuccessTips({
    required String message,
    required ApiResponseTipsType type,
    RequestExtra? extra,
  }) {
    if (extra?.showSuccessToast == false || message.isEmpty) return;
    switch (type) {
      case ApiResponseTipsType.showDialog:
        DialogManager.showSuccess(message);
        break;
      case ApiResponseTipsType.showToast:
        Toast.showSuccess(message);
        break;
      case ApiResponseTipsType.showSnackBar:
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
    required ApiResponseTipsType type,
    ApiResponseCode? status,
    RequestExtra? extra,
  }) {
    // // 鉴权失败处理
    // if (status == StatusCode.error) {
    //   return;
    // }
    // 其他错误
    if (extra?.showErrorToast == false || message.isEmpty) return;
    switch (type) {
      case ApiResponseTipsType.showDialog:
        DialogManager.showError(message);
        break;
      case ApiResponseTipsType.showToast:
        Toast.showError(message);
        break;
      case ApiResponseTipsType.showSnackBar:
        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
    }
  }
}
