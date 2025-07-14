import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/layout/utils/layout_breakpoints.dart';
import 'package:ttpolyglot/src/core/layout/widgets/responsive_sidebar.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';

/// 主布局 Shell - 包含侧边栏和子路由出口
/// 参考微信设计风格的现代化布局
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

  /// 构建桌面端布局（常驻侧边栏）- 微信风格
  Widget _buildDesktopLayout(BuildContext context) {
    return GetRouterOutlet.builder(
      routerDelegate: Get.rootDelegate,
      builder: (context, delegate, config) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          body: Row(
            children: [
              // 左侧侧边栏 - 微信风格的窄边栏
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
                child: ResponsiveSidebar(delegate: delegate),
              ),

              // 主内容区域 - 带圆角和阴影的现代设计
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

  /// 构建移动端布局（抽屉式侧边栏）- 微信风格
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      drawer: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: const ResponsiveSidebar(),
      ),
      appBar: _buildMobileAppBar(context),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: GetRouterOutlet(
          initialRoute: Routes.dashboard,
          anchorRoute: Routes.home,
        ),
      ),
    );
  }

  /// 构建移动端应用栏 - 微信风格
  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(
            Icons.menu_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      title: GetBuilder<LayoutController>(
        builder: (controller) => Obx(
          () => Text(
            controller.pageTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
      ),
      actions: [
        // 搜索按钮
        IconButton(
          onPressed: () {
            // TODO: 实现搜索功能
          },
          icon: Icon(
            Icons.search_outlined,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),

        // 更多操作按钮
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert_outlined,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          onSelected: (value) {
            // TODO: 处理菜单选择
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh_outlined),
                title: Text('刷新'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('设置'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
