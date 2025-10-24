// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileModelImpl _$$FileModelImplFromJson(Map<String, dynamic> json) =>
    _$FileModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      size: (json['size'] as num).toInt(),
      type: json['type'] as String,
      createdAt: const NullableTimesConverter().fromJson(json['created_at']),
      updatedAt: const NullableTimesConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$FileModelImplToJson(_$FileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'size': instance.size,
      'type': instance.type,
      'created_at': const NullableTimesConverter().toJson(instance.createdAt),
      'updated_at': const NullableTimesConverter().toJson(instance.updatedAt),
    };
