import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';

class ProjectShell extends StatelessWidget {
  const ProjectShell({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectsController>(
      builder: (controller) {
        return GetRouterOutlet(
          initialRoute: Routes.projectDashboard(controller.selectedProjectId),
          anchorRoute: Routes.project(controller.selectedProjectId),
        );
      }
    );
  }
}