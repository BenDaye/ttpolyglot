import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot/src/features/settings/models/translation_provider.dart';

void main() {
  group('TranslationConfig 模型测试', () {
    test('fromMap 应该正确处理空的providers列表', () {
      final map = {
        'providers': [],
        'maxRetries': 3,
        'timeoutSeconds': 30,
      };

      final config = TranslationConfig.fromMap(map);

      expect(config.providers.length, 0);
      expect(config.maxRetries, 3);
      expect(config.timeoutSeconds, 30);
    });

    test('fromMap 应该正确处理有providers的列表', () {
      final map = {
        'providers': [
          {
            'id': 'test_id_1',
            'provider': 'baidu',
            'name': '百度翻译',
            'appId': 'test_id',
            'appKey': 'test_key',
            'isEnabled': true,
          },
          {
            'id': 'test_id_2',
            'provider': 'youdao',
            'name': '有道翻译',
            'appId': 'test_id_2',
            'appKey': 'test_key_2',
            'isEnabled': false,
          },
        ],
        'maxRetries': 5,
        'timeoutSeconds': 60,
      };

      final config = TranslationConfig.fromMap(map);

      expect(config.providers.length, 2);
      expect(config.providers[0].provider, TranslationProvider.baidu);
      expect(config.providers[1].provider, TranslationProvider.youdao);
      expect(config.maxRetries, 5);
      expect(config.timeoutSeconds, 60);
    });

    test('copyWith 应该正确更新providers列表', () {
      final config = TranslationConfig(
        providers: [
          TranslationProviderConfig(
            id: 'test_id_1',
            provider: TranslationProvider.baidu,
            name: '百度翻译',
            appId: 'test_id',
            appKey: 'test_key',
            isEnabled: true,
          ),
          TranslationProviderConfig(
            id: 'test_id_2',
            provider: TranslationProvider.youdao,
            name: '有道翻译',
            appId: 'test_id_2',
            appKey: 'test_key_2',
            isEnabled: false,
          ),
        ],
      );

      // 删除第一个provider
      final updatedProviders = config.providers.where((p) => p.id != 'test_id_1').toList();
      final updatedConfig = config.copyWith(providers: updatedProviders);

      expect(updatedConfig.providers.length, 1);
      expect(updatedConfig.providers.first.id, 'test_id_2');
      expect(updatedConfig.providers.first.provider, TranslationProvider.youdao);
    });

    test('toMap 和 fromMap 应该保持数据一致性', () {
      final originalConfig = TranslationConfig(
        providers: [
          TranslationProviderConfig(
            id: 'test_id_1',
            provider: TranslationProvider.baidu,
            name: '百度翻译',
            appId: 'test_id',
            appKey: 'test_key',
            isEnabled: true,
          ),
        ],
        maxRetries: 5,
        timeoutSeconds: 60,
      );

      final map = originalConfig.toMap();
      final restoredConfig = TranslationConfig.fromMap(map);

      expect(restoredConfig.providers.length, originalConfig.providers.length);
      expect(restoredConfig.providers.first.id, originalConfig.providers.first.id);
      expect(restoredConfig.providers.first.provider, originalConfig.providers.first.provider);
      expect(restoredConfig.providers.first.name, originalConfig.providers.first.name);
      expect(restoredConfig.providers.first.appId, originalConfig.providers.first.appId);
      expect(restoredConfig.providers.first.appKey, originalConfig.providers.first.appKey);
      expect(restoredConfig.providers.first.isEnabled, originalConfig.providers.first.isEnabled);
      expect(restoredConfig.maxRetries, originalConfig.maxRetries);
      expect(restoredConfig.timeoutSeconds, originalConfig.timeoutSeconds);
    });
  });
}
