import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

/// 项目导入页面
class ProjectImportView extends StatelessWidget {
  const ProjectImportView({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: projectId,
      builder: (controller) {
        return Obx(
          () {
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
                          _buildFormatCard(context, 'JSON', 'application/json', Icons.code),
                          _buildFormatCard(context, 'CSV', 'text/csv', Icons.table_chart),
                          _buildFormatCard(context, 'Excel', 'application/vnd.ms-excel', Icons.table_view),
                          _buildFormatCard(context, 'ARB', 'application/arb', Icons.flutter_dash),
                          _buildFormatCard(context, 'PO', 'application/x-po', Icons.language),
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
                          Container(
                            width: double.infinity,
                            height: 200.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  size: 48.0,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  '拖拽文件到此处或点击选择',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '支持 JSON、CSV、Excel、ARB、PO 格式',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                ),
                                const SizedBox(height: 16.0),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: 选择文件功能
                                  },
                                  icon: const Icon(Icons.folder_open),
                                  label: const Text('选择文件'),
                                ),
                              ],
                            ),
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
      },
    );
  }

  Widget _buildFormatCard(
    BuildContext context,
    String name,
    String mimeType,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  mimeType,
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
    String filename,
    String result,
    String time,
    bool success,
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
            success ? Icons.check_circle : Icons.error,
            color: success ? Colors.green : Colors.red,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filename,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  result,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: success ? Colors.green : Colors.red,
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
