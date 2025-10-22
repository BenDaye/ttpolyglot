import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/core/theme/app_theme.dart';
import 'package:ttpolyglot/src/features/settings/settings.dart';
import 'package:ttpolyglot_core/core.dart';

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

class _SettingsViewContent extends StatefulWidget {
  const _SettingsViewContent();

  @override
  State<_SettingsViewContent> createState() => _SettingsViewContentState();
}

class _SettingsViewContentState extends State<_SettingsViewContent> {
  // 控制翻译接口配置是否展开
  bool _isTranslationConfigExpanded = false;

  @override
  Widget build(BuildContext context) {
    // 获取控制器
    final controller = Get.find<SettingsController>();
    final translationController = Get.find<TranslationConfigController>();

    return Scaffold(
      body: Obx(() {
        // 显示加载状态
        if (controller.isLoading || translationController.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('加载设置中...'),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThemeSection(AppThemeController.instance),
              _buildLanguageSection(controller),
              _buildGeneralSection(controller),
              _buildTranslationSection(context),
            ],
          ),
        );
      }),
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
                const Icon(Icons.palette),
                const SizedBox(width: 12),
                const Text(
                  '主题设置',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
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
                Text(
                  '语言设置',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
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
                Text(
                  '通用设置',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
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

  /// 构建翻译设置部分
  Widget _buildTranslationSection(BuildContext context) {
    final translationController = Get.find<TranslationConfigController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 添加翻译接口按钮
            Row(
              children: [
                const Icon(Icons.translate),
                const SizedBox(width: 12.0),
                const Expanded(
                  child: Text(
                    '翻译设置',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddProviderDialog(
                    translationController,
                    onSuccess: () {
                      // 只有在翻译接口列表没有展开时才自动展开
                      if (!_isTranslationConfigExpanded) {
                        setState(() {
                          _isTranslationConfigExpanded = true;
                        });
                      }
                    },
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    '添加翻译接口',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 2.0,
                    shadowColor: AppThemeController.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // 翻译接口配置（可展开/收起）
            _buildProviderConfigs(context, translationController),
            const SizedBox(height: 16.0),
            // 高级设置
            _buildAdvancedSettings(translationController),
          ],
        ),
      ),
    );
  }

  /// 构建翻译接口配置列表
  Widget _buildProviderConfigs(BuildContext context, TranslationConfigController controller) {
    return Obx(() {
      final providers = controller.config.providers;

      return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: AppThemeController.cardDecoration,
          child: ExpansionTile(
            initiallyExpanded: _isTranslationConfigExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _isTranslationConfigExpanded = expanded;
              });
            },
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppThemeController.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.translate,
                    color: AppThemeController.primaryColor,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                const Text(
                  '翻译接口配置',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // 翻译接口列表
                    ...providers.map((config) => _buildProviderItem(context, controller, config)),
                    if (providers.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.translate,
                              size: 48.0,
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              '暂无翻译接口配置',
                              style: TextStyle(
                                color: Colors.grey.withValues(alpha: 0.6),
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '点击上方"添加翻译接口"按钮添加配置',
                              style: TextStyle(
                                color: Colors.grey.withValues(alpha: 0.5),
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 构建单个翻译接口项
  Widget _buildProviderItem(
      BuildContext context, TranslationConfigController controller, TranslationProviderConfig config) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Column(
        children: [
          // 标题区域
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // 左侧：默认标识和名称
                Expanded(
                  child: Row(
                    children: [
                      if (config.isDefault) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.withValues(alpha: 0.2),
                                Colors.amber.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 14.0,
                                color: Colors.amber.shade700,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                '默认',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12.0),
                      ],
                      Expanded(
                        child: Text(
                          config.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧：操作按钮
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 设为默认开关
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '设为默认',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: config.isDefault
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Switch(
                          value: config.isDefault,
                          onChanged: (bool value) {
                            controller.updateProviderConfigById(
                              config.id,
                              isDefault: value,
                            );
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16.0),
                    // 编辑按钮
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        onPressed: () => _showEditProviderDialog(controller, config),
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        tooltip: '编辑',
                        padding: const EdgeInsets.all(10.0),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // 删除按钮
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        onPressed: () => _showDeleteProviderDialog(controller, config),
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20.0,
                          color: Colors.red.shade600,
                        ),
                        tooltip: '删除',
                        padding: const EdgeInsets.all(10.0),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建高级设置
  Widget _buildAdvancedSettings(TranslationConfigController controller) {
    return Obx(
      () => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: AppThemeController.cardDecoration,
          child: ExpansionTile(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppThemeController.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: AppThemeController.primaryColor,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                const Text(
                  '高级设置',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // 最大重试次数
                    _buildSettingRow(
                      icon: Icons.refresh,
                      title: '最大重试次数',
                      subtitle: '${controller.config.maxRetries} 次',
                      controller: TextEditingController(
                        text: controller.config.maxRetries.toString(),
                      ),
                      onChanged: (value) {
                        final retries = int.tryParse(value);
                        if (retries != null) {
                          controller.setMaxRetries(retries);
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // 超时时间
                    _buildSettingRow(
                      icon: Icons.timer,
                      title: '超时时间',
                      subtitle: '${controller.config.timeoutSeconds} 秒',
                      controller: TextEditingController(
                        text: controller.config.timeoutSeconds.toString(),
                      ),
                      onChanged: (value) {
                        final timeout = int.tryParse(value);
                        if (timeout != null) {
                          controller.setTimeout(timeout);
                        }
                      },
                    ),
                    const SizedBox(height: 24.0),
                    // 重置按钮
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('确认重置'),
                              content: const Text('确定要重置所有翻译配置为默认值吗？'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.resetToDefault();
                                    Get.back();
                                  },
                                  child: const Text('确认'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.restore),
                        label: const Text('重置为默认配置'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          side: BorderSide(
                            color: AppThemeController.primaryColor.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建设置行
  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF2C2C2E) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Get.isDarkMode ? const Color(0xFF38383A) : const Color(0xFFE9ECEF),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppThemeController.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              color: AppThemeController.primaryColor,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          SizedBox(
            width: 80.0,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Get.isDarkMode ? const Color(0xFF3A3A3C) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppThemeController.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Get.isDarkMode ? const Color(0xFF48484A) : const Color(0xFFE9ECEF),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppThemeController.primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示添加翻译接口对话框
  void _showAddProviderDialog(TranslationConfigController controller, {VoidCallback? onSuccess}) {
    Get.dialog(
      ProviderDialog(
        controller: controller,
        mode: ProviderDialogMode.add,
        onSuccess: onSuccess,
      ),
    );
  }

  /// 显示编辑翻译接口对话框
  void _showEditProviderDialog(TranslationConfigController controller, TranslationProviderConfig config) {
    Get.dialog(
      ProviderDialog(
        controller: controller,
        mode: ProviderDialogMode.edit,
        config: config,
      ),
    );
  }

  /// 显示删除翻译接口对话框
  void _showDeleteProviderDialog(TranslationConfigController controller, TranslationProviderConfig config) {
    Get.dialog(
      AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除翻译接口 "${config.displayName}" 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeTranslationProvider(config.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
