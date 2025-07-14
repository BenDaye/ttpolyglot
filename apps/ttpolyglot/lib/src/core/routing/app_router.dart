import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout.dart';
import 'package:ttpolyglot/src/features/features.dart';

enum RootRoute {
  main('main', '/main'),
  welcome('welcome', '/'),
  auth('auth', '/auth'),
  unknown('unknown', '/404'),
  ;

  const RootRoute(this.name, this.path);

  final String name;
  final String path;
}

enum MainRoute {
  home('home', '/home'),
  projects('projects', '/projects'),
  settings('settings', '/settings'),
  ;

  const MainRoute(this.name, this.path);

  final String name;
  final String path;

  static final String prefix = RootRoute.main.path;
  String get fullPath => '$prefix$path';
}

enum AuthRoute {
  signIn('signIn', '/signIn'),
  signUp('signUp', '/signUp'),
  ;

  const AuthRoute(this.name, this.path);

  final String name;
  final String path;

  static final String prefix = RootRoute.auth.path;
  String get fullPath => '$prefix$path';
}

enum ProjectsRoute {
  empty('empty', '/empty'),
  dashboard('dashboard', '/:projectId/dashboard'),
  translations('translations', '/:projectId/translations'),
  languages('languages', '/:projectId/languages'),
  settings('settings', '/:projectId/settings'),
  ;

  const ProjectsRoute(this.name, this.path);

  final String name;
  final String path;

  static final String prefix = MainRoute.projects.fullPath;
  String get fullPath => '$prefix$path';
}

/// 应用路由配置
class AppRouter {
  static List<GetPage> get routes => [
        // 欢迎页面（可选）
        GetPage(
          name: RootRoute.welcome.path,
          page: () => const HomePage(),
        ),

        // 主布局路由（包含侧边栏）
        GetPage(
          name: RootRoute.main.path,
          page: () => const MainShell(),
          bindings: [LayoutBindings()],
          children: [
            // 首页子路由
            GetPage(
              name: MainRoute.home.path,
              page: () => const HomePage(),
              transition: Transition.fadeIn,
            ),
            // 项目页面子路由
            GetPage(
              name: MainRoute.projects.path,
              page: () => const ProjectShell(),
              transition: Transition.fadeIn,
              bindings: [ProjectsBindings()],
              children: [
                GetPage(
                  name: ProjectsRoute.empty.path,
                  page: () => const Placeholder(
                    child: Text('empty'),
                  ),
                ),
                GetPage(
                  name: ProjectsRoute.dashboard.path,
                  page: () => const Placeholder(
                    child: Text('dashboard'),
                  ),
                ),
                GetPage(
                  name: ProjectsRoute.translations.path,
                  page: () => const Placeholder(
                    child: Text('translations'),
                  ),
                ),
                GetPage(
                  name: ProjectsRoute.languages.path,
                  page: () => const Placeholder(
                    child: Text('languages'),
                  ),
                ),
              ],
            ),
            // 设置页面子路由
            GetPage(
              name: MainRoute.settings.path,
              page: () => const SettingsPage(),
              transition: Transition.fadeIn,
            ),
          ],
        ),

        // 认证相关路由（独立布局）
        GetPage(
          name: AuthRoute.signIn.path,
          page: () => const LoginPage(),
        ),
        GetPage(
          name: AuthRoute.signUp.path,
          page: () => const RegisterPage(),
        ),
      ];

  /// 未知路由处理
  static GetPage get unknownRoute => GetPage(
        name: RootRoute.unknown.path,
        page: () => const NotFoundPage(),
      );

  /// 获取默认路由
  static String get initialRoute => RootRoute.main.path;
}

/// 404 页面
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              '页面未找到',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '抱歉，您访问的页面不存在',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(MainRoute.home.fullPath),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 临时登录页面
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: const Center(
        child: Text('登录页面'),
      ),
    );
  }
}

/// 临时注册页面
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('注册')),
      body: const Center(
        child: Text('注册页面'),
      ),
    );
  }
}
