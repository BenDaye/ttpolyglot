import 'package:ttpolyglot_core/core.dart';

/// Web存储的占位实现（非Web平台）
class WebStorageImpl {
  /// 初始化存储服务
  Future<void> initialize() async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 写入数据
  Future<void> write(String key, String data) async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 读取数据
  Future<String?> read(String key) async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 删除数据
  Future<void> delete(String key) async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 列出键
  Future<List<String>> listKeys(String prefix) async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 检查是否存在
  Future<bool> exists(String key) async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 清空数据
  Future<void> clear(String prefix) async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 获取大小
  Future<int> getSize(String prefix) async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 导出数据
  Future<Map<String, String>> exportData(String prefix) async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }

  /// 获取存储配额
  Future<StorageQuota> getStorageQuota() async {
    throw UnsupportedError('Web storage is not supported on this platform');
  }
}
