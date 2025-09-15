import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';

class TranslationsCardByKey extends StatelessWidget {
  const TranslationsCardByKey({
    super.key,
    required this.translationKey,
    required this.translationEntries,
    this.onDeleteAllEntries,
    this.onEditEntry,
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

  @override
  Widget build(BuildContext context) {
    final firstEntry = translationEntries.first;

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
                    translationKey,
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
                        onDeleteAllEntries?.call(
                          key: translationKey,
                          entries: translationEntries,
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

                    // 去翻译（根据默认语言）
                    PopupMenuItem(
                      onTap: () {
                        //
                      },
                      child: Row(
                        children: [Icon(Icons.translate), SizedBox(width: 8.0), Text('去翻译（根据默认语言）')],
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
                    onPressed: () {
                      //
                    },
                    icon: Icon(Icons.translate),
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
                ...translationEntries.map(
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
      onTap: () => onEditEntry?.call(entry: entry),
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
}
