// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogModelImpl _$$AuditLogModelImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      userId: json['user_id'] as String?,
      action: json['action'] as String,
      resourceType: json['resource_type'] as String,
      resourceId: const FlexibleIntConverter().fromJson(json['resource_id']),
      oldValues: json['old_values'] as Map<String, dynamic>?,
      newValues: json['new_values'] as Map<String, dynamic>?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
    );

Map<String, dynamic> _$$AuditLogModelImplToJson(_$AuditLogModelImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIntConverter().toJson(instance.id),
      'user_id': instance.userId,
      'action': instance.action,
      'resource_type': instance.resourceType,
      'resource_id': _$JsonConverterToJson<dynamic, int>(
          instance.resourceId, const FlexibleIntConverter().toJson),
      'old_values': instance.oldValues,
      'new_values': instance.newValues,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'created_at': const TimesConverter().toJson(instance.createdAt),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
