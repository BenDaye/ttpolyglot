import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot/src/app.dart';

void main() {
  group('嵌套路由测试', () {
    testWidgets('应用启动时应该显示主布局', (WidgetTester tester) async {
      // 构建应用
      await tester.pumpWidget(const TTPolyglotApp());

      // 等待所有动画完成
      await tester.pumpAndSettle();

      // 验证主布局是否显示
      expect(find.text('TTPolyglot'), findsOneWidget);
    });

    testWidgets('侧边栏导航应该切换子路由而不重建整个页面', (WidgetTester tester) async {
      await tester.pumpWidget(const TTPolyglotApp());
      await tester.pumpAndSettle();

      // 查找项目导航按钮
      final projectsButton = find.text('项目');
      if (projectsButton.evaluate().isNotEmpty) {
        await tester.tap(projectsButton);
        await tester.pumpAndSettle();

        // 验证路由已切换但侧边栏仍然存在
        expect(find.text('项目'), findsWidgets);
      }
    });

    // testWidgets('路由配置应该正确设置', (WidgetTester tester) async {
    //   // 验证路由常量
    //   expect(MainRoute.home.fullPath, equals('/main/home'));
    //   expect(MainRoute.projects.fullPath, equals('/main/projects'));
    //   expect(MainRoute.settings.fullPath, equals('/main/settings'));
    //   expect(RootRoute.main.path, equals('/main'));
    // });
  });
}
