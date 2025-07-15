import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/widgets/stat_card.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

/// 项目翻译管理页面
class ProjectTranslationsView extends StatelessWidget {
  const ProjectTranslationsView({super.key, required this.projectId});
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
                  // 翻译统计卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '翻译统计',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  title: '总词条',
                                  value: '1,234',
                                  icon: Icons.text_fields,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: StatCard(
                                  title: '已翻译',
                                  value: '856',
                                  icon: Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: StatCard(
                                  title: '待翻译',
                                  value: '378',
                                  icon: Icons.pending,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 翻译进度卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '翻译进度',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          ...project.targetLanguages.map((lang) => _buildLanguageProgress(
                                context,
                                lang,
                                0.7, // 模拟进度
                              )),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 最近翻译活动
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '最近活动',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          _buildActivityItem(
                            context,
                            '用户A 翻译了 "welcome_message"',
                            '2 小时前',
                            Icons.translate,
                          ),
                          _buildActivityItem(
                            context,
                            '用户B 审核了 "login_button"',
                            '4 小时前',
                            Icons.check,
                          ),
                          _buildActivityItem(
                            context,
                            '用户C 添加了新词条 "error_message"',
                            '1 天前',
                            Icons.add,
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

  Widget _buildLanguageProgress(
    BuildContext context,
    dynamic language,
    double progress,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${language.nativeName} (${language.code})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String time,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              size: 16.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 2.0),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
