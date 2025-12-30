/// 存储服务抽象基类
abstract class StorageService {
  /// 写入数据
  Future<void> write(String key, String data);

  /// 读取数据
  Future<String?> read(String key);

  /// 删除数据
  Future<void> delete(String key);

  /// 列出键
  Future<List<String>> listKeys(String prefix);

  /// 检查是否存在
  Future<bool> exists(String key);

  /// 清空数据
  Future<void> clear();

  /// 获取存储大小（字节）
  Future<int> getSize();

  /// 导出所有数据
  Future<Map<String, String>> exportData();

  /// 导入数据
  Future<void> importData(Map<String, String> data);
}
