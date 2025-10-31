import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'translation_entry_model.freezed.dart';
part 'translation_entry_model.g.dart';

/// 翻译条目数据传输对象（优化版）
@freezed
class TranslationEntryModel with _$TranslationEntryModel {
  const factory TranslationEntryModel({
    /// 条目ID
    @JsonKey(name: 'id') @FlexibleIntConverter() int? id,

    /// UUID（用于分布式场景）
    @JsonKey(name: 'uuid') String? uuid,

    /// 项目ID
    @JsonKey(name: 'project_id') required String projectId,

    /// 原始键名
    @JsonKey(name: 'key') String? key,

    /// 条目键（优化字段）
    @JsonKey(name: 'entry_key') required String entryKey,

    /// 源语言ID
    @JsonKey(name: 'source_language_id') @FlexibleIntConverter() int? sourceLanguageId,

    /// 目标语言ID
    @JsonKey(name: 'target_language_id') @FlexibleIntConverter() int? targetLanguageId,

    /// 语言代码（保留兼容性，建议使用 sourceLanguageId 和 targetLanguageId）
    @JsonKey(name: 'language_code') @LanguageEnumConverter() LanguageEnum? languageCode,

    /// 源文本
    @JsonKey(name: 'source_text') String? sourceText,

    /// 源文本哈希值
    @JsonKey(name: 'source_text_hash') String? sourceTextHash,

    /// 目标文本
    @JsonKey(name: 'target_text') String? targetText,

    /// 目标文本哈希值
    @JsonKey(name: 'target_text_hash') String? targetTextHash,

    /// 状态 (pending, completed, reviewing, approved)
    @JsonKey(name: 'status') @Default('pending') String status,

    /// 源文本字符数
    @JsonKey(name: 'source_char_count') @FlexibleIntConverter() @Default(0) int sourceCharCount,

    /// 目标文本字符数
    @JsonKey(name: 'target_char_count') @FlexibleIntConverter() @Default(0) int targetCharCount,

    /// 源文本单词数
    @JsonKey(name: 'source_word_count') @FlexibleIntConverter() @Default(0) int sourceWordCount,

    /// 目标文本单词数
    @JsonKey(name: 'target_word_count') @FlexibleIntConverter() @Default(0) int targetWordCount,

    /// 翻译者ID
    @JsonKey(name: 'translated_by') String? translatedBy,

    /// 翻译者用户名（关联查询字段）
    @JsonKey(name: 'translator_username') String? translatorUsername,

    /// 审核者ID
    @JsonKey(name: 'reviewed_by') String? reviewedBy,

    /// 审核者用户名（关联查询字段）
    @JsonKey(name: 'reviewer_username') String? reviewerUsername,

    /// 上下文信息
    @JsonKey(name: 'context_info') String? contextInfo,

    /// 版本号（乐观锁）
    @JsonKey(name: 'version') @FlexibleIntConverter() @Default(1) int version,

    /// 质量评分
    @JsonKey(name: 'quality_score') double? qualityScore,

    /// 问题列表
    @JsonKey(name: 'issues') String? issues,

    /// 是否有问题
    @JsonKey(name: 'has_issues') @Default(false) bool hasIssues,

    /// 字符数（保留兼容性）
    @JsonKey(name: 'character_count') int? characterCount,

    /// 单词数（保留兼容性）
    @JsonKey(name: 'word_count') int? wordCount,

    /// 翻译者ID（保留兼容性）
    @JsonKey(name: 'translator_id') String? translatorId,

    /// 审核者ID（保留兼容性）
    @JsonKey(name: 'reviewer_id') String? reviewerId,

    /// 是否软删除
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,

    /// 删除时间
    @JsonKey(name: 'deleted_at') @NullableTimesConverter() DateTime? deletedAt,

    /// 删除者ID
    @JsonKey(name: 'deleted_by') String? deletedBy,

    /// 分配时间
    @JsonKey(name: 'assigned_at') @NullableTimesConverter() DateTime? assignedAt,

    /// 翻译完成时间
    @JsonKey(name: 'translated_at') @NullableTimesConverter() DateTime? translatedAt,

    /// 审核时间
    @JsonKey(name: 'reviewed_at') @NullableTimesConverter() DateTime? reviewedAt,

    /// 批准时间
    @JsonKey(name: 'approved_at') @NullableTimesConverter() DateTime? approvedAt,

    /// 创建时间
    @JsonKey(name: 'created_at') @NullableTimesConverter() DateTime? createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @NullableTimesConverter() DateTime? updatedAt,
  }) = _TranslationEntryModel;

  const TranslationEntryModel._();

  factory TranslationEntryModel.fromJson(Map<String, dynamic> json) => _$TranslationEntryModelFromJson(json);

  /// 是否已翻译
  bool get isTranslated => targetText != null && targetText!.isNotEmpty;

  /// 是否已完成
  bool get isCompleted => status == 'completed' || status == 'approved';

  /// 是否正在审核
  bool get isReviewing => status == 'reviewing';

  /// 是否已批准
  bool get isApproved => status == 'approved';

  /// 是否待处理
  bool get isPending => status == 'pending';

  /// 获取状态显示文本
  String getStatusText() {
    switch (status) {
      case 'pending':
        return '待翻译';
      case 'completed':
        return '已完成';
      case 'reviewing':
        return '审核中';
      case 'approved':
        return '已批准';
      default:
        return status;
    }
  }

  /// 获取翻译进度百分比
  double getProgress() {
    if (isApproved) return 100.0;
    if (isReviewing) return 75.0;
    if (isCompleted) return 50.0;
    if (isTranslated) return 25.0;
    return 0.0;
  }
}
