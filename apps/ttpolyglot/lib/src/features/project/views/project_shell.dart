import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/utils/layout_breakpoints.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

/// 项目外壳视图 - 包含悬浮导航和子页面
class ProjectShell extends StatefulWidget {
  const ProjectShell({super.key});

  @override
  State<ProjectShell> createState() => _ProjectShellState();
}

class _ProjectShellState extends State<ProjectShell> {
  final projectId = Get.parameters['projectId'] ?? '';

  @override
  Widget build(BuildContext context) {
    final isCompact = ResponsiveUtils.shouldShowDrawer(context);

    return GetBuilder<ProjectController>(
      tag: projectId,
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              // 主内容区域
              Obx(
                () {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final project = controller.project;
                  if (project == null) {
                    return const Center(
                      child: Text('项目不存在'),
                    );
                  }

                  // 根据当前子页面显示不同内容
                  return GetBuilder<ProjectNavigationController>(
                    tag: projectId,
                    builder: (navController) {
                      return Obx(() => navController.subPage);
                    },
                  );
                },
              ),

              // 悬浮导航
              if (!isCompact)
                ProjectFloatingNavigation(projectId: projectId)
              else
                ProjectFloatingNavigationHorizontal(projectId: projectId),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    final projectId = Get.parameters['projectId'] ?? '';
    if (projectId.isNotEmpty && Get.isRegistered<ProjectNavigationController>(tag: projectId)) {
      Get.delete<ProjectNavigationController>(tag: projectId);
    }
    super.dispose();
  }
}
