final class Utils {
  Utils._();

  static dynamic toJsonValue<T>(T data) {
    if (data == null) {
      return null;
    }

    // 如果是基本类型，直接返回
    if (data is String || data is num || data is bool) {
      return data;
    }

    // 处理 DateTime 类型
    if (data is DateTime) {
      return data.toUtc().toIso8601String();
    }

    // 如果是 Map，递归处理每个值
    if (data is Map) {
      return data.map((key, value) => MapEntry(key, toJsonValue(value)));
    }

    // 如果是 List，递归处理每个元素
    if (data is List) {
      return data.map((item) => toJsonValue(item)).toList();
    }

    // 如果对象有 toJson 方法，调用它
    try {
      final dynamic obj = data;
      // 尝试调用 toJson 方法
      return obj.toJson();
    } catch (error) {
      // 如果没有 toJson 方法或调用失败，直接返回原数据
      return data;
    }
  }
}
