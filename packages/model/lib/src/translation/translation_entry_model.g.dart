// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationEntryDtoImpl _$$TranslationEntryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationEntryDtoImpl(
      id: json['id'] as String?,
      projectId: json['project_id'] as String,
      entryKey: json['entry_key'] as String,
      languageCode: json['language_code'] as String,
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
      assignedAt: json['assigned_at'] == null
          ? null
          : DateTime.parse(json['assigned_at'] as String),
      translatedAt: json['translated_at'] == null
          ? null
          : DateTime.parse(json['translated_at'] as String),
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      languageName: json['language_name'] as String?,
      languageNativeName: json['language_native_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TranslationEntryDtoImplToJson(
        _$TranslationEntryDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project_id': instance.projectId,
      'entry_key': instance.entryKey,
      'language_code': instance.languageCode,
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
      'assigned_at': instance.assignedAt?.toIso8601String(),
      'translated_at': instance.translatedAt?.toIso8601String(),
      'reviewed_at': instance.reviewedAt?.toIso8601String(),
      'approved_at': instance.approvedAt?.toIso8601String(),
      'language_name': instance.languageName,
      'language_native_name': instance.languageNativeName,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
