import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project_controller.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: Get.parameters['projectId'],
      builder: (controller) {
        return Center(
          child: Text('ProjectView: ${controller.projectId}'),
        );
      },
    );
  }
}
