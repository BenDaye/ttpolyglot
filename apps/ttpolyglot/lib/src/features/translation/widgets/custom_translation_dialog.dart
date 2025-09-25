import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/core/services/translation_service_manager.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_controller.dart';
import 'package:ttpolyglot/src/features/settings/controllers/translation_config_controller.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_translators/translators.dart';

class CustomTranslationDialog extends StatefulWidget {
  const CustomTranslationDialog({
    super.key,
    required this.translationKey,
    required this.entries,
    required this.controller,
  });

  final String translationKey;
  final List<TranslationEntry> entries;
  final TranslationController controller;

  @override
  State<CustomTranslationDialog> createState() => _CustomTranslationDialogState();

  /// 显示自定义翻译弹窗
  static void show({
    required String translationKey,
    required List<TranslationEntry> entries,
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
  TranslationProviderConfig? _selectedProvider;
  TranslationEntry? _selectedSourceEntry;
  bool _isTranslating = false;
  bool _isOverride = true; // 是否覆盖

  @override
  Widget build(BuildContext context) {
    final primaryLanguage = ProjectController.getInstance(widget.controller.projectId).project?.primaryLanguage;
    _selectedSourceEntry ??= (primaryLanguage != null
        ? widget.entries.firstWhereOrNull((item) => item.targetLanguage.code == primaryLanguage.code)
        : widget.entries.first);
    _selectedProvider ??= TranslationConfigController.instance.config.defaultProvider;

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
              _buildProviderSelector(
                list: TranslationConfigController.instance.config.providers,
              ),
              const SizedBox(height: 24.0),
              // 选择源语言
              _buildSourceLanguageSelector(
                list: widget.entries,
              ),
              const SizedBox(height: 24.0),
              // 是否覆盖翻译条目
              _buildDefaultSwitch(),
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
          onPressed: _isTranslating ? null : _saveCustomTranslation,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 2.0,
            shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
          child: _isTranslating
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.0,
                  children: [
                    SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
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
                )
              : const Text(
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
    required List<TranslationProviderConfig> list,
  }) {
    return DropdownButtonFormField<TranslationProviderConfig>(
      value: _selectedProvider,
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
      items: list.map((provider) {
        return DropdownMenuItem<TranslationProviderConfig>(
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
                  child: Text(provider.displayName),
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
          log('选择翻译提供商: ${value.displayName}', name: 'CustomTranslationDialog');
        }
      },
    );
  }

  /// 构建源语言选择器
  Widget _buildSourceLanguageSelector({
    required List<TranslationEntry> list,
  }) {
    return DropdownButtonFormField<TranslationEntry>(
      value: _selectedSourceEntry,
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
      items: list.map((entry) {
        return DropdownMenuItem<TranslationEntry>(
          value: entry,
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
                    entry.targetLanguage.code,
                    style: GoogleFonts.notoSansMono(
                      color: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(entry.targetText),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedSourceEntry = value;
          });
          log('选择源语言: ${value.targetLanguage.code} - ${value.targetText}', name: 'CustomTranslationDialog');
        }
      },
    );
  }

  /// 保存自定义翻译设置
  Future<void> _saveCustomTranslation() async {
    if (_isTranslating) return; // 防止重复点击

    // 表单验证
    if (_selectedProvider == null) {
      _showErrorSnackBar('请选择翻译接口');
      return;
    }

    if (_selectedSourceEntry == null) {
      _showErrorSnackBar('请选择源语言');
      return;
    }

    if (_selectedSourceEntry!.targetText.isEmpty) {
      _showErrorSnackBar('源语言文本不能为空');
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      final translationManager = Get.find<TranslationServiceManager>();

      // 检查翻译配置
      if (!await translationManager.hasValidConfigAsync()) {
        if (mounted) {
          await TranslationServiceManager.showConfigCheckDialog(context);
        }
        _resetTranslatingState();
        return;
      }

      // 开始自定义翻译
      await _performCustomTranslation(translationManager);
    } catch (error, stackTrace) {
      log('自定义翻译异常', error: error, stackTrace: stackTrace, name: 'CustomTranslationDialog');
      _showErrorSnackBar('翻译处理异常: $error');
      _resetTranslatingState();
    }
  }

  /// 执行自定义翻译
  Future<void> _performCustomTranslation(TranslationServiceManager translationManager) async {
    // 获取需要翻译的条目
    final List<TranslationEntry> translateEntries = [];
    for (final entry in widget.entries) {
      if (entry.targetLanguage.code == _selectedSourceEntry!.targetLanguage.code) continue;
      translateEntries.add(entry.copyWith(
        sourceText: _selectedSourceEntry!.targetText,
      ));
    }

    // 如果不覆盖，则直接返回
    if (!_isOverride && !translateEntries.any((e) => e.targetText.trim().isEmpty)) {
      _showErrorSnackBar('没有可翻译语言');
      _resetTranslatingState();
      return;
    }

    if (translateEntries.isEmpty) {
      _showErrorSnackBar('没有需要翻译的目标语言');
      _resetTranslatingState();
      return;
    }

    try {
      // 批量翻译
      final results = await translationManager.batchTranslateEntries(
        sourceEntries: _selectedSourceEntry!,
        entries: translateEntries,
        provider: _selectedProvider!,
      );

      // 如果翻译成功，关闭对话框
      Get.back();

      // 处理翻译结果
      await _handleTranslationResults(results, translateEntries);
    } catch (error, stackTrace) {
      log('自定义翻译异常', error: error, stackTrace: stackTrace, name: 'CustomTranslationDialog');
      _showErrorSnackBar('翻译处理异常: $error');
      _resetTranslatingState();
    }
  }

  /// 处理翻译结果
  Future<void> _handleTranslationResults(
    List<TranslationResult> results,
    List<TranslationEntry> translateEntries,
  ) async {
    int successCount = 0;
    int failCount = 0;
    final updatedEntries = <TranslationEntry>[];

    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      final entry = translateEntries[i];
      if (result.success) {
        successCount++;
        updatedEntries.add(entry.copyWith(
          targetText: result.translatedText,
          status: TranslationStatus.completed,
          updatedAt: DateTime.now(),
        ));
      } else {
        failCount++;
        log('翻译失败: ${entry.key} - ${result.error}', name: 'CustomTranslationDialog');
      }
    }

    // 更新翻译条目
    if (updatedEntries.isNotEmpty) {
      for (final entry in updatedEntries) {
        await widget.controller.updateTranslationEntry(entry, isShowSnackbar: false);
      }
      await widget.controller.refreshTranslationEntries();
    }

    // 显示结果
    if (mounted) {
      _showTranslationResultSnackBar(successCount, failCount);
    }

    _resetTranslatingState();
  }

  /// 重置翻译状态
  void _resetTranslatingState() {
    if (mounted) {
      setState(() {
        _isTranslating = false;
      });
    }
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

  /// 显示翻译结果提示
  void _showTranslationResultSnackBar(int successCount, int failCount) {
    final message = '翻译完成: 成功 $successCount 个，失败 $failCount 个';
    final backgroundColor = failCount > 0 ? Theme.of(context).colorScheme.error : Colors.green;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// 构建默认翻译开关
  Widget _buildDefaultSwitch() {
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
              '是否覆盖翻译条目',
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
