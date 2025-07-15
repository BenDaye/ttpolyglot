import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout.dart';
import 'package:ttpolyglot/src/features/dashboard/views/dashboard_view.dart';
import 'package:ttpolyglot/src/features/project/bindings/project_binding.dart';
import 'package:ttpolyglot/src/features/project/views/project_shell.dart';
import 'package:ttpolyglot/src/features/projects/bindings/projects_binding.dart';
import 'package:ttpolyglot/src/features/projects/views/projects_shell.dart';
import 'package:ttpolyglot/src/features/root/bindings/root_binding.dart';
import 'package:ttpolyglot/src/features/root/views/root_view.dart';
import 'package:ttpolyglot/src/features/settings/bindings/settings_binding.dart';
import 'package:ttpolyglot/src/features/settings/views/settings_view.dart';
import 'package:ttpolyglot/src/features/sign_in/bindings/sign_in_binding.dart';
import 'package:ttpolyglot/src/features/sign_in/views/sign_in_view.dart';
import 'package:ttpolyglot/src/features/sign_up/bindings/sign_up_binding.dart';
import 'package:ttpolyglot/src/features/sign_up/views/sign_up_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final unknownRoute = GetPage(
    name: Routes.unknown,
    page: () => const Placeholder(
      child: Center(
        child: Text('Unknown Page'),
      ),
    ),
  );

  static final List<GetPage> pages = [
    GetPage(
        name: '/',
        page: () => const RootView(),
        bindings: [RootBinding()],
        participatesInRootNavigator: true,
        preventDuplicates: true,
        children: [
          GetPage(
            name: _Paths.signIn,
            page: () => const SignInView(),
            bindings: [SignInBinding()],
            middlewares: [EnsureNotAuthenticatedMiddleware()],
          ),
          GetPage(
            name: _Paths.signUp,
            page: () => const SignUpView(),
            bindings: [SignUpBinding()],
            middlewares: [EnsureNotAuthenticatedMiddleware()],
          ),
          GetPage(
            name: _Paths.home,
            page: () => const MainShell(),
            bindings: [LayoutBindings()],
            preventDuplicates: true,
            title: null,
            children: [
              GetPage(
                name: _Paths.dashboard,
                page: () => const DashboardView(),
                transition: Transition.fadeIn,
              ),
              GetPage(
                name: _Paths.settings,
                page: () => const SettingsView(),
                bindings: [SettingsBinding()],
                transition: Transition.fadeIn,
              ),
              GetPage(
                name: _Paths.projects,
                page: () => const ProjectsShell(),
                bindings: [ProjectsBinding()],
                transition: Transition.fadeIn,
                children: [
                  GetPage(
                    name: _Paths.project,
                    page: () => const ProjectShell(),
                    bindings: [ProjectBinding()],
                    transition: Transition.leftToRightWithFade,
                  ),
                ],
              ),
            ],
          ),
        ]),
  ];
}

class EnsureNotAuthenticatedMiddleware extends GetMiddleware {}

class EnsureAuthenticatedMiddleware extends GetMiddleware {}
