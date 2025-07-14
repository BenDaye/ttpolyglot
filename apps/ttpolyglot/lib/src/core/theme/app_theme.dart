import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// 应用主题控制器 - 橙色主题设计
class AppThemeController extends GetxController {
  // 主题模式响应式变量
  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  /// 切换主题模式
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  /// 橙色主题的浅色主题
  ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.orangeM3,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 5,
      subThemesData: FlexSubThemesData(
        blendOnLevel: 8,
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        // 卡片样式
        cardRadius: 16.0,
        cardElevation: 2.0,
        // 按钮样式
        elevatedButtonRadius: 12.0,
        filledButtonRadius: 12.0,
        outlinedButtonRadius: 12.0,
        textButtonRadius: 12.0,
        // 输入框样式
        inputDecoratorRadius: 8.0,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        // 导航栏样式
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarSelectedIconSchemeColor: SchemeColor.primary,
        // 应用栏样式
        appBarBackgroundSchemeColor: SchemeColor.surface,
        // 底部导航栏样式
        bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
        bottomNavigationBarBackgroundSchemeColor: SchemeColor.surface,
        bottomNavigationBarElevation: 8,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    ).copyWith(
      // 自定义颜色
      colorScheme: FlexColorScheme.light(
        scheme: FlexScheme.orangeM3,
        blendLevel: 5,
      ).toScheme.copyWith(
            // 橙色主色调
            primary: const Color(0xFFFF6B35),
            primaryContainer: const Color(0xFFFF6B35).withValues(alpha: 0.1),
            onPrimary: Colors.white,
            onPrimaryContainer: const Color(0xFFFF6B35),
            // 表面颜色
            surface: const Color(0xFFFAFAFA),
            surfaceContainerLowest: const Color(0xFFF5F5F5),
            surfaceContainerLow: const Color(0xFFF0F0F0),
            surfaceContainer: const Color(0xFFEDEDED),
            surfaceContainerHigh: const Color(0xFFE8E8E8),
            surfaceContainerHighest: const Color(0xFFE3E3E3),
            // 错误色
            error: const Color(0xFFE53E3E),
            onError: Colors.white,
            // 轮廓色
            outline: const Color(0xFFE5E5E5),
            outlineVariant: const Color(0xFFF0F0F0),
          ),
      // 自定义阴影
      shadowColor: Colors.black.withValues(alpha: 0.1),
      // TextField 全局样式
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: const Color(0xFFE5E5E5).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: const Color(0xFFE5E5E5).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF6B35),
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: const Color(0xFF191919).withValues(alpha: 0.5),
        ),
      ),
    );
  }

  /// 橙色主题的深色主题
  ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.orangeM3,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 8,
      subThemesData: FlexSubThemesData(
        blendOnLevel: 12,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        // 卡片样式
        cardRadius: 16.0,
        cardElevation: 4.0,
        // 按钮样式
        elevatedButtonRadius: 12.0,
        filledButtonRadius: 12.0,
        outlinedButtonRadius: 12.0,
        textButtonRadius: 12.0,
        // 输入框样式
        inputDecoratorRadius: 8.0,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        // 导航栏样式
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarSelectedIconSchemeColor: SchemeColor.primary,
        // 应用栏样式
        appBarBackgroundSchemeColor: SchemeColor.surface,
        // 底部导航栏样式
        bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
        bottomNavigationBarBackgroundSchemeColor: SchemeColor.surface,
        bottomNavigationBarElevation: 8,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    ).copyWith(
      // 自定义颜色
      colorScheme: FlexColorScheme.dark(
        scheme: FlexScheme.orangeM3,
        blendLevel: 8,
      ).toScheme.copyWith(
            // 橙色主色调
            primary: const Color(0xFFFF6B35),
            primaryContainer: const Color(0xFFFF6B35).withValues(alpha: 0.2),
            onPrimary: Colors.white,
            onPrimaryContainer: const Color(0xFFFF6B35),
            // 表面颜色 - 深色模式
            surface: const Color(0xFF1C1C1E),
            surfaceContainerLowest: const Color(0xFF000000),
            surfaceContainerLow: const Color(0xFF1C1C1E),
            surfaceContainer: const Color(0xFF2C2C2E),
            surfaceContainerHigh: const Color(0xFF3A3A3C),
            surfaceContainerHighest: const Color(0xFF48484A),
            // 错误色
            error: const Color(0xFFE53E3E),
            onError: Colors.white,
            // 轮廓色
            outline: const Color(0xFF38383A),
            outlineVariant: const Color(0xFF2C2C2E),
          ),
      // 自定义阴影
      shadowColor: Colors.black.withValues(alpha: 0.3),
      // TextField 全局样式
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2E),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: const Color(0xFF38383A).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: const Color(0xFF38383A).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF6B35),
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  /// 橙色主色调
  Color get primaryColor => const Color(0xFFFF6B35);

  /// 橙色次要色调
  Color get secondaryColor => const Color(0xFFFF8A65);

  /// 成功色 - 绿色
  Color get successColor => const Color(0xFF38A169);

  /// 警告色 - 橙色
  Color get warningColor => const Color(0xFFFF6B35);

  /// 错误色 - 红色
  Color get errorColor => const Color(0xFFE53E3E);

  /// 信息色 - 蓝色
  Color get infoColor => const Color(0xFF3182CE);

  /// 获取当前主题的卡片装饰
  BoxDecoration get cardDecoration {
    final isDark = Get.isDarkMode;
    return BoxDecoration(
      color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFAFAFA),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.08),
          blurRadius: isDark ? 8 : 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// 获取当前主题的按钮装饰
  BoxDecoration get buttonDecoration {
    return BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// 获取当前主题的输入框装饰
  BoxDecoration get inputDecoration {
    final isDark = Get.isDarkMode;
    return BoxDecoration(
      color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5E5),
        width: 1,
      ),
    );
  }

  /// 获取橙色主题的文本样式
  TextStyle get orangeTitleStyle {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Get.isDarkMode ? Colors.white : const Color(0xFF191919),
    );
  }

  TextStyle get orangeBodyStyle {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Get.isDarkMode ? Colors.white70 : const Color(0xFF333333),
    );
  }

  TextStyle get orangeCaptionStyle {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Get.isDarkMode ? Colors.white54 : const Color(0xFF999999),
    );
  }

  /// 获取橙色主题的渐变色
  LinearGradient get primaryGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor,
        primaryColor.withValues(alpha: 0.8),
      ],
    );
  }

  /// 获取橙色主题的分割线
  Widget get divider {
    return Container(
      height: 1,
      color: Get.isDarkMode ? const Color(0xFF38383A) : const Color(0xFFE5E5E5),
    );
  }
}
