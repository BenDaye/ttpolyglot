import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/layout/layout_controller.dart';
import '../../core/routing/app_router.dart';
import 'projects_controller.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<LayoutController>();
      controller.updateLayoutForRoute(AppRouter.projects);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ProjectsPageContent();
  }
}

/// 导出的项目页面内容组件，用于嵌套路由
class ProjectsPageContent extends StatelessWidget {
  const ProjectsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProjectsPageContent();
  }
}

class _ProjectsPageContent extends StatelessWidget {
  const _ProjectsPageContent();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectsController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProjectDialog(controller),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.searchProjects,
              decoration: const InputDecoration(
                hintText: '搜索项目...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // 项目列表
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final projects = controller.filteredProjects;

              if (projects.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.folder_open, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        controller.searchQuery.isEmpty ? '暂无项目' : '未找到匹配的项目',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      if (controller.searchQuery.isEmpty)
                        ElevatedButton.icon(
                          onPressed: () => _showCreateProjectDialog(controller),
                          icon: const Icon(Icons.add),
                          label: const Text('创建项目'),
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshProjects,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return _buildProjectCard(project, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project, ProjectsController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.folder),
        ),
        title: Text(
          project.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.translate, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${project.translationCount} 条翻译',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 12),
                Icon(Icons.language, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${project.languages.length} 种语言',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '更新于 ${DateFormat('yyyy-MM-dd HH:mm').format(project.updatedAt)}',
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmDialog(project, controller);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('编辑'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('删除', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: () {
          Get.snackbar('提示', '项目详情页面即将推出');
        },
      ),
    );
  }

  void _showCreateProjectDialog(ProjectsController controller) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('创建项目'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '项目名称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: '项目描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                controller.createProject(
                  nameController.text.trim(),
                  descriptionController.text.trim(),
                );
                Get.back();
              } else {
                Get.snackbar('错误', '请输入项目名称');
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(ProjectModel project, ProjectsController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除项目 "${project.name}" 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteProject(project.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
