// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageModelImpl _$$LanguageModelImplFromJson(Map<String, dynamic> json) =>
    _$LanguageModelImpl(
      id: (json['id'] as num).toInt(),
      code: const LanguageEnumConverter().fromJson(json['code'] as String),
      name: json['name'] as String,
      nativeName: json['native_name'] as String?,
      flagEmoji: json['flag_emoji'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isRtl: json['is_rtl'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      updatedAt: const TimesConverter().fromJson(json['updated_at'] as Object),
      isPrimary: json['is_primary'] as bool? ?? false,
    );

Map<String, dynamic> _$$LanguageModelImplToJson(_$LanguageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': const LanguageEnumConverter().toJson(instance.code),
      'name': instance.name,
      'native_name': instance.nativeName,
      'flag_emoji': instance.flagEmoji,
      'is_active': instance.isActive,
      'is_rtl': instance.isRtl,
      'sort_order': instance.sortOrder,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'updated_at': const TimesConverter().toJson(instance.updatedAt),
      'is_primary': instance.isPrimary,
    };
