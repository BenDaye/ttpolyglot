import 'package:freezed_annotation/freezed_annotation.dart';

part 'language_model.freezed.dart';
part 'language_model.g.dart';

/// 语言模型
@freezed
class LanguageModel with _$LanguageModel {
  const factory LanguageModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'native_name') String? nativeName,
    @JsonKey(name: 'flag_emoji') String? flagEmoji,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_rtl') @Default(false) bool isRtl,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _LanguageModel;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => _$LanguageModelFromJson(json);
}

/// 创建语言请求模型
@freezed
class CreateLanguageRequest with _$CreateLanguageRequest {
  const factory CreateLanguageRequest({
    required String code,
    required String name,
    String? nativeName,
    String? flagEmoji,
    @Default(true) bool isActive,
    @Default(false) bool isRtl,
    @Default(0) int sortOrder,
  }) = _CreateLanguageRequest;

  factory CreateLanguageRequest.fromJson(Map<String, dynamic> json) => _$CreateLanguageRequestFromJson(json);
}

/// 更新语言请求模型
@freezed
class UpdateLanguageRequest with _$UpdateLanguageRequest {
  const factory UpdateLanguageRequest({
    String? code,
    String? name,
    String? nativeName,
    String? flagEmoji,
    bool? isActive,
    bool? isRtl,
    int? sortOrder,
  }) = _UpdateLanguageRequest;

  factory UpdateLanguageRequest.fromJson(Map<String, dynamic> json) => _$UpdateLanguageRequestFromJson(json);
}
