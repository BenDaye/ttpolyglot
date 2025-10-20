import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';

/// 布局控制器
class LayoutController extends GetxController {
  // 当前页面索引
  final _currentIndex = 0.obs;

  // 侧边栏是否打开
  final _isDrawerOpen = false.obs;

  // 是否显示 FAB
  final _showFab = false.obs;

  // 页面标题
  final _pageTitle = 'TTPolyglot'.obs;

  // 导航徽章
  final _badges = <String, String>{}.obs;

  // 项目徽章数量
  final _projectsBadge = 0.obs;

  // 未读通知状态
  final _hasUnreadNotifications = false.obs;

  // Getters
  int get currentIndex => _currentIndex.value;
  bool get isDrawerOpen => _isDrawerOpen.value;
  bool get showFab => _showFab.value;
  String get pageTitle => _pageTitle.value;
  Map<String, String> get badges => _badges;
  Rx<int> get projectsBadge => _projectsBadge;
  Rx<bool> get hasUnreadNotifications => _hasUnreadNotifications;

  // 底部导航项配置
  final List<BottomNavConfig> navItems = [
    BottomNavConfig(
      route: Routes.dashboard,
      index: 0,
      title: '首页',
      showFab: false,
    ),
    BottomNavConfig(
      route: Routes.projects,
      index: 1,
      title: '项目管理',
      showFab: true,
    ),
    BottomNavConfig(
      route: Routes.settings,
      index: 2,
      title: '设置',
      showFab: false,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _updateLayoutForCurrentRoute();
  }

  /// 设置当前页面索引
  void setCurrentIndex(int index) {
    if (index >= 0 && index < navItems.length) {
      _currentIndex.value = index;
      _updateLayoutForIndex(index);
    }
  }

  /// 根据路由更新布局
  void updateLayoutForRoute(String route) {
    final config = navItems.firstWhereOrNull((item) => item.route == route);
    if (config != null) {
      _currentIndex.value = config.index;
      _pageTitle.value = config.title;
      _showFab.value = config.showFab;
    } else {
      // 处理不在导航列表中的路由
      if (route == Routes.profile) {
        _currentIndex.value = -1; // 不高亮任何导航项
        _pageTitle.value = '个人信息';
        _showFab.value = false;
      }
    }
  }

  /// 根据索引更新布局
  void _updateLayoutForIndex(int index) {
    if (index >= 0 && index < navItems.length) {
      final config = navItems[index];
      _pageTitle.value = config.title;
      _showFab.value = config.showFab;
    }
  }

  /// 更新当前路由的布局
  void _updateLayoutForCurrentRoute() {
    final currentRoute = Get.currentRoute;
    updateLayoutForRoute(currentRoute);
  }

  /// 设置侧边栏状态
  void setDrawerState(bool isOpen) {
    _isDrawerOpen.value = isOpen;
  }

  /// 切换侧边栏状态
  void toggleDrawer() {
    _isDrawerOpen.value = !_isDrawerOpen.value;
  }

  /// 设置页面标题
  void setPageTitle(String title) {
    _pageTitle.value = title;
  }

  /// 设置 FAB 显示状态
  void setFabVisibility(bool show) {
    _showFab.value = show;
  }

  /// 设置徽章
  void setBadge(String route, String badge) {
    _badges[route] = badge;
  }

  /// 清除徽章
  void clearBadge(String route) {
    _badges.remove(route);
  }

  /// 清除所有徽章
  void clearAllBadges() {
    _badges.clear();
  }

  /// 设置项目徽章数量
  void setProjectsBadge(int count) {
    _projectsBadge.value = count;
  }

  /// 清除项目徽章
  void clearProjectsBadge() {
    _projectsBadge.value = 0;
  }

  /// 设置未读通知状态
  void setUnreadNotifications(bool hasUnread) {
    _hasUnreadNotifications.value = hasUnread;
  }

  /// 清除未读通知
  void clearUnreadNotifications() {
    _hasUnreadNotifications.value = false;
  }

  /// 获取路由对应的配置
  BottomNavConfig? getConfigForRoute(String route) {
    return navItems.firstWhereOrNull((item) => item.route == route);
  }

  /// 获取索引对应的配置
  BottomNavConfig? getConfigForIndex(int index) {
    if (index >= 0 && index < navItems.length) {
      return navItems[index];
    }
    return null;
  }
}

/// 底部导航配置
class BottomNavConfig {
  final String route;
  final int index;
  final String title;
  final bool showFab;

  const BottomNavConfig({
    required this.route,
    required this.index,
    required this.title,
    required this.showFab,
  });
}

/// 布局状态枚举
enum LayoutState {
  /// 正常状态
  normal,

  /// 加载状态
  loading,

  /// 错误状态
  error,

  /// 空状态
  empty,
}

/// 布局工具类
class LayoutUtils {
  /// 获取布局控制器
  static LayoutController get controller => Get.find<LayoutController>();

  /// 初始化布局控制器
  static void initLayoutController() {
    if (!Get.isRegistered<LayoutController>()) {
      Get.put(LayoutController(), permanent: true);
    }
  }

  /// 更新当前页面布局
  static void updateCurrentPageLayout({
    String? title,
    bool? showFab,
  }) {
    final controller = Get.find<LayoutController>();
    if (title != null) {
      controller.setPageTitle(title);
    }
    if (showFab != null) {
      controller.setFabVisibility(showFab);
    }
  }

  /// 设置页面徽章
  static void setPageBadge(String route, String badge) {
    final controller = Get.find<LayoutController>();
    controller.setBadge(route, badge);
  }

  /// 清除页面徽章
  static void clearPageBadge(String route) {
    final controller = Get.find<LayoutController>();
    controller.clearBadge(route);
  }

  /// 获取当前页面配置
  static BottomNavConfig? getCurrentPageConfig() {
    final controller = Get.find<LayoutController>();
    return controller.getConfigForRoute(Get.currentRoute);
  }
}
