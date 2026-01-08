// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_target_language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationTargetLanguageModelImpl
    _$$TranslationTargetLanguageModelImplFromJson(Map<String, dynamic> json) =>
        _$TranslationTargetLanguageModelImpl(
          language: const LanguageEnumConverter()
              .fromJson(json['language'] as String),
          text: json['text'] as String,
        );

Map<String, dynamic> _$$TranslationTargetLanguageModelImplToJson(
        _$TranslationTargetLanguageModelImpl instance) =>
    <String, dynamic>{
      'language': const LanguageEnumConverter().toJson(instance.language),
      'text': instance.text,
    };
