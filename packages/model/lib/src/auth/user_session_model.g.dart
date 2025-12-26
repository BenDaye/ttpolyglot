// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSessionModelImpl _$$UserSessionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSessionModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      userId: json['user_id'] as String,
      tokenHash: json['token_hash'] as String,
      refreshTokenHash: json['refresh_token_hash'] as String?,
      deviceId: json['device_id'] as String?,
      deviceName: json['device_name'] as String?,
      deviceType: json['device_type'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      locationInfo: json['location_info'] as Map<String, dynamic>?,
      lastActivityAt:
          const TimesConverter().fromJson(json['last_activity_at'] as Object),
      expiresAt: const TimesConverter().fromJson(json['expires_at'] as Object),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      updatedAt: const TimesConverter().fromJson(json['updated_at'] as Object),
    );

Map<String, dynamic> _$$UserSessionModelImplToJson(
        _$UserSessionModelImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIntConverter().toJson(instance.id),
      'user_id': instance.userId,
      'token_hash': instance.tokenHash,
      'refresh_token_hash': instance.refreshTokenHash,
      'device_id': instance.deviceId,
      'device_name': instance.deviceName,
      'device_type': instance.deviceType,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'location_info': instance.locationInfo,
      'last_activity_at':
          const TimesConverter().toJson(instance.lastActivityAt),
      'expires_at': const TimesConverter().toJson(instance.expiresAt),
      'is_active': instance.isActive,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'updated_at': const TimesConverter().toJson(instance.updatedAt),
    };
