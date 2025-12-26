// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationHistoryModelImpl _$$TranslationHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationHistoryModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      entryId: const FlexibleIntConverter().fromJson(json['entry_id']),
      entryUuid: json['entry_uuid'] as String?,
      projectId: const FlexibleIntConverter().fromJson(json['project_id']),
      oldTargetText: json['old_target_text'] as String?,
      newTargetText: json['new_target_text'] as String,
      oldStatus: json['old_status'] as String?,
      newStatus: json['new_status'] as String?,
      action: json['action'] as String,
      changedBy: json['changed_by'] as String,
      changedAt: const TimesConverter().fromJson(json['changed_at'] as Object),
      reason: json['reason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TranslationHistoryModelImplToJson(
        _$TranslationHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIntConverter().toJson(instance.id),
      'entry_id': const FlexibleIntConverter().toJson(instance.entryId),
      'entry_uuid': instance.entryUuid,
      'project_id': const FlexibleIntConverter().toJson(instance.projectId),
      'old_target_text': instance.oldTargetText,
      'new_target_text': instance.newTargetText,
      'old_status': instance.oldStatus,
      'new_status': instance.newStatus,
      'action': instance.action,
      'changed_by': instance.changedBy,
      'changed_at': const TimesConverter().toJson(instance.changedAt),
      'reason': instance.reason,
      'metadata': instance.metadata,
    };
