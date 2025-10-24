import 'package:freezed_annotation/freezed_annotation.dart';

/// TIMESTAMPTZ（带时区时间戳）的 JSON 转换器
///
/// PostgreSQL 的 TIMESTAMPTZ 类型会存储为 UTC 时间
/// 该转换器用于处理：
/// 1. 从 JSON 字符串解析为 DateTime（UTC）
/// 2. 从数据库 DateTime 对象直接使用
/// 3. 序列化为 ISO8601 格式的 UTC 字符串
class TimesConverter implements JsonConverter<DateTime, Object> {
  const TimesConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is DateTime) {
      // 数据库直接返回的 DateTime 对象
      return json.toUtc();
    } else if (json is String) {
      // 从 JSON/Redis 缓存读取的字符串
      return DateTime.parse(json).toUtc();
    } else {
      throw ArgumentError('Cannot convert $json to DateTime');
    }
  }

  @override
  String toJson(DateTime object) {
    // 序列化为 ISO8601 格式的 UTC 字符串
    return object.toUtc().toIso8601String();
  }
}

/// 可空 TIMESTAMPTZ 的 JSON 转换器
class NullableTimesConverter implements JsonConverter<DateTime?, Object?> {
  const NullableTimesConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) {
      return null;
    }

    if (json is DateTime) {
      return json.toUtc();
    } else if (json is String) {
      return DateTime.parse(json).toUtc();
    } else {
      throw ArgumentError('Cannot convert $json to DateTime?');
    }
  }

  @override
  String? toJson(DateTime? object) {
    return object?.toUtc().toIso8601String();
  }
}
