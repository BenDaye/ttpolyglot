import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';

/// 忘记密码控制器
class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // 表单控制器
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // 响应式状态
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _successMessage = ''.obs;
  final _autoValidate = false.obs;
  final _countdown = 0.obs; // 倒计时秒数

  // Getters
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get successMessage => _successMessage.value;
  AutovalidateMode get autoValidateMode => _autoValidate.value ? AutovalidateMode.always : AutovalidateMode.disabled;
  int get countdown => _countdown.value;
  bool get canResend => _countdown.value == 0 && !_isLoading.value;

  @override
  void onInit() {
    super.onInit();
    developer.log('ForgotPasswordController 初始化', name: 'ForgotPasswordController');
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// 表单验证 - 邮箱
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱';
    }
    // 简单的邮箱格式验证
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '邮箱格式不正确';
    }
    return null;
  }

  /// 发送重置密码邮件
  Future<void> sendResetEmail() async {
    if (_isLoading.value) {
      developer.log('发送重置邮件请求进行中，忽略重复提交', name: 'ForgotPasswordController');
      return;
    }

    // 清除之前的消息
    _errorMessage.value = '';
    _successMessage.value = '';

    // 验证表单
    if (formKey.currentState?.validate() != true) {
      // 启用自动验证
      _autoValidate.value = true;
      developer.log('表单验证失败', name: 'ForgotPasswordController');
      return;
    }

    try {
      _isLoading.value = true;

      // 调用认证服务
      final success = await _authService.forgotPassword(
        email: emailController.text.trim(),
      );

      if (success) {
        _successMessage.value = '重置密码邮件已发送到您的邮箱，请查收';

        // 开始倒计时（60秒）
        _startCountdown(60);

        // 显示成功提示
        Get.snackbar(
          '成功',
          '重置密码邮件已发送',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16.0),
          borderRadius: 8.0,
        );
      }
    } catch (error, stackTrace) {
      developer.log('发送重置邮件失败', error: error, stackTrace: stackTrace, name: 'ForgotPasswordController');

      // 提取错误信息
      String message = '发送失败，请稍后重试';
      if (error.toString().contains('网络')) {
        message = '网络连接失败，请检查网络设置';
      }

      _errorMessage.value = message;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 开始倒计时
  void _startCountdown(int seconds) {
    _countdown.value = seconds;

    Future.delayed(const Duration(seconds: 1), () {
      if (_countdown.value > 0) {
        _countdown.value--;
        _startCountdown(_countdown.value);
      }
    });
  }

  /// 返回登录
  void backToSignIn() {
    Get.back();
  }
}
