// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_request_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateTranslationKeyRequestImpl _$$CreateTranslationKeyRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateTranslationKeyRequestImpl(
      projectId: (json['project_id'] as num).toInt(),
      entryKey: json['entry_key'] as String,
      sourceLanguage: const LanguageEnumConverter()
          .fromJson(json['source_language'] as String),
      targetLanguages: (json['target_languages'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$LanguageEnumEnumMap, e))
              .toList() ??
          const [],
      sourceText: json['source_text'] as String,
      context: json['context'] as String?,
      maxLength: (json['max_length'] as num?)?.toInt(),
      isPlural: json['is_plural'] as bool? ?? false,
      pluralForms: json['plural_forms'] as String?,
    );

Map<String, dynamic> _$$CreateTranslationKeyRequestImplToJson(
        _$CreateTranslationKeyRequestImpl instance) =>
    <String, dynamic>{
      'project_id': instance.projectId,
      'entry_key': instance.entryKey,
      'source_language':
          const LanguageEnumConverter().toJson(instance.sourceLanguage),
      'target_languages': instance.targetLanguages
          .map((e) => _$LanguageEnumEnumMap[e]!)
          .toList(),
      'source_text': instance.sourceText,
      'context': instance.context,
      'max_length': instance.maxLength,
      'is_plural': instance.isPlural,
      'plural_forms': instance.pluralForms,
    };

const _$LanguageEnumEnumMap = {
  LanguageEnum.enUS: 'enUS',
  LanguageEnum.zhCN: 'zhCN',
  LanguageEnum.zhTW: 'zhTW',
  LanguageEnum.thTH: 'thTH',
  LanguageEnum.jaJP: 'jaJP',
  LanguageEnum.koKR: 'koKR',
  LanguageEnum.myMM: 'myMM',
  LanguageEnum.trTR: 'trTR',
  LanguageEnum.deDE: 'deDE',
  LanguageEnum.svSE: 'svSE',
};

_$UpdateTranslationRequestImpl _$$UpdateTranslationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateTranslationRequestImpl(
      targetText: json['target_text'] as String?,
      status: _$JsonConverterFromJson<String, TranslationStatusEnum>(
          json['status'], const TranslationStatusEnumConverter().fromJson),
      context: json['context'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$UpdateTranslationRequestImplToJson(
        _$UpdateTranslationRequestImpl instance) =>
    <String, dynamic>{
      'target_text': instance.targetText,
      'status': _$JsonConverterToJson<String, TranslationStatusEnum>(
          instance.status, const TranslationStatusEnumConverter().toJson),
      'context': instance.context,
      'comment': instance.comment,
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

_$BatchTranslationRequestImpl _$$BatchTranslationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$BatchTranslationRequestImpl(
      entryIds:
          (json['entry_ids'] as List<dynamic>).map((e) => e as String).toList(),
      targetLanguage: _$JsonConverterFromJson<String, LanguageEnum>(
          json['target_language'], const LanguageEnumConverter().fromJson),
      provider: _$JsonConverterFromJson<String, TranslationProviderEnum>(
          json['provider'], const TranslationProviderEnumConverter().fromJson),
    );

Map<String, dynamic> _$$BatchTranslationRequestImplToJson(
        _$BatchTranslationRequestImpl instance) =>
    <String, dynamic>{
      'entry_ids': instance.entryIds,
      'target_language': _$JsonConverterToJson<String, LanguageEnum>(
          instance.targetLanguage, const LanguageEnumConverter().toJson),
      'provider': _$JsonConverterToJson<String, TranslationProviderEnum>(
          instance.provider, const TranslationProviderEnumConverter().toJson),
    };
