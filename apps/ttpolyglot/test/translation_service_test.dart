import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot/src/core/services/translation_api_service.dart';
import 'package:ttpolyglot/src/features/settings/models/translation_provider.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('TranslationApiService', () {
    test('should create TranslationResult with success', () {
      const result = TranslationResult(
        success: true,
        translatedText: 'Hello',
        sourceLanguage: Language(code: 'zh-CN', name: 'Chinese', nativeName: '中文'),
        targetLanguage: Language(code: 'en-US', name: 'English', nativeName: 'English'),
      );

      expect(result.success, true);
      expect(result.translatedText, 'Hello');
      expect(result.sourceLanguage?.code, 'zh-CN');
      expect(result.targetLanguage?.code, 'en-US');
    });

    test('should create TranslationResult with error', () {
      const result = TranslationResult(
        success: false,
        translatedText: '',
        error: 'API Error',
      );

      expect(result.success, false);
      expect(result.translatedText, '');
      expect(result.error, 'API Error');
    });
  });

  group('TranslationProviderConfig', () {
    test('should validate baidu config correctly', () {
      const config = TranslationProviderConfig(
        id: 'test',
        provider: TranslationProvider.baidu,
        appId: 'test_app_id',
        appKey: 'test_app_key',
        isEnabled: true,
      );

      expect(config.isValid, true);
      expect(config.displayName, '百度翻译');
    });

    test('should validate youdao config correctly', () {
      const config = TranslationProviderConfig(
        id: 'test',
        provider: TranslationProvider.youdao,
        appId: 'test_app_id',
        appKey: 'test_app_key',
        isEnabled: true,
      );

      expect(config.isValid, true);
      expect(config.displayName, '有道翻译');
    });

    test('should validate google config correctly', () {
      const config = TranslationProviderConfig(
        id: 'test',
        provider: TranslationProvider.google,
        appId: 'test_app_id',
        appKey: 'test_app_key',
        isEnabled: true,
      );

      expect(config.isValid, true);
      expect(config.displayName, '谷歌翻译');
    });

    test('should validate custom config correctly', () {
      const config = TranslationProviderConfig(
        id: 'test',
        provider: TranslationProvider.custom,
        appId: 'test_auth_token',
        appKey: 'test_auth_key',
        apiUrl: 'https://api.example.com/translate',
        isEnabled: true,
      );

      expect(config.isValid, true);
      expect(config.displayName, '自定义翻译');
    });

    test('should return false for invalid config', () {
      const config = TranslationProviderConfig(
        id: 'test',
        provider: TranslationProvider.baidu,
        appId: '',
        appKey: '',
        isEnabled: true,
      );

      expect(config.isValid, false);
    });
  });

  group('TranslationProvider', () {
    test('should get all providers', () {
      final providers = TranslationProvider.getAllProviders();

      expect(providers.length, 4);
      expect(providers.any((p) => p['code'] == 'baidu'), true);
      expect(providers.any((p) => p['code'] == 'youdao'), true);
      expect(providers.any((p) => p['code'] == 'google'), true);
      expect(providers.any((p) => p['code'] == 'custom'), true);
    });

    test('should get provider by code', () {
      expect(TranslationProvider.fromCode('baidu'), TranslationProvider.baidu);
      expect(TranslationProvider.fromCode('youdao'), TranslationProvider.youdao);
      expect(TranslationProvider.fromCode('google'), TranslationProvider.google);
      expect(TranslationProvider.fromCode('custom'), TranslationProvider.custom);
      expect(TranslationProvider.fromCode('invalid'), null);
    });
  });
}
