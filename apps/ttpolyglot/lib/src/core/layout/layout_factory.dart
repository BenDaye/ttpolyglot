import 'package:flutter/material.dart';

import 'layout_config.dart';
import 'widgets/auth_layout.dart';
import 'widgets/fullscreen_layout.dart';
import 'widgets/main_layout.dart';

/// 布局工厂
class LayoutFactory {
  /// 创建布局
  static Widget create(LayoutConfig config, Widget child) {
    switch (config.type) {
      case LayoutType.main:
        return MainLayout(config: config, child: child);
      case LayoutType.auth:
        return AuthLayout(config: config, child: child);
      case LayoutType.fullscreen:
        return FullscreenLayout(config: config, child: child);
    }
  }

  /// 创建主布局
  static Widget createMain({
    required String title,
    required Widget child,
    List<Widget>? actions,
    bool showBackButton = false,
    bool showDrawer = true,
    bool showBottomNav = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool scrollable = false,
    EdgeInsets? padding,
  }) {
    final config = LayoutConfig.main(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      showDrawer: showDrawer,
      showBottomNav: showBottomNav,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      scrollable: scrollable,
      padding: padding,
    );
    return MainLayout(config: config, child: child);
  }

  /// 创建主布局（带标签页）
  static Widget createMainWithTabs({
    required String title,
    required List<Tab> tabs,
    required List<Widget> children,
    TabController? tabController,
    List<Widget>? actions,
    bool showBackButton = false,
    bool showDrawer = true,
    bool showBottomNav = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool scrollable = false,
    EdgeInsets? padding,
  }) {
    final config = LayoutConfig.main(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      showDrawer: showDrawer,
      showBottomNav: showBottomNav,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      scrollable: scrollable,
      padding: padding,
    );
    return MainLayoutWithTabs(
      config: config,
      tabs: tabs,
      tabController: tabController,
      child: TabBarView(
        controller: tabController,
        children: children,
      ),
    );
  }

  /// 创建认证布局
  static Widget createAuth({
    required String title,
    required Widget child,
    List<Widget>? actions,
    bool showBackButton = true,
    Color? backgroundColor,
    bool scrollable = true,
    EdgeInsets? padding,
  }) {
    final config = LayoutConfig.auth(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      backgroundColor: backgroundColor,
      scrollable: scrollable,
      padding: padding,
    );
    return AuthLayout(config: config, child: child);
  }

  /// 创建认证布局（带装饰背景）
  static Widget createAuthWithDecoration({
    required String title,
    required Widget child,
    Widget? backgroundDecoration,
    List<Widget>? actions,
    bool showBackButton = true,
    Color? backgroundColor,
    bool scrollable = true,
    EdgeInsets? padding,
  }) {
    final config = LayoutConfig.auth(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      backgroundColor: backgroundColor,
      scrollable: scrollable,
      padding: padding,
    );
    return AuthLayoutWithDecoration(
      config: config,
      backgroundDecoration: backgroundDecoration,
      child: child,
    );
  }

  /// 创建认证布局（带卡片）
  static Widget createAuthWithCard({
    required String title,
    required Widget child,
    List<Widget>? actions,
    bool showBackButton = true,
    Color? backgroundColor,
    bool scrollable = true,
    EdgeInsets? padding,
    double? cardMaxWidth,
    EdgeInsets? cardPadding,
  }) {
    final config = LayoutConfig.auth(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      backgroundColor: backgroundColor,
      scrollable: scrollable,
      padding: padding,
    );
    return AuthLayoutWithCard(
      config: config,
      cardMaxWidth: cardMaxWidth,
      cardPadding: cardPadding,
      child: child,
    );
  }

  /// 创建全屏布局
  static Widget createFullscreen({
    required Widget child,
    String title = '',
    Color? backgroundColor,
    bool safeArea = false,
    bool scrollable = false,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
  }) {
    final config = LayoutConfig.fullscreen(
      title: title,
      backgroundColor: backgroundColor,
      safeArea: safeArea,
      scrollable: scrollable,
    );
    return FullscreenLayout(
      config: config.copyWith(
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
      child: child,
    );
  }

  /// 创建全屏布局（带渐变背景）
  static Widget createFullscreenWithGradient({
    required Widget child,
    Gradient? gradient,
    String title = '',
    bool safeArea = false,
    bool scrollable = false,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
  }) {
    final config = LayoutConfig.fullscreen(
      title: title,
      safeArea: safeArea,
      scrollable: scrollable,
    );
    return FullscreenLayoutWithGradient(
      config: config.copyWith(
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
      gradient: gradient,
      child: child,
    );
  }

  /// 创建引导页布局
  static Widget createOnboarding({
    required Widget child,
    Widget? skipButton,
    Widget? nextButton,
    String title = '',
    Color? backgroundColor,
    bool safeArea = true,
    bool scrollable = false,
  }) {
    final config = LayoutConfig.fullscreen(
      title: title,
      backgroundColor: backgroundColor,
      safeArea: safeArea,
      scrollable: scrollable,
    );
    return OnboardingLayout(
      config: config,
      skipButton: skipButton,
      nextButton: nextButton,
      child: child,
    );
  }
}
