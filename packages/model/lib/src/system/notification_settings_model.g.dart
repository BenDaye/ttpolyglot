// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsModelImpl _$$NotificationSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      userId: json['user_id'] as String,
      projectId: const FlexibleIntConverter().fromJson(json['project_id']),
      notificationType: const NotificationTypeEnumConverter()
          .fromJson(json['notification_type'] as String),
      channel: const NotificationChannelEnumConverter()
          .fromJson(json['channel'] as String),
      isEnabled: json['is_enabled'] as bool? ?? true,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      updatedAt: const TimesConverter().fromJson(json['updated_at'] as Object),
    );

Map<String, dynamic> _$$NotificationSettingsModelImplToJson(
        _$NotificationSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIntConverter().toJson(instance.id),
      'user_id': instance.userId,
      'project_id': _$JsonConverterToJson<dynamic, int>(
          instance.projectId, const FlexibleIntConverter().toJson),
      'notification_type': const NotificationTypeEnumConverter()
          .toJson(instance.notificationType),
      'channel':
          const NotificationChannelEnumConverter().toJson(instance.channel),
      'is_enabled': instance.isEnabled,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'updated_at': const TimesConverter().toJson(instance.updatedAt),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$UpdateNotificationSettingsRequestImpl
    _$$UpdateNotificationSettingsRequestImplFromJson(
            Map<String, dynamic> json) =>
        _$UpdateNotificationSettingsRequestImpl(
          userId: json['user_id'] as String,
          projectId: const FlexibleIntConverter().fromJson(json['project_id']),
          notificationType: const NotificationTypeEnumConverter()
              .fromJson(json['notification_type'] as String),
          channel: const NotificationChannelEnumConverter()
              .fromJson(json['channel'] as String),
          isEnabled: json['is_enabled'] as bool,
        );

Map<String, dynamic> _$$UpdateNotificationSettingsRequestImplToJson(
        _$UpdateNotificationSettingsRequestImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'project_id': _$JsonConverterToJson<dynamic, int>(
          instance.projectId, const FlexibleIntConverter().toJson),
      'notification_type': const NotificationTypeEnumConverter()
          .toJson(instance.notificationType),
      'channel':
          const NotificationChannelEnumConverter().toJson(instance.channel),
      'is_enabled': instance.isEnabled,
    };

_$BatchUpdateNotificationSettingsRequestImpl
    _$$BatchUpdateNotificationSettingsRequestImplFromJson(
            Map<String, dynamic> json) =>
        _$BatchUpdateNotificationSettingsRequestImpl(
          userId: json['user_id'] as String,
          projectId: const FlexibleIntConverter().fromJson(json['project_id']),
          updates: (json['updates'] as List<dynamic>)
              .map((e) =>
                  NotificationSettingUpdate.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$BatchUpdateNotificationSettingsRequestImplToJson(
        _$BatchUpdateNotificationSettingsRequestImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'project_id': _$JsonConverterToJson<dynamic, int>(
          instance.projectId, const FlexibleIntConverter().toJson),
      'updates': instance.updates,
    };

_$NotificationSettingUpdateImpl _$$NotificationSettingUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingUpdateImpl(
      notificationType: const NotificationTypeEnumConverter()
          .fromJson(json['notification_type'] as String),
      channel: const NotificationChannelEnumConverter()
          .fromJson(json['channel'] as String),
      isEnabled: json['is_enabled'] as bool,
    );

Map<String, dynamic> _$$NotificationSettingUpdateImplToJson(
        _$NotificationSettingUpdateImpl instance) =>
    <String, dynamic>{
      'notification_type': const NotificationTypeEnumConverter()
          .toJson(instance.notificationType),
      'channel':
          const NotificationChannelEnumConverter().toJson(instance.channel),
      'is_enabled': instance.isEnabled,
    };
