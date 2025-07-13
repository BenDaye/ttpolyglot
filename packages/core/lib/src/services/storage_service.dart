/// 存储服务接口
abstract class StorageService {
  /// 写入数据
  Future<void> write(String key, String data);

  /// 读取数据
  Future<String?> read(String key);

  /// 删除数据
  Future<void> delete(String key);

  /// 列出指定前缀的所有键
  Future<List<String>> listKeys(String prefix);

  /// 检查键是否存在
  Future<bool> exists(String key);

  /// 清空所有数据
  Future<void> clear();

  /// 获取存储大小
  Future<int> getSize();

  /// 导出数据
  Future<Map<String, String>> exportData();

  /// 导入数据
  Future<void> importData(Map<String, String> data);
}

/// 存储键值规范
class StorageKeys {
  StorageKeys._();

  // 全局配置
  static const String workspaceConfig = 'workspace.config';
  static const String userPreferences = 'user.preferences';
  static const String projectList = 'projects.list';

  // 项目数据
  static String projectConfig(String projectId) => 'project.$projectId.config';
  static String projectDatabase(String projectId) => 'project.$projectId.database';
  static String projectCache(String projectId) => 'project.$projectId.cache';
  static String projectSettings(String projectId) => 'project.$projectId.settings';

  // 用户数据
  static String userSession(String userId) => 'user.$userId.session';
  static String userProjects(String userId) => 'user.$userId.projects';

  // 缓存数据
  static const String recentProjects = 'cache.recent_projects';
  static const String appState = 'cache.app_state';
}

/// 存储提供者工厂
class StorageProviderFactory {
  static StorageService createProvider(StorageType type) {
    switch (type) {
      case StorageType.filesystem:
        throw UnimplementedError('FileSystemStorageService needs concrete implementation');
      case StorageType.web:
        throw UnimplementedError('WebStorageService needs concrete implementation');
      case StorageType.mobile:
        throw UnimplementedError('MobileStorageService needs concrete implementation');
      case StorageType.memory:
        return MemoryStorageService();
    }
  }
}

/// 存储类型枚举
enum StorageType {
  /// 文件系统存储 (桌面端)
  filesystem,

  /// Web 存储 (LocalStorage/IndexedDB)
  web,

  /// 移动端存储 (应用沙盒)
  mobile,

  /// 内存存储 (测试用)
  memory,
}

/// 文件系统存储服务 (桌面端)
abstract class FileSystemStorageService implements StorageService {
  /// 获取存储根目录
  Future<String> getStorageRoot();

  /// 获取配置目录
  Future<String> getConfigDirectory();

  /// 获取项目目录
  Future<String> getProjectDirectory(String projectId);

  /// 确保目录存在
  Future<void> ensureDirectoryExists(String path);
}

/// Web 存储服务
abstract class WebStorageService implements StorageService {
  /// 使用 LocalStorage
  Future<void> useLocalStorage();

  /// 使用 IndexedDB
  Future<void> useIndexedDB();

  /// 获取存储配额
  Future<StorageQuota> getStorageQuota();

  /// 请求存储权限
  Future<bool> requestStoragePermission();
}

/// 移动端存储服务
abstract class MobileStorageService implements StorageService {
  /// 获取应用文档目录
  Future<String> getDocumentsDirectory();

  /// 获取应用缓存目录
  Future<String> getCacheDirectory();

  /// 获取临时目录
  Future<String> getTemporaryDirectory();
}

/// 内存存储服务 (测试用)
class MemoryStorageService implements StorageService {
  final Map<String, String> _storage = {};

  @override
  Future<void> write(String key, String data) async {
    _storage[key] = data;
  }

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<List<String>> listKeys(String prefix) async {
    return _storage.keys.where((key) => key.startsWith(prefix)).toList();
  }

  @override
  Future<bool> exists(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  Future<int> getSize() async {
    return _storage.values.fold<int>(0, (sum, value) => sum + value.length);
  }

  @override
  Future<Map<String, String>> exportData() async {
    return Map.from(_storage);
  }

  @override
  Future<void> importData(Map<String, String> data) async {
    _storage.clear();
    _storage.addAll(data);
  }
}

/// 存储配额信息
class StorageQuota {
  const StorageQuota({
    required this.total,
    required this.used,
    required this.available,
  });

  /// 总配额（字节）
  final int total;

  /// 已使用（字节）
  final int used;

  /// 可用空间（字节）
  final int available;

  /// 使用率（0.0-1.0）
  double get usageRatio => total > 0 ? used / total : 0.0;

  /// 格式化显示
  String get formattedUsage => '${_formatBytes(used)} / ${_formatBytes(total)}';

  /// 格式化字节数
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}

/// 存储异常
class StorageException implements Exception {
  const StorageException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'StorageException: $message';
}

/// 存储配置
class StorageConfig {
  const StorageConfig({
    this.maxSize = 100 * 1024 * 1024, // 100MB
    this.compressionEnabled = true,
    this.encryptionEnabled = false,
    this.backupEnabled = true,
    this.cacheEnabled = true,
  });

  final int maxSize;
  final bool compressionEnabled;
  final bool encryptionEnabled;
  final bool backupEnabled;
  final bool cacheEnabled;
}
