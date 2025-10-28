import 'package:freezed_annotation/freezed_annotation.dart';

/// 灵活的 int 转换器
/// 支持 null、double、int、String 类型
final class FlexibleIntConverter implements JsonConverter<int, dynamic> {
  const FlexibleIntConverter();

  @override
  int fromJson(dynamic json) {
    if (json == null) return 0;
    if (json is double) return json.toInt();
    if (json is int) return json;
    if (json is String) return int.tryParse(json) ?? 0;
    return 0;
  }

  @override
  dynamic toJson(int object) => object;
}
