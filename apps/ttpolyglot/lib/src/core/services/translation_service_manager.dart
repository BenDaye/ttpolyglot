import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/features/settings/controllers/translation_config_controller.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_translators/translators.dart';

/// 翻译服务管理器
class TranslationServiceManager extends GetxService {
  static TranslationServiceManager get instance => Get.isRegistered<TranslationServiceManager>()
      ? Get.find<TranslationServiceManager>()
      : Get.put(TranslationServiceManager());

  /// 检查翻译配置是否完整
  bool get hasValidConfig {
    final config = TranslationConfigController.instance.config;
    return config.enabledProviders.isNotEmpty;
  }

  /// 异步检查翻译配置是否完整（等待配置加载完成）
  Future<bool> hasValidConfigAsync() async {
    // 如果正在加载配置，等待加载完成
    if (TranslationConfigController.instance.isLoading) {
      // 等待配置加载完成
      while (TranslationConfigController.instance.isLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    final config = TranslationConfigController.instance.config;
    return config.enabledProviders.isNotEmpty;
  }

  /// 获取默认翻译接口
  TranslationProviderConfig? get defaultProvider {
    return TranslationConfigController.instance.config.defaultProvider;
  }

  /// 检查是否有设置默认翻译接口
  Future<bool> hasDefaultProviderAsync() async {
    // 如果正在加载配置，等待加载完成
    if (TranslationConfigController.instance.isLoading) {
      // 等待配置加载完成
      while (TranslationConfigController.instance.isLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    final config = TranslationConfigController.instance.config;
    // 检查是否有明确设置为默认的接口
    return config.providers.any((p) => p.isDefault);
  }

  /// 获取所有启用的翻译接口
  List<TranslationProviderConfig> get enabledProviders {
    return TranslationConfigController.instance.config.enabledProviders;
  }

  /// 批量翻译翻译条目
  Future<List<TranslationResult>> batchTranslateEntries({
    required TranslationEntry sourceEntries, // 翻译源
    required List<TranslationEntry> entries, // 需要的翻译条目
    TranslationProviderConfig? provider,
  }) async {
    try {
      // 检查配置（异步等待配置加载完成）
      if (!await hasValidConfigAsync()) {
        return entries
            .map((entry) => TranslationResult(
                  success: false,
                  translatedText: '',
                  error: '请先配置翻译接口',
                  sourceLanguage: entry.sourceLanguage,
                  targetLanguage: entry.targetLanguage,
                ))
            .toList();
      }

      // 使用指定的提供商或默认提供商
      final selectedProvider = provider ?? defaultProvider;
      if (selectedProvider == null) {
        return entries
            .map((entry) => TranslationResult(
                  success: false,
                  translatedText: '',
                  error: '没有可用的翻译接口',
                  sourceLanguage: entry.sourceLanguage,
                  targetLanguage: entry.targetLanguage,
                ))
            .toList();
      }

      // 验证提供商配置
      if (!selectedProvider.isValid) {
        return entries
            .map((entry) => TranslationResult(
                  success: false,
                  translatedText: '',
                  error: '${selectedProvider.displayName} 配置不完整',
                  sourceLanguage: entry.sourceLanguage,
                  targetLanguage: entry.targetLanguage,
                ))
            .toList();
      }

      log('开始批量翻译 ${entries.length} 个条目，使用 ${selectedProvider.displayName}', name: 'TranslationServiceManager');

      // 使用批量翻译API
      final result = await TranslationApiService.translateBatchTexts(
        sourceText: sourceEntries.targetText,
        sourceLanguage: sourceEntries.targetLanguage,
        targetLanguages: entries.map((e) => e.targetLanguage).toSet().toList(),
        config: selectedProvider,
      );

      return result.items
          .map((item) => TranslationResult(
                success: item.success,
                translatedText: item.translatedText,
                sourceLanguage: sourceEntries.sourceLanguage,
                targetLanguage: item.targetLanguage,
                error: item.error,
              ))
          .toList();
    } catch (error, stackTrace) {
      log('批量翻译条目异常', error: error, stackTrace: stackTrace, name: 'TranslationServiceManager');

      // 返回所有条目的失败结果
      return entries
          .map((entry) => TranslationResult(
                success: false,
                translatedText: '',
                sourceLanguage: entry.sourceLanguage,
                targetLanguage: entry.targetLanguage,
                error: '批量翻译异常: $error',
              ))
          .toList();
    }
  }

  /// 显示默认接口未设置弹窗
  static Future<void> showDefaultProviderNotSetDialog(BuildContext context) {
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                Icons.star_border,
                color: Theme.of(context).colorScheme.primary,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              '未设置默认翻译接口',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '请先设置一个默认的翻译接口才能使用翻译功能',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepItem(context, '1', '前往设置页面'),
                  const SizedBox(height: 8.0),
                  _buildStepItem(context, '2', '添加翻译接口（百度、有道、谷歌等）'),
                  const SizedBox(height: 8.0),
                  _buildStepItem(context, '3', '启用翻译接口'),
                  const SizedBox(height: 8.0),
                  _buildStepItem(context, '4', '设置其中一个接口为默认接口'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // 导航到设置页面
              Get.rootDelegate.offAndToNamed(Routes.settings);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  /// 显示配置检查弹窗
  static Future<void> showConfigCheckDialog(BuildContext context) {
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              '翻译配置未完成',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '请先配置翻译接口才能使用翻译功能',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepItem(context, '1', '前往设置页面'),
                  const SizedBox(height: 8.0),
                  _buildStepItem(context, '2', '添加翻译接口（百度、有道、谷歌等）'),
                  const SizedBox(height: 8.0),
                  _buildStepItem(context, '3', '填写API密钥和配置信息'),
                  const SizedBox(height: 8.0),
                  _buildStepItem(context, '4', '启用翻译接口'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // 导航到设置页面
              Get.rootDelegate.offAndToNamed(Routes.settings);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('去配置'),
          ),
        ],
      ),
    );
  }

  /// 构建步骤项
  static Widget _buildStepItem(BuildContext context, String step, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              step,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ],
    );
  }

  /// 显示翻译提供商选择弹窗
  static Future<TranslationProviderConfig?> showProviderSelectionDialog(
    BuildContext context,
    List<TranslationProviderConfig> providers,
  ) {
    if (providers.isEmpty) {
      return Future.value(null);
    }

    if (providers.length == 1) {
      return Future.value(providers.first);
    }

    return Get.dialog<TranslationProviderConfig>(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.translate,
              color: Theme.of(context).primaryColor,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            const Text('选择翻译接口'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: providers.map((provider) {
            return ListTile(
              leading: Icon(
                _getProviderIcon(provider.provider),
                color: Theme.of(context).primaryColor,
              ),
              title: Text(provider.displayName),
              subtitle: Text(provider.provider.name),
              onTap: () => Get.back(result: provider),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 获取提供商图标
  static IconData _getProviderIcon(TranslationProvider provider) {
    switch (provider) {
      case TranslationProvider.baidu:
        return Icons.search;
      case TranslationProvider.youdao:
        return Icons.translate;
      case TranslationProvider.google:
        return Icons.language;
      case TranslationProvider.custom:
        return Icons.api;
    }
  }

  /// 显示翻译结果弹窗
  static Future<void> showTranslationResultDialog(
    BuildContext context,
    TranslationResult result,
  ) {
    return Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              result.success ? Icons.check_circle : Icons.error,
              color: result.success ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Text(result.success ? '翻译成功' : '翻译失败'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.success) ...[
              const Text('翻译结果：'),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  result.translatedText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ] else ...[
              Text('错误信息：${result.error}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
