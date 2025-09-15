import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('翻译配置逻辑测试', () {
    test('删除翻译接口应该正确工作', () {
      // 创建初始配置
      var config = TranslationConfig(
        providers: [
          TranslationProviderConfig(
            id: 'test_id_1',
            provider: TranslationProvider.baidu,
            name: '百度翻译',
            appId: 'test_id',
            appKey: 'test_key',
          ),
          TranslationProviderConfig(
            id: 'test_id_2',
            provider: TranslationProvider.youdao,
            name: '有道翻译',
            appId: 'test_id_2',
            appKey: 'test_key_2',
          ),
        ],
      );

      // 验证初始状态
      expect(config.providers.length, 2);

      // 模拟删除操作
      final updatedProviders = config.providers.where((p) => p.id != 'test_id_1').toList();
      config = config.copyWith(providers: updatedProviders);

      // 验证删除结果
      expect(config.providers.length, 1);
      expect(config.providers.first.id, 'test_id_2');
      expect(config.providers.first.provider, TranslationProvider.youdao);
    });

    test('删除所有翻译接口后列表应该为空', () {
      // 创建初始配置
      var config = TranslationConfig(
        providers: [
          TranslationProviderConfig(
            id: 'test_id_1',
            provider: TranslationProvider.baidu,
            name: '百度翻译',
            appId: 'test_id',
            appKey: 'test_key',
          ),
        ],
      );

      // 验证初始状态
      expect(config.providers.length, 1);

      // 模拟删除操作
      final updatedProviders = config.providers.where((p) => p.id != 'test_id_1').toList();
      config = config.copyWith(providers: updatedProviders);

      // 验证删除结果
      expect(config.providers.length, 0);
    });

    test('删除不存在的ID应该不影响列表', () {
      // 创建初始配置
      var config = TranslationConfig(
        providers: [
          TranslationProviderConfig(
            id: 'test_id_1',
            provider: TranslationProvider.baidu,
            name: '百度翻译',
            appId: 'test_id',
            appKey: 'test_key',
          ),
        ],
      );

      // 验证初始状态
      expect(config.providers.length, 1);

      // 模拟删除不存在的ID
      final updatedProviders = config.providers.where((p) => p.id != 'non_existent_id').toList();
      config = config.copyWith(providers: updatedProviders);

      // 验证列表没有变化
      expect(config.providers.length, 1);
      expect(config.providers.first.id, 'test_id_1');
    });
  });
}
