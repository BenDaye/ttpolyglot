// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoModelImpl _$$UserInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoModelImpl(
      id: json['id'] as String?,
      username: json['username'] as String,
      email: json['email'] as String,
      emailEncrypted: json['email_encrypted'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
      timezone: json['timezone'] as String?,
      locale: json['locale'] as String?,
      isActive: json['is_active'] as bool?,
      isEmailVerified: json['is_email_verified'] as bool?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at'] as String),
      lastLoginIp: json['last_login_ip'] as String?,
      lastLoginLocation: json['last_login_location'] == null
          ? null
          : LocationModel.fromJson(
              json['last_login_location'] as Map<String, dynamic>),
      loginAttempts: (json['login_attempts'] as num?)?.toInt(),
      lockedUntil: json['locked_until'] == null
          ? null
          : DateTime.parse(json['locked_until'] as String),
      passwordChangedAt: json['password_changed_at'] == null
          ? null
          : DateTime.parse(json['password_changed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserInfoModelImplToJson(_$UserInfoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'email_encrypted': instance.emailEncrypted,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'phone': instance.phone,
      'timezone': instance.timezone,
      'locale': instance.locale,
      'is_active': instance.isActive,
      'is_email_verified': instance.isEmailVerified,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
      'last_login_ip': instance.lastLoginIp,
      'last_login_location': instance.lastLoginLocation,
      'login_attempts': instance.loginAttempts,
      'locked_until': instance.lockedUntil?.toIso8601String(),
      'password_changed_at': instance.passwordChangedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
