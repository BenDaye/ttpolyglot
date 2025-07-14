import 'package:ttpolyglot_core/core.dart';

import '../platform/platform_adapter.dart';
import 'filesystem_storage_service.dart';
import 'web_storage_service.dart';

/// 存储提供者
class StorageProvider {
  static StorageProvider? _instance;
  StorageService? _storageService;
  late final PlatformAdapter _platformAdapter;
  bool _isInitialized = false;
  bool _isInitializing = false;

  StorageProvider._internal() {
    _platformAdapter = PlatformAdapter();
  }

  factory StorageProvider() {
    return _instance ??= StorageProvider._internal();
  }

  /// 初始化存储服务
  Future<void> initialize() async {
    if (_isInitialized) {
      return; // 已经初始化过了，直接返回
    }

    if (_isInitializing) {
      // 正在初始化，等待完成
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }

    _isInitializing = true;

    try {
      _storageService = _createStorageService();

      // 如果是具体的存储服务，进行初始化
      if (_storageService is FileSystemStorageServiceImpl) {
        await (_storageService as FileSystemStorageServiceImpl).initialize();
      } else if (_storageService is WebStorageServiceImpl) {
        await (_storageService as WebStorageServiceImpl).initialize();
      }

      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  /// 创建存储服务
  StorageService _createStorageService() {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
        return FileSystemStorageServiceImpl();
      case PlatformType.web:
        return WebStorageServiceImpl();
      case PlatformType.mobile:
        // 移动端暂时使用内存存储
        return MemoryStorageService();
      case PlatformType.unknown:
        return MemoryStorageService();
    }
  }

  /// 获取存储服务
  StorageService get storageService => _storageService!;

  /// 获取当前平台
  PlatformType get currentPlatform => _platformAdapter.currentPlatform;

  /// 获取平台名称
  String get platformName => _platformAdapter.platformName;

  /// 获取平台功能
  PlatformFeatures get platformFeatures => _platformAdapter.features;

  /// 是否支持文件系统
  bool get supportsFileSystem => _platformAdapter.features.supportsFileSystem;

  /// 是否支持文件监控
  bool get supportsFileWatcher => _platformAdapter.features.supportsFileWatcher;

  /// 是否支持系统托盘
  bool get supportsSystemTray => _platformAdapter.features.supportsSystemTray;

  /// 是否支持热键
  bool get supportsHotkeys => _platformAdapter.features.supportsHotkeys;
}
