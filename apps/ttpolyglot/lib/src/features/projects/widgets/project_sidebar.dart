import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/utils/layout_breakpoints.dart';
import 'package:ttpolyglot/src/core/routing/app_router.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';

class ProjectSidebar extends StatelessWidget {
  const ProjectSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.shouldShowPersistentSidebar(context)
        ? _buildPersistentSidebar(context)
        : _buildDrawerSidebar(context);
  }

  Widget _buildPersistentSidebar(BuildContext context) {
    final isCompact = ResponsiveUtils.shouldShowCompactSidebar(context);
    final width = ResponsiveUtils.getSidebarWidth(context);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          // 应用头部
          _buildAppHeader(context, isCompact),

          // 导航菜单
          Expanded(
            child: _buildNavigationMenu(context, isCompact),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSidebar(BuildContext context) {
    return const Placeholder();
  }

  Widget _buildAppHeader(BuildContext context, bool isCompact) {
    return GetBuilder<ProjectsController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: controller.searchProjects,
          decoration: const InputDecoration(
            hintText: '搜索项目...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationMenu(BuildContext context, bool isCompact) {
    return GetBuilder<ProjectsController>(
      builder: (controller) => Obx(() {
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
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProjects,
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return _buildProjectCard(project, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildProjectCard(ProjectModel project, ProjectsController controller) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: ContinuousRectangleBorder(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        dense: true,
        leading: const CircleAvatar(
          child: Icon(Icons.folder),
        ),
        title: Text(
          '${project.name} - ${project.description}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        subtitle: Column(
          spacing: 2.0,
          children: [
            Row(
              children: [
                Icon(Icons.translate, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${project.translationCount} 条翻译',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.language, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${project.languages.length} 种语言',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          final name = ProjectsRoute.dashboard.fullPath.replaceFirst(':projectId', project.id);
          log(name);
          Get.rootDelegate.offAndToNamed(name);
        },
      ),
    );
  }
}
