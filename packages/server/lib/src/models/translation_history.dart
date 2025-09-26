import 'package:json_annotation/json_annotation.dart';

part 'translation_history.g.dart';

/// 翻译历史记录模型
@JsonSerializable()
class TranslationHistory {
  final String id;
  final String translationEntryId;
  final String? oldTargetText;
  final String? newTargetText;
  final String? oldStatus;
  final String? newStatus;
  final String changeType; // 'create', 'update', 'delete'
  final String? changedBy;
  final String? changeReason;
  final DateTime createdAt;

  TranslationHistory({
    required this.id,
    required this.translationEntryId,
    this.oldTargetText,
    this.newTargetText,
    this.oldStatus,
    this.newStatus,
    required this.changeType,
    this.changedBy,
    this.changeReason,
    required this.createdAt,
  });

  factory TranslationHistory.fromJson(Map<String, dynamic> json) => _$TranslationHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationHistoryToJson(this);

  factory TranslationHistory.fromMap(Map<String, dynamic> map) {
    return TranslationHistory(
      id: map['id'] as String,
      translationEntryId: map['translation_entry_id'] as String,
      oldTargetText: map['old_target_text'] as String?,
      newTargetText: map['new_target_text'] as String?,
      oldStatus: map['old_status'] as String?,
      newStatus: map['new_status'] as String?,
      changeType: map['change_type'] as String,
      changedBy: map['changed_by'] as String?,
      changeReason: map['change_reason'] as String?,
      createdAt: map['created_at'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'translation_entry_id': translationEntryId,
      'old_target_text': oldTargetText,
      'new_target_text': newTargetText,
      'old_status': oldStatus,
      'new_status': newStatus,
      'change_type': changeType,
      'changed_by': changedBy,
      'change_reason': changeReason,
      'created_at': createdAt,
    };
  }
}
