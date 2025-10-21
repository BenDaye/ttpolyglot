import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/services/auth_service.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot_model/model.dart';

/// 个人信息控制器
class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // 用户信息
  final Rx<UserInfoModel?> userInfo = Rx<UserInfoModel?>(null);

  // 加载状态
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  /// 加载用户信息
  Future<void> _loadUserInfo() async {
    try {
      isLoading.value = true;

      // 从认证服务获取用户信息
      userInfo.value = _authService.currentUser;

      // 如果本地没有用户信息，则强制刷新
      if (userInfo.value == null) {
        await refreshUserInfo();
      }
    } catch (error, stackTrace) {
      log('_loadUserInfo', error: error, stackTrace: stackTrace, name: 'ProfileController');
      Get.snackbar(
        '错误',
        '加载用户信息失败',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 刷新用户信息
  Future<void> refreshUserInfo() async {
    try {
      isLoading.value = true;

      // 从服务器获取最新用户信息
      final user = await _authService.getCurrentUser(forceRefresh: true);
      userInfo.value = user;

      Get.snackbar(
        '成功',
        '用户信息已刷新',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    } catch (error, stackTrace) {
      log('refreshUserInfo', error: error, stackTrace: stackTrace, name: 'ProfileController');
      Get.snackbar(
        '错误',
        '刷新用户信息失败',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 退出登录
  Future<void> logout() async {
    try {
      // 确认退出
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('确认退出'),
          content: const Text('确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('确定'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      isLoading.value = true;

      // 在异步操作前保存主题颜色，避免 context 失效
      final theme = Theme.of(Get.context!);
      final primaryContainer = theme.colorScheme.primaryContainer;
      final onPrimaryContainer = theme.colorScheme.onPrimaryContainer;

      // 执行退出
      await _authService.logout();

      // 跳转到登录页面
      Get.offAllNamed(Routes.signIn);

      // 显示退出成功提示
      Get.snackbar(
        '提示',
        '已退出登录',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryContainer,
        colorText: onPrimaryContainer,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    } catch (error, stackTrace) {
      log('logout', error: error, stackTrace: stackTrace, name: 'ProfileController');
      Get.snackbar(
        '错误',
        '退出登录失败',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
