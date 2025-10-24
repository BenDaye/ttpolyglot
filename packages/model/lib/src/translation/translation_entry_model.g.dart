// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationEntryModelImpl _$$TranslationEntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationEntryModelImpl(
      id: json['id'] as String?,
      projectId: json['project_id'] as String,
      entryKey: json['entry_key'] as String,
      languageCode: const LanguageEnumConverter()
          .fromJson(json['language_code'] as String),
      sourceText: json['source_text'] as String?,
      targetText: json['target_text'] as String?,
      translatorId: json['translator_id'] as String?,
      translatorUsername: json['translator_username'] as String?,
      reviewerId: json['reviewer_id'] as String?,
      reviewerUsername: json['reviewer_username'] as String?,
      contextInfo: json['context_info'] as String?,
      status: json['status'] as String? ?? 'pending',
      version: (json['version'] as num?)?.toInt() ?? 1,
      qualityScore: (json['quality_score'] as num?)?.toDouble(),
      issues: json['issues'] as String?,
      hasIssues: json['has_issues'] as bool? ?? false,
      characterCount: (json['character_count'] as num?)?.toInt(),
      wordCount: (json['word_count'] as num?)?.toInt(),
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
      'id': instance.id,
      'project_id': instance.projectId,
      'entry_key': instance.entryKey,
      'language_code':
          const LanguageEnumConverter().toJson(instance.languageCode),
      'source_text': instance.sourceText,
      'target_text': instance.targetText,
      'translator_id': instance.translatorId,
      'translator_username': instance.translatorUsername,
      'reviewer_id': instance.reviewerId,
      'reviewer_username': instance.reviewerUsername,
      'context_info': instance.contextInfo,
      'status': instance.status,
      'version': instance.version,
      'quality_score': instance.qualityScore,
      'issues': instance.issues,
      'has_issues': instance.hasIssues,
      'character_count': instance.characterCount,
      'word_count': instance.wordCount,
      'assigned_at': const NullableTimesConverter().toJson(instance.assignedAt),
      'translated_at':
          const NullableTimesConverter().toJson(instance.translatedAt),
      'reviewed_at': const NullableTimesConverter().toJson(instance.reviewedAt),
      'approved_at': const NullableTimesConverter().toJson(instance.approvedAt),
      'created_at': const NullableTimesConverter().toJson(instance.createdAt),
      'updated_at': const NullableTimesConverter().toJson(instance.updatedAt),
    };
