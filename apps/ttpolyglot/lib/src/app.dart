import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/layout/layout_controller.dart';
import 'core/routing/app_pages.dart';
import 'core/theme/app_theme.dart';

class TTPolyglotApp extends StatelessWidget {
  const TTPolyglotApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 初始化控制器
    final themeController = Get.put(AppThemeController());
    LayoutUtils.initLayoutController();

    return GetMaterialApp(
      title: 'TTPolyglot',
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
      themeMode: themeController.themeMode,
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      unknownRoute: AppPages.unknownRoute,
      debugShowCheckedModeBanner: kDebugMode,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('zh', 'CN'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
