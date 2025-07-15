import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_controller.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: Get.parameters['projectId'],
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Obx(
              () => ListTile(
                title: Text(
                  controller.project?.name ?? 'ProjectView: ${controller.projectId}',
                ),
                subtitle: Text(
                  controller.project?.description ?? '',
                ),
              ),
            ),
            toolbarHeight: 64.0,
            actions: [
              Obx(
                () => controller.project != null
                    ? Row(
                        spacing: 8.0,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => controller.editProject(),
                            tooltip: '编辑项目',
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: controller.refreshProject,
                            tooltip: '刷新项目',
                          ),
                          PopupMenuButton(
                            offset: const Offset(0, 48.0),
                            menuPadding: EdgeInsets.zero,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                padding: EdgeInsets.zero,
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                  onTap: () => controller.deleteProject(),
                                  title: Text('删除项目'),
                                  leading: const Icon(Icons.delete),
                                ),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 16.0),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.error.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64.0,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      controller.error,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: controller.refreshProject,
                      child: const Text('重试'),
                    ),
                  ],
                ),
              );
            }

            final project = controller.project;
            if (project == null) {
              return const Center(
                child: Text('项目不存在'),
              );
            }

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
                            children: project.targetLanguages.map((lang) => _buildLanguageChip(lang)).toList(),
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
                ],
              ),
            );
          }),
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
