// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoModelImpl _$$UserInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoModelImpl(
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
      emailVerifiedAt:
          const NullableTimesConverter().fromJson(json['email_verified_at']),
      lastLoginAt:
          const NullableTimesConverter().fromJson(json['last_login_at']),
      lastLoginIp: json['last_login_ip'] as String?,
      lastLoginLocation: json['last_login_location'] == null
          ? null
          : LocationModel.fromJson(
              json['last_login_location'] as Map<String, dynamic>),
      loginAttempts: (json['login_attempts'] as num?)?.toInt(),
      lockedUntil:
          const NullableTimesConverter().fromJson(json['locked_until']),
      passwordChangedAt:
          const NullableTimesConverter().fromJson(json['password_changed_at']),
      createdAt: const NullableTimesConverter().fromJson(json['created_at']),
      updatedAt: const NullableTimesConverter().fromJson(json['updated_at']),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserInfoModelImplToJson(_$UserInfoModelImpl instance) =>
    <String, dynamic>{
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
      'email_verified_at':
          const NullableTimesConverter().toJson(instance.emailVerifiedAt),
      'last_login_at':
          const NullableTimesConverter().toJson(instance.lastLoginAt),
      'last_login_ip': instance.lastLoginIp,
      'last_login_location': instance.lastLoginLocation,
      'login_attempts': instance.loginAttempts,
      'locked_until':
          const NullableTimesConverter().toJson(instance.lockedUntil),
      'password_changed_at':
          const NullableTimesConverter().toJson(instance.passwordChangedAt),
      'created_at': const NullableTimesConverter().toJson(instance.createdAt),
      'updated_at': const NullableTimesConverter().toJson(instance.updatedAt),
      'roles': instance.roles,
    };
