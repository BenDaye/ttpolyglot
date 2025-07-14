import 'package:flutter/material.dart';

/// 布局类型枚举
enum LayoutType {
  /// 主应用布局（有导航栏、侧边栏等）
  main,

  /// 认证布局（登录、注册页面）
  auth,

  /// 全屏布局（欢迎页、引导页）
  fullscreen,
}

/// 布局配置类
class LayoutConfig {
  /// 布局类型
  final LayoutType type;

  /// 页面标题
  final String title;

  /// AppBar 操作按钮
  final List<Widget>? actions;

  /// 是否显示返回按钮
  final bool showBackButton;

  /// 是否显示侧边栏
  final bool showDrawer;

  /// 是否显示底部导航
  final bool showBottomNav;

  /// 浮动操作按钮
  final Widget? floatingActionButton;

  /// 浮动操作按钮位置
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// 自定义 AppBar
  final PreferredSizeWidget? customAppBar;

  /// 背景颜色
  final Color? backgroundColor;

  /// 是否安全区域
  final bool safeArea;

  /// 是否可滚动
  final bool scrollable;

  /// 页面内边距
  final EdgeInsets? padding;

  /// 是否显示 AppBar
  final bool showAppBar;

  /// AppBar 底部组件（如 TabBar）
  final PreferredSizeWidget? bottom;

  /// AppBar 背景颜色
  final Color? appBarBackgroundColor;

  /// AppBar 前景颜色
  final Color? appBarForegroundColor;

  /// AppBar 阴影
  final double? appBarElevation;

  const LayoutConfig({
    required this.type,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.showDrawer = true,
    this.showBottomNav = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.customAppBar,
    this.backgroundColor,
    this.safeArea = true,
    this.scrollable = false,
    this.padding,
    this.showAppBar = true,
    this.bottom,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.appBarElevation,
  });

  /// 创建主应用布局配置
  factory LayoutConfig.main({
    required String title,
    List<Widget>? actions,
    bool showBackButton = false,
    bool showDrawer = true,
    bool showBottomNav = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool scrollable = false,
    EdgeInsets? padding,
    bool showAppBar = true,
    PreferredSizeWidget? bottom,
    Color? appBarBackgroundColor,
    Color? appBarForegroundColor,
    double? appBarElevation,
  }) {
    return LayoutConfig(
      type: LayoutType.main,
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      showDrawer: showDrawer,
      showBottomNav: showBottomNav,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      scrollable: scrollable,
      padding: padding,
      showAppBar: showAppBar,
      bottom: bottom,
      appBarBackgroundColor: appBarBackgroundColor,
      appBarForegroundColor: appBarForegroundColor,
      appBarElevation: appBarElevation,
    );
  }

  /// 创建认证布局配置
  factory LayoutConfig.auth({
    required String title,
    List<Widget>? actions,
    bool showBackButton = true,
    Color? backgroundColor,
    bool scrollable = true,
    EdgeInsets? padding,
    bool showAppBar = true,
  }) {
    return LayoutConfig(
      type: LayoutType.auth,
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      showDrawer: false,
      showBottomNav: false,
      backgroundColor: backgroundColor,
      scrollable: scrollable,
      padding: padding ?? const EdgeInsets.all(24),
      showAppBar: showAppBar,
    );
  }

  /// 创建全屏布局配置
  factory LayoutConfig.fullscreen({
    String title = '',
    Color? backgroundColor,
    bool safeArea = false,
    bool scrollable = false,
    bool showAppBar = false,
  }) {
    return LayoutConfig(
      type: LayoutType.fullscreen,
      title: title,
      showDrawer: false,
      showBottomNav: false,
      backgroundColor: backgroundColor,
      safeArea: safeArea,
      scrollable: scrollable,
      showAppBar: showAppBar,
    );
  }

  /// 复制并修改配置
  LayoutConfig copyWith({
    LayoutType? type,
    String? title,
    List<Widget>? actions,
    bool? showBackButton,
    bool? showDrawer,
    bool? showBottomNav,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    PreferredSizeWidget? customAppBar,
    Color? backgroundColor,
    bool? safeArea,
    bool? scrollable,
    EdgeInsets? padding,
    bool? showAppBar,
    PreferredSizeWidget? bottom,
    Color? appBarBackgroundColor,
    Color? appBarForegroundColor,
    double? appBarElevation,
  }) {
    return LayoutConfig(
      type: type ?? this.type,
      title: title ?? this.title,
      actions: actions ?? this.actions,
      showBackButton: showBackButton ?? this.showBackButton,
      showDrawer: showDrawer ?? this.showDrawer,
      showBottomNav: showBottomNav ?? this.showBottomNav,
      floatingActionButton: floatingActionButton ?? this.floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation ?? this.floatingActionButtonLocation,
      customAppBar: customAppBar ?? this.customAppBar,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      safeArea: safeArea ?? this.safeArea,
      scrollable: scrollable ?? this.scrollable,
      padding: padding ?? this.padding,
      showAppBar: showAppBar ?? this.showAppBar,
      bottom: bottom ?? this.bottom,
      appBarBackgroundColor: appBarBackgroundColor ?? this.appBarBackgroundColor,
      appBarForegroundColor: appBarForegroundColor ?? this.appBarForegroundColor,
      appBarElevation: appBarElevation ?? this.appBarElevation,
    );
  }
}
