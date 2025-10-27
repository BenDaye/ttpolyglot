import 'package:freezed_annotation/freezed_annotation.dart';

/// 灵活的 double 转换器
/// 支持 null、double、int、String 类型
final class FlexibleDoubleConverter implements JsonConverter<double, dynamic> {
  const FlexibleDoubleConverter();

  @override
  double fromJson(dynamic json) {
    if (json == null) return 0.0;
    if (json is double) return json;
    if (json is int) return json.toDouble();
    if (json is String) return double.tryParse(json) ?? 0.0;
    return 0.0;
  }

  @override
  dynamic toJson(double object) => object;
}
