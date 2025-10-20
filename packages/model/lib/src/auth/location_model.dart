import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

/// 用户位置信息模型
@freezed
class LocationModel with _$LocationModel {
  const LocationModel._();

  const factory LocationModel({
    @Default("") String country,
    @Default("") String city,
    @Default("") String region,
    @Default("") String countryCode,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);

  String get locationString => (country.isNotEmpty && city.isNotEmpty) ? '$country/$city' : '未知';
}
