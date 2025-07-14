import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/layout/layout_controller.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
import 'settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<LayoutController>();
      controller.updateLayoutForRoute(AppRouter.settings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SettingsPageContent();
  }
}

/// 导出的设置页面内容组件，用于嵌套路由
class SettingsPageContent extends StatelessWidget {
  const SettingsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsPageContent();
  }
}

class _SettingsPageContent extends StatelessWidget {
  const _SettingsPageContent();

  @override
  Widget build(BuildContext context) {
    // 获取控制器
    final controller = Get.put(SettingsController());
    final themeController = Get.find<AppThemeController>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeSection(themeController),
            const SizedBox(height: 24),
            _buildLanguageSection(controller),
            const SizedBox(height: 24),
            _buildGeneralSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(AppThemeController themeController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.palette),
                SizedBox(width: 12),
                Text(
                  '主题设置',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => ListTile(
                  title: const Text('主题模式'),
                  subtitle: Text(_getThemeModeText(themeController.themeMode)),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeController.themeMode,
                    onChanged: (ThemeMode? mode) {
                      if (mode != null) {
                        themeController.setThemeMode(mode);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('跟随系统'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('浅色'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('深色'),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(SettingsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.language),
                SizedBox(width: 12),
                Text(
                  '语言设置',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => ListTile(
                  title: const Text('应用语言'),
                  subtitle: Text(_getLanguageName(controller.language)),
                  trailing: DropdownButton<String>(
                    value: controller.language,
                    onChanged: (String? language) {
                      if (language != null) {
                        controller.setLanguage(language);
                      }
                    },
                    items: controller.languages.map<DropdownMenuItem<String>>((lang) {
                      return DropdownMenuItem<String>(
                        value: lang['code'],
                        child: Text(lang['name']!),
                      );
                    }).toList(),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSection(SettingsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 12),
                Text(
                  '通用设置',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => SwitchListTile(
                  title: const Text('自动保存'),
                  subtitle: const Text('编辑时自动保存更改'),
                  value: controller.autoSave,
                  onChanged: (bool value) {
                    controller.toggleAutoSave();
                  },
                )),
            Obx(() => SwitchListTile(
                  title: const Text('通知'),
                  subtitle: const Text('接收应用通知'),
                  value: controller.notifications,
                  onChanged: (bool value) {
                    controller.toggleNotifications();
                  },
                )),
          ],
        ),
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '跟随系统';
      case ThemeMode.light:
        return '浅色';
      case ThemeMode.dark:
        return '深色';
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'zh_CN':
        return '中文';
      case 'en_US':
        return 'English';
      default:
        return '中文';
    }
  }
}
