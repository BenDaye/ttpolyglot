import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 注册控制器
class SignUpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // 表单控制器
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // 响应式状态
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _showPassword = false.obs;
  final _showConfirmPassword = false.obs;
  final _autoValidate = false.obs;
  final _passwordStrength = 0.obs; // 0-4: 很弱、弱、中、强、很强

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
    LoggerUtils.info('SignUpController 初始化');

    // 监听密码变化，计算密码强度
    passwordController.addListener(_onPasswordChanged);
  }

  @override
  void onClose() {
    passwordController.removeListener(_onPasswordChanged);
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// 密码变化监听
  void _onPasswordChanged() {
    _calculatePasswordStrength(passwordController.text);
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

  /// 表单验证 - 用户名
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入用户名';
    }
    if (value.length < 3) {
      return '用户名至少3个字符';
    }
    if (value.length > 50) {
      return '用户名最多50个字符';
    }
    // 只允许字母、数字和下划线
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return '用户名只能包含字母、数字和下划线';
    }
    return null;
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

  /// 表单验证 - 密码
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
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

  /// 注册
  Future<void> register() async {
    if (_isLoading.value) {
      LoggerUtils.error('注册请求进行中，忽略重复提交');
      return;
    }

    // 清除之前的错误
    _errorMessage.value = '';

    // 验证表单
    if (formKey.currentState?.validate() != true) {
      // 启用自动验证，让用户看到错误提示
      _autoValidate.value = true;
      LoggerUtils.error('表单验证失败');
      return;
    }

    try {
      _isLoading.value = true;

      // 调用认证服务注册
      await _authService.register(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        displayName: usernameController.text.trim(),
      );

      // 显示成功提示
      Get.snackbar(
        '成功',
        '注册成功！请登录',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );

      // 跳转到登录页面
      Get.offAllNamed(Routes.signIn);
    } catch (error) {
      // 提取错误信息
      String message = '注册失败，请稍后重试';
      if (error.toString().contains('用户名已存在')) {
        message = '用户名已存在';
      } else if (error.toString().contains('邮箱已被使用')) {
        message = '邮箱已被使用';
      } else if (error.toString().contains('密码强度不足')) {
        message = '密码强度不足';
      } else if (error.toString().contains('网络')) {
        message = '网络连接失败，请检查网络设置';
      }

      _errorMessage.value = message;
    } finally {
      // 确保 loading 状态一定会被重置
      _isLoading.value = false;
    }
  }

  /// 跳转到登录页
  void goToSignIn() {
    Get.offAllNamed(Routes.signIn);
  }

  /// 清空表单
  void clearForm() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _errorMessage.value = '';
    _autoValidate.value = false;
    _passwordStrength.value = 0;
  }
}
