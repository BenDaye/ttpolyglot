import 'package:ttpolyglot_utils/utils.dart';

final class ModelUtils {
  ModelUtils._();

  /// 将对象转换为 JSON 值
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
      // 先尝试带参数的 toJson（泛型类型，如 PagerModel<T>）
      try {
        return obj.toJson((item) => toJsonValue(item));
      } catch (_) {
        // 如果带参数失败，尝试无参数的 toJson
        return obj.toJson();
      }
    } catch (error, stackTrace) {
      // 如果都失败，直接返回原数据
      LoggerUtils.error('toJsonValue error:', error: error, stackTrace: stackTrace);
      return data;
    }
  }

  /// 将任意类型转换为 T 泛型
  static T? toModel<T>(dynamic data, T Function(Map<String, dynamic>)? fromJson) {
    try {
      if (data == null) return null;
      if (data is T) return data;

      if (data is Map<String, dynamic> && fromJson != null) {
        return fromJson(data);
      }

      return data;
    } catch (error, stackTrace) {
      LoggerUtils.error('toModel error:', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 将任意数组类型转换为 T 泛型
  static List<T>? toModelArray<T>(dynamic data, T Function(Map<String, dynamic>)? fromJson) {
    try {
      if (data == null) return [];
      if (data is Iterable && fromJson != null) {
        return data.map((item) => toModel<T>(item, fromJson)).whereType<T>().toList();
      }
      return data;
    } catch (error, stackTrace) {
      LoggerUtils.error('toModelArray error:', error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
