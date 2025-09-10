import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/widgets/format_card.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/project/widgets/upload_file.dart';
import 'package:ttpolyglot/src/features/project/widgets/upload_file_list.dart';

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
                          child: UploadFileList(
                            files: controller.files,
                            languages: controller.project?.targetLanguages ?? [],
                            allowedExtensions: controller.allowedExtensions,
                            onDelete: (index) {
                              controller.setFiles(
                                List.from(controller.files)..removeAt(index),
                              );
                            },
                            onClear: () {
                              controller.setFiles([]);
                            },
                            onImport: (languageMap, translationMap) {
                              controller.importFiles(languageMap, translationMap);
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
                      Text(
                        '导入历史',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      Obx(() {
                        if (controller.importRecords.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              '暂无导入记录',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: controller.importRecords
                              .map((record) => _buildHistoryItem(
                                    context,
                                    record.fileName,
                                    record.message,
                                    record.formattedTime,
                                    record.status == ImportRecordStatus.success,
                                    record: record,
                                  ))
                              .toList(),
                        );
                      }),
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
    bool isSuccess, {
    ImportRecord? record,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          _buildStatusIcon(context, record),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fileName,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (record?.language != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          record!.language!.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  result,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _getStatusColor(context, record),
                      ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                    ),
                    if (record?.formattedDuration != null) ...[
                      const SizedBox(width: 8.0),
                      Icon(
                        Icons.schedule,
                        size: 12.0,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 2.0),
                      Text(
                        record!.formattedDuration!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ],
                ),
                if (record != null && record.totalCount > 0) ...[
                  const SizedBox(height: 6.0),
                  _buildProgressIndicator(context, record),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建状态图标
  Widget _buildStatusIcon(BuildContext context, ImportRecord? record) {
    if (record == null) {
      return const Icon(Icons.help_outline, size: 24.0);
    }

    IconData iconData;
    Color color;

    switch (record.status) {
      case ImportRecordStatus.success:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case ImportRecordStatus.failure:
        iconData = Icons.error;
        color = Colors.red;
        break;
      case ImportRecordStatus.partial:
        iconData = Icons.warning;
        color = Colors.orange;
        break;
    }

    return Icon(iconData, color: color, size: 24.0);
  }

  /// 获取状态颜色
  Color _getStatusColor(BuildContext context, ImportRecord? record) {
    if (record == null) {
      return Theme.of(context).colorScheme.onSurface;
    }

    switch (record.status) {
      case ImportRecordStatus.success:
        return Colors.green;
      case ImportRecordStatus.failure:
        return Colors.red;
      case ImportRecordStatus.partial:
        return Colors.orange;
    }
  }

  /// 构建进度指示器
  Widget _buildProgressIndicator(BuildContext context, ImportRecord record) {
    final successRate = record.successRate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '成功率: ${(successRate * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
            ),
            const Spacer(),
            Text(
              '${record.importedCount}/${record.totalCount}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Container(
          height: 4.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: FractionallySizedBox(
            widthFactor: successRate,
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              decoration: BoxDecoration(
                color: _getStatusColor(context, record),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
