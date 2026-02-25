import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/common/api/translation_api.dart';
import 'package:ttpolyglot/src/core/services/translation_service_manager.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

class TranslationsCardByKey extends StatefulWidget {
  const TranslationsCardByKey({
    super.key,
    required this.translationKey,
    required this.translationEntries,
    this.onDeleteAllEntries,
    this.onEditEntry,
    this.onTranslateByDefaultLanguage,
    this.onChangeTranslate,
    this.onTranslateByCustom,
  });

  final String translationKey;
  final List<TranslationEntryModel> translationEntries;
  final Function({
    required String key,
    required List<TranslationEntryModel> entries,
  })? onDeleteAllEntries;
  final Function({
    required TranslationEntryModel entry,
  })? onEditEntry;
  final Function({required List<TranslationEntryModel> entries})? onChangeTranslate;
  final Function({
    required String key,
    required List<TranslationEntryModel> entries,
  })? onTranslateByDefaultLanguage;
  final Function({
    required String key,
    required List<TranslationEntryModel> entries,
  })? onTranslateByCustom;

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
                    PopupMenuItem(
                      onTap: () {
                        widget.onTranslateByCustom?.call(
                          key: widget.translationKey,
                          entries: widget.translationEntries,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.translate),
                          SizedBox(width: 8.0),
                          Text('自定义翻译'),
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
            if (firstEntry.context.isNotEmpty) ...[
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
                      firstEntry.context,
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
    TranslationEntryModel entry,
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
              child: Builder(
                builder: (context) {
                  final targetLang = entry.targetLanguages.isNotEmpty
                      ? entry.targetLanguages.first
                      : TranslationTargetLanguageModel(language: entry.sourceLanguage, text: '');
                  return Text(
                    targetLang.language.code,
                    style: GoogleFonts.notoSansMono(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 8.0),

            // 翻译内容
            Expanded(
              child: Builder(
                builder: (context) {
                  final targetLang = entry.targetLanguages.isNotEmpty
                      ? entry.targetLanguages.first
                      : TranslationTargetLanguageModel(language: entry.sourceLanguage, text: '');
                  final targetText = targetLang.text;
                  final status = targetLang.status;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        targetText.isEmpty ? '待翻译' : targetText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: targetText.isEmpty
                                  ? Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                                  : null,
                              fontStyle: targetText.isEmpty ? FontStyle.italic : null,
                              overflow: TextOverflow.ellipsis,
                            ),
                        maxLines: 1,
                      ),

                      const SizedBox(height: 4.0),

                      // 状态标签
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: TranslationController.getStatusColor(status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          status.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: TranslationController.getStatusColor(status),
                                fontSize: 10.0,
                              ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理根据默认语言翻译（调用服务端接口翻译 + 入库，然后刷新列表）
  Future<void> _handleTranslateByDefaultLanguage(BuildContext context) async {
    if (_isTranslating) return;

    if (mounted) {
      setState(() => _isTranslating = true);
    }

    try {
      final translationManager = Get.find<TranslationServiceManager>();

      // 检查翻译配置
      if (!await translationManager.hasValidConfigAsync()) {
        if (context.mounted) {
          await TranslationServiceManager.showConfigCheckDialog(context);
        }
        if (mounted) setState(() => _isTranslating = false);
        return;
      }

      // 检查是否有设置默认翻译接口
      if (!await translationManager.hasDefaultProviderAsync()) {
        if (context.mounted) {
          _showErrorSnackBar(context, '您还没有设置默认翻译接口');
        }
        if (mounted) setState(() => _isTranslating = false);
        return;
      }

      final provider = translationManager.defaultProvider!;
      final firstEntry = widget.translationEntries.first;

      // 收集所有目标语言代码
      final targetLanguageCodes = widget.translationEntries
          .expand((e) => e.targetLanguages)
          .map((t) => t.language.code)
          .toSet()
          .toList();

      if (targetLanguageCodes.isEmpty) {
        if (context.mounted) {
          _showErrorSnackBar(context, '没有需要翻译的目标语言');
        }
        if (mounted) setState(() => _isTranslating = false);
        return;
      }

      // 调用服务端翻译接口（翻译 + 入库）
      final success = await TranslationApi().translateEntry(
        projectId: firstEntry.projectId,
        entryId: firstEntry.uuid,
        targetLanguages: targetLanguageCodes,
        provider: provider,
      );

      if (success) {
        // 翻译成功，通知父组件刷新列表
        widget.onTranslateByDefaultLanguage?.call(
          key: widget.translationKey,
          entries: widget.translationEntries,
        );
        if (context.mounted) {
          _showSuccessSnackBar(context, '翻译成功');
        }
      } else {
        if (context.mounted) {
          _showErrorSnackBar(context, '翻译失败，请稍后重试');
        }
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('翻译处理异常', error: error, stackTrace: stackTrace);
      if (context.mounted) {
        _showErrorSnackBar(context, '翻译处理异常: $error');
      }
    } finally {
      if (mounted) setState(() => _isTranslating = false);
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

  /// 显示成功提示
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
