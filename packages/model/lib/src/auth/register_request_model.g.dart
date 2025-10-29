// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterRequestModelImpl _$$RegisterRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestModelImpl(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      displayName: json['display_name'] as String?,
      languageCode: json['language_code'] as String?,
    );

Map<String, dynamic> _$$RegisterRequestModelImplToJson(
        _$RegisterRequestModelImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'display_name': instance.displayName,
      'language_code': instance.languageCode,
    };
