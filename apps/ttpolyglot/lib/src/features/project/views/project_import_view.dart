import 'dart:developer';

import 'package:excel/excel.dart' as excel;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/utils/file_save_util.dart';
import 'package:ttpolyglot/src/core/widgets/format_card.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/project/widgets/upload_file.dart';
import 'package:ttpolyglot/src/features/project/widgets/upload_file_list.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目导入页面
class ProjectImportView extends StatefulWidget {
  const ProjectImportView({super.key, required this.projectId});
  final String projectId;

  @override
  State<ProjectImportView> createState() => _ProjectImportViewState();
}

class _ProjectImportViewState extends State<ProjectImportView> {
  String _formatImportTime(DateTime timestamp) {
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: widget.projectId,
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
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // 响应式列数：小屏幕1列，中等屏幕2列，大屏幕3列，超大屏4列，超超大屏5列
                          final crossAxisCount = constraints.maxWidth < 600.0
                              ? 1
                              : constraints.maxWidth < 900.0
                                  ? 2
                                  : constraints.maxWidth < 1200.0
                                      ? 3
                                      : constraints.maxWidth < 1400.0
                                          ? 4
                                          : 5;

                          // 动态计算卡片宽度：总宽度减去间距后除以列数
                          final totalSpacing = (crossAxisCount - 1) * 8.0; // 间距总和
                          var cardWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

                          return Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              SizedBox(
                                width: cardWidth,
                                child: FormatCard(
                                  name: 'JSON',
                                  description: 'application/json',
                                  icon: Icons.code,
                                  color: Colors.orange,
                                  trailing: TextButton.icon(
                                    onPressed: () async {
                                      try {
                                        await FileSaveUtil.saveTextFile(
                                          fileName: 'demo.json',
                                          content: '{"hello": "你好"}',
                                          mimeType: 'application/json',
                                        );
                                      } catch (error, stackTrace) {
                                        log('下载 JSON Demo 失败',
                                            error: error, stackTrace: stackTrace, name: 'ProjectImportView');
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      textStyle: Theme.of(context).textTheme.labelSmall,
                                    ),
                                    icon: const Icon(Icons.download, size: 16.0),
                                    label: const Text('下载 Demo'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
                                child: FormatCard(
                                  name: 'CSV',
                                  description: 'text/csv',
                                  icon: Icons.table_chart,
                                  color: Colors.lightBlue,
                                  trailing: TextButton.icon(
                                    onPressed: () async {
                                      try {
                                        // CSV 解析器默认包含表头 key,value
                                        const csv = 'key,value\nhello,你好';
                                        await FileSaveUtil.saveTextFile(
                                          fileName: 'demo.csv',
                                          content: csv,
                                          mimeType: 'text/csv',
                                        );
                                      } catch (error, stackTrace) {
                                        log('下载 CSV Demo 失败',
                                            error: error, stackTrace: stackTrace, name: 'ProjectImportView');
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      textStyle: Theme.of(context).textTheme.labelSmall,
                                    ),
                                    icon: const Icon(Icons.download, size: 16.0),
                                    label: const Text('下载 Demo'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
                                child: FormatCard(
                                  name: 'Excel',
                                  description: 'application/vnd.ms-excel',
                                  icon: Icons.table_view,
                                  color: Colors.green,
                                  trailing: TextButton.icon(
                                    onPressed: () async {
                                      try {
                                        // 生成真正的 XLSX，第一行表头，第二行数据
                                        final book = excel.Excel.createExcel();
                                        final sheet = book[book.getDefaultSheet() ?? 'Sheet1'];
                                        sheet.appendRow(['key', 'value']);
                                        sheet.appendRow(['hello', '你好']);
                                        final bytes = book.encode();
                                        if (bytes != null) {
                                          await FileSaveUtil.saveBytesFile(
                                            fileName: 'demo.xlsx',
                                            bytes: bytes,
                                            mimeType:
                                                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                          );
                                        }
                                      } catch (error, stackTrace) {
                                        log('下载 Excel Demo 失败',
                                            error: error, stackTrace: stackTrace, name: 'ProjectImportView');
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      textStyle: Theme.of(context).textTheme.labelSmall,
                                    ),
                                    icon: const Icon(Icons.download, size: 16.0),
                                    label: const Text('下载 Demo'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
                                child: FormatCard(
                                  name: 'ARB',
                                  description: 'application/arb',
                                  icon: Icons.flutter_dash,
                                  color: Colors.purple,
                                  trailing: TextButton.icon(
                                    onPressed: () async {
                                      try {
                                        const arb = '{"@@locale":"zh","hello":"你好"}';
                                        await FileSaveUtil.saveTextFile(
                                          fileName: 'app_zh.arb',
                                          content: arb,
                                          mimeType: 'application/json',
                                        );
                                      } catch (error, stackTrace) {
                                        log('下载 ARB Demo 失败',
                                            error: error, stackTrace: stackTrace, name: 'ProjectImportView');
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      textStyle: Theme.of(context).textTheme.labelSmall,
                                    ),
                                    icon: const Icon(Icons.download, size: 16.0),
                                    label: const Text('下载 Demo'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
                                child: FormatCard(
                                  name: 'PO',
                                  description: 'application/x-po',
                                  icon: Icons.language,
                                  color: Colors.teal,
                                  trailing: TextButton.icon(
                                    onPressed: () async {
                                      try {
                                        const po = '# Translation file for zh_CN\nmsgid "hello"\nmsgstr "你好"\n';
                                        await FileSaveUtil.saveTextFile(
                                          fileName: 'zh_CN.po',
                                          content: po,
                                          mimeType: 'text/plain',
                                        );
                                      } catch (error, stackTrace) {
                                        log('下载 PO Demo 失败',
                                            error: error, stackTrace: stackTrace, name: 'ProjectImportView');
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      textStyle: Theme.of(context).textTheme.labelSmall,
                                    ),
                                    icon: const Icon(Icons.download, size: 16.0),
                                    label: const Text('下载 Demo'),
                                  ),
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
                      // 上传文件
                      UploadFile(
                        height: 200.0,
                        multiple: true,
                        title: '拖拽文件到此处或点击选择',
                        subtitle: '支持 JSON、CSV、Excel、ARB、PO 格式',
                        allowedExtensions: controller.allowedExtensions,
                        maxFileSize: 10 * 1024 * 1024, // 10MB
                        onFileSelected: (files) {
                          final newFiles = controller.files;
                          for (final newFile in files) {
                            final existingIndex = controller.files.indexWhere(
                              (existingFile) => existingFile.name == newFile.name,
                            );
                            // 文件已存在，覆盖
                            if (existingIndex != -1) {
                              newFiles[existingIndex] = newFile;
                            } else {
                              newFiles.add(newFile);
                            }
                          }
                          //
                          controller.setFiles(newFiles);
                        },
                      ),
                      Obx(() {
                        if (controller.files.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Builder(
                            builder: (context) {
                              // 组合默认语言 + 目标语言，并按 code 去重
                              final combinedLanguages = <Language>[
                                if (controller.project?.primaryLanguage != null) controller.project!.primaryLanguage,
                                ...(controller.project?.targetLanguages ?? []),
                              ];

                              final languages = {
                                for (final lang in combinedLanguages) lang.code: lang,
                              }.values.toList();

                              return UploadFileList(
                                files: controller.files,
                                languages: languages,
                                allowedExtensions: controller.allowedExtensions,
                                onDelete: (index) {
                                  controller.setFiles(
                                    List.from(controller.files)..removeAt(index),
                                  );
                                },
                                onClear: () {
                                  controller.setFiles([]);
                                },
                                onImport: (languageMap, translationMap) async {
                                  try {
                                    await controller.importFiles(languageMap, translationMap);

                                    // 获取导入的文件名（假设从languageMap中获取第一个文件的名字）
                                    final firstFile = controller.files.isNotEmpty ? controller.files.first : null;
                                    final filename = firstFile?.name ?? '导入文件';

                                    // 计算总记录数
                                    final totalRecords =
                                        translationMap.values.expand((translations) => translations.values).length;

                                    // 确定文件格式
                                    final format = firstFile?.name.split('.').last.toUpperCase() ?? 'UNKNOWN';

                                    // 生成描述
                                    final languageCount = languageMap.length;
                                    final languageText = languageCount == 1 ? '单语言' : '$languageCount 种语言';
                                    final description = '$languageText - $format格式 - $totalRecords 条记录';

                                    // 保存导入历史
                                    final historyItem = ImportHistoryItem(
                                      filename: filename,
                                      description: description,
                                      timestamp: DateTime.now(),
                                      success: true,
                                      format: format,
                                      recordCount: totalRecords,
                                    );

                                    await ImportHistoryCache.saveImportHistory(widget.projectId, historyItem);

                                    // 强制刷新UI
                                    setState(() {});
                                  } catch (e) {
                                    // 导入失败时保存失败记录
                                    final firstFile = controller.files.isNotEmpty ? controller.files.first : null;
                                    final filename = firstFile?.name ?? '导入失败';
                                    final format = firstFile?.name.split('.').last.toUpperCase() ?? 'UNKNOWN';

                                    final historyItem = ImportHistoryItem(
                                      filename: filename,
                                      description: '导入过程中发生错误 - $format格式',
                                      timestamp: DateTime.now(),
                                      success: false,
                                      format: format,
                                      recordCount: 0,
                                    );

                                    await ImportHistoryCache.saveImportHistory(widget.projectId, historyItem);
                                    setState(() {});
                                  }
                                },
                              );
                            },
                          ),
                        );
                      }),
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
                      Obx(() => _buildOptionItem(
                            context,
                            '覆盖现有翻译',
                            '如果词条已存在，是否覆盖现有翻译',
                            controller.overrideExisting,
                            controller.setOverrideExisting,
                          )),
                      Obx(() => _buildOptionItem(
                            context,
                            '自动审核',
                            '导入的翻译自动标记为已审核',
                            controller.autoReview,
                            controller.setAutoReview,
                          )),
                      Obx(() => _buildOptionItem(
                            context,
                            '忽略空值',
                            '跳过空的翻译内容',
                            controller.ignoreEmpty,
                            controller.setIgnoreEmpty,
                          )),
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
                      Row(
                        children: [
                          Text(
                            '导入历史',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          FutureBuilder<List<ImportHistoryItem>>(
                            future: ImportHistoryCache.getImportHistory(widget.projectId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                return TextButton.icon(
                                  onPressed: () async {
                                    final result = await Get.dialog<bool>(
                                      AlertDialog(
                                        title: const Text('确认清空'),
                                        content: const Text('确定要清空所有的导入历史记录吗？此操作不可撤销。'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(result: false),
                                            child: const Text('取消'),
                                          ),
                                          TextButton(
                                            onPressed: () => Get.back(result: true),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Theme.of(context).colorScheme.error,
                                            ),
                                            child: const Text('清空'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result == true) {
                                      await ImportHistoryCache.clearImportHistory(widget.projectId);
                                      setState(() {}); // 触发UI更新
                                    }
                                  },
                                  icon: const Icon(Icons.clear, size: 16.0),
                                  label: const Text('清空'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.error,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<ImportHistoryItem>>(
                        future: ImportHistoryCache.getImportHistory(widget.projectId),
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
                                      '暂无导入记录',
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
                                .map((item) => _buildImportHistoryItem(
                                      context,
                                      item.filename,
                                      item.description,
                                      _formatImportTime(item.timestamp),
                                      item.success,
                                      item: item,
                                    ))
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

  Widget _buildImportHistoryItem(
    BuildContext context,
    String filename,
    String description,
    String time,
    bool isSuccess, {
    ImportHistoryItem? item,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isSuccess
              ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isSuccess
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                  : Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              size: 20.0,
              color: isSuccess ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filename,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                    if (item != null && item.recordCount > 0) ...[
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          '${item.recordCount} 条',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
