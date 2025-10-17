// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TokenInfoModelImpl _$$TokenInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$TokenInfoModelImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$$TokenInfoModelImplToJson(
        _$TokenInfoModelImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };
