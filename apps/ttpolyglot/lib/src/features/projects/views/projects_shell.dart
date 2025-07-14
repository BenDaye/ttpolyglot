import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';

class ProjectsShell extends StatefulWidget {
  const ProjectsShell({super.key});

  @override
  State<ProjectsShell> createState() => _ProjectsShellState();
}

class _ProjectsShellState extends State<ProjectsShell> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<LayoutController>()) {
        final controller = Get.find<LayoutController>();
        controller.updateLayoutForRoute(Routes.projects);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldShowPersistentSidebar = ResponsiveUtils.shouldShowPersistentSidebar(context);

        if (shouldShowPersistentSidebar) {
          return _buildDesktopLayout(context);
        } else {
          // TODO: 移动端布局
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        const ProjectsSidebar(),
        Expanded(
          child: GetBuilder<ProjectsController>(
            builder: (controller) => Obx(
              () {
                if (controller.selectedProjectId.isEmpty) {
                  return Container(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                    child: Center(
                      child: Text('No project selected'),
                    ),
                  );
                }

                return GetRouterOutlet(
                  initialRoute: Routes.project(controller.selectedProjectId),
                  anchorRoute: Routes.projects,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
