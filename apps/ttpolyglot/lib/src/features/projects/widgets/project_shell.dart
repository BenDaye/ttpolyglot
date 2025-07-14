import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout.dart';
import 'package:ttpolyglot/src/core/routing/app_router.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';

class ProjectShell extends StatefulWidget {
  const ProjectShell({super.key});

  @override
  State<ProjectShell> createState() => _ProjectShellState();
}

class _ProjectShellState extends State<ProjectShell> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<LayoutController>()) {
        final controller = Get.find<LayoutController>();
        controller.updateLayoutForRoute(MainRoute.projects.fullPath);
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
        const ProjectSidebar(),
        Expanded(
          child: GetRouterOutlet(
            initialRoute: ProjectsRoute.empty.fullPath,
            delegate: Get.rootDelegate,
          ),
        ),
      ],
    );
  }
}
