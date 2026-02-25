import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/common/api/translation_api.dart';
import 'package:ttpolyglot/src/core/services/translation_service_manager.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_controller.dart';
import 'package:ttpolyglot/src/features/settings/controllers/translation_config_controller.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

class CustomTranslationDialog extends StatefulWidget {
  const CustomTranslationDialog({
    super.key,
    required this.translationKey,
    required this.entries,
    required this.controller,
  });

  final String translationKey;
  final List<TranslationEntryModel> entries;
  final TranslationController controller;

  @override
  State<CustomTranslationDialog> createState() => _CustomTranslationDialogState();

  /// 显示自定义翻译弹窗
  static void show({
    required String translationKey,
    required List<TranslationEntryModel> entries,
    required TranslationController controller,
  }) {
    Get.dialog(
      CustomTranslationDialog(
        translationKey: translationKey,
        entries: entries,
        controller: controller,
      ),
    );
  }
}

class _CustomTranslationDialogState extends State<CustomTranslationDialog> {
  // 状态管理
  TranslationProviderConfigModel? _selectedProvider;
  LanguageModel? _selectedSourceLanguage;
  bool _isTranslating = false;
  bool _isOverride = false;

  @override
  Widget build(BuildContext context) {
    final projectController = ProjectController.getInstance(widget.controller.projectId);
    final project = projectController.project;

    // 默认使用项目主语言
    if (_selectedSourceLanguage == null && project != null) {
      _selectedSourceLanguage = project.languages.firstWhereOrNull(
        (lang) => lang.id == project.primaryLanguageId,
      );
    }

    return AlertDialog(
      title: Row(
        children: [
          Text(
            '自定义翻译',
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
              // 选择翻译接口
              Obx(
                () {
                  final config = TranslationConfigController.instance.config;
                  _selectedProvider ??= config.providers.firstWhereOrNull(
                        (p) => p.provider == config.defaultProvider,
                      ) ??
                      config.providers.firstOrNull;
                  return _buildProviderSelector(
                    list: config.providers,
                  );
                },
              ),
              const SizedBox(height: 24.0),
              // 选择源语言
              _buildSourceLanguageSelector(
                languages: project?.languages ?? [],
              ),
              const SizedBox(height: 24.0),
              // 是否覆盖翻译条目
              _buildOverrideSwitch(),
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
        if (_isTranslating)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.0,
              children: [
                SizedBox(
                  width: 16.0,
                  height: 16.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const Text(
                  '翻译中...',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          )
        else
          ElevatedButton(
            onPressed: _startTranslation,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 2.0,
              shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
            child: const Text(
              '开始翻译',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ),
      ],
    );
  }

  /// 构建翻译服务提供商选择器
  Widget _buildProviderSelector({
    required List<TranslationProviderConfigModel> list,
  }) {
    // 去重，确保 items 唯一
    final providers = _distinctProviders(list);
    // 将外部选中的 provider 映射为当前列表中的同一实例，避免 value 不在 items 中
    final mappedValue = _selectedProvider == null
        ? null
        : providers.firstWhereOrNull(
            (p) => p.provider == _selectedProvider!.provider && p.name == _selectedProvider!.name,
          );

    return DropdownButtonFormField<TranslationProviderConfigModel>(
      value: mappedValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        labelText: '请选择翻译接口',
        labelStyle: TextStyle(
          color: Theme.of(Get.context!).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.translate,
          color: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.7),
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
            color: Theme.of(Get.context!).primaryColor,
            width: 2.0,
          ),
        ),
      ),
      items: providers.map((provider) {
        return DropdownMenuItem<TranslationProviderConfigModel>(
          value: provider,
          child: SizedBox(
            width: 300.0,
            child: Row(
              spacing: 4.0,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    provider.provider.name.length >= 2
                        ? provider.provider.name.substring(0, 2).toUpperCase()
                        : provider.provider.name.toUpperCase(),
                    style: GoogleFonts.notoSansMono(
                      color: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(provider.name),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedProvider = value;
          });
          LoggerUtils.info('选择翻译提供商: ${value.name}');
        }
      },
    );
  }

  /// 根据 provider 标识去重
  List<TranslationProviderConfigModel> _distinctProviders(List<TranslationProviderConfigModel> list) {
    final seen = <String>{};
    final result = <TranslationProviderConfigModel>[];
    for (final p in list) {
      final key = '${p.provider.name}::${p.name}';
      if (seen.add(key)) {
        result.add(p);
      }
    }
    return result;
  }

  /// 构建源语言选择器（使用项目语言列表，默认主语言）
  Widget _buildSourceLanguageSelector({
    required List<LanguageModel> languages,
  }) {
    return DropdownButtonFormField<LanguageModel>(
      value: _selectedSourceLanguage,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        labelText: '请选择源语言',
        labelStyle: TextStyle(
          color: Theme.of(Get.context!).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.language,
          color: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.7),
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
            color: Theme.of(Get.context!).primaryColor,
            width: 2.0,
          ),
        ),
      ),
      items: languages.map((lang) {
        return DropdownMenuItem<LanguageModel>(
          value: lang,
          child: SizedBox(
            width: 300.0,
            child: Row(
              spacing: 4.0,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    lang.code.code,
                    style: GoogleFonts.notoSansMono(
                      color: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    lang.nativeName ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedSourceLanguage = value;
          });
          LoggerUtils.info(
            '选择源语言: ${value.code.name} - ${value.nativeName ?? ''}',
            name: 'CustomTranslationDialog',
          );
        }
      },
    );
  }

  /// 开始翻译（调用服务端单条翻译接口）
  Future<void> _startTranslation() async {
    if (_isTranslating) return;

    if (_selectedProvider == null) {
      _showErrorSnackBar('请选择翻译接口');
      return;
    }

    if (_selectedSourceLanguage == null) {
      _showErrorSnackBar('请选择源语言');
      return;
    }

    final translationManager = Get.find<TranslationServiceManager>();
    if (!await translationManager.hasValidConfigAsync()) {
      if (mounted) {
        await TranslationServiceManager.showConfigCheckDialog(context);
      }
      return;
    }

    // 获取第一个条目（所有展开条目共享同一个 UUID）
    final firstEntry = widget.entries.firstOrNull;
    if (firstEntry == null) {
      _showErrorSnackBar('没有翻译条目');
      return;
    }

    // 收集目标语言（排除源语言）
    final sourceCode = _selectedSourceLanguage!.code.code;
    final targetLanguageCodes = widget.entries
        .expand((e) => e.targetLanguages)
        .map((t) => t.language.code)
        .where((code) => code != sourceCode)
        .toSet()
        .toList();

    if (targetLanguageCodes.isEmpty) {
      _showErrorSnackBar('没有需要翻译的目标语言');
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      final updatedEntry = await TranslationApi().translateEntry(
        projectId: firstEntry.projectId,
        entryId: firstEntry.uuid,
        targetLanguages: targetLanguageCodes,
        provider: _selectedProvider!,
        force: _isOverride,
      );

      if (!mounted) return;

      if (updatedEntry != null) {
        // 用返回的最新数据更新本地列表
        widget.controller.updateLocalEntry(updatedEntry);

        Get.back();
        _showSuccessSnackBar('翻译成功');
      } else {
        _showErrorSnackBar('翻译失败，请稍后重试');
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('自定义翻译异常', error: error, stackTrace: stackTrace);
      if (mounted) {
        _showErrorSnackBar('翻译处理异常: $error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTranslating = false;
        });
      }
    }
  }

  /// 显示成功提示
  void _showSuccessSnackBar(String message) {
    Get.snackbar(
      '成功',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    );
  }

  /// 显示错误提示
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// 构建覆盖翻译开关
  Widget _buildOverrideSwitch() {
    return Container(
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
            Icons.autorenew,
            color: Theme.of(context).primaryColor,
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          const Expanded(
            child: Text(
              '是否覆盖已有翻译',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: _isOverride,
            onChanged: (value) {
              setState(() {
                _isOverride = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
