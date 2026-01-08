import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'translation_target_language_model.freezed.dart';
part 'translation_target_language_model.g.dart';

@freezed
class TranslationTargetLanguageModel with _$TranslationTargetLanguageModel {
  const factory TranslationTargetLanguageModel({
    /// 语言
    @JsonKey(name: 'language') @LanguageEnumConverter() required LanguageEnum language,

    /// 翻译文本
    @JsonKey(name: 'text') required String text,
  }) = _TranslationTargetLanguageModel;

  const TranslationTargetLanguageModel._();

  /// 状态
  TranslationStatusEnum get status => text.isEmpty ? TranslationStatusEnum.pending : TranslationStatusEnum.completed;

  factory TranslationTargetLanguageModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationTargetLanguageModelFromJson(json);
}
