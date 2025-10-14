import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:ttpolyglot_core/core.dart';

/// Loading 管理器（全局单例）
class LoadingManager {
  static final LoadingManager _instance = LoadingManager._internal();
  factory LoadingManager() => _instance;
  LoadingManager._internal();

  // Loading 引用计数
  int _loadingCount = 0;

  /// 显示 Loading
  void show() {
    Logger.info('显示 Loading，当前计数: $_loadingCount');

    if (_loadingCount == 0) {
      try {
        Get.dialog(
          PopScope(
            canPop: false, // 防止返回键关闭
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          barrierDismissible: false,
          name: 'loading_dialog',
        );
        Logger.info('Loading 对话框已显示');
      } catch (error, stackTrace) {
        Logger.error('显示 Loading 失败', error: error, stackTrace: stackTrace);
      }
    }
    _loadingCount++;
  }

  /// 隐藏 Loading
  void hide() {
    _loadingCount--;

    Logger.info('隐藏 Loading，当前计数: $_loadingCount');

    if (_loadingCount <= 0) {
      _loadingCount = 0; // 确保不会变成负数
      try {
        if (Get.isDialogOpen ?? false) {
          Get.back();
          Logger.info('Loading 对话框已关闭');
        }
      } catch (error, stackTrace) {
        Logger.error('隐藏 Loading 失败', error: error, stackTrace: stackTrace);
        // 强制重置计数
        _loadingCount = 0;
      }
    }
  }

  /// 强制关闭所有 Loading
  void forceHideAll() {
    Logger.info('强制关闭所有 Loading，当前计数: $_loadingCount');
    _loadingCount = 0;
    try {
      while (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Logger.info('所有 Loading 已强制关闭');
    } catch (error, stackTrace) {
      Logger.error('强制关闭 Loading 失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 重置计数器
  void reset() {
    _loadingCount = 0;
    Logger.info('Loading 计数器已重置');
  }

  /// 获取当前计数
  int get count => _loadingCount;
}
