import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/core/theme/app_theme.dart';
import 'package:ttpolyglot/src/features/settings/settings.dart';

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
            _buildThemeSection(AppThemeController.instance),
            _buildLanguageSection(controller),
            _buildGeneralSection(controller),
            _buildTranslationSection(context),
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
            Row(
              children: [
                const Icon(Icons.translate),
                const SizedBox(width: 12.0),
                const Expanded(
                  child: Text(
                    '翻译接口配置',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showAddProviderDialog(translationController),
                  icon: const Icon(Icons.add),
                  label: const Text('添加翻译接口'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // 翻译接口配置
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

      return Column(
        children: [
          // 翻译接口列表
          ...providers.map((config) => _buildProviderItem(context, controller, config)),
        ],
      );
    });
  }

  /// 构建单个翻译接口项
  Widget _buildProviderItem(
      BuildContext context, TranslationConfigController controller, TranslationProviderConfig config) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (config.isDefault) ...[
                    Icon(
                      Icons.star,
                      size: 16.0,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4.0),
                  ],
                  Expanded(
                    child: Text(
                      config.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              config.isEnabled ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16.0,
              color: config.isEnabled ? Colors.green : Colors.grey,
            ),
          ],
        ),
        subtitle: Text(
          config.isEnabled && config.isValid
              ? '已启用'
              : config.isEnabled && !config.isValid
                  ? '配置不完整'
                  : '未启用',
          style: TextStyle(
            color: config.isEnabled && !config.isValid ? Colors.orange : null,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 启用开关
                SwitchListTile(
                  dense: true,
                  title: const Text('启用'),
                  value: config.isEnabled,
                  onChanged: (value) => controller.toggleProviderById(config.id),
                ),
                // 默认翻译开关
                SwitchListTile(
                  dense: true,
                  title: Row(
                    children: [
                      const Text('默认翻译'),
                      const SizedBox(width: 8.0),
                      Icon(
                        Icons.star,
                        size: 16.0,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  subtitle: const Text('设为此翻译接口为默认'),
                  value: config.isDefault,
                  onChanged: (value) => controller.updateProviderConfigById(
                    config.id,
                    isDefault: value,
                  ),
                  activeColor: Colors.white,
                  activeTrackColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return Colors.grey.shade400;
                  }),
                  trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).primaryColor;
                    }
                    return Colors.grey.shade300;
                  }),
                ),
                const Divider(),
                // 配置表单
                if (config.isEnabled) ...[
                  // 名称输入框
                  TextFormField(
                    initialValue: config.name,
                    decoration: const InputDecoration(
                      labelText: '名称',
                      border: OutlineInputBorder(),
                      hintText: '输入翻译接口名称',
                    ),
                    onChanged: (value) {
                      controller.updateProviderConfigById(config.id, name: value);
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // App ID 输入框
                  TextFormField(
                    initialValue: config.appId,
                    decoration: InputDecoration(
                      labelText: config.provider == TranslationProvider.custom ? 'API Key' : 'App ID',
                      border: const OutlineInputBorder(),
                      hintText: config.provider == TranslationProvider.custom ? '输入API密钥' : '输入应用ID',
                    ),
                    onChanged: (value) {
                      controller.updateProviderConfigById(config.id, appId: value);
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // App Key 输入框（非自定义翻译）
                  if (config.provider != TranslationProvider.custom) ...[
                    TextFormField(
                      initialValue: config.appKey,
                      decoration: const InputDecoration(
                        labelText: 'App Key',
                        border: OutlineInputBorder(),
                        hintText: '输入应用密钥',
                      ),
                      onChanged: (value) {
                        controller.updateProviderConfigById(config.id, appKey: value);
                      },
                    ),
                    const SizedBox(height: 12.0),
                  ],
                  // API URL 输入框（仅自定义翻译）
                  if (config.provider == TranslationProvider.custom) ...[
                    TextFormField(
                      initialValue: config.apiUrl ?? '',
                      decoration: const InputDecoration(
                        labelText: 'API 地址',
                        border: OutlineInputBorder(),
                        hintText: '输入自定义翻译API地址',
                      ),
                      onChanged: (value) {
                        controller.updateProviderConfigById(config.id, apiUrl: value);
                      },
                    ),
                    const SizedBox(height: 12.0),
                  ],
                  // 验证状态
                  if (!config.isValid) ...[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange, size: 16.0),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              config.getValidationErrors().join('\n'),
                              style: const TextStyle(color: Colors.orange, fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ],
                // 删除按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showDeleteProviderDialog(controller, config),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('删除', style: TextStyle(color: Colors.red)),
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
      () => ExpansionTile(
        title: const Text(
          '高级设置',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // 最大重试次数
                ListTile(
                  dense: true,
                  title: const Text('最大重试次数'),
                  subtitle: Text('${controller.config.maxRetries} 次'),
                  trailing: SizedBox(
                    width: 120.0,
                    child: TextFormField(
                      initialValue: controller.config.maxRetries.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      ),
                      onChanged: (value) {
                        final retries = int.tryParse(value);
                        if (retries != null) {
                          controller.setMaxRetries(retries);
                        }
                      },
                    ),
                  ),
                ),
                // 超时时间
                ListTile(
                  dense: true,
                  title: const Text('超时时间'),
                  subtitle: Text('${controller.config.timeoutSeconds} 秒'),
                  trailing: SizedBox(
                    width: 120.0,
                    child: TextFormField(
                      initialValue: controller.config.timeoutSeconds.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      ),
                      onChanged: (value) {
                        final timeout = int.tryParse(value);
                        if (timeout != null) {
                          controller.setTimeout(timeout);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                // 重置按钮
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: Get.context!,
                      builder: (context) => AlertDialog(
                        title: const Text('确认重置'),
                        content: const Text('确定要重置所有翻译配置为默认值吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.resetToDefault();
                              Navigator.of(context).pop();
                            },
                            child: const Text('确认'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('重置为默认配置'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 显示添加翻译接口对话框
  void _showAddProviderDialog(TranslationConfigController controller) {
    TranslationProvider selectedProvider = TranslationProvider.baidu;
    final nameController = TextEditingController();
    final appIdController = TextEditingController();
    final appKeyController = TextEditingController();
    final apiUrlController = TextEditingController();
    bool isDefault = false;

    // 错误状态
    String? nameError;
    String? appIdError;
    String? appKeyError;
    String? apiUrlError;

    // 验证函数
    bool validateInputs() {
      bool isValid = true;

      // 重置错误状态
      nameError = null;
      appIdError = null;
      appKeyError = null;
      apiUrlError = null;

      // 验证名称
      if (nameController.text.trim().isEmpty) {
        nameError = '请输入翻译接口名称';
        isValid = false;
      }

      // 验证App ID
      if (appIdController.text.trim().isEmpty) {
        appIdError = selectedProvider == TranslationProvider.custom ? '请输入API密钥' : '请输入应用ID';
        isValid = false;
      }

      // 验证App Key（非自定义翻译）
      if (selectedProvider != TranslationProvider.custom && appKeyController.text.trim().isEmpty) {
        appKeyError = '请输入应用密钥';
        isValid = false;
      }

      // 验证API URL（仅自定义翻译）
      if (selectedProvider == TranslationProvider.custom && apiUrlController.text.trim().isEmpty) {
        apiUrlError = '请输入API地址';
        isValid = false;
      }

      // 验证API URL格式（仅自定义翻译）
      if (selectedProvider == TranslationProvider.custom &&
          apiUrlController.text.trim().isNotEmpty &&
          !apiUrlController.text.trim().startsWith('http')) {
        apiUrlError = 'API地址必须以http或https开头';
        isValid = false;
      }

      return isValid;
    }

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Text(
                '添加翻译接口',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade600,
                  size: 24.0,
                ),
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(),
                splashRadius: 28.0,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8.0,
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          content: Container(
            width: 480.0,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 翻译提供商选择
                  DropdownButtonFormField<TranslationProvider>(
                    value: selectedProvider,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12.0),
                      labelText: '翻译提供商',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.translate,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                        size: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    items: TranslationProvider.values.map((provider) {
                      return DropdownMenuItem(
                        value: provider,
                        child: Text(provider.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProvider = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // 名称输入框
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12.0),
                      labelText: '名称',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                        size: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                      hintText: '输入翻译接口名称',
                      hintStyle: TextStyle(
                        color: Colors.grey.withValues(alpha: 0.6),
                        fontSize: 14.0,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      errorText: nameError,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // App ID 输入框
                  TextField(
                    controller: appIdController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12.0),
                      labelText: selectedProvider == TranslationProvider.custom ? 'API Key' : 'App ID',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                        size: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                      hintText: selectedProvider == TranslationProvider.custom ? '输入API密钥' : '输入应用ID',
                      hintStyle: TextStyle(
                        color: Colors.grey.withValues(alpha: 0.6),
                        fontSize: 14.0,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      errorText: appIdError,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // App Key 输入框（非自定义翻译）
                  if (selectedProvider != TranslationProvider.custom) ...[
                    TextField(
                      controller: appKeyController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12.0),
                        labelText: 'App Key',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                          size: 20.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                        hintText: '输入应用密钥',
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.6),
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        errorText: appKeyError,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  // API URL 输入框（仅自定义翻译）
                  if (selectedProvider == TranslationProvider.custom) ...[
                    TextField(
                      controller: apiUrlController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12.0),
                        labelText: 'API 地址',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(
                          Icons.link,
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                          size: 20.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                        hintText: '输入自定义翻译API地址',
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.6),
                          fontSize: 14.0,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        errorText: apiUrlError,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  // 默认翻译开关
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Theme.of(context).primaryColor,
                          size: 20.0,
                        ),
                        const SizedBox(width: 12.0),
                        const Expanded(
                          child: Text(
                            '设为默认翻译接口',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Switch(
                          value: isDefault,
                          onChanged: (value) {
                            setState(() {
                              isDefault = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                '取消',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: () {
                if (validateInputs()) {
                  controller.addTranslationProvider(
                    provider: selectedProvider,
                    name: nameController.text.trim(),
                    appId: appIdController.text.trim(),
                    appKey: selectedProvider != TranslationProvider.custom ? appKeyController.text.trim() : null,
                    apiUrl: selectedProvider == TranslationProvider.custom ? apiUrlController.text.trim() : null,
                    isDefault: isDefault,
                  );
                  Get.back();
                } else {
                  // 触发UI更新以显示错误信息
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 2.0,
                shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              ),
              child: Text(
                '添加',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示删除翻译接口对话框
  void _showDeleteProviderDialog(TranslationConfigController controller, TranslationProviderConfig config) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除翻译接口 "${config.displayName}" 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeTranslationProvider(config.id);
              Navigator.of(context).pop();
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
