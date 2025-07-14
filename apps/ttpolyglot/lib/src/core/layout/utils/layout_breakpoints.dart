import 'package:flutter/material.dart';

/// 布局断点常量
class LayoutBreakpoints {
  /// 移动端断点 (< 600px)
  static const double mobile = 600;

  /// 平板端断点 (600px - 1024px)
  static const double tablet = 1024;

  /// 桌面端断点 (> 1024px)
  static const double desktop = 1024;

  /// 侧边栏宽度
  static const double sidebarWidth = 280;

  /// 紧凑侧边栏宽度（仅图标）
  static const double compactSidebarWidth = 72;
}

/// 屏幕类型枚举
enum ScreenType {
  mobile,
  tablet,
  desktop,
}

/// 响应式布局工具类
class ResponsiveUtils {
  /// 获取当前屏幕类型
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < LayoutBreakpoints.mobile) {
      return ScreenType.mobile;
    } else if (width < LayoutBreakpoints.desktop) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  /// 是否为移动端
  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }

  /// 是否为平板端
  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }

  /// 是否为桌面端
  static bool isDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.desktop;
  }

  /// 是否应该显示常驻侧边栏
  static bool shouldShowPersistentSidebar(BuildContext context) {
    return !isMobile(context);
  }

  /// 是否应该显示抽屉式侧边栏
  static bool shouldShowDrawer(BuildContext context) {
    return isMobile(context);
  }

  /// 获取侧边栏宽度
  static double getSidebarWidth(BuildContext context) {
    if (isMobile(context)) {
      return LayoutBreakpoints.sidebarWidth;
    } else if (isTablet(context)) {
      return LayoutBreakpoints.compactSidebarWidth;
    } else {
      return LayoutBreakpoints.sidebarWidth;
    }
  }

  /// 是否应该显示紧凑侧边栏
  static bool shouldShowCompactSidebar(BuildContext context) {
    return isTablet(context);
  }
}
