import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/theme/app_theme.dart';
import 'package:ttpolyglot/src/features/settings/controllers/settings_controller.dart';
import 'package:ttpolyglot/src/features/settings/controllers/translation_config_controller.dart';
import 'package:ttpolyglot/src/features/settings/views/settings_view.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  setUp(() {
    // 初始化 GetX
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('SettingsView should render translation config section', (WidgetTester tester) async {
    // 创建必要的控制器实例
    final settingsController = SettingsController();
    final translationController = TranslationConfigController();

    Get.put(settingsController);
    Get.put(translationController);
    Get.put(AppThemeController.instance);

    // 构建设置页面
    await tester.pumpWidget(
      GetMaterialApp(
        home: const SettingsView(),
        theme: AppThemeController.lightTheme,
      ),
    );

    // 等待页面构建完成
    await tester.pumpAndSettle();

    // 检查翻译配置部分是否存在
    expect(find.text('翻译接口配置'), findsOneWidget);
  });

  testWidgets('TranslationConfigController should initialize correctly', (WidgetTester tester) async {
    final controller = TranslationConfigController();
    Get.put(controller);

    // 检查默认配置
    expect(controller.config.providers.length, 0); // 初始化时为空
    expect(controller.config.maxRetries, 3);
    expect(controller.config.timeoutSeconds, 30);
  });

  testWidgets('Provider config should toggle correctly', (WidgetTester tester) async {
    final controller = TranslationConfigController();
    Get.put(controller);

    // 添加测试数据
    controller.addTranslationProvider(
      provider: TranslationProvider.baidu,
      name: '测试百度翻译',
      appId: 'test_id',
      appKey: 'test_key',
    );

    // 获取刚添加的配置
    final config = controller.config.providers.first;

    // 切换启用状态
    controller.toggleProviderById(config.id);

    // 检查配置是否更新
    final updatedConfig = controller.getProviderConfigById(config.id);
    expect(updatedConfig?.isEnabled, true);
  });

  testWidgets('Translation config should update correctly', (WidgetTester tester) async {
    final controller = TranslationConfigController();
    Get.put(controller);

    // 添加测试数据
    controller.addTranslationProvider(
      provider: TranslationProvider.baidu,
      name: '测试百度翻译',
      appId: 'original_id',
      appKey: 'original_key',
    );

    // 获取刚添加的配置
    final config = controller.config.providers.first;

    // 更新配置
    controller.updateProviderConfigById(
      config.id,
      appId: 'test_app_id',
      appKey: 'test_app_key',
      isEnabled: true,
    );

    // 检查配置是否更新
    final updatedConfig = controller.getProviderConfigById(config.id);
    expect(updatedConfig?.appId, 'test_app_id');
    expect(updatedConfig?.appKey, 'test_app_key');
    expect(updatedConfig?.isEnabled, true);
  });
}
