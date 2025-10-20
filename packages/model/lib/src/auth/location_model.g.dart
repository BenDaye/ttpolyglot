// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationModelImpl _$$LocationModelImplFromJson(Map<String, dynamic> json) =>
    _$LocationModelImpl(
      country: json['country'] as String? ?? "",
      city: json['city'] as String? ?? "",
      region: json['region'] as String? ?? "",
      countryCode: json['countryCode'] as String? ?? "",
    );

Map<String, dynamic> _$$LocationModelImplToJson(_$LocationModelImpl instance) =>
    <String, dynamic>{
      'country': instance.country,
      'city': instance.city,
      'region': instance.region,
      'countryCode': instance.countryCode,
    };
