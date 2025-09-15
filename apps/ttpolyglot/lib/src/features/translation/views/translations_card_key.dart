import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/core/services/translation_service_manager.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';

class TranslationsCardByKey extends StatefulWidget {
  const TranslationsCardByKey({
    super.key,
    required this.translationKey,
    required this.translationEntries,
    this.onDeleteAllEntries,
    this.onEditEntry,
    this.onTranslateByDefaultLanguage,
    this.onChangeTranslate,
  });

  final String translationKey;
  final List<TranslationEntry> translationEntries;
  final Function({
    required String key,
    required List<TranslationEntry> entries,
  })? onDeleteAllEntries;
  final Function({
    required TranslationEntry entry,
  })? onEditEntry;
  final Function({required List<TranslationEntry> entries})? onChangeTranslate;
  final Function({
    required String key,
    required List<TranslationEntry> entries,
  })? onTranslateByDefaultLanguage;

  @override
  State<TranslationsCardByKey> createState() => _TranslationsCardByKeyState();
}

class _TranslationsCardByKeyState extends State<TranslationsCardByKey> {
  bool _isTranslating = false;

  @override
  Widget build(BuildContext context) {
    final firstEntry = widget.translationEntries.first;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部信息
            Row(
              children: [
                // 翻译键
                Expanded(
                  child: Text(
                    widget.translationKey,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                // 操作按钮
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        widget.onDeleteAllEntries?.call(
                          key: widget.translationKey,
                          entries: widget.translationEntries,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete_sweep),
                          SizedBox(width: 8.0),
                          Text('删除整个键'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8.0),

            // 源文本
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '源文本 (${firstEntry.sourceLanguage.code})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          firstEntry.sourceText,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // 去翻译（根据默认语言）
                  IconButton(
                    onPressed: _isTranslating ? null : () => _handleTranslateByDefaultLanguage(context),
                    icon: _isTranslating
                        ? SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : Icon(Icons.translate),
                  ),
                ],
              ),
            ),

            // 上下文信息（如果有）
            if (firstEntry.context != null && firstEntry.context!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '上下文',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      firstEntry.context!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12.0),

            Text(
              '翻译',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8.0),

            Column(
              spacing: 8.0,
              children: [
                ...widget.translationEntries.map(
                  (entry) => _buildLanguageTranslationItem(context, entry),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建语言翻译项
  Widget _buildLanguageTranslationItem(
    BuildContext context,
    TranslationEntry entry,
  ) {
    return InkWell(
      onTap: () => widget.onEditEntry?.call(entry: entry),
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.5),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 语言标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                entry.targetLanguage.code,
                style: GoogleFonts.notoSansMono(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 8.0),

            // 翻译内容
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.targetText.isEmpty ? '待翻译' : entry.targetText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: entry.targetText.isEmpty
                              ? Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                              : null,
                          fontStyle: entry.targetText.isEmpty ? FontStyle.italic : null,
                          overflow: TextOverflow.ellipsis,
                        ),
                    maxLines: 1,
                  ),

                  const SizedBox(height: 4.0),

                  // 状态标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: TranslationController.getStatusColor(entry.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      entry.status.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TranslationController.getStatusColor(entry.status),
                            fontSize: 10.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理根据默认语言翻译
  Future<void> _handleTranslateByDefaultLanguage(BuildContext context) async {
    if (_isTranslating) return; // 防止重复点击

    setState(() {
      _isTranslating = true;
    });

    try {
      final translationManager = Get.find<TranslationServiceManager>();

      // 检查翻译配置（异步等待配置加载完成）
      if (!await translationManager.hasValidConfigAsync()) {
        await TranslationServiceManager.showConfigCheckDialog(context);
        setState(() {
          _isTranslating = false;
        });
        return;
      }

      // 获取可用的源语言（从翻译条目中提取）
      final availableSourceLanguages = widget.translationEntries.map((entry) => entry.sourceLanguage).toSet().toList();

      if (availableSourceLanguages.isEmpty) {
        _showErrorSnackBar(context, '没有可用的源语言');
        setState(() {
          _isTranslating = false;
        });
        return;
      }

      // 如果有多个源语言，让用户选择
      Language selectedSourceLanguage;
      if (availableSourceLanguages.length == 1) {
        selectedSourceLanguage = availableSourceLanguages.first;
      } else {
        final selectedLanguage = await LanguageSelectionDialog.show(
          context: context,
          availableLanguages: availableSourceLanguages,
          title: '选择源语言',
          subtitle: '请选择要翻译的源语言',
        );

        if (selectedLanguage == null) {
          setState(() {
            _isTranslating = false;
          });
          return; // 用户取消了选择
        }
        selectedSourceLanguage = selectedLanguage;
      }

      // 源语言文本
      final TranslationEntry? entriesToTranslate = widget.translationEntries
          .firstWhereOrNull((entry) => entry.targetLanguage.code == selectedSourceLanguage.code);

      if (entriesToTranslate == null || entriesToTranslate.targetText.isEmpty) {
        _showErrorSnackBar(context, '没有找到需要翻译的条目');
        setState(() {
          _isTranslating = false;
        });
        return;
      }

      // 获取需要翻译的条目
      final List<TranslationEntry> translateEntries = [];
      for (final entry in widget.translationEntries) {
        if (entry.targetLanguage.code == selectedSourceLanguage.code) continue;
        translateEntries.add(entry.copyWith(
          sourceText: entriesToTranslate.targetText,
        ));
      }

      // 批量翻译
      final results = await translationManager.batchTranslateEntries(
        entries: translateEntries,
      );

      // 处理翻译结果
      int successCount = 0;
      int failCount = 0;
      final updatedEntries = <TranslationEntry>[];
      final failedEntries = <TranslationEntry>[];

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
          failedEntries.add(entry);
          log('翻译失败: ${entry.key} - ${result.error}', name: 'TranslationsCardByKey');
        }
      }

      // 调用回调更新条目
      widget.onChangeTranslate?.call(entries: updatedEntries);

      // 显示结果
      _showTranslationResultSnackBar(context, successCount, failCount);

      // 如果有失败的翻译，显示详细信息
      if (failCount > 0) {
        _showFailedTranslationsDialog(
            context, failedEntries, results.where((r) => !r.success).map((r) => r.error ?? '未知错误').toList());
      }

      // 重置加载状态
      setState(() {
        _isTranslating = false;
      });
    } catch (error, stackTrace) {
      log('翻译处理异常', error: error, stackTrace: stackTrace, name: 'TranslationsCardByKey');
      if (context.mounted) {
        _showErrorSnackBar(context, '翻译处理异常: $error');
      }
      setState(() {
        _isTranslating = false;
      });
    }
  }

  /// 显示错误提示
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 显示翻译结果提示
  void _showTranslationResultSnackBar(BuildContext context, int successCount, int failCount) {
    final message = '翻译完成: 成功 $successCount 个，失败 $failCount 个';
    final backgroundColor = failCount > 0 ? Theme.of(context).colorScheme.error : Colors.green;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 显示失败翻译详情对话框
  void _showFailedTranslationsDialog(
    BuildContext context,
    List<TranslationEntry> failedEntries,
    List<String> errors,
  ) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8.0),
            const Text('翻译失败详情'),
          ],
        ),
        content: SizedBox(
          width: 640.0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: failedEntries.length,
            itemBuilder: (context, index) {
              final entry = failedEntries[index];
              final error = errors[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        entry.sourceText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '错误: $error',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('确定'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
