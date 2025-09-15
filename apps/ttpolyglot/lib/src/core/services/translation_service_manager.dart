import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/core/services/translation_api_service.dart';
import 'package:ttpolyglot/src/features/settings/controllers/translation_config_controller.dart';
import 'package:ttpolyglot/src/features/settings/models/translation_provider.dart';
import 'package:ttpolyglot_core/core.dart';

/// 翻译服务管理器
class TranslationServiceManager extends GetxService {
  static TranslationServiceManager get instance => Get.find<TranslationServiceManager>();

  final TranslationConfigController _configController = Get.find<TranslationConfigController>();

  /// 检查翻译配置是否完整
  bool get hasValidConfig {
    final config = _configController.config;
    return config.enabledProviders.isNotEmpty;
  }

  /// 获取默认翻译接口
  TranslationProviderConfig? get defaultProvider {
    return _configController.config.defaultProvider;
  }

  /// 获取所有启用的翻译接口
  List<TranslationProviderConfig> get enabledProviders {
    return _configController.config.enabledProviders;
  }

  /// 翻译文本
  Future<TranslationResult> translateText({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    TranslationProviderConfig? provider,
    String? context,
  }) async {
    try {
      // 检查配置
      if (!hasValidConfig) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '请先配置翻译接口',
        );
      }

      // 使用指定的提供商或默认提供商
      final selectedProvider = provider ?? defaultProvider;
      if (selectedProvider == null) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '没有可用的翻译接口',
        );
      }

      // 验证提供商配置
      if (!selectedProvider.isValid) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '${selectedProvider.displayName} 配置不完整',
        );
      }

      log('开始翻译: $text (${sourceLanguage.code} -> ${targetLanguage.code}) 使用 ${selectedProvider.displayName}',
          name: 'TranslationServiceManager');

      // 调用翻译API
      final result = await TranslationApiService.translateText(
        text: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        config: selectedProvider,
        context: context,
      );

      if (result.success) {
        log('翻译成功: ${result.translatedText}', name: 'TranslationServiceManager');
      } else {
        log('翻译失败: ${result.error}', name: 'TranslationServiceManager');
      }

      return result;
    } catch (error, stackTrace) {
      log('翻译服务异常', error: error, stackTrace: stackTrace, name: 'TranslationServiceManager');
      return TranslationResult(
        success: false,
        translatedText: '',
        error: '翻译服务异常: $error',
      );
    }
  }

  /// 批量翻译文本
  Future<List<TranslationResult>> batchTranslateText({
    required List<String> texts,
    required Language sourceLanguage,
    required Language targetLanguage,
    TranslationProviderConfig? provider,
    String? context,
  }) async {
    final results = <TranslationResult>[];

    for (final text in texts) {
      final result = await translateText(
        text: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        provider: provider,
        context: context,
      );
      results.add(result);

      // 添加延迟避免API限制
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return results;
  }

  /// 翻译翻译条目
  Future<TranslationResult> translateEntry({
    required TranslationEntry entry,
    TranslationProviderConfig? provider,
  }) async {
    return await translateText(
      text: entry.sourceText,
      sourceLanguage: entry.sourceLanguage,
      targetLanguage: entry.targetLanguage,
      provider: provider,
      context: entry.context,
    );
  }

  /// 批量翻译翻译条目
  Future<List<TranslationResult>> batchTranslateEntries({
    required List<TranslationEntry> entries,
    TranslationProviderConfig? provider,
  }) async {
    final results = <TranslationResult>[];

    for (final entry in entries) {
      final result = await translateEntry(
        entry: entry,
        provider: provider,
      );
      results.add(result);

      // 添加延迟避免API限制
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return results;
  }

  /// 显示配置检查弹窗
  static Future<void> showConfigCheckDialog(BuildContext context) {
    return Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            const Text('翻译配置未完成'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('请先配置翻译接口才能使用翻译功能：'),
            SizedBox(height: 12.0),
            Text('1. 前往设置页面'),
            Text('2. 添加翻译接口（百度、有道、谷歌等）'),
            Text('3. 填写API密钥和配置信息'),
            Text('4. 启用翻译接口'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // 导航到设置页面
              Get.rootDelegate.offAndToNamed(Routes.settings);
            },
            child: const Text('去配置'),
          ),
        ],
      ),
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
