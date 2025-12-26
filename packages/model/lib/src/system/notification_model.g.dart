// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      userId: json['user_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      priority: json['priority'] as String? ?? 'normal',
      isRead: json['is_read'] as bool? ?? false,
      isSystem: json['is_system'] as bool? ?? false,
      actionUrl: json['action_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      readAt: const NullableTimesConverter().fromJson(json['read_at']),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIntConverter().toJson(instance.id),
      'user_id': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'priority': instance.priority,
      'is_read': instance.isRead,
      'is_system': instance.isSystem,
      'action_url': instance.actionUrl,
      'metadata': instance.metadata,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'read_at': const NullableTimesConverter().toJson(instance.readAt),
    };
