import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'language_model.freezed.dart';
part 'language_model.g.dart';

/// 语言模型
@freezed
class LanguageModel with _$LanguageModel {
  const factory LanguageModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'code') @LanguageEnumConverter() required LanguageEnum code,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'native_name') String? nativeName,
    @JsonKey(name: 'flag_emoji') String? flagEmoji,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_rtl') @Default(false) bool isRtl,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,
  }) = _LanguageModel;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => _$LanguageModelFromJson(json);
}
