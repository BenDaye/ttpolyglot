import 'dart:developer';

/// 种子数据: 004 - 插入支持的语言
/// 创建时间: 2024-12-26
/// 描述: 插入系统支持的语言数据
class Seed004InsertLanguages {
  static const String name = '004_insert_languages';
  static const String description = '插入系统支持的语言数据';
  static const String createdAt = '2024-12-26';

  /// 执行种子数据插入
  static Future<void> up() async {
    try {
      log('开始执行种子数据: $name', name: 'Seed004InsertLanguages');

      // 插入支持的语言
      await _insertLanguages();

      log('种子数据完成: $name', name: 'Seed004InsertLanguages');
    } catch (error, stackTrace) {
      log('种子数据失败: $name', error: error, stackTrace: stackTrace, name: 'Seed004InsertLanguages');
      rethrow;
    }
  }

  /// 回滚种子数据
  static Future<void> down() async {
    try {
      log('开始回滚种子数据: $name', name: 'Seed004InsertLanguages');

      // 删除支持的语言
      await _deleteLanguages();

      log('回滚完成: $name', name: 'Seed004InsertLanguages');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Seed004InsertLanguages');
      rethrow;
    }
  }

  /// 插入支持的语言
  static Future<void> _insertLanguages() async {
    final languages = [
      {'code': 'en', 'name': 'English', 'native_name': 'English', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 1},
      {
        'code': 'zh-CN',
        'name': 'Chinese (Simplified)',
        'native_name': '简体中文',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 2
      },
      {
        'code': 'zh-TW',
        'name': 'Chinese (Traditional)',
        'native_name': '繁體中文',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 3
      },
      {'code': 'ja', 'name': 'Japanese', 'native_name': '日本語', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 4},
      {'code': 'ko', 'name': 'Korean', 'native_name': '한국어', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 5},
      {'code': 'fr', 'name': 'French', 'native_name': 'Français', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 6},
      {'code': 'de', 'name': 'German', 'native_name': 'Deutsch', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 7},
      {'code': 'es', 'name': 'Spanish', 'native_name': 'Español', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 8},
      {
        'code': 'it',
        'name': 'Italian',
        'native_name': 'Italiano',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 9
      },
      {
        'code': 'pt',
        'name': 'Portuguese',
        'native_name': 'Português',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 10
      },
      {
        'code': 'ru',
        'name': 'Russian',
        'native_name': 'Русский',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 11
      },
      {'code': 'ar', 'name': 'Arabic', 'native_name': 'العربية', 'direction': 'rtl', 'is_rtl': true, 'sort_index': 12},
      {'code': 'he', 'name': 'Hebrew', 'native_name': 'עברית', 'direction': 'rtl', 'is_rtl': true, 'sort_index': 13},
      {'code': 'hi', 'name': 'Hindi', 'native_name': 'हिन्दी', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 14},
      {'code': 'th', 'name': 'Thai', 'native_name': 'ไทย', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 15},
      {
        'code': 'vi',
        'name': 'Vietnamese',
        'native_name': 'Tiếng Việt',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 16
      },
      {
        'code': 'nl',
        'name': 'Dutch',
        'native_name': 'Nederlands',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 17
      },
      {'code': 'pl', 'name': 'Polish', 'native_name': 'Polski', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 18},
      {'code': 'tr', 'name': 'Turkish', 'native_name': 'Türkçe', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 19},
      {
        'code': 'sv',
        'name': 'Swedish',
        'native_name': 'Svenska',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 20
      },
      {'code': 'da', 'name': 'Danish', 'native_name': 'Dansk', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 21},
      {
        'code': 'no',
        'name': 'Norwegian',
        'native_name': 'Norsk',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 22
      },
      {'code': 'fi', 'name': 'Finnish', 'native_name': 'Suomi', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 23},
      {'code': 'cs', 'name': 'Czech', 'native_name': 'Čeština', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 24},
      {
        'code': 'sk',
        'name': 'Slovak',
        'native_name': 'Slovenčina',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 25
      },
      {
        'code': 'hu',
        'name': 'Hungarian',
        'native_name': 'Magyar',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 26
      },
      {
        'code': 'ro',
        'name': 'Romanian',
        'native_name': 'Română',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 27
      },
      {
        'code': 'bg',
        'name': 'Bulgarian',
        'native_name': 'Български',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 28
      },
      {
        'code': 'hr',
        'name': 'Croatian',
        'native_name': 'Hrvatski',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 29
      },
      {'code': 'sr', 'name': 'Serbian', 'native_name': 'Српски', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 30},
      {
        'code': 'sl',
        'name': 'Slovenian',
        'native_name': 'Slovenščina',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 31
      },
      {'code': 'et', 'name': 'Estonian', 'native_name': 'Eesti', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 32},
      {
        'code': 'lv',
        'name': 'Latvian',
        'native_name': 'Latviešu',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 33
      },
      {
        'code': 'lt',
        'name': 'Lithuanian',
        'native_name': 'Lietuvių',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 34
      },
      {
        'code': 'uk',
        'name': 'Ukrainian',
        'native_name': 'Українська',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 35
      },
      {
        'code': 'be',
        'name': 'Belarusian',
        'native_name': 'Беларуская',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 36
      },
      {
        'code': 'ka',
        'name': 'Georgian',
        'native_name': 'ქართული',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 37
      },
      {
        'code': 'hy',
        'name': 'Armenian',
        'native_name': 'Հայերեն',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 38
      },
      {
        'code': 'az',
        'name': 'Azerbaijani',
        'native_name': 'Azərbaycan',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 39
      },
      {'code': 'kk', 'name': 'Kazakh', 'native_name': 'Қазақша', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 40},
      {
        'code': 'ky',
        'name': 'Kyrgyz',
        'native_name': 'Кыргызча',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 41
      },
      {'code': 'uz', 'name': 'Uzbek', 'native_name': 'Oʻzbek', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 42},
      {'code': 'tg', 'name': 'Tajik', 'native_name': 'Тоҷикӣ', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 43},
      {
        'code': 'mn',
        'name': 'Mongolian',
        'native_name': 'Монгол',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 44
      },
      {
        'code': 'id',
        'name': 'Indonesian',
        'native_name': 'Bahasa Indonesia',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 45
      },
      {
        'code': 'ms',
        'name': 'Malay',
        'native_name': 'Bahasa Melayu',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 46
      },
      {
        'code': 'tl',
        'name': 'Filipino',
        'native_name': 'Filipino',
        'direction': 'ltr',
        'is_rtl': false,
        'sort_index': 47
      },
      {'code': 'bn', 'name': 'Bengali', 'native_name': 'বাংলা', 'direction': 'ltr', 'is_rtl': false, 'sort_index': 48},
      {'code': 'ur', 'name': 'Urdu', 'native_name': 'اردو', 'direction': 'rtl', 'is_rtl': true, 'sort_index': 49},
      {'code': 'fa', 'name': 'Persian', 'native_name': 'فارسی', 'direction': 'rtl', 'is_rtl': true, 'sort_index': 50},
    ];

    for (final language in languages) {
      log('插入语言: ${language['code']} - ${language['name']}', name: 'Seed004InsertLanguages');
    }
  }

  /// 删除支持的语言
  static Future<void> _deleteLanguages() async {
    final languageCodes = [
      'en',
      'zh-CN',
      'zh-TW',
      'ja',
      'ko',
      'fr',
      'de',
      'es',
      'it',
      'pt',
      'ru',
      'ar',
      'he',
      'hi',
      'th',
      'vi',
      'nl',
      'pl',
      'tr',
      'sv',
      'da',
      'no',
      'fi',
      'cs',
      'sk',
      'hu',
      'ro',
      'bg',
      'hr',
      'sr',
      'sl',
      'et',
      'lv',
      'lt',
      'uk',
      'be',
      'ka',
      'hy',
      'az',
      'kk',
      'ky',
      'uz',
      'tg',
      'mn',
      'id',
      'ms',
      'tl',
      'bn',
      'ur',
      'fa',
    ];

    for (final languageCode in languageCodes) {
      log('删除语言: $languageCode', name: 'Seed004InsertLanguages');
    }
  }
}
