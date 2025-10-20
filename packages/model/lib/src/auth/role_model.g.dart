// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleModelImpl _$$RoleModelImplFromJson(Map<String, dynamic> json) =>
    _$RoleModelImpl(
      roleId: (json['role_id'] as num).toInt(),
      roleName: json['role_name'] as String,
      roleDisplayName: json['role_display_name'] as String,
      isSystemRole: json['is_system_role'] as bool,
      assignedAt: DateTime.parse(json['assigned_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$$RoleModelImplToJson(_$RoleModelImpl instance) =>
    <String, dynamic>{
      'role_id': instance.roleId,
      'role_name': instance.roleName,
      'role_display_name': instance.roleDisplayName,
      'is_system_role': instance.isSystemRole,
      'assigned_at': instance.assignedAt.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
    };
