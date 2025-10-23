import 'dart:developer';

import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_core/core.dart';

/// 语言 API
class LanguageApi {
  /// 获取语言列表
  Future<List<Language>> getLanguages() async {
    try {
      log('[getLanguages] 请求语言列表', name: 'LanguageApi');

      final response = await HttpClient.get('/api/languages');

      final data = response.data as Map<String, dynamic>;
      final languagesData = data['data'] as List<dynamic>;

      final languages = languagesData.map((e) => _languageFromJson(e as Map<String, dynamic>)).toList();

      log('[getLanguages] 获取到 ${languages.length} 个语言', name: 'LanguageApi');

      return languages;
    } catch (error, stackTrace) {
      log('[getLanguages]', error: error, stackTrace: stackTrace, name: 'LanguageApi');
      rethrow;
    }
  }

  /// 从 JSON 转换为 Language
  Language _languageFromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['native_name'] as String? ?? json['name'] as String,
      sortIndex: json['sort_order'] as int? ?? 0,
    );
  }

  /// 获取默认语言列表（作为降级方案）
  static List<Language> getDefaultLanguages() {
    return [
      const Language(
        code: 'zh-CN',
        name: '中文（简体）',
        nativeName: '中文（简体）',
        sortIndex: 0,
      ),
      const Language(
        code: 'zh-TW',
        name: '中文（繁體）',
        nativeName: '中文（繁體）',
        sortIndex: 1,
      ),
      const Language(
        code: 'en-US',
        name: 'English (United States)',
        nativeName: 'English (United States)',
        sortIndex: 2,
      ),
      const Language(
        code: 'ja-JP',
        name: '日本語',
        nativeName: '日本語',
        sortIndex: 3,
      ),
      const Language(
        code: 'ko-KR',
        name: '한국어',
        nativeName: '한국어',
        sortIndex: 4,
      ),
      const Language(
        code: 'fr-FR',
        name: 'Français',
        nativeName: 'Français',
        sortIndex: 5,
      ),
      const Language(
        code: 'de-DE',
        name: 'Deutsch',
        nativeName: 'Deutsch',
        sortIndex: 6,
      ),
      const Language(
        code: 'es-ES',
        name: 'Español',
        nativeName: 'Español',
        sortIndex: 7,
      ),
      const Language(
        code: 'pt-BR',
        name: 'Português (Brasil)',
        nativeName: 'Português (Brasil)',
        sortIndex: 8,
      ),
      const Language(
        code: 'ru-RU',
        name: 'Русский',
        nativeName: 'Русский',
        sortIndex: 9,
      ),
      const Language(
        code: 'it-IT',
        name: 'Italiano',
        nativeName: 'Italiano',
        sortIndex: 10,
      ),
      const Language(
        code: 'ar-SA',
        name: 'العربية',
        nativeName: 'العربية',
        sortIndex: 11,
      ),
      const Language(
        code: 'th-TH',
        name: 'ไทย',
        nativeName: 'ไทย',
        sortIndex: 12,
      ),
      const Language(
        code: 'vi-VN',
        name: 'Tiếng Việt',
        nativeName: 'Tiếng Việt',
        sortIndex: 13,
      ),
      const Language(
        code: 'id-ID',
        name: 'Bahasa Indonesia',
        nativeName: 'Bahasa Indonesia',
        sortIndex: 14,
      ),
      const Language(
        code: 'ms-MY',
        name: 'Bahasa Melayu',
        nativeName: 'Bahasa Melayu',
        sortIndex: 15,
      ),
      const Language(
        code: 'hi-IN',
        name: 'हिन्दी',
        nativeName: 'हिन्दी',
        sortIndex: 16,
      ),
      const Language(
        code: 'tr-TR',
        name: 'Türkçe',
        nativeName: 'Türkçe',
        sortIndex: 17,
      ),
      const Language(
        code: 'pl-PL',
        name: 'Polski',
        nativeName: 'Polski',
        sortIndex: 18,
      ),
      const Language(
        code: 'nl-NL',
        name: 'Nederlands',
        nativeName: 'Nederlands',
        sortIndex: 19,
      ),
      const Language(
        code: 'sv-SE',
        name: 'Svenska',
        nativeName: 'Svenska',
        sortIndex: 20,
      ),
    ];
  }
}
