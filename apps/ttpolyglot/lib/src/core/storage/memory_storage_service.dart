import 'dart:convert';

import 'storage_service.dart';

/// 内存存储服务实现（用于移动端或不支持持久化的平台）
class MemoryStorageService extends StorageService {
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
    int totalSize = 0;
    for (final entry in _storage.entries) {
      totalSize += utf8.encode(entry.key).length;
      totalSize += utf8.encode(entry.value).length;
    }
    return totalSize;
  }

  @override
  Future<Map<String, String>> exportData() async {
    return Map<String, String>.from(_storage);
  }

  @override
  Future<void> importData(Map<String, String> data) async {
    for (final entry in data.entries) {
      await write(entry.key, entry.value);
    }
  }
}
