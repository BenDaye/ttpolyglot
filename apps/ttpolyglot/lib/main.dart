import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot/src/features/settings/controllers/translation_config_controller.dart';
import 'package:ttpolyglot_utils/utils.dart';
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
  LoggerUtils.info('🌐 Web platform initialized');
}

/// 移动端初始化
Future<void> _initializeMobile() async {
  // 移动端特定初始化
  LoggerUtils.info('📱 Mobile platform initialized');
}

/// 初始化存储服务
Future<void> _initializeStorage() async {
  final storageProvider = StorageProvider();
  await storageProvider.initialize();
  LoggerUtils.info('💾 Storage service initialized for ${storageProvider.currentPlatform}');
}

/// 初始化服务
Future<void> _initializeService() async {
  // 配置日志
  Get.config(
    enableLog: false, // 关闭日志
    logWriterCallback: (text, {isError = false}) {
      // 自定义日志处理逻辑
      if (isError) {
        LoggerUtils.warning('Getx: $text');
      } else {
        LoggerUtils.debug('Getx: $text');
      }
    },
  );

  // 初始化 SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // 注册认证相关服务
  Get.put<TokenStorageService>(
    TokenStorageService(prefs),
    permanent: true,
  );
  Get.put<AuthApi>(
    AuthApi(),
    permanent: true,
  );
  Get.put<AuthService>(
    AuthService(
      authApi: Get.find<AuthApi>(),
      tokenStorage: Get.find<TokenStorageService>(),
    ),
    permanent: true,
  );

  // 注册用户设置 API
  Get.put<UserSettingsApi>(
    UserSettingsApi(),
    permanent: true,
  );

  // 注册用户 API
  Get.put<UserApi>(
    UserApi(),
    permanent: true,
  );

  // 注册项目 API
  Get.put<ProjectApi>(
    ProjectApi(),
    permanent: true,
  );

  // 注册语言 API
  Get.put<LanguageApi>(
    LanguageApi(),
    permanent: true,
  );

  // 注册通知设置 API
  Get.put<NotificationSettingsApi>(
    NotificationSettingsApi(),
    permanent: true,
  );

  // 初始化认证服务（检查登录状态）
  await Get.find<AuthService>().init();

  // 注册其他业务服务
  await Get.putAsync(() => ProjectServiceImpl.create());
  await Get.putAsync(() => TranslationServiceImpl.create());
  await Get.putAsync(() => ExportServiceImpl.create());
  Get.lazyPut(() => TranslationServiceManager(), fenix: true);
  Get.lazyPut(() => TranslationConfigController(), fenix: true);

  LoggerUtils.info('⚙️ Services initialized');
}
