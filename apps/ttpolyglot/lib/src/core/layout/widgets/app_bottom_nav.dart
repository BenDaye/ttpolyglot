import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routing/app_router.dart';

/// 底部导航栏配置
class BottomNavItem {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const BottomNavItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// 应用底部导航栏
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  /// 导航项配置
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      route: AppRouter.home,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: '首页',
    ),
    BottomNavItem(
      route: AppRouter.projects,
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder,
      label: '项目',
    ),
    BottomNavItem(
      route: AppRouter.settings,
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: '设置',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _getCurrentIndex(),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: _navItems.map((item) {
          final isSelected = Get.currentRoute == item.route;
          return BottomNavigationBarItem(
            icon: Icon(isSelected ? item.activeIcon : item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  /// 获取当前选中的索引
  int _getCurrentIndex() {
    final currentRoute = Get.currentRoute;
    for (int i = 0; i < _navItems.length; i++) {
      if (_navItems[i].route == currentRoute) {
        return i;
      }
    }
    return 0; // 默认选中首页
  }

  /// 处理导航项点击
  void _onItemTapped(int index) {
    if (index < _navItems.length) {
      final targetRoute = _navItems[index].route;
      if (Get.currentRoute != targetRoute) {
        Get.offAllNamed(targetRoute);
      }
    }
  }
}

/// 带徽章的底部导航栏（可选功能）
class AppBottomNavWithBadge extends StatelessWidget {
  final Map<String, String>? badges;

  const AppBottomNavWithBadge({
    super.key,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _getCurrentIndex(),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: AppBottomNav._navItems.map((item) {
          final isSelected = Get.currentRoute == item.route;
          final badgeText = badges?[item.route];

          Widget iconWidget = Icon(isSelected ? item.activeIcon : item.icon);

          // 如果有徽章，添加徽章
          if (badgeText != null && badgeText.isNotEmpty) {
            iconWidget = Stack(
              children: [
                iconWidget,
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          }

          return BottomNavigationBarItem(
            icon: iconWidget,
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  /// 获取当前选中的索引
  int _getCurrentIndex() {
    final currentRoute = Get.currentRoute;
    for (int i = 0; i < AppBottomNav._navItems.length; i++) {
      if (AppBottomNav._navItems[i].route == currentRoute) {
        return i;
      }
    }
    return 0;
  }

  /// 处理导航项点击
  void _onItemTapped(int index) {
    if (index < AppBottomNav._navItems.length) {
      final targetRoute = AppBottomNav._navItems[index].route;
      if (Get.currentRoute != targetRoute) {
        Get.offAllNamed(targetRoute);
      }
    }
  }
}
