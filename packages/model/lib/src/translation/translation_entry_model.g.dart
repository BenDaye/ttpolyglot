// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationEntryModelImpl _$$TranslationEntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationEntryModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      uuid: json['uuid'] as String?,
      projectId: json['project_id'] as String,
      key: json['key'] as String?,
      entryKey: json['entry_key'] as String,
      sourceLanguageId:
          const FlexibleIntConverter().fromJson(json['source_language_id']),
      targetLanguageId:
          const FlexibleIntConverter().fromJson(json['target_language_id']),
      languageCode: _$JsonConverterFromJson<String, LanguageEnum>(
          json['language_code'], const LanguageEnumConverter().fromJson),
      sourceText: json['source_text'] as String?,
      sourceTextHash: json['source_text_hash'] as String?,
      targetText: json['target_text'] as String?,
      targetTextHash: json['target_text_hash'] as String?,
      status: json['status'] as String? ?? 'pending',
      sourceCharCount: json['source_char_count'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['source_char_count']),
      targetCharCount: json['target_char_count'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['target_char_count']),
      sourceWordCount: json['source_word_count'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['source_word_count']),
      targetWordCount: json['target_word_count'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['target_word_count']),
      translatedBy: json['translated_by'] as String?,
      translatorUsername: json['translator_username'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewerUsername: json['reviewer_username'] as String?,
      contextInfo: json['context_info'] as String?,
      version: json['version'] == null
          ? 1
          : const FlexibleIntConverter().fromJson(json['version']),
      qualityScore: (json['quality_score'] as num?)?.toDouble(),
      issues: json['issues'] as String?,
      hasIssues: json['has_issues'] as bool? ?? false,
      characterCount: (json['character_count'] as num?)?.toInt(),
      wordCount: (json['word_count'] as num?)?.toInt(),
      translatorId: json['translator_id'] as String?,
      reviewerId: json['reviewer_id'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      deletedAt: const NullableTimesConverter().fromJson(json['deleted_at']),
      deletedBy: json['deleted_by'] as String?,
      assignedAt: const NullableTimesConverter().fromJson(json['assigned_at']),
      translatedAt:
          const NullableTimesConverter().fromJson(json['translated_at']),
      reviewedAt: const NullableTimesConverter().fromJson(json['reviewed_at']),
      approvedAt: const NullableTimesConverter().fromJson(json['approved_at']),
      createdAt: const NullableTimesConverter().fromJson(json['created_at']),
      updatedAt: const NullableTimesConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$$TranslationEntryModelImplToJson(
        _$TranslationEntryModelImpl instance) =>
    <String, dynamic>{
      'id': _$JsonConverterToJson<dynamic, int>(
          instance.id, const FlexibleIntConverter().toJson),
      'uuid': instance.uuid,
      'project_id': instance.projectId,
      'key': instance.key,
      'entry_key': instance.entryKey,
      'source_language_id': _$JsonConverterToJson<dynamic, int>(
          instance.sourceLanguageId, const FlexibleIntConverter().toJson),
      'target_language_id': _$JsonConverterToJson<dynamic, int>(
          instance.targetLanguageId, const FlexibleIntConverter().toJson),
      'language_code': _$JsonConverterToJson<String, LanguageEnum>(
          instance.languageCode, const LanguageEnumConverter().toJson),
      'source_text': instance.sourceText,
      'source_text_hash': instance.sourceTextHash,
      'target_text': instance.targetText,
      'target_text_hash': instance.targetTextHash,
      'status': instance.status,
      'source_char_count':
          const FlexibleIntConverter().toJson(instance.sourceCharCount),
      'target_char_count':
          const FlexibleIntConverter().toJson(instance.targetCharCount),
      'source_word_count':
          const FlexibleIntConverter().toJson(instance.sourceWordCount),
      'target_word_count':
          const FlexibleIntConverter().toJson(instance.targetWordCount),
      'translated_by': instance.translatedBy,
      'translator_username': instance.translatorUsername,
      'reviewed_by': instance.reviewedBy,
      'reviewer_username': instance.reviewerUsername,
      'context_info': instance.contextInfo,
      'version': const FlexibleIntConverter().toJson(instance.version),
      'quality_score': instance.qualityScore,
      'issues': instance.issues,
      'has_issues': instance.hasIssues,
      'character_count': instance.characterCount,
      'word_count': instance.wordCount,
      'translator_id': instance.translatorId,
      'reviewer_id': instance.reviewerId,
      'is_deleted': instance.isDeleted,
      'deleted_at': const NullableTimesConverter().toJson(instance.deletedAt),
      'deleted_by': instance.deletedBy,
      'assigned_at': const NullableTimesConverter().toJson(instance.assignedAt),
      'translated_at':
          const NullableTimesConverter().toJson(instance.translatedAt),
      'reviewed_at': const NullableTimesConverter().toJson(instance.reviewedAt),
      'approved_at': const NullableTimesConverter().toJson(instance.approvedAt),
      'created_at': const NullableTimesConverter().toJson(instance.createdAt),
      'updated_at': const NullableTimesConverter().toJson(instance.updatedAt),
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
