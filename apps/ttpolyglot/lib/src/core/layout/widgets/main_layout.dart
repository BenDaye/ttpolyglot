import 'package:flutter/material.dart';

import 'package:ttpolyglot/src/core/layout/layout.dart';

/// 主应用布局
class MainLayout extends StatelessWidget {
  final LayoutConfig config;
  final Widget child;

  const MainLayout({
    super.key,
    required this.config,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldShowPersistentSidebar = ResponsiveUtils.shouldShowPersistentSidebar(context);
        return shouldShowPersistentSidebar ? _buildDesktopLayout(context) : _buildMobileLayout(context);
      },
    );
  }

  /// 构建桌面端布局（带常驻侧边栏）
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 常驻侧边栏
          if (config.showDrawer) const ResponsiveSidebar(),

          // 主内容区域
          Expanded(
            child: Column(
              children: [
                // AppBar
                if (config.showAppBar) _buildAppBar(context),

                // 主内容
                Expanded(
                  child: Container(
                    padding: config.padding,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 底部导航（桌面端通常不显示）
      bottomNavigationBar: config.showBottomNav ? const AppBottomNav() : null,

      // 浮动按钮
      floatingActionButton: config.floatingActionButton,
    );
  }

  /// 构建移动端布局（带抽屉式侧边栏）
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: config.showAppBar ? _buildAppBar(context) : null,

      // 抽屉式侧边栏
      drawer: config.showDrawer ? const ResponsiveSidebar() : null,

      // 主内容
      body: Container(
        padding: config.padding,
        child: child,
      ),

      // 底部导航
      bottomNavigationBar: config.showBottomNav ? const AppBottomNav() : null,

      // 浮动按钮
      floatingActionButton: config.floatingActionButton,
    );
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final shouldShowPersistentSidebar = ResponsiveUtils.shouldShowPersistentSidebar(context);

    return AppBar(
      title: Text(config.title),

      // 桌面端不显示菜单按钮（因为有常驻侧边栏）
      automaticallyImplyLeading: !shouldShowPersistentSidebar && config.showDrawer,

      // 操作按钮
      actions: config.actions,

      // 底部标签栏
      bottom: config.bottom,

      // 背景色
      backgroundColor: config.appBarBackgroundColor,

      // 前景色
      foregroundColor: config.appBarForegroundColor,

      // 阴影
      elevation: config.appBarElevation,
    );
  }
}

/// 带标签页的主应用布局
class MainLayoutWithTabs extends StatelessWidget {
  final LayoutConfig config;
  final Widget child;
  final List<Tab> tabs;
  final TabController? tabController;

  const MainLayoutWithTabs({
    super.key,
    required this.config,
    required this.child,
    required this.tabs,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldShowPersistentSidebar = ResponsiveUtils.shouldShowPersistentSidebar(context);
        return shouldShowPersistentSidebar ? _buildDesktopLayout(context) : _buildMobileLayout(context);
      },
    );
  }

  /// 构建桌面端布局
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 常驻侧边栏
          if (config.showDrawer) const ResponsiveSidebar(),

          // 主内容区域
          Expanded(
            child: Column(
              children: [
                // AppBar with tabs
                if (config.showAppBar) _buildAppBarWithTabs(context),

                // 主内容
                Expanded(
                  child: Container(
                    padding: config.padding,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 底部导航
      bottomNavigationBar: config.showBottomNav ? const AppBottomNav() : null,

      // 浮动按钮
      floatingActionButton: config.floatingActionButton,
    );
  }

  /// 构建移动端布局
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: config.showAppBar ? _buildAppBarWithTabs(context) : null,

      // 抽屉式侧边栏
      drawer: config.showDrawer ? const ResponsiveSidebar() : null,

      // 主内容
      body: Container(
        padding: config.padding,
        child: child,
      ),

      // 底部导航
      bottomNavigationBar: config.showBottomNav ? const AppBottomNav() : null,

      // 浮动按钮
      floatingActionButton: config.floatingActionButton,
    );
  }

  /// 构建带标签页的应用栏
  PreferredSizeWidget _buildAppBarWithTabs(BuildContext context) {
    final shouldShowPersistentSidebar = ResponsiveUtils.shouldShowPersistentSidebar(context);

    return AppBar(
      title: Text(config.title),

      // 桌面端不显示菜单按钮
      automaticallyImplyLeading: !shouldShowPersistentSidebar && config.showDrawer,

      // 操作按钮
      actions: config.actions,

      // 标签栏
      bottom: TabBar(
        controller: tabController,
        tabs: tabs,
      ),

      // 背景色
      backgroundColor: config.appBarBackgroundColor,

      // 前景色
      foregroundColor: config.appBarForegroundColor,

      // 阴影
      elevation: config.appBarElevation,
    );
  }
}
