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
    @JsonKey(name: 'project_id') required String projectId,

    /// 条目键（优化字段）
    @JsonKey(name: 'entry_key') required String entryKey,

    /// 源语言ID
    @JsonKey(name: 'source_language') @LanguageEnumConverter() @Default(LanguageEnum.enUS) LanguageEnum sourceLanguage,

    /// 目标语言ID
    @JsonKey(name: 'target_language') @LanguageEnumConverter() required LanguageEnum targetLanguage,

    /// 源文本
    @JsonKey(name: 'source_text') required String sourceText,

    /// 目标文本
    @JsonKey(name: 'target_text') required String targetText,

    /// 状态 (pending, completed, reviewing, approved)
    @JsonKey(name: 'status') @TranslationStatusEnumConverter() required TranslationStatusEnum status,

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

    /// 最大长度限制
    @JsonKey(name: 'max_length') int? maxLength,

    /// 是否为复数形式
    @JsonKey(name: 'is_plural') @Default(false) bool isPlural,

    /// 复数形式（JSON字符串）
    @JsonKey(name: 'plural_forms') String? pluralForms,

    /// 排序索引
    @JsonKey(name: 'sort_index') @Default(0.0) int sortIndex,

    /// 目标语言ID（用于兼容旧代码）
    @JsonKey(name: 'target_language_id') int? targetLanguageId,

    /// 删除时间
    @JsonKey(name: 'deleted_at') @NullableTimesConverter() DateTime? deletedAt,

    /// 创建时间
    @JsonKey(name: 'created_at') @NullableTimesConverter() DateTime? createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @NullableTimesConverter() DateTime? updatedAt,
  }) = _TranslationEntryModel;

  const TranslationEntryModel._();

  /// ID 别名（指向 uuid）
  String get id => uuid;

  /// key 别名（指向 entryKey）
  String get key => entryKey;

  factory TranslationEntryModel.fromJson(Map<String, dynamic> json) => _$TranslationEntryModelFromJson(json);
}
