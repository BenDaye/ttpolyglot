import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/widgets/stat_card.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目概览页面
class ProjectDashboardView extends StatelessWidget {
  const ProjectDashboardView({super.key, required this.projectId});
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
                  // 项目统计卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.analytics, size: 24.0),
                              const SizedBox(width: 8.0),
                              Text(
                                '项目统计',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          FutureBuilder<ProjectStats>(
                            future: controller.getProjectStats(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              final stats = snapshot.data ??
                                  ProjectStats(
                                    totalEntries: 0,
                                    completedEntries: 0,
                                    pendingEntries: 0,
                                    reviewingEntries: 0,
                                    completionRate: 0.0,
                                    languageCount: project.allLanguages.length,
                                    memberCount: 1,
                                    lastUpdated: DateTime.now(),
                                  );

                              return Column(
                                children: [
                                  // 翻译统计
                                  Row(
                                    children: [
                                      Expanded(
                                        child: StatCard(
                                          title: '总词条',
                                          value: stats.totalEntries.toString(),
                                          icon: Icons.text_fields,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: StatCard(
                                          title: '已翻译',
                                          value: stats.completedEntries.toString(),
                                          icon: Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: StatCard(
                                          title: '待翻译',
                                          value: stats.pendingEntries.toString(),
                                          icon: Icons.pending,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: StatCard(
                                          title: '审核中',
                                          value: stats.reviewingEntries.toString(),
                                          icon: Icons.rate_review,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  // 语言和成员统计
                                  Row(
                                    children: [
                                      Expanded(
                                        child: StatCard(
                                          title: '总语言数',
                                          value: stats.languageCount.toString(),
                                          icon: Icons.language,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: StatCard(
                                          title: '目标语言',
                                          value: project.targetLanguages.length.toString(),
                                          icon: Icons.translate,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: StatCard(
                                          title: '团队成员',
                                          value: stats.memberCount.toString(),
                                          icon: Icons.people,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: StatCard(
                                          title: '完成率',
                                          value: '${(stats.completionRate * 100).toStringAsFixed(1)}%',
                                          icon: Icons.trending_up,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ],
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

                  // 项目基本信息卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, size: 24.0),
                              const SizedBox(width: 8.0),
                              Text(
                                '项目信息',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          _buildInfoRow('项目名称', project.name),
                          _buildInfoRow('项目描述', project.description),
                          _buildInfoRow('项目ID', project.id),
                          _buildInfoRow('项目状态', project.isActive ? '激活' : '停用'),
                          _buildInfoRow('创建时间', _formatDateTime(project.createdAt)),
                          _buildInfoRow('更新时间', _formatDateTime(project.updatedAt)),
                          if (project.lastAccessedAt != null)
                            _buildInfoRow('最后访问', _formatDateTime(project.lastAccessedAt!)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 语言配置卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.language, size: 24.0),
                              const SizedBox(width: 8.0),
                              Text(
                                '语言配置',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          _buildLanguageInfo('默认语言', project.defaultLanguage),
                          const SizedBox(height: 8.0),
                          Text(
                            '目标语言:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8.0),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: project.targetLanguages.map<Widget>((lang) => _buildLanguageChip(lang)).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 项目所有者信息卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, size: 24.0),
                              const SizedBox(width: 8.0),
                              Text(
                                '项目所有者',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          _buildInfoRow('姓名', project.owner.name),
                          _buildInfoRow('邮箱', project.owner.email),
                          _buildInfoRow('角色', project.owner.role.toString().split('.').last),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.0,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageInfo(String label, dynamic language) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.0,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${language.nativeName} (${language.code})',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(dynamic language) {
    return Chip(
      label: Text('${language.nativeName} (${language.code})'),
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
      side: BorderSide(color: Colors.blue.withValues(alpha: 0.3)),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
