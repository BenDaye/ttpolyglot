import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/home/home_page.dart';
import '../../features/projects/projects_page.dart';
import '../../features/settings/settings_page.dart';
import '../layout/widgets/main_shell.dart';

/// 应用路由配置
class AppRouter {
  // 主路由
  static const String main = '/main';

  // 子路由
  static const String home = '$main/home';
  static const String projects = '$main/projects';
  static const String settings = '$main/settings';

  // 其他路由
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';

  static List<GetPage> get routes => [
        // 欢迎页面（可选）
        GetPage(
          name: welcome,
          page: () => const HomePage(),
        ),

        // 主布局路由（包含侧边栏）
        GetPage(
          name: main,
          page: () => const MainShell(),
          children: [
            // 首页子路由
            GetPage(
              name: '/home',
              page: () => const HomePage(),
              transition: Transition.fadeIn,
            ),
            // 项目页面子路由
            GetPage(
              name: '/projects',
              page: () => const ProjectsPage(),
              transition: Transition.fadeIn,
            ),
            // 设置页面子路由
            GetPage(
              name: '/settings',
              page: () => const SettingsPage(),
              transition: Transition.fadeIn,
            ),
          ],
        ),

        // 认证相关路由（独立布局）
        GetPage(
          name: login,
          page: () => const LoginPage(),
        ),
        GetPage(
          name: register,
          page: () => const RegisterPage(),
        ),
      ];

  /// 未知路由处理
  static GetPage get unknownRoute => GetPage(
        name: '/404',
        page: () => const NotFoundPage(),
      );

  /// 获取默认路由
  static String get initialRoute => main;
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
              onPressed: () => Get.offAllNamed(AppRouter.home),
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
