import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'language_model.freezed.dart';
part 'language_model.g.dart';

/// 语言模型
@freezed
class LanguageModel with _$LanguageModel {
  const factory LanguageModel({
    /// 语言ID
    @JsonKey(name: 'id') required int id,

    /// 语言代码
    @JsonKey(name: 'code') @LanguageEnumConverter() required LanguageEnum code,

    /// 语言名称
    @JsonKey(name: 'name') required String name,

    /// 语言本地名称
    @JsonKey(name: 'native_name') String? nativeName,

    /// 语言标志emoji
    @JsonKey(name: 'flag_emoji') String? flagEmoji,

    /// 是否为活跃语言
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    ///  是否为从右到左语言
    @JsonKey(name: 'is_rtl') @Default(false) bool isRtl,

    /// 排序顺序
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,

    /// 是否为主语言
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
  }) = _LanguageModel;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => _$LanguageModelFromJson(json);
}
