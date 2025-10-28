import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

/// 用户位置信息模型（IP地理位置）
@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    /// 国家名称
    @JsonKey(name: 'country') @Default('') String country,

    /// 城市
    @JsonKey(name: 'city') @Default('') String city,

    /// 省份/地区
    @JsonKey(name: 'region') @Default('') String region,

    /// 国家代码
    @JsonKey(name: 'country_code') @Default('') String countryCode,

    /// 时区
    @JsonKey(name: 'timezone') @Default('') String timezone,

    /// ISP运营商
    @JsonKey(name: 'isp') @Default('') String isp,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
}

extension LocationModelExtension on LocationModel {
  /// 获取格式化的位置字符串（中国/北京）
  String get locationString => isValid ? '$country/$city' : '未知';

  /// 检查是否为有效的位置信息
  bool get isValid => country.isNotEmpty || city.isNotEmpty;

  /// 检查是否为空位置
  bool get isEmpty =>
      country.isEmpty && countryCode.isEmpty && region.isEmpty && city.isEmpty && timezone.isEmpty && isp.isEmpty;
}
