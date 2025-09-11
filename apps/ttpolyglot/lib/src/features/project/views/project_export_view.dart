import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/widgets/clickable_stat_card.dart';
import 'package:ttpolyglot/src/features/features.dart';

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
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // 响应式列数：小屏幕2列，中等屏幕3列，大屏幕5列
                              final crossAxisCount = constraints.maxWidth < 600.0
                                  ? 2
                                  : constraints.maxWidth < 900.0
                                      ? 3
                                      : 5;

                              // 动态计算卡片宽度：总宽度减去间距后除以列数
                              final totalSpacing = (crossAxisCount - 1) * 16.0; // 间距总和
                              final cardWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

                              return Wrap(
                                spacing: 16.0,
                                runSpacing: 16.0,
                                children: [
                                  SizedBox(
                                    width: cardWidth,
                                    child: ClickableStatCard(
                                      title: 'JSON',
                                      subtitle: '适合开发使用',
                                      icon: Icons.code,
                                      color: Colors.blue,
                                      onTap: () {
                                        ProjectExportController.exportTranslationsShortcutJson(projectId);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: cardWidth,
                                    child: ClickableStatCard(
                                      title: 'CSV',
                                      subtitle: '适合批量编辑',
                                      icon: Icons.table_chart,
                                      color: Colors.green,
                                      onTap: () {
                                        ProjectExportController.exportTranslationsShortcutCsv(projectId);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: cardWidth,
                                    child: ClickableStatCard(
                                      title: 'Excel',
                                      subtitle: '适合数据分析',
                                      icon: Icons.table_view,
                                      color: Colors.orange,
                                      onTap: () {
                                        ProjectExportController.exportTranslationsShortcutExcel(projectId);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: cardWidth,
                                    child: ClickableStatCard(
                                      title: 'ARB',
                                      subtitle: 'Flutter ARB格式',
                                      icon: Icons.flutter_dash,
                                      color: Colors.purple,
                                      onTap: () {
                                        ProjectExportController.exportTranslationsShortcutArb(projectId);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: cardWidth,
                                    child: ClickableStatCard(
                                      title: 'PO',
                                      subtitle: 'GNU PO格式',
                                      icon: Icons.language,
                                      color: Colors.teal,
                                      onTap: () {
                                        ProjectExportController.exportTranslationsShortcutPo(projectId);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 自定义导出卡片
                  GetBuilder<ProjectExportController>(
                    tag: projectId,
                    builder: (exportController) {
                      // 初始化自定义导出设置
                      exportController.initializeCustomExport(project);

                      return Obx(
                        () => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '自定义导出',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const Spacer(),
                                    if (exportController.isExporting)
                                      const SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(strokeWidth: 2.0),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),

                                // 语言选择
                                Text(
                                  '选择语言 (${exportController.selectedLanguages.length}/${project.targetLanguages.length + 1})',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8.0),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    _buildLanguageChip(context, project.defaultLanguage, true, exportController),
                                    ...project.targetLanguages
                                        .map((lang) => _buildLanguageChip(context, lang, false, exportController)),
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
                                  exportController.exportOnlyTranslated,
                                  (value) => exportController.setExportOnlyTranslated(value),
                                ),
                                _buildExportOption(
                                  context,
                                  '包含翻译状态',
                                  '在导出文件中包含翻译状态信息',
                                  exportController.includeStatus,
                                  (value) => exportController.setIncludeStatus(value),
                                ),
                                _buildExportOption(
                                  context,
                                  '包含时间戳',
                                  '在导出文件中包含创建和更新时间',
                                  exportController.includeTimestamps,
                                  (value) => exportController.setIncludeTimestamps(value),
                                ),

                                const SizedBox(height: 16.0),

                                // 格式选择
                                Text(
                                  '选择格式',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8.0),
                                _buildFormatSelector(context, exportController),

                                const SizedBox(height: 16.0),

                                // 导出摘要
                                Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '导出摘要',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.language,
                                            size: 16.0,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            '语言: ${exportController.selectedLanguages.length} 个',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.description,
                                            size: 16.0,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            '格式: ${exportController.selectedFormat.toUpperCase()}',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.filter_list,
                                            size: 16.0,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Text(
                                              '选项: ${[
                                                if (exportController.exportOnlyTranslated) '仅已翻译',
                                                if (exportController.includeStatus) '包含状态',
                                                if (exportController.includeTimestamps) '包含时间戳',
                                              ].join(', ').isNotEmpty ? [
                                                  if (exportController.exportOnlyTranslated) '仅已翻译',
                                                  if (exportController.includeStatus) '包含状态',
                                                  if (exportController.includeTimestamps) '包含时间戳',
                                                ].join(', ') : '无'}',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16.0),

                                // 导出按钮
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        exportController.isExporting || exportController.selectedLanguages.isEmpty
                                            ? null
                                            : () {
                                                ProjectExportController.exportTranslationsCustom(
                                                  projectId,
                                                  selectedLanguages: exportController.selectedLanguages,
                                                  exportOnlyTranslated: exportController.exportOnlyTranslated,
                                                  includeStatus: exportController.includeStatus,
                                                  includeTimestamps: exportController.includeTimestamps,
                                                  format: exportController.selectedFormat,
                                                );
                                              },
                                    icon: exportController.isExporting
                                        ? const SizedBox(
                                            width: 16.0,
                                            height: 16.0,
                                            child: CircularProgressIndicator(strokeWidth: 2.0),
                                          )
                                        : const Icon(Icons.download),
                                    label: Text(exportController.isExporting ? '导出中...' : '开始导出'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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

  Widget _buildLanguageChip(
    BuildContext context,
    dynamic language,
    bool isDefault,
    ProjectExportController exportController,
  ) {
    final isSelected = exportController.selectedLanguages.contains(language.code);

    return FilterChip(
      selected: isSelected,
      label: Text('${language.nativeName} (${language.code})'),
      avatar: isDefault ? const Icon(Icons.star, size: 16.0) : null,
      onSelected: (selected) {
        exportController.toggleLanguage(language.code);
      },
      backgroundColor: isDefault ? Theme.of(context).colorScheme.primaryContainer : null,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.primary,
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

  Widget _buildFormatSelector(BuildContext context, ProjectExportController exportController) {
    final formats = [
      {'label': 'JSON', 'value': 'json', 'icon': Icons.code, 'description': '适合开发使用'},
      {'label': 'CSV', 'value': 'csv', 'icon': Icons.table_chart, 'description': '适合批量编辑'},
      {'label': 'Excel', 'value': 'excel', 'icon': Icons.table_view, 'description': '适合数据分析'},
      {'label': 'ARB', 'value': 'arb', 'icon': Icons.flutter_dash, 'description': 'Flutter ARB格式'},
      {'label': 'PO', 'value': 'po', 'icon': Icons.language, 'description': 'GNU PO格式'},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600.0 ? 2 : 3;

        return Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: formats.map((format) {
            final isSelected = exportController.selectedFormat == format['value'];

            return SizedBox(
              width: (constraints.maxWidth - (crossAxisCount - 1) * 8.0) / crossAxisCount,
              child: RadioListTile<String>(
                title: Row(
                  children: [
                    Icon(
                      format['icon'] as IconData,
                      size: 20.0,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            format['label'] as String,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: isSelected ? FontWeight.bold : null,
                                ),
                          ),
                          Text(
                            format['description'] as String,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                value: format['value'] as String,
                groupValue: exportController.selectedFormat,
                onChanged: (value) {
                  if (value != null) {
                    exportController.setSelectedFormat(value);
                  }
                },
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              ),
            );
          }).toList(),
        );
      },
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
