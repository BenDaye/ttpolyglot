import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/root/root.dart';
import 'package:ttpolyglot_utils/utils.dart';

import 'core/layout/layout_controller.dart';
import 'core/routing/app_pages.dart';
import 'core/theme/app_theme.dart';

class TTPolyglotApp extends StatelessWidget {
  const TTPolyglotApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 初始化控制器
    LayoutUtils.initLayoutController();

    return GetMaterialApp(
      title: 'TTPolyglot',
      initialBinding: RootBinding(),
      theme: AppThemeController.lightTheme,
      darkTheme: AppThemeController.darkTheme,
      themeMode: AppThemeController.instance.themeMode,
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
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: (context, child) {
        child ??= SizedBox.shrink();
        // 初始化 Toast
        child = ToastUtils.botToastInit(context, child);
        //
        return child;
      },
    );
  }
}
