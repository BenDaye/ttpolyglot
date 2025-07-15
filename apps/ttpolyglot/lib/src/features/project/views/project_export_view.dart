import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

/// 项目导出页面
class ProjectExportView extends StatelessWidget {
  const ProjectExportView({super.key, required this.projectId});
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
                  // 页面标题
                  Row(
                    children: [
                      const Icon(Icons.file_upload, size: 28.0),
                      const SizedBox(width: 12.0),
                      Text(
                        '导出翻译',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // 快速导出卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '快速导出',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickExportCard(
                                  context,
                                  'JSON',
                                  '适合前端应用',
                                  Icons.code,
                                  Colors.blue,
                                  () {},
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: _buildQuickExportCard(
                                  context,
                                  'CSV',
                                  '适合表格编辑',
                                  Icons.table_chart,
                                  Colors.green,
                                  () {},
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: _buildQuickExportCard(
                                  context,
                                  'Excel',
                                  '适合数据分析',
                                  Icons.table_view,
                                  Colors.orange,
                                  () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 自定义导出卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '自定义导出',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),

                          // 语言选择
                          Text(
                            '选择语言',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              _buildLanguageChip(context, project.defaultLanguage, true),
                              ...project.targetLanguages.map((lang) => _buildLanguageChip(context, lang, false)),
                            ],
                          ),

                          const SizedBox(height: 16.0),

                          // 导出选项
                          Text(
                            '导出选项',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8.0),
                          _buildExportOption(
                            context,
                            '仅导出已翻译内容',
                            '跳过未翻译的词条',
                            true,
                            (value) {},
                          ),
                          _buildExportOption(
                            context,
                            '包含翻译状态',
                            '在导出文件中包含翻译状态信息',
                            false,
                            (value) {},
                          ),
                          _buildExportOption(
                            context,
                            '包含时间戳',
                            '在导出文件中包含创建和更新时间',
                            false,
                            (value) {},
                          ),

                          const SizedBox(height: 16.0),

                          // 格式选择
                          Text(
                            '选择格式',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8.0),
                          _buildFormatSelector(context),

                          const SizedBox(height: 16.0),

                          // 导出按钮
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: 自定义导出功能
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('开始导出'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 导出历史卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '导出历史',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          _buildExportHistoryItem(
                            context,
                            'translations_all.json',
                            '包含所有语言的完整导出',
                            '1 小时前',
                            true,
                          ),
                          _buildExportHistoryItem(
                            context,
                            'translations_en.csv',
                            '仅英文翻译',
                            '3 小时前',
                            true,
                          ),
                          _buildExportHistoryItem(
                            context,
                            'translations_zh.xlsx',
                            '中文翻译（Excel格式）',
                            '1 天前',
                            true,
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

  Widget _buildQuickExportCard(
    BuildContext context,
    String format,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32.0, color: color),
              const SizedBox(height: 8.0),
              Text(
                format,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(height: 4.0),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageChip(
    BuildContext context,
    dynamic language,
    bool isDefault,
  ) {
    return FilterChip(
      selected: true,
      label: Text('${language.nativeName} (${language.code})'),
      onSelected: (selected) {
        // TODO: 切换语言选择
      },
    );
  }

  Widget _buildExportOption(
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
        dense: true,
      ),
    );
  }

  Widget _buildFormatSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('JSON'),
            value: 'json',
            groupValue: 'json',
            onChanged: (value) {},
            dense: true,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('CSV'),
            value: 'csv',
            groupValue: 'json',
            onChanged: (value) {},
            dense: true,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Excel'),
            value: 'excel',
            groupValue: 'json',
            onChanged: (value) {},
            dense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildExportHistoryItem(
    BuildContext context,
    String filename,
    String description,
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
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
          IconButton(
            onPressed: () {
              // TODO: 下载文件
            },
            icon: const Icon(Icons.download),
            tooltip: '下载',
          ),
        ],
      ),
    );
  }
}
