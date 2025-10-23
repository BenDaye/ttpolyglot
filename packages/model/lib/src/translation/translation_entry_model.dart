import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/enums/language_enum.dart';

part 'translation_entry_model.freezed.dart';
part 'translation_entry_model.g.dart';

/// 翻译条目数据传输对象
@freezed
class TranslationEntryModel with _$TranslationEntryModel {
  const factory TranslationEntryModel({
    /// 条目ID
    String? id,

    /// 项目ID
    @JsonKey(name: 'project_id') required String projectId,

    /// 条目键
    @JsonKey(name: 'entry_key') required String entryKey,

    /// 语言代码
    @JsonKey(name: 'language_code') @LanguageEnumConverter() required LanguageEnum languageCode,

    /// 源文本
    @JsonKey(name: 'source_text') String? sourceText,

    /// 目标文本
    @JsonKey(name: 'target_text') String? targetText,

    /// 翻译者ID
    @JsonKey(name: 'translator_id') String? translatorId,

    /// 翻译者用户名
    @JsonKey(name: 'translator_username') String? translatorUsername,

    /// 审核者ID
    @JsonKey(name: 'reviewer_id') String? reviewerId,

    /// 审核者用户名
    @JsonKey(name: 'reviewer_username') String? reviewerUsername,

    /// 上下文信息
    @JsonKey(name: 'context_info') String? contextInfo,

    /// 状态 (pending, completed, reviewing, approved)
    @Default('pending') String status,

    /// 版本号
    @Default(1) int version,

    /// 质量评分
    @JsonKey(name: 'quality_score') double? qualityScore,

    /// 问题列表
    String? issues,

    /// 是否有问题
    @JsonKey(name: 'has_issues') @Default(false) bool hasIssues,

    /// 字符数
    @JsonKey(name: 'character_count') int? characterCount,

    /// 单词数
    @JsonKey(name: 'word_count') int? wordCount,

    /// 分配时间
    @JsonKey(name: 'assigned_at') DateTime? assignedAt,

    /// 翻译完成时间
    @JsonKey(name: 'translated_at') DateTime? translatedAt,

    /// 审核时间
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,

    /// 批准时间
    @JsonKey(name: 'approved_at') DateTime? approvedAt,

    /// 创建时间
    @JsonKey(name: 'created_at') DateTime? createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
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
