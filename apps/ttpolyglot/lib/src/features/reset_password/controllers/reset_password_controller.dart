import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';

/// 重置密码控制器
class ResetPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // 表单控制器
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // 重置令牌（从路由参数获取）
  late final String token;

  // 响应式状态
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _showPassword = false.obs;
  final _showConfirmPassword = false.obs;
  final _autoValidate = false.obs;
  final _passwordStrength = 0.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get showPassword => _showPassword.value;
  bool get showConfirmPassword => _showConfirmPassword.value;
  AutovalidateMode get autoValidateMode => _autoValidate.value ? AutovalidateMode.always : AutovalidateMode.disabled;
  int get passwordStrength => _passwordStrength.value;

  @override
  void onInit() {
    super.onInit();

    // 从路由参数获取token
    token = Get.parameters['token'] ?? '';

    if (token.isEmpty) {
      developer.log('重置令牌为空', name: 'ResetPasswordController');
      _errorMessage.value = '重置链接无效，请重新申请';
    }

    developer.log('ResetPasswordController 初始化, token: $token', name: 'ResetPasswordController');

    // 监听密码变化，计算密码强度
    passwordController.addListener(() {
      _calculatePasswordStrength(passwordController.text);
    });
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// 切换密码显示/隐藏
  void togglePasswordVisibility() {
    _showPassword.value = !_showPassword.value;
  }

  /// 切换确认密码显示/隐藏
  void toggleConfirmPasswordVisibility() {
    _showConfirmPassword.value = !_showConfirmPassword.value;
  }

  /// 计算密码强度
  void _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      _passwordStrength.value = 0;
      return;
    }

    int strength = 0;

    // 长度
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // 包含数字
    if (RegExp(r'\d').hasMatch(password)) strength++;

    // 包含小写字母
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;

    // 包含大写字母
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;

    // 包含特殊字符
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    // 映射到 0-4 范围
    _passwordStrength.value = (strength / 1.5).ceil().clamp(0, 4);
  }

  /// 表单验证 - 密码
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入新密码';
    }
    if (value.length < 8) {
      return '密码至少8位';
    }
    // 至少包含一个字母和一个数字
    if (!RegExp(r'[a-zA-Z]').hasMatch(value) || !RegExp(r'\d').hasMatch(value)) {
      return '密码必须包含字母和数字';
    }
    return null;
  }

  /// 表单验证 - 确认密码
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请再次输入密码';
    }
    if (value != passwordController.text) {
      return '两次输入的密码不一致';
    }
    return null;
  }

  /// 重置密码
  Future<void> resetPassword() async {
    if (_isLoading.value) {
      developer.log('重置密码请求进行中，忽略重复提交', name: 'ResetPasswordController');
      return;
    }

    // 检查token
    if (token.isEmpty) {
      _errorMessage.value = '重置链接无效';
      return;
    }

    // 清除之前的错误
    _errorMessage.value = '';

    // 验证表单
    if (formKey.currentState?.validate() != true) {
      // 启用自动验证
      _autoValidate.value = true;
      developer.log('表单验证失败', name: 'ResetPasswordController');
      return;
    }

    try {
      _isLoading.value = true;

      // 调用认证服务
      final success = await _authService.resetPassword(
        token: token,
        newPassword: passwordController.text,
      );

      if (success) {
        // 显示成功提示
        Get.snackbar(
          '成功',
          '密码重置成功，请使用新密码登录',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16.0),
          borderRadius: 8.0,
        );

        // 延迟跳转到登录页面
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(Routes.signIn);
      }
    } catch (error, stackTrace) {
      developer.log('重置密码失败', error: error, stackTrace: stackTrace, name: 'ResetPasswordController');

      // 提取错误信息
      String message = '重置失败，请稍后重试';
      if (error.toString().contains('无效的重置令牌')) {
        message = '重置链接已失效，请重新申请';
      } else if (error.toString().contains('密码强度不足')) {
        message = '密码强度不足';
      } else if (error.toString().contains('网络')) {
        message = '网络连接失败，请检查网络设置';
      }

      _errorMessage.value = message;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 返回登录
  void goToSignIn() {
    Get.offAllNamed(Routes.signIn);
  }
}
