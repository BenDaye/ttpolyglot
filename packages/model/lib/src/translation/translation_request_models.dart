import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'translation_request_models.freezed.dart';
part 'translation_request_models.g.dart';

/// 创建翻译键请求
@freezed
class CreateTranslationKeyRequest with _$CreateTranslationKeyRequest {
  const factory CreateTranslationKeyRequest({
    /// 项目ID
    @JsonKey(name: 'project_id') required String projectId,

    /// 条目键
    @JsonKey(name: 'entry_key') required String entryKey,

    /// 源语言
    @JsonKey(name: 'source_language') @LanguageEnumConverter() required LanguageEnum sourceLanguage,

    /// 目标语言列表
    @JsonKey(name: 'target_languages') @Default([]) List<LanguageEnum> targetLanguages,

    /// 源文本
    @JsonKey(name: 'source_text') required String sourceText,

    /// 上下文信息
    @JsonKey(name: 'context') String? context,

    /// 最大长度限制
    @JsonKey(name: 'max_length') int? maxLength,

    /// 是否为复数形式
    @JsonKey(name: 'is_plural') @Default(false) bool isPlural,

    /// 复数形式
    @JsonKey(name: 'plural_forms') String? pluralForms,
  }) = _CreateTranslationKeyRequest;

  factory CreateTranslationKeyRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTranslationKeyRequestFromJson(json);
}

/// 更新翻译请求
@freezed
class UpdateTranslationRequest with _$UpdateTranslationRequest {
  const factory UpdateTranslationRequest({
    /// 目标文本
    @JsonKey(name: 'target_text') String? targetText,

    /// 状态
    @JsonKey(name: 'status') @TranslationStatusEnumConverter() TranslationStatusEnum? status,

    /// 上下文信息
    @JsonKey(name: 'context') String? context,

    /// 备注
    @JsonKey(name: 'comment') String? comment,
  }) = _UpdateTranslationRequest;

  factory UpdateTranslationRequest.fromJson(Map<String, dynamic> json) => _$UpdateTranslationRequestFromJson(json);
}

/// 批量翻译请求
@freezed
class BatchTranslationRequest with _$BatchTranslationRequest {
  const factory BatchTranslationRequest({
    /// 翻译条目ID列表
    @JsonKey(name: 'entry_ids') required List<String> entryIds,

    /// 目标语言
    @JsonKey(name: 'target_language') @LanguageEnumConverter() LanguageEnum? targetLanguage,

    /// 翻译提供商
    @JsonKey(name: 'provider') @TranslationProviderEnumConverter() TranslationProviderEnum? provider,
  }) = _BatchTranslationRequest;

  factory BatchTranslationRequest.fromJson(Map<String, dynamic> json) => _$BatchTranslationRequestFromJson(json);
}
