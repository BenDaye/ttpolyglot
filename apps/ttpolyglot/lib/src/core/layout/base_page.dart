import 'package:flutter/material.dart';

import 'layout_config.dart';
import 'layout_factory.dart';

/// 页面基类
abstract class BasePage extends StatelessWidget {
  const BasePage({super.key});

  /// 布局配置
  LayoutConfig get layoutConfig;

  /// 构建页面内容
  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return LayoutFactory.create(layoutConfig, buildContent(context));
  }
}

/// 有状态页面基类
abstract class BaseStatefulPage extends StatefulWidget {
  const BaseStatefulPage({super.key});

  /// 布局配置
  LayoutConfig get layoutConfig;

  /// 构建页面内容
  Widget buildContent(BuildContext context);

  @override
  State<BaseStatefulPage> createState() => _BaseStatefulPageState();
}

class _BaseStatefulPageState extends State<BaseStatefulPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutFactory.create(widget.layoutConfig, widget.buildContent(context));
  }
}

/// 主页面基类
abstract class MainPage extends BasePage {
  const MainPage({super.key});

  @override
  LayoutConfig get layoutConfig => LayoutConfig.main(
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

  /// 页面标题
  String get title;

  /// AppBar 操作按钮
  List<Widget>? get actions => null;

  /// 是否显示返回按钮
  bool get showBackButton => false;

  /// 是否显示侧边栏
  bool get showDrawer => true;

  /// 是否显示底部导航
  bool get showBottomNav => true;

  /// 浮动操作按钮
  Widget? get floatingActionButton => null;

  /// 浮动操作按钮位置
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  /// 是否可滚动
  bool get scrollable => false;

  /// 页面内边距
  EdgeInsets? get padding => null;
}

/// 有状态主页面基类
abstract class MainStatefulPage extends BaseStatefulPage {
  const MainStatefulPage({super.key});

  @override
  LayoutConfig get layoutConfig => LayoutConfig.main(
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

  /// 页面标题
  String get title;

  /// AppBar 操作按钮
  List<Widget>? get actions => null;

  /// 是否显示返回按钮
  bool get showBackButton => false;

  /// 是否显示侧边栏
  bool get showDrawer => true;

  /// 是否显示底部导航
  bool get showBottomNav => true;

  /// 浮动操作按钮
  Widget? get floatingActionButton => null;

  /// 浮动操作按钮位置
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  /// 是否可滚动
  bool get scrollable => false;

  /// 页面内边距
  EdgeInsets? get padding => null;
}

/// 认证页面基类
abstract class AuthPage extends BasePage {
  const AuthPage({super.key});

  @override
  LayoutConfig get layoutConfig => LayoutConfig.auth(
        title: title,
        actions: actions,
        showBackButton: showBackButton,
        backgroundColor: backgroundColor,
        scrollable: scrollable,
        padding: padding,
      );

  /// 页面标题
  String get title;

  /// AppBar 操作按钮
  List<Widget>? get actions => null;

  /// 是否显示返回按钮
  bool get showBackButton => true;

  /// 背景颜色
  Color? get backgroundColor => null;

  /// 是否可滚动
  bool get scrollable => true;

  /// 页面内边距
  EdgeInsets? get padding => const EdgeInsets.all(24);
}

/// 全屏页面基类
abstract class FullscreenPage extends BasePage {
  const FullscreenPage({super.key});

  @override
  LayoutConfig get layoutConfig => LayoutConfig.fullscreen(
        title: title,
        backgroundColor: backgroundColor,
        safeArea: safeArea,
        scrollable: scrollable,
      );

  /// 页面标题
  String get title => '';

  /// 背景颜色
  Color? get backgroundColor => null;

  /// 是否安全区域
  bool get safeArea => false;

  /// 是否可滚动
  bool get scrollable => false;
}

/// 带标签页的主页面基类
abstract class MainPageWithTabs extends StatefulWidget {
  const MainPageWithTabs({super.key});

  /// 页面标题
  String get title;

  /// 标签页列表
  List<Tab> get tabs;

  /// 标签页内容
  List<Widget> get tabViews;

  /// AppBar 操作按钮
  List<Widget>? get actions => null;

  /// 是否显示返回按钮
  bool get showBackButton => false;

  /// 是否显示侧边栏
  bool get showDrawer => true;

  /// 是否显示底部导航
  bool get showBottomNav => true;

  /// 浮动操作按钮
  Widget? get floatingActionButton => null;

  /// 浮动操作按钮位置
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  /// 是否可滚动
  bool get scrollable => false;

  /// 页面内边距
  EdgeInsets? get padding => null;

  @override
  State<MainPageWithTabs> createState() => _MainPageWithTabsState();
}

class _MainPageWithTabsState extends State<MainPageWithTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFactory.createMainWithTabs(
      title: widget.title,
      tabs: widget.tabs,
      children: widget.tabViews,
      tabController: _tabController,
      actions: widget.actions,
      showBackButton: widget.showBackButton,
      showDrawer: widget.showDrawer,
      showBottomNav: widget.showBottomNav,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      scrollable: widget.scrollable,
      padding: widget.padding,
    );
  }
}

/// 页面工具类
class PageUtils {
  /// 创建快速主页面
  static Widget createMainPage({
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
    return LayoutFactory.createMain(
      title: title,
      child: child,
      actions: actions,
      showBackButton: showBackButton,
      showDrawer: showDrawer,
      showBottomNav: showBottomNav,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      scrollable: scrollable,
      padding: padding,
    );
  }

  /// 创建快速认证页面
  static Widget createAuthPage({
    required String title,
    required Widget child,
    List<Widget>? actions,
    bool showBackButton = true,
    Color? backgroundColor,
    bool scrollable = true,
    EdgeInsets? padding,
  }) {
    return LayoutFactory.createAuth(
      title: title,
      child: child,
      actions: actions,
      showBackButton: showBackButton,
      backgroundColor: backgroundColor,
      scrollable: scrollable,
      padding: padding,
    );
  }

  /// 创建快速全屏页面
  static Widget createFullscreenPage({
    required Widget child,
    String title = '',
    Color? backgroundColor,
    bool safeArea = false,
    bool scrollable = false,
  }) {
    return LayoutFactory.createFullscreen(
      child: child,
      title: title,
      backgroundColor: backgroundColor,
      safeArea: safeArea,
      scrollable: scrollable,
    );
  }
}
