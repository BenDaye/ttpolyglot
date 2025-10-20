import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/layout/layout.dart';
import 'package:ttpolyglot/src/features/features.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.signIn;

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
            middlewares: [EnsureAuthenticatedMiddleware()],
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
                name: _Paths.profile,
                page: () => const ProfileView(),
                bindings: [ProfileBinding()],
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

/// 确保未登录中间件（用于登录页、注册页等）
class EnsureNotAuthenticatedMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // 如果已登录，重定向到主页
    final authService = Get.find<AuthService>();
    if (authService.isLoggedIn) {
      return const RouteSettings(name: Routes.home);
    }
    return null;
  }
}

/// 确保已登录中间件（用于需要登录的页面）
class EnsureAuthenticatedMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // 如果未登录，重定向到登录页
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn) {
      return const RouteSettings(name: Routes.signIn);
    }
    return null;
  }
}
