

import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';
import 'base_seed.dart';

/// 种子: 004 - 插入默认语言
/// 创建时间: 2024-12-26
/// 描述: 插入常用的默认语言数据
class Seed004InsertLanguages extends BaseSeed {
  @override
  String get name => '004_insert_languages';

  @override
  String get description => '插入默认语言';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> run() async {
    try {
      LoggerUtils.info('开始插入默认语言数据');

      // 定义默认语言列表
      final languages = [
        // 中文
        {
          'code': 'zh-CN',
          'name': 'Chinese (Simplified)',
          'native_name': '简体中文',
          'flag_emoji': '🇨🇳',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 1,
        },
        {
          'code': 'zh-TW',
          'name': 'Chinese (Traditional)',
          'native_name': '繁體中文',
          'flag_emoji': '🇹🇼',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 2,
        },

        // 英语
        {
          'code': 'en-US',
          'name': 'English (US)',
          'native_name': 'English (US)',
          'flag_emoji': '🇺🇸',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 3,
        },
        {
          'code': 'en-GB',
          'name': 'English (UK)',
          'native_name': 'English (UK)',
          'flag_emoji': '🇬🇧',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 4,
        },

        // 日语
        {
          'code': 'ja-JP',
          'name': 'Japanese',
          'native_name': '日本語',
          'flag_emoji': '🇯🇵',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 5,
        },

        // 韩语
        {
          'code': 'ko-KR',
          'name': 'Korean',
          'native_name': '한국어',
          'flag_emoji': '🇰🇷',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 6,
        },

        // 法语
        {
          'code': 'fr-FR',
          'name': 'French',
          'native_name': 'Français',
          'flag_emoji': '🇫🇷',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 7,
        },

        // 德语
        {
          'code': 'de-DE',
          'name': 'German',
          'native_name': 'Deutsch',
          'flag_emoji': '🇩🇪',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 8,
        },

        // 西班牙语
        {
          'code': 'es-ES',
          'name': 'Spanish (Spain)',
          'native_name': 'Español (España)',
          'flag_emoji': '🇪🇸',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 9,
        },
        {
          'code': 'es-MX',
          'name': 'Spanish (Mexico)',
          'native_name': 'Español (México)',
          'flag_emoji': '🇲🇽',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 10,
        },

        // 意大利语
        {
          'code': 'it-IT',
          'name': 'Italian',
          'native_name': 'Italiano',
          'flag_emoji': '🇮🇹',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 11,
        },

        // 葡萄牙语
        {
          'code': 'pt-BR',
          'name': 'Portuguese (Brazil)',
          'native_name': 'Português (Brasil)',
          'flag_emoji': '🇧🇷',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 12,
        },
        {
          'code': 'pt-PT',
          'name': 'Portuguese (Portugal)',
          'native_name': 'Português (Portugal)',
          'flag_emoji': '🇵🇹',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 13,
        },

        // 俄语
        {
          'code': 'ru-RU',
          'name': 'Russian',
          'native_name': 'Русский',
          'flag_emoji': '🇷🇺',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 14,
        },

        // 阿拉伯语
        {
          'code': 'ar-SA',
          'name': 'Arabic (Saudi Arabia)',
          'native_name': 'العربية',
          'flag_emoji': '🇸🇦',
          'is_active': true,
          'is_rtl': true,
          'sort_order': 15,
        },

        // 印地语
        {
          'code': 'hi-IN',
          'name': 'Hindi',
          'native_name': 'हिन्दी',
          'flag_emoji': '🇮🇳',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 16,
        },

        // 泰语
        {
          'code': 'th-TH',
          'name': 'Thai',
          'native_name': 'ไทย',
          'flag_emoji': '🇹🇭',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 17,
        },

        // 越南语
        {
          'code': 'vi-VN',
          'name': 'Vietnamese',
          'native_name': 'Tiếng Việt',
          'flag_emoji': '🇻🇳',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 18,
        },

        // 印尼语
        {
          'code': 'id-ID',
          'name': 'Indonesian',
          'native_name': 'Bahasa Indonesia',
          'flag_emoji': '🇮🇩',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 19,
        },

        // 土耳其语
        {
          'code': 'tr-TR',
          'name': 'Turkish',
          'native_name': 'Türkçe',
          'flag_emoji': '🇹🇷',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 20,
        },

        // 荷兰语
        {
          'code': 'nl-NL',
          'name': 'Dutch',
          'native_name': 'Nederlands',
          'flag_emoji': '🇳🇱',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 21,
        },

        // 波兰语
        {
          'code': 'pl-PL',
          'name': 'Polish',
          'native_name': 'Polski',
          'flag_emoji': '🇵🇱',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 22,
        },

        // 瑞典语
        {
          'code': 'sv-SE',
          'name': 'Swedish',
          'native_name': 'Svenska',
          'flag_emoji': '🇸🇪',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 23,
        },

        // 丹麦语
        {
          'code': 'da-DK',
          'name': 'Danish',
          'native_name': 'Dansk',
          'flag_emoji': '🇩🇰',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 24,
        },

        // 挪威语
        {
          'code': 'no-NO',
          'name': 'Norwegian',
          'native_name': 'Norsk',
          'flag_emoji': '🇳🇴',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 25,
        },

        // 芬兰语
        {
          'code': 'fi-FI',
          'name': 'Finnish',
          'native_name': 'Suomi',
          'flag_emoji': '🇫🇮',
          'is_active': true,
          'is_rtl': false,
          'sort_order': 26,
        },
      ];

      // 插入语言数据
      await insertData('languages', languages);

      LoggerUtils.info('默认语言数据插入完成，共 ${languages.length} 种语言');
    } catch (error, stackTrace) {
      LoggerUtils.error('插入默认语言数据失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
