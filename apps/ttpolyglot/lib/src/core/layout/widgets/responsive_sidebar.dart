import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout_controller.dart';
import '../utils/layout_breakpoints.dart';

/// 响应式侧边栏组件
class ResponsiveSidebar extends StatelessWidget {
  const ResponsiveSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LayoutController>(
      builder: (controller) {
        if (ResponsiveUtils.shouldShowPersistentSidebar(context)) {
          // 桌面端和平板端：常驻侧边栏
          return _buildPersistentSidebar(context);
        } else {
          // 移动端：抽屉式侧边栏
          return _buildDrawerSidebar(context);
        }
      },
    );
  }

  /// 构建常驻侧边栏
  Widget _buildPersistentSidebar(BuildContext context) {
    final isCompact = ResponsiveUtils.shouldShowCompactSidebar(context);
    final width = ResponsiveUtils.getSidebarWidth(context);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 应用头部
          _buildAppHeader(context, isCompact),

          // 导航菜单
          Expanded(
            child: _buildNavigationMenu(context, isCompact),
          ),

          // 底部信息
          if (!isCompact) _buildBottomInfo(context),
        ],
      ),
    );
  }

  /// 构建抽屉式侧边栏
  Widget _buildDrawerSidebar(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 应用头部
          _buildAppHeader(context, false),

          // 导航菜单
          Expanded(
            child: _buildNavigationMenu(context, false),
          ),

          // 底部信息
          _buildBottomInfo(context),
        ],
      ),
    );
  }

  /// 构建应用头部
  Widget _buildAppHeader(BuildContext context, bool isCompact) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 8 : 16),
      child: isCompact
          ? Icon(
              Icons.translate,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            )
          : Row(
              children: [
                Icon(
                  Icons.translate,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TTPolyglot',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '多语言翻译工具',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// 构建导航菜单
  Widget _buildNavigationMenu(BuildContext context, bool isCompact) {
    return GetBuilder<LayoutController>(
      builder: (controller) => Obx(
        () => ListView(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 4 : 8,
            vertical: 8,
          ),
          children: [
            _buildNavigationItem(
              context: context,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: '首页',
              route: '/home',
              isCompact: isCompact,
              isActive: controller.currentIndex == 0,
            ),
            _buildNavigationItem(
              context: context,
              icon: Icons.folder_outlined,
              activeIcon: Icons.folder,
              label: '项目',
              route: '/projects',
              isCompact: isCompact,
              badge: controller.projectsBadge.value,
              isActive: controller.currentIndex == 1,
            ),
            _buildNavigationItem(
              context: context,
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: '设置',
              route: '/settings',
              isCompact: isCompact,
              isActive: controller.currentIndex == 2,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建导航项
  Widget _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required bool isCompact,
    int? badge,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // 使用 GetX 路由导航到子路由
            Get.rootDelegate.offAndToNamed('/main$route');
            if (ResponsiveUtils.isMobile(context)) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            padding: EdgeInsets.all(isCompact ? 12 : 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isActive ? Theme.of(context).colorScheme.primaryContainer : null,
            ),
            child: isCompact
                ? _buildCompactNavigationItem(context, icon, activeIcon, isActive, badge)
                : _buildFullNavigationItem(context, icon, activeIcon, label, isActive, badge),
          ),
        ),
      ),
    );
  }

  /// 构建紧凑导航项
  Widget _buildCompactNavigationItem(
    BuildContext context,
    IconData icon,
    IconData activeIcon,
    bool isActive,
    int? badge,
  ) {
    return Stack(
      children: [
        Icon(
          isActive ? activeIcon : icon,
          color: isActive ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
        ),
        if (badge != null && badge > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badge > 99 ? '99+' : badge.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
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

  /// 构建完整导航项
  Widget _buildFullNavigationItem(
    BuildContext context,
    IconData icon,
    IconData activeIcon,
    String label,
    bool isActive,
    int? badge,
  ) {
    return Row(
      children: [
        Icon(
          isActive ? activeIcon : icon,
          color: isActive ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isActive
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ),
        if (badge != null && badge > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge > 99 ? '99+' : badge.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  /// 构建底部信息
  Widget _buildBottomInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '版本信息',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'v1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
          ),
        ],
      ),
    );
  }
}
