// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      ownerId: json['owner_id'] as String,
      status: json['status'] as String,
      visibility: json['visibility'] as String,
      primaryLanguageCode: _$JsonConverterFromJson<String, LanguageEnum>(
          json['primary_language_code'],
          const LanguageEnumConverter().fromJson),
      totalKeys: (json['total_keys'] as num?)?.toInt() ?? 0,
      translatedKeys: (json['translated_keys'] as num?)?.toInt() ?? 0,
      languagesCount: (json['languages_count'] as num?)?.toInt() ?? 0,
      membersCount: (json['members_count'] as num?)?.toInt() ?? 1,
      isPublic: json['is_public'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      settings: json['settings'] as Map<String, dynamic>?,
      lastActivityAt: json['last_activity_at'] == null
          ? null
          : DateTime.parse(json['last_activity_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      ownerUsername: json['owner_username'] as String?,
      ownerDisplayName: json['owner_display_name'] as String?,
      ownerAvatar: json['owner_avatar'] as String?,
      completionPercentage:
          (json['completion_percentage'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ProjectModelImplToJson(_$ProjectModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'owner_id': instance.ownerId,
      'status': instance.status,
      'visibility': instance.visibility,
      'primary_language_code': _$JsonConverterToJson<String, LanguageEnum>(
          instance.primaryLanguageCode, const LanguageEnumConverter().toJson),
      'total_keys': instance.totalKeys,
      'translated_keys': instance.translatedKeys,
      'languages_count': instance.languagesCount,
      'members_count': instance.membersCount,
      'is_public': instance.isPublic,
      'is_active': instance.isActive,
      'settings': instance.settings,
      'last_activity_at': instance.lastActivityAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'owner_username': instance.ownerUsername,
      'owner_display_name': instance.ownerDisplayName,
      'owner_avatar': instance.ownerAvatar,
      'completion_percentage': instance.completionPercentage,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$CreateProjectRequestImpl _$$CreateProjectRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateProjectRequestImpl(
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      visibility: json['visibility'] as String? ?? 'private',
      primaryLanguageCode: _$JsonConverterFromJson<String, LanguageEnum>(
          json['primaryLanguageCode'], const LanguageEnumConverter().fromJson),
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
      'primaryLanguageCode': _$JsonConverterToJson<String, LanguageEnum>(
          instance.primaryLanguageCode, const LanguageEnumConverter().toJson),
      'settings': instance.settings,
    };

_$UpdateProjectRequestImpl _$$UpdateProjectRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateProjectRequestImpl(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      visibility: json['visibility'] as String?,
      primaryLanguageCode: _$JsonConverterFromJson<String, LanguageEnum>(
          json['primaryLanguageCode'], const LanguageEnumConverter().fromJson),
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
      'primaryLanguageCode': _$JsonConverterToJson<String, LanguageEnum>(
          instance.primaryLanguageCode, const LanguageEnumConverter().toJson),
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
