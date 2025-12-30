import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

enum LanguageEnum {
  enUS('en-US', 'English (US)', 'English (US)', '🇺🇸', 1, 1),
  zhCN('zh-CN', 'Chinese (Simplified)', '简体中文', '🇨🇳', 2, 2),
  zhTW('zh-TW', 'Chinese (Traditional)', '繁體中文', '🇨🇳', 3, 3),
  thTH('th-TH', 'Thai', 'ภาษาไทย', '🇹🇭', 4, 4),
  jaJP('ja-JP', 'Japanese', '日本語', '🇯🇵', 5, 5),
  koKR('ko-KR', 'Korean', '한국어', '🇰🇷', 6, 6),
  myMM('my-MM', 'Myanmar', 'မြန်မာဘာသာ', '🇲🇲', 7, 7),
  trTR('tr-TR', 'Turkish', 'Türkçe', '🇹🇷', 8, 8),
  deDE('de-DE', 'German', 'Deutschland', '🇩🇪', 9, 9),
  svSE('sv-SE', 'Swedish', 'Svenska', '🇸🇪', 10, 10);

  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;
  final int id;
  final int sortIndex;

  const LanguageEnum(this.code, this.name, this.nativeName, this.flagEmoji, this.id, this.sortIndex);

  /// 根据值获取对应的枚举
  static LanguageEnum fromValue(String value) {
    return LanguageEnum.values.firstWhere(
      (item) => item.code == value,
      orElse: () => LanguageEnum.enUS,
    );
  }

  /// 根据ID获取对应的枚举
  static LanguageEnum? fromId(int id) {
    try {
      return LanguageEnum.values.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取所有支持的语言列表
  static List<LanguageEnum> get supportedLanguages => LanguageEnum.values;

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
