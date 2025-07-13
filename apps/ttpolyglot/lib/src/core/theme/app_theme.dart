import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// 应用主题提供者
final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

/// 应用主题管理
class AppTheme {
  /// 浅色主题
  ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.blue,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }

  /// 深色主题
  ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.blue,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }

  /// 主题模式
  ThemeMode get themeMode => ThemeMode.system;

  /// 主色调
  Color get primaryColor => Colors.blue;

  /// 次要色调
  Color get secondaryColor => Colors.blueAccent;

  /// 成功色
  Color get successColor => Colors.green;

  /// 警告色
  Color get warningColor => Colors.orange;

  /// 错误色
  Color get errorColor => Colors.red;

  /// 信息色
  Color get infoColor => Colors.blue;
}
