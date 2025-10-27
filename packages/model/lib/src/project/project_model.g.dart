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
      languagesCount: json['languages_count'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['languages_count']),
      membersCount: json['members_count'] == null
          ? 1
          : const FlexibleIntConverter().fromJson(json['members_count']),
      isPublic: json['is_public'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      settings: json['settings'] as Map<String, dynamic>?,
      lastActivityAt:
          const NullableTimesConverter().fromJson(json['last_activity_at']),
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      updatedAt: const TimesConverter().fromJson(json['updated_at'] as Object),
      ownerUsername: json['owner_username'] as String?,
      ownerDisplayName: json['owner_display_name'] as String?,
      ownerAvatar: json['owner_avatar'] as String?,
      completionPercentage: json['completion_percentage'] == null
          ? 0.0
          : const FlexibleDoubleConverter()
              .fromJson(json['completion_percentage']),
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
      'languages_count':
          const FlexibleIntConverter().toJson(instance.languagesCount),
      'members_count':
          const FlexibleIntConverter().toJson(instance.membersCount),
      'is_public': instance.isPublic,
      'is_active': instance.isActive,
      'settings': instance.settings,
      'last_activity_at':
          const NullableTimesConverter().toJson(instance.lastActivityAt),
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'updated_at': const TimesConverter().toJson(instance.updatedAt),
      'owner_username': instance.ownerUsername,
      'owner_display_name': instance.ownerDisplayName,
      'owner_avatar': instance.ownerAvatar,
      'completion_percentage':
          const FlexibleDoubleConverter().toJson(instance.completionPercentage),
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
          const FlexibleIntConverter().fromJson(json['primaryLanguageId']),
      settings: json['settings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CreateProjectRequestImplToJson(
        _$CreateProjectRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'status': instance.status,
      'visibility': instance.visibility,
      'primaryLanguageId': _$JsonConverterToJson<dynamic, int>(
          instance.primaryLanguageId, const FlexibleIntConverter().toJson),
      'settings': instance.settings,
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
          const FlexibleIntConverter().fromJson(json['primaryLanguageId']),
      settings: json['settings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UpdateProjectRequestImplToJson(
        _$UpdateProjectRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'status': instance.status,
      'visibility': instance.visibility,
      'primaryLanguageId': _$JsonConverterToJson<dynamic, int>(
          instance.primaryLanguageId, const FlexibleIntConverter().toJson),
      'settings': instance.settings,
    };

_$ProjectDetailModelImpl _$$ProjectDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectDetailModelImpl(
      project: ProjectModel.fromJson(json['project'] as Map<String, dynamic>),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => ProjectMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProjectDetailModelImplToJson(
        _$ProjectDetailModelImpl instance) =>
    <String, dynamic>{
      'project': instance.project,
      'languages': instance.languages,
      'members': instance.members,
    };
