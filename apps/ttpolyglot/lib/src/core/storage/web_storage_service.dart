import 'package:ttpolyglot_core/core.dart';

// 条件导入：只在 Web 平台上导入 dart:html
import 'web_storage_stub.dart' if (dart.library.html) 'web_storage_html.dart' as web_impl;

/// Web存储服务实现（基于LocalStorage）
class WebStorageServiceImpl extends WebStorageService {
  static const String _keyPrefix = 'ttpolyglot.';

  bool _initialized = false;
  late final web_impl.WebStorageImpl _impl;

  WebStorageServiceImpl() {
    _impl = web_impl.WebStorageImpl();
  }

  /// 初始化存储服务
  Future<void> initialize() async {
    if (_initialized) return;

    await _impl.initialize();
    _initialized = true;
  }

  @override
  Future<void> write(String key, String data) async {
    await _ensureInitialized();
    await _impl.write(_keyPrefix + key, data);
  }

  @override
  Future<String?> read(String key) async {
    await _ensureInitialized();
    return await _impl.read(_keyPrefix + key);
  }

  @override
  Future<void> delete(String key) async {
    await _ensureInitialized();
    await _impl.delete(_keyPrefix + key);
  }

  @override
  Future<List<String>> listKeys(String prefix) async {
    await _ensureInitialized();

    final keys = await _impl.listKeys(_keyPrefix + prefix);
    // 移除前缀，返回原始键
    return keys.map((key) => key.substring(_keyPrefix.length)).toList();
  }

  @override
  Future<bool> exists(String key) async {
    await _ensureInitialized();
    return await _impl.exists(_keyPrefix + key);
  }

  @override
  Future<void> clear() async {
    await _ensureInitialized();
    await _impl.clear(_keyPrefix);
  }

  @override
  Future<int> getSize() async {
    await _ensureInitialized();
    return await _impl.getSize(_keyPrefix);
  }

  @override
  Future<Map<String, String>> exportData() async {
    await _ensureInitialized();

    final data = await _impl.exportData(_keyPrefix);
    // 移除前缀
    final result = <String, String>{};
    for (final entry in data.entries) {
      if (entry.key.startsWith(_keyPrefix)) {
        final originalKey = entry.key.substring(_keyPrefix.length);
        result[originalKey] = entry.value;
      }
    }
    return result;
  }

  @override
  Future<void> importData(Map<String, String> data) async {
    await _ensureInitialized();

    for (final entry in data.entries) {
      await write(entry.key, entry.value);
    }
  }

  @override
  Future<void> useLocalStorage() async {
    // 默认就是使用LocalStorage
    await _ensureInitialized();
  }

  @override
  Future<void> useIndexedDB() async {
    throw UnimplementedError('IndexedDB storage not implemented yet');
  }

  @override
  Future<StorageQuota> getStorageQuota() async {
    await _ensureInitialized();
    return await _impl.getStorageQuota();
  }

  @override
  Future<bool> requestStoragePermission() async {
    // Web端LocalStorage不需要特殊权限
    return true;
  }

  /// 确保已初始化
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }
}
