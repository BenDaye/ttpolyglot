import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/core/widgets/clickable_stat_card.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

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
                          Row(
                            children: [
                              Expanded(
                                child: ClickableStatCard(
                                  title: 'JSON',
                                  subtitle: '适合开发使用',
                                  icon: Icons.code,
                                  color: Colors.blue,
                                  onTap: () {
                                    ProjectExportController.getInstance(projectId).exportTranslationsJson();
                                  },
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: ClickableStatCard(
                                  title: 'CSV',
                                  subtitle: '适合批量编辑',
                                  icon: Icons.table_chart,
                                  color: Colors.green,
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: ClickableStatCard(
                                  title: 'Excel',
                                  subtitle: '适合数据分析',
                                  icon: Icons.table_view,
                                  color: Colors.orange,
                                  onTap: () {},
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
                  GetBuilder<ProjectExportController>(
                      init: ProjectExportController.getInstance(projectId),
                      tag: projectId,
                      builder: (controller) {
                        return Card(
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

                                // 格式选择
                                Text(
                                  '选择格式',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8.0),
                                Obx(
                                  () => Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: FileFormats.allFormats
                                        .map(
                                          (format) => FilterChip(
                                            showCheckmark: false,
                                            selected: controller.exportFormat == format,
                                            label: Text(
                                              '${FileFormats.getDisplayName(format)} (${FileFormats.getFileExtension(format)})',
                                            ),
                                            onSelected: (selected) {
                                              if (selected) {
                                                controller.exportFormat = format;
                                              }
                                            },
                                            selectedColor:
                                                Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),

                                const SizedBox(height: 16.0),

                                // 语言选择
                                Text(
                                  '选择语言',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8.0),
                                Obx(
                                  () => Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: controller.supportedLanguages
                                        .map(
                                          (lang) => _buildLanguageChip(
                                            context,
                                            language: lang,
                                            isDefault: controller.isDefaultLanguage(lang),
                                            isSelected: controller.isActiveLanguage(lang),
                                            onTap: controller.toggleLanguage,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),

                                const SizedBox(height: 16.0),

                                // 导出选项
                                Text(
                                  '导出选项',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8.0),
                                ...[
                                  Obx(
                                    () => _buildExportOption(
                                      context,
                                      title: '嵌套键值风格',
                                      subtitle:
                                          '当开启时, 导出文件将使用嵌套键值风格 ({ "auth": { "login": "登录" } }), 否则使用扁平风格. 例如: { "auth.login": "登录" }',
                                      value: controller.exportKeyStyle == TranslationKeyStyle.nested,
                                      onChanged: (value) {
                                        if (value) {
                                          controller.exportKeyStyle = TranslationKeyStyle.nested;
                                        } else {
                                          controller.exportKeyStyle = TranslationKeyStyle.flat;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Obx(
                                    () => _buildExportOption(
                                      context,
                                      title: '创建语言文件夹',
                                      subtitle:
                                          '当开启时, 使用语言名称作为文件夹名 (en-US/translations.json), 否则导出文件将使用语言代码作为文件名 (en-US.json).',
                                      value: controller.useLanguageCodeAsFolderName,
                                      onChanged: (value) {
                                        controller.useLanguageCodeAsFolderName = value;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Obx(
                                    () => _buildExportOption(
                                      context,
                                      title: '创建 namespace 文件夹',
                                      subtitle:
                                          '当开启时, 使用语言名称作为文件夹名 (en-US/auth.json), 否则导出文件将使用语言代码作为文件名 (en-US.json).',
                                      value: controller.separateFirstLevelKeyIntoFiles,
                                      onChanged: (value) {
                                        controller.separateFirstLevelKeyIntoFiles = value;
                                      },
                                      isDisabled: !controller.useLanguageCodeAsFolderName,
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 16.0),

                                // 导出按钮
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: controller.submitForm,
                                    icon: const Icon(Icons.download),
                                    label: const Text('开始导出'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

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
    BuildContext context, {
    required Language language,
    required bool isDefault,
    required void Function(Language) onTap,
    required bool isSelected,
  }) {
    return FilterChip(
      showCheckmark: false,
      selected: isSelected,
      label: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                language.code,
                style: GoogleFonts.notoSansMono(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Text(language.nativeName),
        ],
      ),
      onSelected: (selected) {
        onTap(language);
      },
      selectedColor: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
    );
  }

  Widget _buildExportOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isDisabled = false,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      isThreeLine: true,
      value: value,
      onChanged: isDisabled ? null : onChanged,
      dense: true,
    );
  }
}
