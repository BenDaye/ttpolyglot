import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

enum LanguageEnum {
  enUS('en-US', 'English (US)', 'English (US)', '🇺🇸'),
  zhCN('zh-CN', 'Chinese (Simplified)', '简体中文', '🇨🇳'),
  zhTW('zh-TW', 'Chinese (Traditional)', '繁體中文', '🇨🇳'),
  thTH('th-TH', 'Thai', 'ภาษาไทย', '🇹🇭'),
  jaJP('ja-JP', 'Japanese', '日本語', '🇯🇵'),
  koKR('ko-KR', 'Korean', '한국어', '🇰🇷'),
  myMM('my-MM', 'Myanmar', 'မြန်မာဘာသာ', '🇲🇲'),
  trTR('tr-TR', 'Turkish', 'Türkçe', '🇹🇷'),
  deDE('de-DE', 'German', 'Deutschland', '🇩🇪'),
  svSE('sv-SE', 'Swedish', 'Svenska', '🇸🇪');

  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;

  const LanguageEnum(this.code, this.name, this.nativeName, this.flagEmoji);

  /// 根据值获取对应的枚举
  static LanguageEnum fromValue(String value) {
    return LanguageEnum.values.firstWhere(
      (item) => item.code == value,
      orElse: () => LanguageEnum.enUS,
    );
  }

  /// 获取所有语言的数组格式
  static List<LanguageModel> toArray() {
    return LanguageEnum.values.asMap().entries.map((entry) {
      final index = entry.key;
      final lang = entry.value;

      return LanguageModel(
        id: index + 1,
        code: lang,
        name: lang.name,
        nativeName: lang.nativeName,
        flagEmoji: lang.flagEmoji,
        isActive: true,
        isRtl: false,
        sortOrder: index + 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
  }
}

/// LanguageEnum 的 JSON 转换器
class LanguageEnumConverter implements JsonConverter<LanguageEnum, String> {
  const LanguageEnumConverter();

  @override
  LanguageEnum fromJson(String json) {
    return LanguageEnum.fromValue(json);
  }

  @override
  String toJson(LanguageEnum object) => object.code;
}
