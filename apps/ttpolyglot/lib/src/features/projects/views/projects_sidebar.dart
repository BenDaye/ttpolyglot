import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/utils/layout_breakpoints.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目侧边栏
class ProjectsSidebar extends StatelessWidget {
  const ProjectsSidebar({super.key, this.delegate});

  final GetDelegate? delegate;

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.shouldShowPersistentSidebar(context)
        ? _buildPersistentSidebar(context, delegate: delegate)
        : _buildDrawerSidebar(context, delegate: delegate);
  }

  Widget _buildPersistentSidebar(BuildContext context, {GetDelegate? delegate}) {
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
          _buildAppHeader(
            context,
            isCompact: isCompact,
          ),

          // 导航菜单
          Expanded(
            child: _buildNavigationMenu(
              context,
              isCompact: isCompact,
              delegate: delegate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSidebar(
    BuildContext context, {
    GetDelegate? delegate,
  }) {
    return const Placeholder();
  }

  Widget _buildAppHeader(
    BuildContext context, {
    bool isCompact = false,
  }) {
    return GetBuilder<ProjectsController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        margin: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: SizedBox(
                height: 36.0,
                child: TextField(
                  onChanged: ProjectsController.searchProjectsWithService,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: '搜索项目...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.0),
              child: InkWell(
                onTap: () {
                  ProjectDialogController.showCreateDialog();
                },
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationMenu(
    BuildContext context, {
    bool isCompact = false,
    GetDelegate? delegate,
  }) {
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
          onRefresh: ProjectsController.refreshProjects,
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Obx(
                () => _buildProjectCard(
                  project,
                  context: context,
                  delegate: delegate,
                  onTap: (project) {
                    ProjectsController.setSelectedProjectId(project.id);
                  },
                  isSelected: controller.selectedProjectId == project.id,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildProjectCard(
    Project project, {
    required BuildContext context,
    GetDelegate? delegate,
    required Function(Project) onTap,
    bool isSelected = false,
  }) {
    final String projectId = project.id;
    return GetBuilder<ProjectController>(
        init: ProjectController(projectId: projectId),
        tag: projectId,
        builder: (controller) {
          return Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: ContinuousRectangleBorder(),
            color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : null,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              dense: true,
              selected: isSelected,
              leading: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Icon(Icons.folder, color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(
                controller.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              subtitle: Column(
                spacing: 2.0,
                children: [
                  Text(
                    controller.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.0,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.translate, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${controller.translationCount}', // 暂时硬编码，后续可以从统计信息获取
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.language, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${controller.languageCount}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () => onTap(controller.project!),
            ),
          );
        });
  }
}
