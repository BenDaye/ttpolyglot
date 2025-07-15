import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目翻译管理页面
class ProjectTranslationsView extends StatelessWidget {
  const ProjectTranslationsView({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    // 初始化翻译控制器
    final translationController = Get.put(
      TranslationController(projectId: projectId),
      tag: 'translation_$projectId',
    );

    return GetBuilder<ProjectController>(
      tag: projectId,
      builder: (projectController) {
        return Obx(() {
          final project = projectController.project;
          if (project == null) {
            return const Center(child: Text('项目不存在'));
          }

          return Scaffold(
            body: Column(
              children: [
                // 工具栏
                _buildToolbar(context, translationController, project),

                // 筛选栏
                _buildFilterBar(context, translationController, project),

                // 翻译条目列表
                Expanded(
                  child: _buildTranslationList(context, translationController),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  /// 构建工具栏
  Widget _buildToolbar(BuildContext context, TranslationController controller, Project project) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // 标题
          Text(
            '翻译管理',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const Spacer(),

          // 统计信息
          Obx(() {
            final stats = controller.getStatistics();
            return Row(
              children: [
                _buildStatChip(context, '总计', stats['total'] ?? 0, Colors.blue),
                const SizedBox(width: 8.0),
                _buildStatChip(context, '已完成', stats['completed'] ?? 0, Colors.green),
                const SizedBox(width: 8.0),
                _buildStatChip(context, '待翻译', stats['pending'] ?? 0, Colors.orange),
                const SizedBox(width: 8.0),
                _buildStatChip(context, '翻译中', stats['translating'] ?? 0, Colors.blue),
                const SizedBox(width: 8.0),
                _buildStatChip(context, '审核中', stats['reviewing'] ?? 0, Colors.purple),
              ],
            );
          }),

          const SizedBox(width: 16.0),

          // 刷新按钮
          IconButton(
            onPressed: () => controller.refreshTranslationEntries(),
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
          ),
        ],
      ),
    );
  }

  /// 构建统计芯片
  Widget _buildStatChip(BuildContext context, String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        '$label: $count',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  /// 构建筛选栏
  Widget _buildFilterBar(BuildContext context, TranslationController controller, Project project) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // 搜索框
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(
                hintText: '搜索翻译键、源文本或目标文本...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => controller.searchTranslationEntries(value),
            ),
          ),

          const SizedBox(width: 16.0),

          // 语言筛选
          Expanded(
            child: Obx(
              () {
                final languages = controller.getAvailableLanguages();
                return DropdownButtonFormField<Language>(
                  menuMaxHeight: 240.0,
                  decoration: const InputDecoration(
                    hintText: '筛选语言',
                    contentPadding: EdgeInsets.all(12.0),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  value: controller.selectedLanguage,
                  items: [
                    DropdownMenuItem<Language>(
                      value: null,
                      child: Text(
                        '所有语言',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ...languages.map(
                      (language) => DropdownMenuItem<Language>(
                        value: language,
                        child: Text(
                          '${language.nativeName} (${language.code})',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (language) => controller.filterByLanguage(language),
                );
              },
            ),
          ),

          const SizedBox(width: 16.0),

          // 状态筛选
          Expanded(
            child: Obx(() {
              final statuses = controller.getAvailableStatuses();
              return DropdownButtonFormField<TranslationStatus>(
                menuMaxHeight: 240.0,
                decoration: const InputDecoration(
                  hintText: '筛选状态',
                  contentPadding: EdgeInsets.all(12.0),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                value: controller.selectedStatus,
                items: [
                  DropdownMenuItem<TranslationStatus>(
                    value: null,
                    child: Text(
                      '所有状态',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  ...statuses.map(
                    (status) => DropdownMenuItem<TranslationStatus>(
                      value: status,
                      child: Text(
                        status.displayName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
                onChanged: (status) => controller.filterByStatus(status),
              );
            }),
          ),

          const SizedBox(width: 16.0),

          // 清除筛选按钮
          IconButton(
            onPressed: () => controller.clearFilters(),
            icon: const Icon(Icons.clear_all),
            tooltip: '清除筛选',
          ),

          const SizedBox(width: 8.0),

          // 添加翻译键按钮
          IconButton(
            onPressed: () => _showAddTranslationDialog(context, controller, project),
            icon: const Icon(Icons.add),
            tooltip: '添加翻译键',
          ),
        ],
      ),
    );
  }

  /// 构建翻译条目列表
  Widget _buildTranslationList(BuildContext context, TranslationController controller) {
    return Obx(
      () {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.0,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16.0),
                Text(
                  '加载失败',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8.0),
                Text(
                  controller.error,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => controller.refreshTranslationEntries(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        final groupedEntries = controller.getGroupedEntries();
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
                      child: _buildTranslationKeyCard(
                        context,
                        controller,
                        key,
                        entries,
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

  /// 构建翻译键卡片
  Widget _buildTranslationKeyCard(
      BuildContext context, TranslationController controller, String key, List<TranslationEntry> entries) {
    final firstEntry = entries.first;

    return Card(
      elevation: 2.0,
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
                    key,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                // 操作按钮
                PopupMenuButton<String>(
                  onSelected: (value) => _handleKeyAction(context, controller, key, entries, value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete_all',
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

            // 各语言翻译
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
                ...entries.map(
                  (entry) => _buildLanguageTranslationItem(context, controller, entry),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建语言翻译项
  Widget _buildLanguageTranslationItem(BuildContext context, TranslationController controller, TranslationEntry entry) {
    return InkWell(
      onTap: () => _showEditTranslationDialog(context, controller, entry),
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
                      color: _getStatusColor(entry.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      entry.status.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(entry.status),
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

  /// 获取状态颜色
  Color _getStatusColor(TranslationStatus status) {
    switch (status) {
      case TranslationStatus.pending:
        return Colors.orange;
      case TranslationStatus.translating:
        return Colors.blue;
      case TranslationStatus.completed:
        return Colors.green;
      case TranslationStatus.reviewing:
        return Colors.purple;
      case TranslationStatus.rejected:
        return Colors.red;
      case TranslationStatus.needsRevision:
        return Colors.amber;
      case TranslationStatus.outdated:
        return Colors.grey;
    }
  }

  /// 处理翻译键操作
  void _handleKeyAction(BuildContext context, TranslationController controller, String key,
      List<TranslationEntry> entries, String action) {
    switch (action) {
      case 'delete_all':
        _deleteTranslationKey(context, controller, key, entries);
        break;
    }
  }

  /// 删除整个翻译键
  void _deleteTranslationKey(
      BuildContext context, TranslationController controller, String key, List<TranslationEntry> entries) async {
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

  /// 显示添加翻译对话框
  void _showAddTranslationDialog(BuildContext context, TranslationController controller, Project project) {
    final keyController = TextEditingController();
    final sourceTextController = TextEditingController();
    final contextController = TextEditingController();
    final commentController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('添加翻译键'),
        content: Container(
          width: 480.0,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: keyController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: '翻译键',
                    hintText: 'common.welcome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: sourceTextController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: '源文本',
                    hintText: 'Welcome to use',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: contextController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: '上下文',
                    hintText: '在欢迎使用页面显示',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: '备注',
                    hintText: '在欢迎使用页面显示',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
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
              final key = keyController.text.trim();
              final sourceText = sourceTextController.text.trim();

              if (key.isEmpty || sourceText.isEmpty) {
                Get.snackbar('错误', '翻译键和源文本不能为空');
                return;
              }

              controller.createTranslationKey(
                key: key,
                sourceText: sourceText,
                sourceLanguage: project.defaultLanguage,
                targetLanguages: project.targetLanguages,
                context: contextController.text.trim().isEmpty ? null : contextController.text.trim(),
                comment: commentController.text.trim().isEmpty ? null : commentController.text.trim(),
              );

              Get.back();
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  /// 显示编辑翻译对话框
  void _showEditTranslationDialog(BuildContext context, TranslationController controller, TranslationEntry entry) {
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
