import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/widgets/format_card.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/project/widgets/drag_drop_upload.dart';

/// 项目导入页面
class ProjectImportView extends StatelessWidget {
  const ProjectImportView({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: projectId,
      builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 页面标题
              Row(
                children: [
                  const Icon(Icons.file_download, size: 28.0),
                  const SizedBox(width: 12.0),
                  Text(
                    '导入翻译',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // 支持的格式卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '支持的文件格式',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        children: [
                          FormatCard(
                            name: 'JSON',
                            description: 'application/json',
                            icon: Icons.code,
                          ),
                          FormatCard(
                            name: 'CSV',
                            description: 'text/csv',
                            icon: Icons.table_chart,
                          ),
                          FormatCard(
                            name: 'Excel',
                            description: 'application/vnd.ms-excel',
                            icon: Icons.table_view,
                          ),
                          FormatCard(
                            name: 'ARB',
                            description: 'application/arb',
                            icon: Icons.flutter_dash,
                          ),
                          FormatCard(
                            name: 'PO',
                            description: 'application/x-po',
                            icon: Icons.language,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // 导入区域卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '选择文件',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      DragDropUpload(
                        languages: controller.project?.targetLanguages ?? [],
                        height: 200.0,
                        allowedExtensions: controller.allowedExtensions,
                        maxFileSize: 10 * 1024 * 1024, // 10MB
                        multiple: true,
                        title: '拖拽文件到此处或点击选择',
                        subtitle: '支持 JSON、CSV、Excel、ARB、PO 格式',
                        icon: Icons.cloud_upload,
                        borderRadius: 12.0,
                        showFileInfo: true,
                        onFileSelected: controller.importFiles,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // 导入选项卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '导入选项',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      _buildOptionItem(
                        context,
                        '覆盖现有翻译',
                        '如果词条已存在，是否覆盖现有翻译',
                        false,
                        (value) {},
                      ),
                      _buildOptionItem(
                        context,
                        '自动审核',
                        '导入的翻译自动标记为已审核',
                        true,
                        (value) {},
                      ),
                      _buildOptionItem(
                        context,
                        '忽略空值',
                        '跳过空的翻译内容',
                        true,
                        (value) {},
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // 导入历史卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '导入历史',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      _buildHistoryItem(
                        context,
                        'translations_zh.json',
                        '成功导入 234 条翻译',
                        '2 小时前',
                        true,
                      ),
                      _buildHistoryItem(
                        context,
                        'translations_en.csv',
                        '成功导入 189 条翻译',
                        '1 天前',
                        true,
                      ),
                      _buildHistoryItem(
                        context,
                        'translations_ja.xlsx',
                        '导入失败：格式错误',
                        '2 天前',
                        false,
                      ),
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
  }

  Widget _buildOptionItem(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    String fileName,
    String result,
    String time,
    bool isSuccess,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? Colors.green : Colors.red,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  result,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
