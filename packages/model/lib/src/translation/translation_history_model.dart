import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'translation_history_model.freezed.dart';
part 'translation_history_model.g.dart';

/// 翻译历史模型
@freezed
class TranslationHistoryModel with _$TranslationHistoryModel {
  const factory TranslationHistoryModel({
    /// 历史记录ID（BIGSERIAL）
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 翻译条目ID
    @JsonKey(name: 'entry_id') @FlexibleIntConverter() required int entryId,

    /// 翻译条目UUID
    @JsonKey(name: 'entry_uuid') String? entryUuid,

    /// 项目ID
    @JsonKey(name: 'project_id') @FlexibleIntConverter() required int projectId,

    /// 旧的目标文本
    @JsonKey(name: 'old_target_text') String? oldTargetText,

    /// 新的目标文本
    @JsonKey(name: 'new_target_text') required String newTargetText,

    /// 旧的状态
    @JsonKey(name: 'old_status') String? oldStatus,

    /// 新的状态
    @JsonKey(name: 'new_status') String? newStatus,

    /// 操作类型
    @JsonKey(name: 'action') required String action,

    /// 修改者ID
    @JsonKey(name: 'changed_by') required String changedBy,

    /// 修改时间
    @JsonKey(name: 'changed_at') @TimesConverter() required DateTime changedAt,

    /// 修改原因
    @JsonKey(name: 'reason') String? reason,

    /// 元数据（JSONB格式）
    @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
  }) = _TranslationHistoryModel;

  factory TranslationHistoryModel.fromJson(Map<String, dynamic> json) => _$TranslationHistoryModelFromJson(json);
}
