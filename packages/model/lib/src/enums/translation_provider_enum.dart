import 'package:freezed_annotation/freezed_annotation.dart';

enum TranslationProviderEnum {
  google('google'),
  baidu('baidu'),
  youdao('youdao'),
  custom('custom');

  final String value;

  const TranslationProviderEnum(this.value);

  /// 根据值获取对应的枚举
  static TranslationProviderEnum fromValue(String value) {
    return TranslationProviderEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TranslationProviderEnum.google,
    );
  }
}

class TranslationProviderEnumConverter implements JsonConverter<TranslationProviderEnum, String> {
  const TranslationProviderEnumConverter();

  @override
  TranslationProviderEnum fromJson(String json) {
    return TranslationProviderEnum.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TranslationProviderEnum.google,
    );
  }

  @override
  String toJson(TranslationProviderEnum object) => object.name;
}
