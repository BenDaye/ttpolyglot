import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

enum ProjectSubPage {
  dashboard,
  translations,
  languages,
  members,
  settings,
  import,
  export,
}

/// 项目导航控制器
class ProjectNavigationController extends GetxController {
  late final String projectId;

  // 当前活跃的子页面
  final _currentSubPage = ProjectSubPage.dashboard.obs;

  // Getters
  ProjectSubPage get currentSubPage => _currentSubPage.value;

  // 导航项配置
  List<ProjectNavItem> get navItems => [
        ProjectNavItem(
          id: ProjectSubPage.dashboard,
          label: '概览',
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard_rounded,
          tooltip: '项目概览',
        ),
        ProjectNavItem(
          id: ProjectSubPage.translations,
          label: '翻译',
          icon: Icons.translate_outlined,
          activeIcon: Icons.translate_rounded,
          tooltip: '翻译管理',
        ),
        ProjectNavItem(
          id: ProjectSubPage.languages,
          label: '语言',
          icon: Icons.language_outlined,
          activeIcon: Icons.language_rounded,
          tooltip: '语言设置',
        ),
        ProjectNavItem(
          id: ProjectSubPage.members,
          label: '成员',
          icon: Icons.people_outline,
          activeIcon: Icons.people_rounded,
          tooltip: '成员管理',
        ),
        ProjectNavItem(
          id: ProjectSubPage.import,
          label: '导入',
          icon: Icons.file_download_outlined,
          activeIcon: Icons.file_download_rounded,
          tooltip: '导入翻译',
        ),
        ProjectNavItem(
          id: ProjectSubPage.export,
          label: '导出',
          icon: Icons.file_upload_outlined,
          activeIcon: Icons.file_upload_rounded,
          tooltip: '导出翻译',
        ),
        ProjectNavItem(
          id: ProjectSubPage.settings,
          label: '设置',
          icon: Icons.settings_outlined,
          activeIcon: Icons.settings_rounded,
          tooltip: '项目设置',
        ),
      ];

  @override
  void onInit() {
    super.onInit();
    projectId = Get.parameters['projectId'] ?? '';
  }

  /// 导航到子页面
  void navigateToSubPage(ProjectSubPage subPageId) {
    if (_currentSubPage.value == subPageId) return;

    try {
      _currentSubPage.value = subPageId;
    } catch (error, stackTrace) {
      log('导航到项目子页面失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 检查是否为当前活跃页面
  bool isCurrentPage(ProjectSubPage subPageId) {
    return _currentSubPage.value == subPageId;
  }

  /// 根据子页面ID构建对应的页面内容
  Widget get subPage {
    switch (currentSubPage) {
      case ProjectSubPage.dashboard:
        return ProjectDashboardView(projectId: projectId);
      case ProjectSubPage.translations:
        return ProjectTranslationsView(projectId: projectId);
      case ProjectSubPage.languages:
        return ProjectLanguagesView(projectId: projectId);
      case ProjectSubPage.members:
        return ProjectMembersView(projectId: projectId);
      case ProjectSubPage.settings:
        return ProjectSettingsView(projectId: projectId);
      case ProjectSubPage.import:
        return ProjectImportView(projectId: projectId);
      case ProjectSubPage.export:
        return ProjectExportView(projectId: projectId);
    }
  }
}

/// 项目导航项配置
class ProjectNavItem {
  final ProjectSubPage id;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String tooltip;
  final Color? color;

  const ProjectNavItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.tooltip,
    this.color,
  });
}
