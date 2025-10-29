// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResetPasswordRequestModelImpl _$$ResetPasswordRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPasswordRequestModelImpl(
      token: json['token'] as String,
      newPassword: json['new_password'] as String,
    );

Map<String, dynamic> _$$ResetPasswordRequestModelImplToJson(
        _$ResetPasswordRequestModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'new_password': instance.newPassword,
    };
