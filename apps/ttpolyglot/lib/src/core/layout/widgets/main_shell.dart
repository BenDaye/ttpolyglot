import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/layout/utils/layout_breakpoints.dart';
import 'package:ttpolyglot/src/core/layout/widgets/responsive_sidebar.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';

/// 主布局 Shell - 包含侧边栏和子路由出口
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldShowPersistentSidebar = ResponsiveUtils.shouldShowPersistentSidebar(context);

        if (shouldShowPersistentSidebar) {
          return _buildDesktopLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  /// 构建桌面端布局（常驻侧边栏）
  Widget _buildDesktopLayout(BuildContext context) {
    return GetRouterOutlet.builder(
      routerDelegate: Get.rootDelegate,
      builder: (context, delegate, config) {
        return Scaffold(
          body: Row(
            children: [
              // 常驻侧边栏
              ResponsiveSidebar(delegate: delegate),

              // 主内容区域 - 使用 GetRouterOutlet 作为子路由出口
              Expanded(
                child: GetRouterOutlet(
                  initialRoute: Routes.dashboard,
                  anchorRoute: Routes.home,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建移动端布局（抽屉式侧边栏）
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      drawer: const ResponsiveSidebar(),
      appBar: AppBar(
        title: GetBuilder<LayoutController>(
          builder: (controller) => Obx(
            () => Text(controller.pageTitle),
          ),
        ),
      ),
      body: GetRouterOutlet(
        initialRoute: Routes.dashboard,
        anchorRoute: Routes.home,
      ),
    );
  }
}
