import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目翻译管理页面
class ProjectTranslationsView extends StatelessWidget {
  const ProjectTranslationsView({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: projectId,
      builder: (projectController) {
        return Obx(() {
          final project = projectController.project;
          if (project == null) {
            return const Center(child: Text('项目不存在'));
          }

          return Scaffold(
            body: GetBuilder<TranslationController>(
              tag: projectId,
              builder: (translationController) {
                return Column(
                  children: [
                    // 工具栏
                    _buildToolbar(
                      context,
                      controller: translationController,
                      project: project,
                    ),

                    // 筛选栏
                    _buildFilterBar(
                      context,
                      controller: translationController,
                      project: project,
                    ),

                    // 翻译条目列表
                    Expanded(
                      child: Obx(
                        () => TranslationsList(
                          type: translationController.listType,
                          projectId: projectId,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
      },
    );
  }

  /// 构建工具栏
  Widget _buildToolbar(
    BuildContext context, {
    required TranslationController controller,
    required Project project,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
            final stats = controller.statistics;
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
  Widget _buildFilterBar(
    BuildContext context, {
    required TranslationController controller,
    required Project project,
  }) {
    return Container(
      height: 72.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                final languages = controller.availableLanguages;
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
              final statuses = controller.availableStatuses;
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

          // 切换列表类型按钮
          Obx(
            () {
              return IconButton(
                onPressed: () => controller.switchListType(
                  controller.listType == TranslationsListType.byKey
                      ? TranslationsListType.byLanguage
                      : TranslationsListType.byKey,
                ),
                icon: Icon(
                  controller.listType == TranslationsListType.byKey ? Icons.view_column : Icons.view_list,
                ),
                tooltip: '切换列表类型',
              );
            },
          ),

          // 添加翻译键按钮
          IconButton(
            onPressed: () => _showAddTranslationDialog(context, controller: controller, project: project),
            icon: const Icon(Icons.add),
            tooltip: '添加翻译键',
          ),
        ],
      ),
    );
  }

  /// 显示添加翻译对话框
  void _showAddTranslationDialog(
    BuildContext context, {
    required TranslationController controller,
    required Project project,
  }) {
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
                targetLanguages: project.targetLanguages..sort((a, b) => a.sortIndex.compareTo(b.sortIndex)),
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
}
