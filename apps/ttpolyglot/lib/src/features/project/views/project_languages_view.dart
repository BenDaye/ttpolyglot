import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目语言设置页面
class ProjectLanguagesView extends StatelessWidget {
  const ProjectLanguagesView({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: projectId,
      builder: (controller) {
        return Obx(
          () {
            final project = controller.project;
            if (project == null) return const Center(child: Text('项目不存在'));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 默认语言卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '默认语言',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          _buildLanguageCard(
                            context,
                            project.defaultLanguage,
                            isDefault: true,
                            onEdit: (language) async {
                              await ProjectDialogController.showEditDefaultLanguagesDialog(project);
                              controller.refreshProject();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 目标语言卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '目标语言',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await ProjectDialogController.showEditTargetLanguagesDialog(project);
                                  controller.refreshProject();
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('添加语言'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          ...project.targetLanguages.map((lang) => _buildLanguageCard(
                                context,
                                lang,
                                isDefault: false,
                                onDelete: (language) {
                                  controller.removeTargetLanguage(language);
                                },
                              )),
                        ],
                      ),
                    ),
                  ),

                  // 为悬浮导航留出空间
                  const SizedBox(height: 100.0),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    Language language, {
    required bool isDefault,
    Function(Language)? onEdit,
    Function(Language)? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDefault
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4.0),
        border: isDefault ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          // 语言标识
          Container(
            width: 48.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                language.code.split('-')[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),

          // 语言信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language.nativeName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${language.name} (${language.code})',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),

          // 操作按钮
          if (!isDefault) ...[
            IconButton(
              onPressed: () => onDelete?.call(language),
              icon: const Icon(Icons.delete),
              tooltip: '删除',
            ),
          ] else ...[
            IconButton(
              onPressed: () => onEdit?.call(language),
              icon: const Icon(Icons.edit),
              tooltip: '编辑',
            ),
          ],
        ],
      ),
    );
  }
}
