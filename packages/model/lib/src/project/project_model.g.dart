// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      ownerId: json['owner_id'] as String,
      status: json['status'] as String,
      visibility: json['visibility'] as String,
      primaryLanguageId:
          const FlexibleIntConverter().fromJson(json['primary_language_id']),
      totalKeys: json['total_keys'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['total_keys']),
      translatedKeys: json['translated_keys'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['translated_keys']),
      memberLimit: json['member_limit'] == null
          ? 10
          : const FlexibleIntConverter().fromJson(json['member_limit']),
      isActive: json['is_active'] as bool? ?? true,
      lastActivityAt:
          const NullableTimesConverter().fromJson(json['last_activity_at']),
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      updatedAt: const TimesConverter().fromJson(json['updated_at'] as Object),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List<dynamic>)
          .map((e) => ProjectMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProjectModelImplToJson(_$ProjectModelImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIntConverter().toJson(instance.id),
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'owner_id': instance.ownerId,
      'status': instance.status,
      'visibility': instance.visibility,
      'primary_language_id':
          const FlexibleIntConverter().toJson(instance.primaryLanguageId),
      'total_keys': const FlexibleIntConverter().toJson(instance.totalKeys),
      'translated_keys':
          const FlexibleIntConverter().toJson(instance.translatedKeys),
      'member_limit': const FlexibleIntConverter().toJson(instance.memberLimit),
      'is_active': instance.isActive,
      'last_activity_at':
          const NullableTimesConverter().toJson(instance.lastActivityAt),
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'updated_at': const TimesConverter().toJson(instance.updatedAt),
      'languages': instance.languages,
      'members': instance.members,
    };

_$CreateProjectRequestImpl _$$CreateProjectRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateProjectRequestImpl(
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      visibility: json['visibility'] as String? ?? 'private',
      primaryLanguageId:
          const FlexibleIntConverter().fromJson(json['primary_language_id']),
    );

Map<String, dynamic> _$$CreateProjectRequestImplToJson(
        _$CreateProjectRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'status': instance.status,
      'visibility': instance.visibility,
      'primary_language_id': _$JsonConverterToJson<dynamic, int>(
          instance.primaryLanguageId, const FlexibleIntConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$UpdateProjectRequestImpl _$$UpdateProjectRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateProjectRequestImpl(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      visibility: json['visibility'] as String?,
      primaryLanguageId:
          const FlexibleIntConverter().fromJson(json['primary_language_id']),
    );

Map<String, dynamic> _$$UpdateProjectRequestImplToJson(
        _$UpdateProjectRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'status': instance.status,
      'visibility': instance.visibility,
      'primary_language_id': _$JsonConverterToJson<dynamic, int>(
          instance.primaryLanguageId, const FlexibleIntConverter().toJson),
    };

_$UpdateMemberLimitRequestImpl _$$UpdateMemberLimitRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateMemberLimitRequestImpl(
      memberLimit: (json['member_limit'] as num).toInt(),
    );

Map<String, dynamic> _$$UpdateMemberLimitRequestImplToJson(
        _$UpdateMemberLimitRequestImpl instance) =>
    <String, dynamic>{
      'member_limit': instance.memberLimit,
    };
