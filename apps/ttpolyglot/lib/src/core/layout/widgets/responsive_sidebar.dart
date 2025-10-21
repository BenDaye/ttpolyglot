import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/services/auth_service.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/layout/utils/layout_breakpoints.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';

/// 响应式侧边栏组件 - 微信风格设计
class ResponsiveSidebar extends StatelessWidget {
  const ResponsiveSidebar({super.key, this.delegate});

  final GetDelegate? delegate;

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.shouldShowPersistentSidebar(context)
        ? _buildPersistentSidebar(
            context,
            delegate: delegate,
          )
        : _buildDrawerSidebar(
            context,
            delegate: delegate,
          );
  }

  /// 构建常驻侧边栏 - 微信风格
  Widget _buildPersistentSidebar(
    BuildContext context, {
    GetDelegate? delegate,
  }) {
    const width = LayoutBreakpoints.compactSidebarWidth;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 应用头部 - 微信风格
          _buildCompactAppHeader(context),

          // 导航菜单
          Expanded(
            child: _buildNavigationMenu(
              context,
              isCompact: true,
              delegate: delegate,
            ),
          ),

          // 底部用户信息
          _buildCompactUserInfo(context),
        ],
      ),
    );
  }

  /// 构建抽屉式侧边栏 - 微信风格
  Widget _buildDrawerSidebar(
    BuildContext context, {
    GetDelegate? delegate,
  }) {
    return Drawer(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // 应用头部
          _buildFullAppHeader(context),

          // 导航菜单
          Expanded(
            child: _buildNavigationMenu(
              context,
              isCompact: false,
              delegate: delegate,
            ),
          ),

          // 底部信息
          _buildBottomInfo(context),
        ],
      ),
    );
  }

  /// 构建紧凑应用头部 - 微信风格
  Widget _buildCompactAppHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.translate_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
        ),
      ),
    );
  }

  /// 构建完整应用头部 - 微信风格
  Widget _buildFullAppHeader(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 应用图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.translate_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 28,
            ),
          ),

          const SizedBox(height: 12),

          // 应用名称
          Text(
            'TTPolyglot',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),

          // 应用描述
          Text(
            '多语言翻译工具',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }

  /// 构建导航菜单 - 微信风格
  Widget _buildNavigationMenu(
    BuildContext context, {
    bool isCompact = false,
    GetDelegate? delegate,
  }) {
    return GetBuilder<LayoutController>(
      builder: (controller) => Obx(
        () => Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 4.0 : 8.0,
          ),
          child: Column(
            children: [
              // 主要导航项
              Expanded(
                child: ListView(
                  children: [
                    _buildNavigationItem(
                      context: context,
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard_rounded,
                      label: '首页',
                      route: Routes.dashboard,
                      isCompact: isCompact,
                      isActive: controller.currentIndex == 0,
                      delegate: delegate,
                    ),
                    const SizedBox(height: 2.0),
                    _buildNavigationItem(
                      context: context,
                      icon: Icons.folder_outlined,
                      activeIcon: Icons.folder_rounded,
                      label: '项目',
                      route: Routes.projects,
                      isCompact: isCompact,
                      badge: controller.projectsBadge.value,
                      isActive: controller.currentIndex == 1,
                      delegate: delegate,
                    ),
                  ],
                ),
              ),

              // 分隔线
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(
                  horizontal: isCompact ? 4.0 : 0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),

              // 设置项
              _buildNavigationItem(
                context: context,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings_rounded,
                label: '设置',
                route: Routes.settings,
                isCompact: isCompact,
                isActive: controller.currentIndex == 2,
                delegate: delegate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建导航项 - 微信风格
  Widget _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    bool isCompact = false,
    int? badge,
    bool isActive = false,
    GetDelegate? delegate,
  }) {
    delegate ??= Get.rootDelegate;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isCompact ? 8.0 : 4.0),
          onTap: () {
            // 添加触觉反馈
            // HapticFeedback.lightImpact();

            delegate?.offAndToNamed(route);

            if (ResponsiveUtils.isMobile(context)) {
              Get.back();
            }
          },
          child: Container(
            padding: EdgeInsets.all(isCompact ? 14.0 : 10.0),
            child: isCompact
                ? _buildCompactNavigationItem(
                    context,
                    icon,
                    activeIcon,
                    isActive,
                    badge,
                  )
                : _buildFullNavigationItem(
                    context,
                    icon,
                    activeIcon,
                    label,
                    isActive,
                    badge,
                  ),
          ),
        ),
      ),
    );
  }

  /// 构建紧凑导航项 - 微信风格
  Widget _buildCompactNavigationItem(
    BuildContext context,
    IconData icon,
    IconData activeIcon,
    bool isActive,
    int? badge,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isActive ? activeIcon : icon,
            key: ValueKey(isActive),
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            size: 24,
          ),
        ),
        if (badge != null && badge > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
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

  /// 构建完整导航项 - 微信风格
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
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isActive ? activeIcon : icon,
            key: ValueKey(isActive),
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ),
        if (badge != null && badge > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              badge > 99 ? '99+' : badge.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  /// 构建紧凑用户信息 - 微信风格
  Widget _buildCompactUserInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: PopupMenuButton<String>(
        offset: const Offset(60.0, -0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12.0),
                const Text('个人信息'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12.0),
                Text(
                  '退出登录',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'profile') {
            Get.rootDelegate.offAndToNamed(Routes.profile);
            if (ResponsiveUtils.isMobile(context)) {
              Get.back();
            }
          } else if (value == 'logout') {
            _handleLogout(context);
          }
        },
        child: SizedBox(
          width: 48.0,
          height: 48.0,
          child: Icon(
            Icons.person_outline_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24.0,
          ),
        ),
      ),
    );
  }

  /// 处理退出登录
  Future<void> _handleLogout(BuildContext context) async {
    try {
      // 确认退出
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('确认退出'),
          content: const Text('确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('确定'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // 在异步操作前保存主题颜色，避免 context 失效
      final theme = Theme.of(Get.context!);
      final primaryContainer = theme.colorScheme.primaryContainer;
      final onPrimaryContainer = theme.colorScheme.onPrimaryContainer;

      // 执行退出
      await Get.find<AuthService>().logout();

      // 跳转到登录页面
      Get.offAllNamed(Routes.signIn);

      // 显示退出成功提示
      Get.snackbar(
        '提示',
        '已退出登录',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryContainer,
        colorText: onPrimaryContainer,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    } catch (error, stackTrace) {
      log('_handleLogout', error: error, stackTrace: stackTrace, name: 'ResponsiveSidebar');
      Get.snackbar(
        '错误',
        '退出登录失败',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    }
  }

  /// 构建底部信息 - 微信风格
  Widget _buildBottomInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '用户',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      '未登录',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 版本信息
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 8),
              Text(
                'v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
