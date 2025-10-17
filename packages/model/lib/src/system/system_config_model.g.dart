// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemConfigModelImpl _$$SystemConfigModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SystemConfigModelImpl(
      id: json['id'] as String?,
      configKey: json['config_key'] as String,
      configValue: json['config_value'] as String,
      valueType: json['value_type'] as String?,
      defaultValue: json['default_value'] as String?,
      category: json['category'] as String?,
      displayName: json['display_name'] as String?,
      description: json['description'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      isEditable: json['is_editable'] as bool? ?? true,
      isPublic: json['is_public'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      updatedBy: json['updated_by'] as String?,
      changeReason: json['change_reason'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SystemConfigModelImplToJson(
        _$SystemConfigModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'config_key': instance.configKey,
      'config_value': instance.configValue,
      'value_type': instance.valueType,
      'default_value': instance.defaultValue,
      'category': instance.category,
      'display_name': instance.displayName,
      'description': instance.description,
      'sort_order': instance.sortOrder,
      'is_editable': instance.isEditable,
      'is_public': instance.isPublic,
      'is_active': instance.isActive,
      'updated_by': instance.updatedBy,
      'change_reason': instance.changeReason,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
