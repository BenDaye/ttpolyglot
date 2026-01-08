// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationEntryModelImpl _$$TranslationEntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationEntryModelImpl(
      uuid: json['uuid'] as String,
      projectId: (json['project_id'] as num).toInt(),
      entryKey: json['entry_key'] as String,
      sourceLanguage: json['source_language'] == null
          ? LanguageEnum.enUS
          : const LanguageEnumConverter()
              .fromJson(json['source_language'] as String),
      sourceText: json['source_text'] as String,
      targetLanguages: (json['target_languages'] as List<dynamic>)
          .map((e) => TranslationTargetLanguageModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      translatedBy: json['translated_by'] as String?,
      translatorUsername: json['translator_username'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewerUsername: json['reviewer_username'] as String?,
      context: json['context'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      sortIndex: (json['sort_index'] as num?)?.toInt() ?? 0,
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
      'source_text': instance.sourceText,
      'target_languages': instance.targetLanguages,
      'translated_by': instance.translatedBy,
      'translator_username': instance.translatorUsername,
      'reviewed_by': instance.reviewedBy,
      'reviewer_username': instance.reviewerUsername,
      'context': instance.context,
      'comment': instance.comment,
      'sort_index': instance.sortIndex,
      'deleted_at': const NullableTimesConverter().toJson(instance.deletedAt),
      'created_at': const NullableTimesConverter().toJson(instance.createdAt),
      'updated_at': const NullableTimesConverter().toJson(instance.updatedAt),
    };
