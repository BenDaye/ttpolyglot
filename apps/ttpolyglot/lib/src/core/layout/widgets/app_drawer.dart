import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routing/app_router.dart';

/// 应用侧边栏
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 侧边栏头部
          _buildDrawerHeader(context),

          // 导航菜单
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: '首页',
                  route: AppRouter.home,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.folder,
                  title: '项目管理',
                  route: AppRouter.projects,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: '设置',
                  route: AppRouter.settings,
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: '帮助',
                  onTap: () {
                    Get.back();
                    Get.snackbar('提示', '帮助页面即将推出');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: '关于',
                  onTap: () {
                    Get.back();
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),

          // 底部版本信息
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  /// 构建侧边栏头部
  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.translate,
              size: 30,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'TTPolyglot',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            '翻译管理平台',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }

  /// 构建侧边栏菜单项
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
  }) {
    final isSelected = route != null && Get.currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      onTap: onTap ??
          () {
            Get.back(); // 关闭侧边栏
            if (route != null && Get.currentRoute != route) {
              Get.offAllNamed(route);
            }
          },
    );
  }

  /// 构建侧边栏底部
  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  /// 显示关于对话框
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TTPolyglot',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.translate, size: 48),
      children: [
        const Text('TTPolyglot 是一个跨平台的翻译管理工具，支持桌面、Web 和移动端。'),
        const SizedBox(height: 16),
        const Text('功能特性：'),
        const Text('• 多文件格式支持'),
        const Text('• 实时协作翻译'),
        const Text('• 智能翻译建议'),
        const Text('• 跨平台数据同步'),
      ],
    );
  }
}
