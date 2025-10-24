// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsModelImpl _$$UserSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSettingsModelImpl(
      languageSettings: LanguageSettingsModel.fromJson(
          json['language_settings'] as Map<String, dynamic>),
      generalSettings: GeneralSettingsModel.fromJson(
          json['general_settings'] as Map<String, dynamic>),
      translationSettings: TranslationSettingsModel.fromJson(
          json['translation_settings'] as Map<String, dynamic>),
      createdAt: const NullableTimesConverter().fromJson(json['created_at']),
      updatedAt: const NullableTimesConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$UserSettingsModelImplToJson(
        _$UserSettingsModelImpl instance) =>
    <String, dynamic>{
      'language_settings': instance.languageSettings,
      'general_settings': instance.generalSettings,
      'translation_settings': instance.translationSettings,
      'created_at': const NullableTimesConverter().toJson(instance.createdAt),
      'updated_at': const NullableTimesConverter().toJson(instance.updatedAt),
    };

_$LanguageSettingsModelImpl _$$LanguageSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguageSettingsModelImpl(
      languageCode: _$JsonConverterFromJson<String, LanguageEnum>(
          json['language_code'], const LanguageEnumConverter().fromJson),
    );

Map<String, dynamic> _$$LanguageSettingsModelImplToJson(
        _$LanguageSettingsModelImpl instance) =>
    <String, dynamic>{
      'language_code': _$JsonConverterToJson<String, LanguageEnum>(
          instance.languageCode, const LanguageEnumConverter().toJson),
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

_$GeneralSettingsModelImpl _$$GeneralSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GeneralSettingsModelImpl(
      autoSave: json['auto_save'] as bool? ?? true,
      notifications: json['notifications'] as bool? ?? true,
    );

Map<String, dynamic> _$$GeneralSettingsModelImplToJson(
        _$GeneralSettingsModelImpl instance) =>
    <String, dynamic>{
      'auto_save': instance.autoSave,
      'notifications': instance.notifications,
    };

_$TranslationSettingsModelImpl _$$TranslationSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationSettingsModelImpl(
      providers: (json['providers'] as List<dynamic>?)
              ?.map((e) => TranslationProviderConfigModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      maxRetries: (json['max_retries'] as num?)?.toInt() ?? 3,
      timeoutSeconds: (json['timeout_seconds'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$$TranslationSettingsModelImplToJson(
        _$TranslationSettingsModelImpl instance) =>
    <String, dynamic>{
      'providers': instance.providers,
      'max_retries': instance.maxRetries,
      'timeout_seconds': instance.timeoutSeconds,
    };

_$TranslationProviderConfigModelImpl
    _$$TranslationProviderConfigModelImplFromJson(Map<String, dynamic> json) =>
        _$TranslationProviderConfigModelImpl(
          id: json['id'] as String,
          provider: json['provider'] as String,
          name: json['name'] as String?,
          appId: json['app_id'] as String? ?? '',
          appKey: json['app_key'] as String? ?? '',
          apiUrl: json['api_url'] as String?,
          isDefault: json['is_default'] as bool? ?? false,
        );

Map<String, dynamic> _$$TranslationProviderConfigModelImplToJson(
        _$TranslationProviderConfigModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provider': instance.provider,
      'name': instance.name,
      'app_id': instance.appId,
      'app_key': instance.appKey,
      'api_url': instance.apiUrl,
      'is_default': instance.isDefault,
    };
