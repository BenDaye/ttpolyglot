import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/core/theme/app_theme.dart';
import 'package:ttpolyglot/src/features/settings/controllers/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<LayoutController>()) {
        final controller = Get.find<LayoutController>();
        controller.updateLayoutForRoute(Routes.settings);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SettingsViewContent();
  }
}

/// 导出的设置页面内容组件，用于嵌套路由
class SettingsViewContent extends StatelessWidget {
  const SettingsViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsViewContent();
  }
}

class _SettingsViewContent extends StatelessWidget {
  const _SettingsViewContent();

  @override
  Widget build(BuildContext context) {
    // 获取控制器
    final controller = Get.find<SettingsController>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeSection(AppThemeController.to),
            _buildLanguageSection(controller),
            _buildGeneralSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(
    AppThemeController themeController,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette),
                SizedBox(width: 12),
                Text('主题设置'),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              dense: true,
              title: const Text('主题'),
              subtitle: const Text('选择应用主题'),
              trailing: Obx(
                () => SegmentedButton<ThemeMode>(
                  selected: {themeController.themeMode},
                  onSelectionChanged: (Set<ThemeMode> mode) {
                    themeController.setThemeMode(mode.first);
                  },
                  segments: [
                    ButtonSegment(
                      icon: const Icon(Icons.brightness_auto),
                      value: ThemeMode.system,
                      label: Text(_getThemeModeText(ThemeMode.system)),
                    ),
                    ButtonSegment(
                      icon: const Icon(Icons.brightness_5),
                      value: ThemeMode.light,
                      label: Text(_getThemeModeText(ThemeMode.light)),
                    ),
                    ButtonSegment(
                      icon: const Icon(Icons.brightness_2),
                      value: ThemeMode.dark,
                      label: Text(_getThemeModeText(ThemeMode.dark)),
                    ),
                  ],
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(SettingsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.language),
                SizedBox(width: 12),
                Text('语言设置'),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListTile(
                dense: true,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSection(SettingsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 12),
                Text('通用设置'),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => SwitchListTile(
                dense: true,
                title: const Text('自动保存'),
                subtitle: const Text('编辑时自动保存更改'),
                value: controller.autoSave,
                onChanged: (bool value) {
                  controller.toggleAutoSave();
                },
              ),
            ),
            Obx(
              () => SwitchListTile(
                dense: true,
                title: const Text('通知'),
                subtitle: const Text('接收应用通知'),
                value: controller.notifications,
                onChanged: (bool value) {
                  controller.toggleNotifications();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '系统';
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
