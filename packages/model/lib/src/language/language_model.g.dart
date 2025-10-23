// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageModelImpl _$$LanguageModelImplFromJson(Map<String, dynamic> json) =>
    _$LanguageModelImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['native_name'] as String?,
      flagEmoji: json['flag_emoji'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isRtl: json['is_rtl'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$LanguageModelImplToJson(_$LanguageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'native_name': instance.nativeName,
      'flag_emoji': instance.flagEmoji,
      'is_active': instance.isActive,
      'is_rtl': instance.isRtl,
      'sort_order': instance.sortOrder,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$CreateLanguageRequestImpl _$$CreateLanguageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateLanguageRequestImpl(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String?,
      flagEmoji: json['flagEmoji'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isRtl: json['isRtl'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CreateLanguageRequestImplToJson(
        _$CreateLanguageRequestImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'nativeName': instance.nativeName,
      'flagEmoji': instance.flagEmoji,
      'isActive': instance.isActive,
      'isRtl': instance.isRtl,
      'sortOrder': instance.sortOrder,
    };

_$UpdateLanguageRequestImpl _$$UpdateLanguageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateLanguageRequestImpl(
      code: json['code'] as String?,
      name: json['name'] as String?,
      nativeName: json['nativeName'] as String?,
      flagEmoji: json['flagEmoji'] as String?,
      isActive: json['isActive'] as bool?,
      isRtl: json['isRtl'] as bool?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UpdateLanguageRequestImplToJson(
        _$UpdateLanguageRequestImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'nativeName': instance.nativeName,
      'flagEmoji': instance.flagEmoji,
      'isActive': instance.isActive,
      'isRtl': instance.isRtl,
      'sortOrder': instance.sortOrder,
    };
