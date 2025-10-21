import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

/// 用户位置信息模型（IP地理位置）
@freezed
class LocationModel with _$LocationModel {
  const LocationModel._();

  const factory LocationModel({
    /// 国家名称
    @Default('') String country,

    /// 城市
    @Default('') String city,

    /// 省份/地区
    @Default('') String region,

    /// 国家代码
    @Default('') String countryCode,

    /// 时区
    @Default('') String timezone,

    /// ISP运营商
    @Default('') String isp,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);

  /// 获取格式化的位置字符串（中国/北京）
  String get locationString => isValid ? '$country/$city' : '未知';

  /// 检查是否为有效的位置信息
  bool get isValid => country.isNotEmpty || city.isNotEmpty;

  /// 检查是否为空位置
  bool get isEmpty =>
      country.isEmpty && countryCode.isEmpty && region.isEmpty && city.isEmpty && timezone.isEmpty && isp.isEmpty;
}
