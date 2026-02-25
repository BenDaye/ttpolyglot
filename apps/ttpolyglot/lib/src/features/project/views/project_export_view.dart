import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/utils/file_save_util.dart';
import 'package:ttpolyglot/src/core/widgets/clickable_stat_card.dart';
import 'package:ttpolyglot/src/features/features.dart';

/// 项目导出页面
class ProjectExportView extends StatefulWidget {
  const ProjectExportView({super.key, required this.projectId});
  final int projectId;

  @override
  State<ProjectExportView> createState() => _ProjectExportViewState();
}

class _ProjectExportViewState extends State<ProjectExportView> {
  final FileApi _fileApi = Get.find<FileApi>();
  late Future<List<ExportHistoryItem>> _exportHistoryFuture;

  @override
  void initState() {
    super.initState();
    _exportHistoryFuture = _fetchExportHistory();
  }

  Future<List<ExportHistoryItem>> _fetchExportHistory() async {
    final data = await _fileApi.getBatchJobs(
      projectId: widget.projectId,
      jobType: 'export',
      limit: 20,
    );
    if (data == null) return [];

    final jobs = data['jobs'] as List<dynamic>? ?? [];
    return jobs.map((job) {
      final jobMap = job as Map<String, dynamic>;
      final config = jobMap['config'] is Map ? jobMap['config'] as Map<String, dynamic> : <String, dynamic>{};
      final status = jobMap['status']?.toString() ?? 'failed';
      final totalItems = jobMap['total_items'] as int? ?? 0;

      final format = config['format']?.toString() ?? 'json';
      final description = status == 'completed' ? '导出 $totalItems 条翻译，格式: ${format.toUpperCase()}' : '导出失败';

      return ExportHistoryItem(
        filename: '${format.toUpperCase()}_export_${jobMap['id']?.toString().substring(0, 8) ?? ''}',
        description: description,
        timestamp: DateTime.tryParse(jobMap['created_at']?.toString() ?? '') ?? DateTime.now(),
        success: status == 'completed',
        format: format,
        languageCount: totalItems,
        filePath: jobMap['file_path']?.toString(),
      );
    }).toList();
  }

