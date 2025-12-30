// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectPermissionImpl _$$ProjectPermissionImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectPermissionImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      updatedAt: const TimesConverter().fromJson(json['updated_at'] as Object),
    );

Map<String, dynamic> _$$ProjectPermissionImplToJson(
        _$ProjectPermissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'is_active': instance.isActive,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'updated_at': const TimesConverter().toJson(instance.updatedAt),
    };
