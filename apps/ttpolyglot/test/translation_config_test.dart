import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('TranslationProvider', () {
    test('fromCode should return correct provider', () {
      expect(TranslationProvider.fromCode('baidu'), TranslationProvider.baidu);
      expect(TranslationProvider.fromCode('youdao'), TranslationProvider.youdao);
      expect(TranslationProvider.fromCode('google'), TranslationProvider.google);
      expect(TranslationProvider.fromCode('custom'), TranslationProvider.custom);
      expect(TranslationProvider.fromCode('invalid'), null);
    });

    test('getAllProviders should return all providers', () {
      final providers = TranslationProvider.getAllProviders();
      expect(providers.length, 4);
      expect(providers[0]['code'], 'baidu');
      expect(providers[0]['name'], '百度翻译');
    });
  });

  group('TranslationProviderConfig', () {
    test('isValid should work correctly for baidu provider', () {
      final config = TranslationProviderConfig(
        id: 'test_id_1',
        provider: TranslationProvider.baidu,
        name: '百度翻译',
        appId: 'test_id',
        appKey: 'test_key',
        isEnabled: true,
      );
      expect(config.isValid, true);

      final invalidConfig = TranslationProviderConfig(
        id: 'test_id_2',
        provider: TranslationProvider.baidu,
        name: '百度翻译',
        appId: '',
        appKey: 'test_key',
        isEnabled: true,
      );
      expect(invalidConfig.isValid, false);
    });

    test('isValid should work correctly for custom provider', () {
      final config = TranslationProviderConfig(
        id: 'test_id_3',
        provider: TranslationProvider.custom,
        name: '自定义翻译',
        appId: 'test_key',
        appKey: '',
        apiUrl: 'https://api.example.com',
        isEnabled: true,
      );
      expect(config.isValid, true);

      final invalidConfig = TranslationProviderConfig(
        id: 'test_id_4',
        provider: TranslationProvider.custom,
        name: '自定义翻译',
        appId: '',
        appKey: '',
        apiUrl: 'https://api.example.com',
        isEnabled: true,
      );
      expect(invalidConfig.isValid, false);
    });

    test('getValidationErrors should return correct errors', () {
      final config = TranslationProviderConfig(
        id: 'test_id_5',
        provider: TranslationProvider.baidu,
        name: '百度翻译',
        appId: '',
        appKey: '',
        isEnabled: true,
      );
      final errors = config.getValidationErrors();
      expect(errors.length, 2);
      expect(errors[0], contains('应用ID不能为空'));
      expect(errors[1], contains('应用密钥不能为空'));
    });

    test('copyWith should create new instance with updated values', () {
      final original = TranslationProviderConfig(
        id: 'test_id_6',
        provider: TranslationProvider.baidu,
        name: '百度翻译',
        appId: 'original_id',
        appKey: 'original_key',
        isEnabled: false,
      );

      final updated = original.copyWith(appId: 'updated_id', isEnabled: true);
      expect(updated.appId, 'updated_id');
      expect(updated.appKey, 'original_key');
      expect(updated.isEnabled, true);
      expect(updated.provider, original.provider);
      expect(updated.id, original.id);
    });

    test('displayName should return name or provider name', () {
      final configWithName = TranslationProviderConfig(
        id: 'test_id_7',
        provider: TranslationProvider.baidu,
        name: '我的百度翻译',
        appId: 'test_id',
        appKey: 'test_key',
        isEnabled: true,
      );

      final configWithoutName = TranslationProviderConfig(
        id: 'test_id_8',
        provider: TranslationProvider.baidu,
        appId: 'test_id',
        appKey: 'test_key',
        isEnabled: true,
      );

      expect(configWithName.displayName, '我的百度翻译');
      expect(configWithoutName.displayName, '百度翻译');
    });
  });

  group('TranslationConfig', () {
    test('fromMap should create correct instance', () {
      final map = {
        'providers': [
          {
            'id': 'test_id_7',
            'provider': 'baidu',
            'name': '百度翻译',
            'appId': 'test_id',
            'appKey': 'test_key',
            'apiUrl': null,
            'isEnabled': true,
            'isDefault': false,
          }
        ],
        'maxRetries': 5,
        'timeoutSeconds': 60,
      };

      final config = TranslationConfig.fromMap(map);
      expect(config.providers.length, 1);
      expect(config.maxRetries, 5);
      expect(config.timeoutSeconds, 60);
    });

    test('enabledProviders should return only enabled and valid providers', () {
      final config = TranslationConfig(
        providers: [
          TranslationProviderConfig(
            id: 'test_id_8',
            provider: TranslationProvider.baidu,
            name: '百度翻译',
            appId: 'test_id',
            appKey: 'test_key',
            isEnabled: true,
          ),
          TranslationProviderConfig(
            id: 'test_id_9',
            provider: TranslationProvider.youdao,
            name: '有道翻译',
            appId: '',
            appKey: '',
            isEnabled: true,
          ),
          TranslationProviderConfig(
            id: 'test_id_10',
            provider: TranslationProvider.google,
            name: '谷歌翻译',
            appId: 'google_id',
            appKey: 'google_key',
            isEnabled: false,
          ),
        ],
      );

      final enabled = config.enabledProviders;
      expect(enabled.length, 1);
      expect(enabled[0].provider, TranslationProvider.baidu);
    });

    test('getProviderConfigById should return correct config', () {
      final config = TranslationConfig(
        providers: [
          TranslationProviderConfig(
            id: 'test_id_11',
            provider: TranslationProvider.baidu,
            name: '百度翻译',
            appId: 'test_id',
            appKey: 'test_key',
            isEnabled: true,
          ),
          TranslationProviderConfig(
            id: 'test_id_12',
            provider: TranslationProvider.youdao,
            name: '有道翻译',
            appId: 'youdao_id',
            appKey: 'youdao_key',
            isEnabled: true,
          ),
        ],
      );

      final foundConfig = config.getProviderConfigById('test_id_11');
      expect(foundConfig?.provider, TranslationProvider.baidu);
      expect(foundConfig?.name, '百度翻译');

      final notFoundConfig = config.getProviderConfigById('nonexistent');
      expect(notFoundConfig, null);
    });
  });
}
