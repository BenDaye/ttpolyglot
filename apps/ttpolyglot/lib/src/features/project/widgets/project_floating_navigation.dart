import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

/// 项目悬浮导航组件
class ProjectFloatingNavigation extends StatelessWidget {
  const ProjectFloatingNavigation({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectNavigationController>(
      tag: projectId,
      builder: (controller) {
        return Positioned(
          right: 8.0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 2.0,
                children: controller.navItems.map((item) {
                  return Obx(() => _buildNavButton(
                        context,
                        item,
                        controller.isCurrentPage(item.id),
                        () => controller.navigateToSubPage(item.id),
                      ));
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    ProjectNavItem item,
    bool isActive,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: item.tooltip,
        preferBelow: false,
        child: InkWell(
          onTap: item.isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(4.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48.0,
            height: 48.0,
            child: Icon(
              isActive ? item.activeIcon : item.icon,
              size: 24.0,
              color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

/// 紧凑版本的悬浮导航（仅图标）
class ProjectFloatingNavigationCompact extends StatelessWidget {
  const ProjectFloatingNavigationCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectNavigationController>(
      builder: (controller) {
        return Positioned(
          right: 16.0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2.0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: controller.navItems.map((item) {
                  return Obx(() => _buildCompactNavButton(
                        context,
                        item,
                        controller.isCurrentPage(item.id),
                        () => controller.navigateToSubPage(item.id),
                      ));
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactNavButton(
    BuildContext context,
    ProjectNavItem item,
    bool isActive,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Material(
        color: Colors.transparent,
        child: Tooltip(
          message: item.tooltip,
          preferBelow: false,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: isActive ? colorScheme.primary.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                size: 20.0,
                color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 水平版本的悬浮导航（适用于移动端）
class ProjectFloatingNavigationHorizontal extends StatelessWidget {
  const ProjectFloatingNavigationHorizontal({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectNavigationController>(
      tag: projectId,
      builder: (controller) {
        return Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 24.0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(28.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
                  blurRadius: 12.0,
                  offset: const Offset(0, 4.0),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: controller.navItems.map((item) {
                return Obx(() => _buildHorizontalNavButton(
                      context,
                      item,
                      controller.isCurrentPage(item.id),
                      () => controller.navigateToSubPage(item.id),
                    ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalNavButton(
    BuildContext context,
    ProjectNavItem item,
    bool isActive,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: item.tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isActive ? colorScheme.primary.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 20.0,
                  color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 2.0),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
