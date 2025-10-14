import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';

/// 登录控制器
class SignInController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // 表单控制器
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // 响应式状态
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _showPassword = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get showPassword => _showPassword.value;

  @override
  void onInit() {
    super.onInit();
    log('SignInController 初始化', name: 'SignInController');
  }

  /// 切换密码显示/隐藏
  void togglePasswordVisibility() {
    _showPassword.value = !_showPassword.value;
  }

  /// 表单验证 - 用户名/邮箱
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入用户名或邮箱';
    }
    if (value.length < 3) {
      return '用户名至少3个字符';
    }
    return null;
  }

  /// 表单验证 - 密码
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码至少6位';
    }
    return null;
  }

  /// 登录
  Future<void> login() async {
    // 清除之前的错误
    _errorMessage.value = '';

    // 验证表单
    if (formKey.currentState?.validate() != true) {
      return;
    }

    try {
      _isLoading.value = true;

      // 调用认证服务登录
      await _authService.login(
        emailOrUsername: emailController.text.trim(),
        password: passwordController.text,
        deviceName: 'Web Browser',
        deviceType: 'web',
      );

      // 登录成功
      log('登录成功，准备跳转', name: 'SignInController');

      // 显示成功提示
      Get.snackbar(
        '成功',
        '登录成功',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );

      // 跳转到主页（使用 offAllNamed 清除登录页面）
      Get.offAllNamed('/projects');
    } catch (error, stackTrace) {
      log('登录失败', error: error, stackTrace: stackTrace, name: 'SignInController');

      // 提取错误信息
      String message = '登录失败，请稍后重试';
      if (error.toString().contains('用户名或密码错误')) {
        message = '用户名或密码错误';
      } else if (error.toString().contains('账户已被禁用')) {
        message = '账户已被禁用，请联系管理员';
      } else if (error.toString().contains('账户已被锁定')) {
        message = '账户已被锁定，请稍后重试';
      } else if (error.toString().contains('网络')) {
        message = '网络连接失败，请检查网络设置';
      }

      _errorMessage.value = message;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 清空表单
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    _errorMessage.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
    log('SignInController 销毁', name: 'SignInController');
  }
}
