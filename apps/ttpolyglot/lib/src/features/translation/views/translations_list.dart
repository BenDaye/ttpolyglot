import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';

enum TranslationsListType {
  byKey,
  byLanguage,
}

class TranslationsList extends StatelessWidget {
  const TranslationsList({
    super.key,
    required this.type,
    required this.projectId,
  });

  final TranslationsListType type;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TranslationController>(
      tag: projectId,
      builder: (controller) {
        switch (type) {
          case TranslationsListType.byKey:
            return _buildByKey(context, controller: controller);
          case TranslationsListType.byLanguage:
            return _buildByLanguage(context, controller: controller);
        }
      },
    );
  }

  /// 构建翻译条目列表
  Widget _buildByKey(
    BuildContext context, {
    required TranslationController controller,
  }) {
    return Obx(
      () {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final groupedEntries = controller.groupedEntries;
        if (groupedEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.translate_outlined,
                  size: 64.0,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16.0),
                Text(
                  '暂无翻译条目',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8.0),
                Text(
                  '点击筛选栏右侧的按钮开始添加翻译条目',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = _calculateCardWidth(constraints.maxWidth);

              return Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: groupedEntries.entries.map(
                  (entry) {
                    final key = entry.key;
                    final entries = entry.value;

                    return SizedBox(
                      width: cardWidth,
                      child: TranslationsCardByKey(
                        translationKey: key,
                        translationEntries: entries,
                        onDeleteAllEntries: ({required String key, required List<TranslationEntry> entries}) async {
                          _deleteTranslationKey(context, controller: controller, key: key, entries: entries);
                        },
                        onEditEntry: ({required TranslationEntry entry}) {
                          _showEditTranslationDialog(context, controller: controller, entry: entry);
                        },
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildByLanguage(
    BuildContext context, {
    required TranslationController controller,
  }) {
    return Obx(
      () {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final groupedEntries = controller.groupedEntriesByLanguage;
        if (groupedEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.translate_outlined,
                  size: 64.0,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16.0),
                Text(
                  '暂无翻译条目',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8.0),
                Text(
                  '点击筛选栏右侧的按钮开始添加翻译条目',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TranslationsCardByLanguageExpansionPanelList(
                groupedEntries: groupedEntries,
                onDeleteAllEntries: ({required String key, required List<TranslationEntry> entries}) async {
                  _deleteTranslationKey(context, controller: controller, key: key, entries: entries);
                },
                onEditEntry: ({required TranslationEntry entry}) {
                  _showEditTranslationDialog(context, controller: controller, entry: entry);
                },
              );
            },
          ),
        );
      },
    );
  }

  /// 计算卡片宽度
  double _calculateCardWidth(double availableWidth) {
    const minCardWidth = 400.0;
    const maxCardWidth = 600.0;
    const spacing = 8.0;

    // 计算可以放置的列数
    int columns = 1;
    while (true) {
      final totalSpacing = (columns - 1) * spacing;
      final cardWidth = (availableWidth - totalSpacing) / columns;

      if (cardWidth >= minCardWidth && cardWidth <= maxCardWidth) {
        return cardWidth;
      } else if (cardWidth < minCardWidth) {
        break;
      }

      columns++;
      if (columns > 4) break; // 最多4列
    }

    // 如果无法满足最小宽度，使用最小宽度
    return minCardWidth.clamp(minCardWidth, availableWidth);
  }

  /// 删除整个翻译键
  void _deleteTranslationKey(
    BuildContext context, {
    required TranslationController controller,
    required String key,
    required List<TranslationEntry> entries,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('删除翻译键'),
        content: Text('确定要删除翻译键 "$key" 及其所有语言版本吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('确定'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (result == true) {
      final entryIds = entries.map((entry) => entry.id).toList();
      await controller.batchDeleteTranslationEntries(entryIds);
    }
  }

  /// 显示编辑翻译对话框
  void _showEditTranslationDialog(
    BuildContext context, {
    required TranslationController controller,
    required TranslationEntry entry,
  }) {
    final targetTextController = TextEditingController(text: entry.targetText);
    final contextController = TextEditingController(text: entry.context ?? '');
    final commentController = TextEditingController(text: entry.comment ?? '');
    var selectedStatus = entry.status;

    Get.dialog(
      AlertDialog(
        title: Text('编辑翻译：${entry.key}'),
        content: Container(
          width: 480.0,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 显示源文本
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '源文本 (${entry.sourceLanguage.code})',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        entry.sourceText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: targetTextController,
                  decoration: InputDecoration(
                    labelText: '目标文本 (${entry.targetLanguage.code})',
                    contentPadding: const EdgeInsets.all(12.0),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16.0),

                TextField(
                  controller: contextController,
                  decoration: const InputDecoration(
                    labelText: '上下文',
                    contentPadding: EdgeInsets.all(12.0),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    labelText: '备注',
                    contentPadding: EdgeInsets.all(12.0),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16.0),
                StatefulBuilder(
                  builder: (context, setState) {
                    return DropdownButtonFormField<TranslationStatus>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: '状态',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(),
                      ),
                      items: TranslationStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.displayName),
                        );
                      }).toList(),
                      onChanged: (status) {
                        if (status != null) {
                          setState(() {
                            selectedStatus = status;
                          });
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedEntry = entry.copyWith(
                targetText: targetTextController.text.trim(),
                status: selectedStatus,
                context: contextController.text.trim().isEmpty ? null : contextController.text.trim(),
                comment: commentController.text.trim().isEmpty ? null : commentController.text.trim(),
              );

              controller.updateTranslationEntry(updatedEntry);
              Get.back();
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
