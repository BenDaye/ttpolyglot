// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationEntryModelImpl _$$TranslationEntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationEntryModelImpl(
      uuid: json['uuid'] as String,
      projectId: json['project_id'] as String,
      entryKey: json['entry_key'] as String,
      sourceLanguage: json['source_language'] == null
          ? LanguageEnum.enUS
          : const LanguageEnumConverter()
              .fromJson(json['source_language'] as String),
      targetLanguage: const LanguageEnumConverter()
          .fromJson(json['target_language'] as String),
      sourceText: json['source_text'] as String,
      targetText: json['target_text'] as String,
      status: const TranslationStatusEnumConverter()
          .fromJson(json['status'] as String),
      translatedBy: json['translated_by'] as String?,
      translatorUsername: json['translator_username'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewerUsername: json['reviewer_username'] as String?,
      context: json['context'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      maxLength: (json['max_length'] as num?)?.toInt(),
      isPlural: json['is_plural'] as bool? ?? false,
      pluralForms: json['plural_forms'] as String?,
      sortIndex: (json['sort_index'] as num?)?.toInt() ?? 0,
      targetLanguageId: (json['target_language_id'] as num?)?.toInt(),
      deletedAt: const NullableTimesConverter().fromJson(json['deleted_at']),
      createdAt: const NullableTimesConverter().fromJson(json['created_at']),
      updatedAt: const NullableTimesConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$TranslationEntryModelImplToJson(
        _$TranslationEntryModelImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'project_id': instance.projectId,
      'entry_key': instance.entryKey,
      'source_language':
          const LanguageEnumConverter().toJson(instance.sourceLanguage),
      'target_language':
          const LanguageEnumConverter().toJson(instance.targetLanguage),
      'source_text': instance.sourceText,
      'target_text': instance.targetText,
      'status': const TranslationStatusEnumConverter().toJson(instance.status),
      'translated_by': instance.translatedBy,
      'translator_username': instance.translatorUsername,
      'reviewed_by': instance.reviewedBy,
      'reviewer_username': instance.reviewerUsername,
      'context': instance.context,
      'comment': instance.comment,
      'max_length': instance.maxLength,
      'is_plural': instance.isPlural,
      'plural_forms': instance.pluralForms,
      'sort_index': instance.sortIndex,
      'target_language_id': instance.targetLanguageId,
      'deleted_at': const NullableTimesConverter().toJson(instance.deletedAt),
      'created_at': const NullableTimesConverter().toJson(instance.createdAt),
      'updated_at': const NullableTimesConverter().toJson(instance.updatedAt),
    };
