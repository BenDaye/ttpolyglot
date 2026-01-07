import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/utils/layout_breakpoints.dart';
import 'package:ttpolyglot/src/features/features.dart';

/// 项目外壳视图 - 包含悬浮导航和子页面
class ProjectShell extends StatefulWidget {
  const ProjectShell({super.key});

  @override
  State<ProjectShell> createState() => _ProjectShellState();
}

class _ProjectShellState extends State<ProjectShell> {
  final projectId = int.tryParse(Get.parameters['projectId'] ?? '0') ?? 0;

  @override
  Widget build(BuildContext context) {
    final isCompact = ResponsiveUtils.shouldShowDrawer(context);

    return GetBuilder<ProjectController>(
      init: ProjectController.getInstance(projectId),
      tag: projectId.toString(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              // 主内容区域
              Obx(
                () {
                  if (controller.isLoading && controller.project == null) {
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
                    init: ProjectNavigationController.getInstance(projectId),
                    tag: projectId.toString(),
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
    final projectId = int.tryParse(Get.parameters['projectId'] ?? '0') ?? 0;
    if (projectId != 0 && Get.isRegistered<ProjectNavigationController>(tag: projectId.toString())) {
      Get.delete<ProjectNavigationController>(tag: projectId.toString());
    }
    super.dispose();
  }
}
