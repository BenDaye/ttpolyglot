import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class TTPolyglotApp extends ConsumerWidget {
  const TTPolyglotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'TTPolyglot',
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
