import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

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

            if (project == null) return const Placeholder();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
