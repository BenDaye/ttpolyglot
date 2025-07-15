import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';

/// 语言模型
class Language extends Equatable {
  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    this.isRtl = false,
    this.sortIndex = 0,
  });

  /// 语言代码 (如: en-US, zh-CN, ja-JP)
  final String code;

  /// 英文名称 (如: English, Chinese, Japanese)
  final String name;

  /// 本地名称 (如: English, 中文, 日本語)
  final String nativeName;

  /// 是否为从右到左的语言
  final bool isRtl;

  /// 排序索引
  final int sortIndex;

  static const enUS = Language(code: 'en-US', name: 'English (United States)', nativeName: 'English (United States)', sortIndex: 11);
  static const zhCN = Language(code: 'zh-CN', name: 'Chinese (Simplified)', nativeName: '中文（简体）', sortIndex: 21);
  static const jaJP = Language(code: 'ja-JP', name: 'Japanese', nativeName: '日本語', sortIndex: 31);
  static const koKR = Language(code: 'ko-KR', name: 'Korean', nativeName: '한국어', sortIndex: 41);
  static const frFR = Language(code: 'fr-FR', name: 'French (France)', nativeName: 'Français (France)', sortIndex: 51);
  static const deDE = Language(code: 'de-DE', name: 'German', nativeName: 'Deutsch', sortIndex: 61);
  static const esES = Language(code: 'es-ES', name: 'Spanish (Spain)', nativeName: 'Español (España)', sortIndex: 71);
  static const itIT = Language(code: 'it-IT', name: 'Italian', nativeName: 'Italiano', sortIndex: 81);

  /// 获取所有支持的语言列表
  static List<Language> get supportedLanguages => [
        // 英语
        enUS,
        const Language(code: 'en-GB', name: 'English (United Kingdom)', nativeName: 'English (United Kingdom)', sortIndex: 12),
        const Language(code: 'en-AU', name: 'English (Australia)', nativeName: 'English (Australia)', sortIndex: 13),
        const Language(code: 'en-CA', name: 'English (Canada)', nativeName: 'English (Canada)', sortIndex: 14),

        // 中文
        zhCN,
        const Language(code: 'zh-TW', name: 'Chinese (Traditional)', nativeName: '中文（繁體）', sortIndex: 22),
        const Language(code: 'zh-HK', name: 'Chinese (Hong Kong)', nativeName: '中文（香港）', sortIndex: 23),

        // 日语
        jaJP,

        // 韩语
        koKR,

        // 法语
        frFR,
        const Language(code: 'fr-CA', name: 'French (Canada)', nativeName: 'Français (Canada)', sortIndex: 52),

        // 德语
        deDE,
        const Language(code: 'de-AT', name: 'German (Austria)', nativeName: 'Deutsch (Österreich)', sortIndex: 62),
        const Language(code: 'de-CH', name: 'German (Switzerland)', nativeName: 'Deutsch (Schweiz)', sortIndex: 63),

        // 西班牙语
        esES,
        const Language(code: 'es-MX', name: 'Spanish (Mexico)', nativeName: 'Español (México)', sortIndex: 72),
        const Language(code: 'es-AR', name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', sortIndex: 73),

        // 意大利语
        itIT,

        // 葡萄牙语
        const Language(code: 'pt-PT', name: 'Portuguese (Portugal)', nativeName: 'Português (Portugal)', sortIndex: 91),
        const Language(code: 'pt-BR', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', sortIndex: 92),

        // 俄语
        const Language(code: 'ru-RU', name: 'Russian', nativeName: 'Русский', sortIndex: 101),

        // 阿拉伯语
        const Language(code: 'ar-SA', name: 'Arabic (Saudi Arabia)', nativeName: 'العربية (السعودية)', isRtl: true, sortIndex: 111),
        const Language(code: 'ar-EG', name: 'Arabic (Egypt)', nativeName: 'العربية (مصر)', isRtl: true, sortIndex: 112),

        // 希伯来语
        const Language(code: 'he-IL', name: 'Hebrew', nativeName: 'עברית', isRtl: true, sortIndex: 121),

        // 泰语
        const Language(code: 'th-TH', name: 'Thai', nativeName: 'ไทย', sortIndex: 131),

        // 越南语
        const Language(code: 'vi-VN', name: 'Vietnamese', nativeName: 'Tiếng Việt', sortIndex: 141),

        // 印地语
        const Language(code: 'hi-IN', name: 'Hindi', nativeName: 'हिन्दी', sortIndex: 151),

        // 荷兰语
        const Language(code: 'nl-NL', name: 'Dutch', nativeName: 'Nederlands', sortIndex: 161),

        // 瑞典语
        const Language(code: 'sv-SE', name: 'Swedish', nativeName: 'Svenska', sortIndex: 171),

        // 挪威语
        const Language(code: 'no-NO', name: 'Norwegian', nativeName: 'Norsk', sortIndex: 181),

        // 丹麦语
        const Language(code: 'da-DK', name: 'Danish', nativeName: 'Dansk', sortIndex: 191),

        // 芬兰语
        const Language(code: 'fi-FI', name: 'Finnish', nativeName: 'Suomi', sortIndex: 201),

        // 波兰语
        const Language(code: 'pl-PL', name: 'Polish', nativeName: 'Polski', sortIndex: 211),

        // 土耳其语
        const Language(code: 'tr-TR', name: 'Turkish', nativeName: 'Türkçe', sortIndex: 221),

        // 印尼语
        const Language(code: 'id-ID', name: 'Indonesian', nativeName: 'Bahasa Indonesia', sortIndex: 231),

        // 马来语
        const Language(code: 'ms-MY', name: 'Malay', nativeName: 'Bahasa Melayu', sortIndex: 241),

        // 乌克兰语
        const Language(code: 'uk-UA', name: 'Ukrainian', nativeName: 'Українська', sortIndex: 251),

        // 捷克语
        const Language(code: 'cs-CZ', name: 'Czech', nativeName: 'Čeština', sortIndex: 261),

        // 匈牙利语
        const Language(code: 'hu-HU', name: 'Hungarian', nativeName: 'Magyar', sortIndex: 271),

        // 罗马尼亚语
        const Language(code: 'ro-RO', name: 'Romanian', nativeName: 'Română', sortIndex: 281),

        // 保加利亚语
        const Language(code: 'bg-BG', name: 'Bulgarian', nativeName: 'Български', sortIndex: 291),

        // 克罗地亚语
        const Language(code: 'hr-HR', name: 'Croatian', nativeName: 'Hrvatski', sortIndex: 301),

        // 斯洛伐克语
        const Language(code: 'sk-SK', name: 'Slovak', nativeName: 'Slovenčina', sortIndex: 311),

        // 斯洛文尼亚语
        const Language(code: 'sl-SI', name: 'Slovenian', nativeName: 'Slovenščina', sortIndex: 321),

        // 爱沙尼亚语
        const Language(code: 'et-EE', name: 'Estonian', nativeName: 'Eesti', sortIndex: 331),

        // 拉脱维亚语
        const Language(code: 'lv-LV', name: 'Latvian', nativeName: 'Latviešu', sortIndex: 341),

        // 立陶宛语
        const Language(code: 'lt-LT', name: 'Lithuanian', nativeName: 'Lietuvių', sortIndex: 351),
      ];

  /// 验证语言代码格式是否正确 (必须是 language_code-country_code 格式)
  static bool isValidLanguageCode(String code) {
    try {
      // 检查格式是否为 xx-XX 形式
      final RegExp languageCodePattern = RegExp(r'^[a-z]{2}-[A-Z]{2}$');
      final isValid = languageCodePattern.hasMatch(code);

      if (!isValid) {
        developer.log('isValidLanguageCode',
            error: 'Invalid language code format: $code. Must be in format: xx-XX (e.g., en-US, zh-CN)');
      }

      return isValid;
    } catch (error, stackTrace) {
      developer.log('isValidLanguageCode', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 根据语言代码获取支持的语言
  static Language? getLanguageByCode(String code) {
    try {
      if (!isValidLanguageCode(code)) {
        return null;
      }

      return supportedLanguages.where((lang) => lang.code == code).firstOrNull;
    } catch (error, stackTrace) {
      developer.log('getLanguageByCode', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 检查语言代码是否被支持
  static bool isLanguageSupported(String code) {
    try {
      return getLanguageByCode(code) != null;
    } catch (error, stackTrace) {
      developer.log('isLanguageSupported', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 获取按语言分组的支持语言列表
  static Map<String, List<Language>> get supportedLanguagesByGroup {
    try {
      final Map<String, List<Language>> grouped = {};

      for (final language in supportedLanguages) {
        final languageCode = language.code.split('-')[0];
        grouped.putIfAbsent(languageCode, () => []).add(language);
      }

      return grouped;
    } catch (error, stackTrace) {
      developer.log('supportedLanguagesByGroup', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 搜索支持的语言
  static List<Language> searchSupportedLanguages(String query) {
    try {
      if (query.isEmpty) {
        return supportedLanguages;
      }

      final lowerQuery = query.toLowerCase();
      return supportedLanguages.where((language) {
        return language.code.toLowerCase().contains(lowerQuery) ||
            language.name.toLowerCase().contains(lowerQuery) ||
            language.nativeName.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (error, stackTrace) {
      developer.log('searchSupportedLanguages', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  /// 复制并更新语言信息
  Language copyWith({
    String? code,
    String? name,
    String? nativeName,
    bool? isRtl,
    int? sortIndex,
  }) {
    return Language(
      code: code ?? this.code,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      isRtl: isRtl ?? this.isRtl,
      sortIndex: sortIndex ?? this.sortIndex,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'isRtl': isRtl,
      'sortIndex': sortIndex,
    };
  }

  /// 从 JSON 创建
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String,
      isRtl: json['isRtl'] as bool? ?? false,
      sortIndex: json['sortIndex'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [code, name, nativeName, isRtl, sortIndex];

  @override
  String toString() => 'Language(code: $code, name: $name, nativeName: $nativeName, isRtl: $isRtl, sortIndex: $sortIndex)';
}
