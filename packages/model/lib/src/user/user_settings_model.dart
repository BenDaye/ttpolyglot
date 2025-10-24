import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/converter/converters.dart';
import 'package:ttpolyglot_model/src/enums/language_enum.dart';

part 'user_settings_model.freezed.dart';
part 'user_settings_model.g.dart';

/// 用户设置数据传输对象
@freezed
class UserSettingsModel with _$UserSettingsModel {
  const factory UserSettingsModel({
    /// 语言设置
    @JsonKey(name: 'language_settings') required LanguageSettingsModel languageSettings,

    /// 通用设置
    @JsonKey(name: 'general_settings') required GeneralSettingsModel generalSettings,

    /// 翻译设置
    @JsonKey(name: 'translation_settings') required TranslationSettingsModel translationSettings,

    /// 创建时间
    @JsonKey(name: 'created_at') @NullableTimesConverter() DateTime? createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @NullableTimesConverter() DateTime? updatedAt,
  }) = _UserSettingsModel;

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) => _$UserSettingsModelFromJson(json);
}

/// 语言设置
@freezed
class LanguageSettingsModel with _$LanguageSettingsModel {
  const factory LanguageSettingsModel({
    /// 应用语言代码
    @JsonKey(name: 'language_code') @LanguageEnumConverter() LanguageEnum? languageCode,
  }) = _LanguageSettingsModel;

  factory LanguageSettingsModel.fromJson(Map<String, dynamic> json) => _$LanguageSettingsModelFromJson(json);
}

/// 通用设置
@freezed
class GeneralSettingsModel with _$GeneralSettingsModel {
  const factory GeneralSettingsModel({
    /// 自动保存
    @JsonKey(name: 'auto_save') @Default(true) bool autoSave,

    /// 通知
    @Default(true) bool notifications,
  }) = _GeneralSettingsModel;

  factory GeneralSettingsModel.fromJson(Map<String, dynamic> json) => _$GeneralSettingsModelFromJson(json);
}

/// 翻译设置
@freezed
class TranslationSettingsModel with _$TranslationSettingsModel {
  const factory TranslationSettingsModel({
    /// 翻译接口列表
    @Default([]) List<TranslationProviderConfigModel> providers,

    /// 最大重试次数
    @JsonKey(name: 'max_retries') @Default(3) int maxRetries,

    /// 超时时间（秒）
    @JsonKey(name: 'timeout_seconds') @Default(30) int timeoutSeconds,
  }) = _TranslationSettingsModel;

  factory TranslationSettingsModel.fromJson(Map<String, dynamic> json) => _$TranslationSettingsModelFromJson(json);
}

/// 翻译接口配置
@freezed
class TranslationProviderConfigModel with _$TranslationProviderConfigModel {
  const factory TranslationProviderConfigModel({
    /// 唯一ID
    required String id,

    /// 翻译提供商代码 (google/baidu/youdao/custom)
    required String provider,

    /// 自定义名称
    String? name,

    /// App ID
    @JsonKey(name: 'app_id') @Default('') String appId,

    /// App Key
    @JsonKey(name: 'app_key') @Default('') String appKey,

    /// API地址（自定义翻译用）
    @JsonKey(name: 'api_url') String? apiUrl,

    /// 是否为默认接口
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _TranslationProviderConfigModel;

  factory TranslationProviderConfigModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationProviderConfigModelFromJson(json);
}