  void _refreshExportHistory() {
    setState(() {
      _exportHistoryFuture = _fetchExportHistory();
    });
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} 小时前';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} 天前';
    } else {
      return '${timestamp.month}-${timestamp.day} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  String _getSelectedConfigSummary(ProjectExportController exportController) {
    final List<String> configParts = [];

    // 语言配置
    if (exportController.selectedLanguages.isNotEmpty) {
      configParts.add('${exportController.selectedLanguages.length} 种语言');
    }

    // 导出格式
    final formatName = switch (exportController.selectedFormat.toLowerCase()) {
      'json' => 'JSON',
      'csv' => 'CSV',
      'excel' => 'Excel',
      'arb' => 'ARB',
      'po' => 'PO',
      _ => exportController.selectedFormat.toUpperCase(),
    };
    configParts.add('$formatName 格式');

    // 导出选项
    final options = <String>[];
    if (exportController.exportOnlyTranslated) {
      options.add('仅已翻译');
    }
    if (exportController.includeStatus) {
      options.add('包含状态');
    }
    if (exportController.includeTimestamps) {
      options.add('包含时间戳');
    }

    if (options.isNotEmpty) {
      configParts.add(options.join(', '));
    }

    return configParts.isEmpty ? '未选择配置' : configParts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: widget.projectId.toString(),
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
                                      onTap: () async {
                                        try {
                                          await ProjectExportController.exportTranslationsShortcutJson(
                                            widget.projectId,
                                          );
                                          setState(() {}); // 触发UI更新
                                        } catch (e) {
                                          setState(() {}); // 触发UI更新
                                        }
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
                                      onTap: () async {
                                        try {
                                          await ProjectExportController.exportTranslationsShortcutCsv(
                                            widget.projectId,
                                          );
                                          setState(() {}); // 触发UI更新
                                        } catch (e) {
                                          setState(() {}); // 触发UI更新
                                        }
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
                                      onTap: () async {
                                        try {
                                          await ProjectExportController.exportTranslationsShortcutExcel(
                                            widget.projectId,
                                          );
                                          setState(() {}); // 触发UI更新
                                        } catch (e) {
                                          setState(() {}); // 触发UI更新
                                        }
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
                                      onTap: () async {
                                        try {
                                          await ProjectExportController.exportTranslationsShortcutArb(
                                            widget.projectId,
                                          );
                                          setState(() {}); // 触发UI更新
                                        } catch (e) {
                                          setState(() {}); // 触发UI更新
                                        }
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
                                      onTap: () async {
                                        try {
                                          await ProjectExportController.exportTranslationsShortcutPo(
                                            widget.projectId,
                                          );
                                          setState(() {}); // 触发UI更新
                                        } catch (e) {
                                          setState(() {}); // 触发UI更新
                                        }
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
                    tag: widget.projectId.toString(),
                    builder: (exportController) {
                      // 初始化自定义导出选项
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
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.translate,
                                            size: 20.0,
                                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                                          ),
                                          const SizedBox(width: 12.0),
                                          Text(
                                            '选择语言 (${exportController.selectedLanguages.length}/${project.languages.length})',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          // 根据屏幕宽度决定列数
                                          final availableWidth = constraints.maxWidth;
                                          int crossAxisCount;

                                          if (availableWidth < 400) {
                                            crossAxisCount = 2; // 很窄的屏幕，双列
                                          } else if (availableWidth < 600) {
                                            crossAxisCount = 3; // 中等宽度，三列
                                          } else if (availableWidth < 800) {
                                            crossAxisCount = 4; // 较宽，四列
                                          } else {
                                            crossAxisCount = 5; // 很宽，五列
                                          }

                                          final allLanguages = project.languages;

                                          return GridView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              crossAxisSpacing: 8.0,
                                              mainAxisSpacing: 8.0,
                                              childAspectRatio: availableWidth < 400 ? 3.5 : 3.0, // 语言选项需要更大的空间
                                            ),
                                            itemCount: allLanguages.length,
                                            itemBuilder: (context, index) {
                                              final language = allLanguages[index];
                                              final isDefault = index == 0; // 第一个是默认语言
                                              return _buildLanguageChip(context, language, isDefault, exportController);
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16.0),

                                // 格式选择
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.folder,
                                            size: 20.0,
                                            color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.7),
                                          ),
                                          const SizedBox(width: 12.0),
                                          Text(
                                            '选择格式',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      _buildFormatSelector(context, exportController),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16.0),

                                // 导出操作区域 - 优化后的合并设计
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                                        Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: exportController.isExporting
                                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.25)
                                          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                      width: exportController.isExporting ? 1.5 : 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                                        blurRadius: 8.0,
                                        offset: const Offset(0, 2),
                                      ),
                                      if (exportController.isExporting)
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                                          blurRadius: 16.0,
                                          offset: const Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // 导出配置摘要
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.settings_outlined,
                                              size: 20.0,
                                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Text(
                                              '导出配置',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                                                  ),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Text(
                                              '(请选择导出参数并开始导出)',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant
                                                        .withValues(alpha: 0.65),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // 导出按钮区域 - 增强设计
                                      Container(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                child: InkWell(
                                                  onTap: exportController.isExporting ||
                                                          exportController.selectedLanguages.isEmpty
                                                      ? null
                                                      : () async {
                                                          await ProjectExportController.exportTranslationsWithHistory(
                                                            widget.projectId,
                                                            selectedLanguages: exportController.selectedLanguages,
                                                            exportOnlyTranslated: exportController.exportOnlyTranslated,
                                                            includeStatus: exportController.includeStatus,
                                                            includeTimestamps: exportController.includeTimestamps,
                                                            format: exportController.selectedFormat,
                                                          );
                                                        },
                                                  child: Container(
                                                    height: 200.0,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: exportController.selectedLanguages.isEmpty
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .outline
                                                                .withValues(alpha: 0.3)
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                                .withValues(alpha: 0.5),
                                                        width: 2.0,
                                                        style: BorderStyle.solid,
                                                      ),
                                                      borderRadius: BorderRadius.circular(12.0),
                                                      color: exportController.selectedLanguages.isEmpty
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .surfaceContainerHighest
                                                              .withValues(alpha: 0.3)
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary
                                                              .withValues(alpha: 0.05),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.cloud_download,
                                                          size: 48.0,
                                                          color: Theme.of(context).colorScheme.primary,
                                                        ),
                                                        const SizedBox(height: 16.0),
                                                        Text(
                                                          '点击开始导出翻译文件',
                                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                color: Theme.of(context).colorScheme.primary,
                                                              ),
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        Text(
                                                          _getSelectedConfigSummary(exportController),
                                                          style: exportController.selectedLanguages.isEmpty
                                                              ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                    color: Theme.of(context)
                                                                        .colorScheme
                                                                        .onSurface
                                                                        .withValues(alpha: 0.7),
                                                                  )
                                                              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                    color: Theme.of(context)
                                                                        .colorScheme
                                                                        .onSurface
                                                                        .withValues(alpha: 0.3),
                                                                  ),
                                                        ),
                                                        const SizedBox(height: 16.0),
                                                        ElevatedButton.icon(
                                                          onPressed: exportController.isExporting ||
                                                                  exportController.selectedLanguages.isEmpty
                                                              ? null
                                                              : () async {
                                                                  await ProjectExportController
                                                                      .exportTranslationsWithHistory(
                                                                    widget.projectId,
                                                                    selectedLanguages:
                                                                        exportController.selectedLanguages,
                                                                    exportOnlyTranslated:
                                                                        exportController.exportOnlyTranslated,
                                                                    includeStatus: exportController.includeStatus,
                                                                    includeTimestamps:
                                                                        exportController.includeTimestamps,
                                                                    format: exportController.selectedFormat,
                                                                  );
                                                                },
                                                          icon: const Icon(Icons.download_rounded),
                                                          label: const Text('确认导出'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // 状态提示
                                            if (exportController.selectedLanguages.isEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  '请至少选择一种语言',
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: Theme.of(context).colorScheme.error,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                ),
                                              )
                                            else if (exportController.isExporting)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  '正在准备导出文件，请稍候...',
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withValues(alpha: 0.8),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16.0),

                                // 导出选项
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.settings,
                                            size: 20.0,
                                            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
                                          ),
                                          const SizedBox(width: 12.0),
                                          Text(
                                            '导出选项',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
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
                                    ],
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
                          Row(
                            children: [
                              Text(
                                '导出历史',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _refreshExportHistory,
                                icon: const Icon(Icons.refresh, size: 20.0),
                                tooltip: '刷新',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          FutureBuilder<List<ExportHistoryItem>>(
                            future: _exportHistoryFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 48.0,
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                        const SizedBox(height: 16.0),
                                        Text(
                                          '加载历史记录失败',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: Theme.of(context).colorScheme.error,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final historyList = snapshot.data ?? [];

                              if (historyList.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.history,
                                          size: 48.0,
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 16.0),
                                        Text(
                                          '暂无导出历史',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return Column(
                                children: historyList
                                    .map(
                                      (item) => _buildExportHistoryItem(
                                        context,
                                        item,
                                      ),
                                    )
                                    .toList(),
                              );
                            },
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
    LanguageModel language,
    bool isDefault,
    ProjectExportController exportController,
  ) {
    final isSelected = exportController.selectedLanguages.contains(language.code.code);

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: () => exportController.toggleLanguage(language.code.code),
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              width: isSelected ? 2.0 : 1.0,
            ),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                      : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Icon(
                  isDefault ? Icons.star : Icons.language,
                  size: 20.0,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : (isDefault ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      language.nativeName ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      language.code.code.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 6.0),
                Icon(
                  Icons.check_circle,
                  size: 22.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
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
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Theme.of(context).colorScheme.primary,
                  activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  inactiveThumbColor: Theme.of(context).colorScheme.outline,
                  inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatSelector(BuildContext context, ProjectExportController exportController) {
    final formats = [
      {'label': 'JSON', 'value': 'json', 'icon': Icons.code, 'description': '适合开发使用', 'color': const Color(0xFF4CAF50)},
      {
        'label': 'CSV',
        'value': 'csv',
        'icon': Icons.table_chart,
        'description': '适合批量编辑',
        'color': const Color(0xFF2196F3),
      },
      {
        'label': 'Excel',
        'value': 'excel',
        'icon': Icons.table_view,
        'description': '适合数据分析',
        'color': const Color(0xFF4CAF50),
      },
      {
        'label': 'ARB',
        'value': 'arb',
        'icon': Icons.flutter_dash,
        'description': 'Flutter ARB格式',
        'color': const Color(0xFF673AB7),
      },
      {
        'label': 'PO',
        'value': 'po',
        'icon': Icons.language,
        'description': 'GNU PO格式',
        'color': const Color(0xFF009688),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据屏幕宽度决定列数
        final availableWidth = constraints.maxWidth;
        int crossAxisCount;

        if (availableWidth < 400) {
          crossAxisCount = 1; // 很窄的屏幕，单列
        } else if (availableWidth < 600) {
          crossAxisCount = 2; // 中等宽度，双列
        } else if (availableWidth < 800) {
          crossAxisCount = 3; // 较宽，三列
        } else {
          crossAxisCount = 4; // 很宽，四列
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: availableWidth < 400 ? 4.5 : 3.8, // 水平布局使用更扁的比例
          ),
          itemCount: formats.length,
          itemBuilder: (context, index) {
            final format = formats[index];
            final isSelected = exportController.selectedFormat == format['value'];

            return Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                onTap: () => exportController.setSelectedFormat(format['value'] as String),
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                              : (format['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          format['icon'] as IconData,
                          size: availableWidth < 400 ? 16.0 : 18.0, // 小屏幕使用小图标
                          color: isSelected ? Theme.of(context).colorScheme.primary : (format['color'] as Color),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              format['label'] as String,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onSurface,
                                    fontSize: availableWidth < 400 ? 12.0 : null, // 小屏幕使用小字体
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              format['description'] as String,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                    fontSize: availableWidth < 400 ? 10.0 : null, // 小屏幕使用小字体
                                  ),
                              maxLines: availableWidth < 400 ? 1 : 2, // 小屏幕只显示一行
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8.0),
                        Icon(
                          Icons.check_circle,
                          size: availableWidth < 400 ? 20.0 : 24.0, // 增大选中图标尺寸
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExportHistoryItem(
    BuildContext context,
    ExportHistoryItem item,
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
            item.success ? Icons.check_circle : Icons.error,
            color: item.success ? Colors.green : Colors.red,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.filename,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                Text(
                  _formatTime(item.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: item.filePath != null && item.success
                ? () async {
                    try {
                      final success = await FileSaveUtil.downloadFileFromPath(
                        filePath: item.filePath!,
                        customFileName: item.filename,
                      );

                      if (success) {
                        Get.snackbar('成功', '文件下载成功');
                      } else {
                        Get.snackbar('错误', '文件下载失败，文件可能已被删除或移动');
                      }
                    } catch (e) {
                      Get.snackbar('错误', '文件下载失败: $e');
                    }
                  }
                : null,
            icon: const Icon(Icons.download),
            tooltip: item.filePath != null && item.success ? '下载' : '文件不可用',
          ),
        ],
      ),
    );
  }
}
