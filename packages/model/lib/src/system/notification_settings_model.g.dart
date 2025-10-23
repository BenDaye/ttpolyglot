// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsModelImpl _$$NotificationSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsModelImpl(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      projectId: (json['project_id'] as num?)?.toInt(),
      notificationType: json['notification_type'] as String,
      channel: json['channel'] as String,
      isEnabled: json['is_enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NotificationSettingsModelImplToJson(
        _$NotificationSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'project_id': instance.projectId,
      'notification_type': instance.notificationType,
      'channel': instance.channel,
      'is_enabled': instance.isEnabled,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$UpdateNotificationSettingsRequestImpl
    _$$UpdateNotificationSettingsRequestImplFromJson(
            Map<String, dynamic> json) =>
        _$UpdateNotificationSettingsRequestImpl(
          userId: json['userId'] as String,
          projectId: (json['projectId'] as num?)?.toInt(),
          notificationType: json['notificationType'] as String,
          channel: json['channel'] as String,
          isEnabled: json['isEnabled'] as bool,
        );

Map<String, dynamic> _$$UpdateNotificationSettingsRequestImplToJson(
        _$UpdateNotificationSettingsRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'projectId': instance.projectId,
      'notificationType': instance.notificationType,
      'channel': instance.channel,
      'isEnabled': instance.isEnabled,
    };

_$BatchUpdateNotificationSettingsRequestImpl
    _$$BatchUpdateNotificationSettingsRequestImplFromJson(
            Map<String, dynamic> json) =>
        _$BatchUpdateNotificationSettingsRequestImpl(
          userId: json['userId'] as String,
          projectId: (json['projectId'] as num?)?.toInt(),
          updates: (json['updates'] as List<dynamic>)
              .map((e) =>
                  NotificationSettingUpdate.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$BatchUpdateNotificationSettingsRequestImplToJson(
        _$BatchUpdateNotificationSettingsRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'projectId': instance.projectId,
      'updates': instance.updates,
    };

_$NotificationSettingUpdateImpl _$$NotificationSettingUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingUpdateImpl(
      notificationType: json['notificationType'] as String,
      channel: json['channel'] as String,
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$$NotificationSettingUpdateImplToJson(
        _$NotificationSettingUpdateImpl instance) =>
    <String, dynamic>{
      'notificationType': instance.notificationType,
      'channel': instance.channel,
      'isEnabled': instance.isEnabled,
    };
