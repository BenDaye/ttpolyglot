// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      emailOrUsername: json['email_or_username'] as String,
      password: json['password'] as String,
      deviceId: json['device_id'] as String?,
      deviceName: json['device_name'] as String?,
      deviceType: json['device_type'] as String?,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'email_or_username': instance.emailOrUsername,
      'password': instance.password,
      'device_id': instance.deviceId,
      'device_name': instance.deviceName,
      'device_type': instance.deviceType,
    };
