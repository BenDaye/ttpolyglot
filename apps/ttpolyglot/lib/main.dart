import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

import 'src/app.dart';
import 'src/core/storage/storage_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 平台特定初始化
  await _initializePlatform();

  // 初始化存储服务
  await _initializeStorage();

  // 初始化服务
  await _initializeService();

  runApp(const TTPolyglotApp());
}

/// 平台特定初始化
Future<void> _initializePlatform() async {
  if (UniversalPlatform.isDesktop) {
    await _initializeDesktop();
  } else if (UniversalPlatform.isWeb) {
    await _initializeWeb();
  } else if (UniversalPlatform.isMobile) {
    await _initializeMobile();
  }
}

/// 桌面端初始化
Future<void> _initializeDesktop() async {
  // 初始化窗口管理器
  await windowManager.ensureInitialized();

  // 设置窗口选项
  final windowOptions = WindowOptions(
    size: const ui.Size(1680, 800),
    minimumSize: const ui.Size(1280, 640),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'TTPolyglot',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

/// Web端初始化
Future<void> _initializeWeb() async {
  // Web端特定初始化
  log('🌐 Web platform initialized');
}

/// 移动端初始化
Future<void> _initializeMobile() async {
  // 移动端特定初始化
  log('📱 Mobile platform initialized');
}

/// 初始化存储服务
Future<void> _initializeStorage() async {
  final storageProvider = StorageProvider();
  await storageProvider.initialize();
  log('💾 Storage service initialized for ${storageProvider.currentPlatform}');
}

/// 初始化服务
Future<void> _initializeService() async {
  await Get.putAsync(() => ProjectServiceImpl.create());
  await Get.putAsync(() => TranslationServiceImpl.create());
  await Get.putAsync(() => ExportServiceImpl.create());
  Get.put(TranslationServiceManager());
  log('⚙️ Services initialized');
}
