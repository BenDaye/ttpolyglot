import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:ttpolyglot_core/core.dart';

/// Web存储的HTML实现（Web平台）
class WebStorageImpl {
  /// 初始化存储服务
  Future<void> initialize() async {
    // Web端初始化（检查LocalStorage可用性）
    try {
      html.window.localStorage['test'] = 'test';
      html.window.localStorage.remove('test');
    } catch (error, stackTrace) {
      Logger.error('initialize', error: error, stackTrace: stackTrace);
      throw Exception('LocalStorage is not available: $error');
    }
  }

  /// 写入数据
  Future<void> write(String key, String data) async {
    html.window.localStorage[key] = data;
  }

  /// 读取数据
  Future<String?> read(String key) async {
    return html.window.localStorage[key];
  }

  /// 删除数据
  Future<void> delete(String key) async {
    html.window.localStorage.remove(key);
  }

  /// 列出键
  Future<List<String>> listKeys(String prefix) async {
    final keys = <String>[];

    for (int i = 0; i < html.window.localStorage.length; i++) {
      final key = html.window.localStorage.keys.elementAt(i);
      if (key.startsWith(prefix)) {
        keys.add(key);
      }
    }

    return keys;
  }

  /// 检查是否存在
  Future<bool> exists(String key) async {
    return html.window.localStorage.containsKey(key);
  }

  /// 清空数据
  Future<void> clear(String prefix) async {
    final keysToRemove = <String>[];

    for (int i = 0; i < html.window.localStorage.length; i++) {
      final key = html.window.localStorage.keys.elementAt(i);
      if (key.startsWith(prefix)) {
        keysToRemove.add(key);
      }
    }

    for (final key in keysToRemove) {
      html.window.localStorage.remove(key);
    }
  }

  /// 获取大小
  Future<int> getSize(String prefix) async {
    int totalSize = 0;

    for (int i = 0; i < html.window.localStorage.length; i++) {
      final key = html.window.localStorage.keys.elementAt(i);
      if (key.startsWith(prefix)) {
        final value = html.window.localStorage[key] ?? '';
        totalSize += utf8.encode(key).length + utf8.encode(value).length;
      }
    }

    return totalSize;
  }

  /// 导出数据
  Future<Map<String, String>> exportData(String prefix) async {
    final data = <String, String>{};

    for (int i = 0; i < html.window.localStorage.length; i++) {
      final key = html.window.localStorage.keys.elementAt(i);
      if (key.startsWith(prefix)) {
        final value = html.window.localStorage[key] ?? '';
        data[key] = value;
      }
    }

    return data;
  }

  /// 获取存储配额
  Future<StorageQuota> getStorageQuota() async {
    // 估算LocalStorage配额（通常是5-10MB）
    int used = 0;
    for (int i = 0; i < html.window.localStorage.length; i++) {
      final key = html.window.localStorage.keys.elementAt(i);
      final value = html.window.localStorage[key] ?? '';
      used += utf8.encode(key).length + utf8.encode(value).length;
    }

    return StorageQuota(
      total: 5 * 1024 * 1024, // 5MB 估算
      used: used,
      available: (5 * 1024 * 1024) - used,
    );
  }
}
