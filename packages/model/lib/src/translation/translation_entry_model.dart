import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'translation_entry_model.freezed.dart';
part 'translation_entry_model.g.dart';

/// 翻译条目数据传输对象（优化版）
@freezed
class TranslationEntryModel with _$TranslationEntryModel {
  const factory TranslationEntryModel({
    /// UUID（用于分布式场景）
    @JsonKey(name: 'uuid') required String uuid,

    /// 项目ID
    @JsonKey(name: 'project_id') required int projectId,

    /// 条目键
    @JsonKey(name: 'entry_key') required String entryKey,

    /// 源语言ID
    @JsonKey(name: 'source_language') @LanguageEnumConverter() @Default(LanguageEnum.enUS) LanguageEnum sourceLanguage,

    /// 源文本
    @JsonKey(name: 'source_text') required String sourceText,

    /// 翻译列表
    @JsonKey(name: 'target_languages') required List<TranslationTargetLanguageModel> targetLanguages,

    /// 翻译者ID
    @JsonKey(name: 'translated_by') String? translatedBy,

    /// 翻译者用户名（关联查询字段）
    @JsonKey(name: 'translator_username') String? translatorUsername,

    /// 审核者ID
    @JsonKey(name: 'reviewed_by') String? reviewedBy,

    /// 审核者用户名（关联查询字段）
    @JsonKey(name: 'reviewer_username') String? reviewerUsername,

    /// 上下文信息
    @JsonKey(name: 'context') @Default('') String context,

    /// 备注
    @JsonKey(name: 'comment') @Default('') String comment,

    /// 排序索引
    @JsonKey(name: 'sort_index') @Default(0) int sortIndex,

    /// 删除时间
    @JsonKey(name: 'deleted_at') @NullableTimesConverter() DateTime? deletedAt,

    /// 创建时间
    @JsonKey(name: 'created_at') @NullableTimesConverter() DateTime? createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @NullableTimesConverter() DateTime? updatedAt,
  }) = _TranslationEntryModel;

  const TranslationEntryModel._();

  factory TranslationEntryModel.fromJson(Map<String, dynamic> json) => _$TranslationEntryModelFromJson(json);
}
