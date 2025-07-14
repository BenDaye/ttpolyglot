import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/app.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/routing/app_router.dart';
import 'package:ttpolyglot/src/core/theme/app_theme.dart';

void main() {
  group('GetX 嵌套路由测试', () {
    setUp(() {
      // 重置 GetX 状态
      Get.reset();
    });

    testWidgets('应用应该能够正常启动并导航到首页', (WidgetTester tester) async {
      // 构建应用
      await tester.pumpWidget(const TTPolyglotApp());
      await tester.pumpAndSettle();

      // 验证应用已启动
      expect(find.text('欢迎使用 TTPolyglot'), findsOneWidget);

      // 验证路由控制器已初始化
      expect(Get.isRegistered<LayoutController>(), true);
      expect(Get.isRegistered<AppThemeController>(), true);
    });

    testWidgets('侧边栏导航应该能够正常工作', (WidgetTester tester) async {
      await tester.pumpWidget(const TTPolyglotApp());
      await tester.pumpAndSettle();

      // 点击项目管理
      await tester.tap(find.text('项目'));
      await tester.pumpAndSettle();

      // 验证页面已切换
      expect(find.text('暂无项目'), findsOneWidget);

      // 点击设置
      await tester.tap(find.text('设置'));
      await tester.pumpAndSettle();

      // 验证页面已切换
      expect(find.text('主题设置'), findsOneWidget);

      // 点击首页
      await tester.tap(find.text('首页'));
      await tester.pumpAndSettle();

      // 验证页面已切换回首页
      expect(find.text('欢迎使用 TTPolyglot'), findsOneWidget);
    });

    testWidgets('GetRouterOutlet 应该能够正确处理子路由', (WidgetTester tester) async {
      await tester.pumpWidget(const TTPolyglotApp());
      await tester.pumpAndSettle();

      // 验证初始路由
      expect(Get.currentRoute, AppRouter.home);

      // 使用 Get.toNamed 导航到项目页面
      Get.toNamed(AppRouter.projects);
      await tester.pumpAndSettle();

      // 验证路由已切换
      expect(Get.currentRoute, AppRouter.projects);
      expect(find.text('暂无项目'), findsOneWidget);

      // 导航到设置页面
      Get.toNamed(AppRouter.settings);
      await tester.pumpAndSettle();

      // 验证路由已切换
      expect(Get.currentRoute, AppRouter.settings);
      expect(find.text('主题设置'), findsOneWidget);
    });
  });
}
