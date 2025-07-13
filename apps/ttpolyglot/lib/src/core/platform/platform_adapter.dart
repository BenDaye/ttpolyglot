import 'package:universal_platform/universal_platform.dart';

/// 平台适配器
class PlatformAdapter {
  static const PlatformAdapter _instance = PlatformAdapter._internal();

  const PlatformAdapter._internal();

  factory PlatformAdapter() => _instance;

  /// 当前平台类型
  PlatformType get currentPlatform {
    if (UniversalPlatform.isDesktop) {
      return PlatformType.desktop;
    } else if (UniversalPlatform.isWeb) {
      return PlatformType.web;
    } else if (UniversalPlatform.isMobile) {
      return PlatformType.mobile;
    } else {
      return PlatformType.unknown;
    }
  }

  /// 是否为桌面平台
  bool get isDesktop => UniversalPlatform.isDesktop;

  /// 是否为Web平台
  bool get isWeb => UniversalPlatform.isWeb;

  /// 是否为移动平台
  bool get isMobile => UniversalPlatform.isMobile;

  /// 是否为macOS
  bool get isMacOS => UniversalPlatform.isMacOS;

  /// 是否为Windows
  bool get isWindows => UniversalPlatform.isWindows;

  /// 是否为Linux
  bool get isLinux => UniversalPlatform.isLinux;

  /// 是否为iOS
  bool get isIOS => UniversalPlatform.isIOS;

  /// 是否为Android
  bool get isAndroid => UniversalPlatform.isAndroid;

  /// 获取平台特定功能
  PlatformFeatures get features {
    switch (currentPlatform) {
      case PlatformType.desktop:
        return const PlatformFeatures(
          supportsFileSystem: true,
          supportsSystemTray: true,
          supportsHotkeys: true,
          supportsFileWatcher: true,
          supportsWindowManagement: true,
          supportsMultiWindow: true,
          supportsMenuBar: true,
          supportsNotifications: true,
          supportsClipboard: true,
          supportsAutoStart: true,
        );
      case PlatformType.web:
        return const PlatformFeatures(
          supportsFileSystem: false,
          supportsSystemTray: false,
          supportsHotkeys: false,
          supportsFileWatcher: false,
          supportsWindowManagement: false,
          supportsMultiWindow: false,
          supportsMenuBar: false,
          supportsNotifications: true,
          supportsClipboard: true,
          supportsAutoStart: false,
        );
      case PlatformType.mobile:
        return const PlatformFeatures(
          supportsFileSystem: true,
          supportsSystemTray: false,
          supportsHotkeys: false,
          supportsFileWatcher: false,
          supportsWindowManagement: false,
          supportsMultiWindow: false,
          supportsMenuBar: false,
          supportsNotifications: true,
          supportsClipboard: true,
          supportsAutoStart: false,
        );
      case PlatformType.unknown:
        return const PlatformFeatures();
    }
  }

  /// 获取平台名称
  String get platformName {
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    if (isIOS) return 'iOS';
    if (isAndroid) return 'Android';
    if (isWeb) return 'Web';
    return 'Unknown';
  }

  /// 获取建议的窗口大小
  Size get suggestedWindowSize {
    if (isDesktop) {
      return const Size(1200, 800);
    } else if (isWeb) {
      return const Size(1024, 768);
    } else {
      return const Size(375, 667); // iPhone 6/7/8 size
    }
  }

  /// 获取最小窗口大小
  Size get minimumWindowSize {
    if (isDesktop) {
      return const Size(800, 600);
    } else if (isWeb) {
      return const Size(768, 576);
    } else {
      return const Size(320, 480);
    }
  }
}

/// 平台类型枚举
enum PlatformType {
  desktop,
  web,
  mobile,
  unknown,
}

/// 平台功能特性
class PlatformFeatures {
  const PlatformFeatures({
    this.supportsFileSystem = false,
    this.supportsSystemTray = false,
    this.supportsHotkeys = false,
    this.supportsFileWatcher = false,
    this.supportsWindowManagement = false,
    this.supportsMultiWindow = false,
    this.supportsMenuBar = false,
    this.supportsNotifications = false,
    this.supportsClipboard = false,
    this.supportsAutoStart = false,
  });

  /// 支持文件系统访问
  final bool supportsFileSystem;

  /// 支持系统托盘
  final bool supportsSystemTray;

  /// 支持全局热键
  final bool supportsHotkeys;

  /// 支持文件监控
  final bool supportsFileWatcher;

  /// 支持窗口管理
  final bool supportsWindowManagement;

  /// 支持多窗口
  final bool supportsMultiWindow;

  /// 支持菜单栏
  final bool supportsMenuBar;

  /// 支持通知
  final bool supportsNotifications;

  /// 支持剪贴板
  final bool supportsClipboard;

  /// 支持开机自启
  final bool supportsAutoStart;
}

/// 尺寸类
class Size {
  const Size(this.width, this.height);

  final double width;
  final double height;

  @override
  String toString() => 'Size($width, $height)';
}
