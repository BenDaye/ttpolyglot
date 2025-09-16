import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/features.dart';

enum ProjectSubPage {
  dashboard,
  translations,
  languages,
  members,
  import,
  export,
  settings,
  refresh,
}

/// 项目导航控制器
class ProjectNavigationController extends GetxController {
  final String projectId;
  ProjectNavigationController({required this.projectId});

  static ProjectNavigationController getInstance(String projectId) {
    return Get.isRegistered<ProjectNavigationController>(tag: projectId)
        ? Get.find<ProjectNavigationController>(tag: projectId)
        : Get.put(ProjectNavigationController(projectId: projectId), tag: projectId);
  }

  // 当前活跃的子页面
  final _currentSubPage = ProjectSubPage.dashboard.obs;

  // Getters
  ProjectSubPage get currentSubPage => _currentSubPage.value;

  final _isLoading = false.obs;

  // 导航项配置
  List<ProjectNavItem> get navItems {
    return [
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
        id: ProjectSubPage.refresh,
        label: '刷新',
        icon: Icons.refresh_outlined,
        activeIcon: Icons.refresh_rounded,
        tooltip: '刷新项目',
        isEnabled: !_isLoading.value,
      ),
      ProjectNavItem(
        id: ProjectSubPage.settings,
        label: '设置',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        tooltip: '项目设置',
      ),
    ];
  }

  /// 导航到子页面
  void navigateToSubPage(ProjectSubPage subPageId) {
    if (_currentSubPage.value == subPageId) return;

    if (subPageId == ProjectSubPage.refresh) {
      if (Get.isRegistered<ProjectController>(tag: projectId)) {
        Future.microtask(() async {
          _isLoading.value = true;

          await Future.wait([
            Get.find<ProjectController>(tag: projectId).refreshProject(),
            Future.delayed(const Duration(seconds: 3)),
          ]);

          _isLoading.value = false;
        });
      }
      return;
    }

    try {
      _currentSubPage.value = subPageId;
    } catch (error, stackTrace) {
      log('导航到项目子页面失败', error: error, stackTrace: stackTrace, name: 'ProjectNavigationController');
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
      default:
        return const SizedBox.shrink();
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
  final bool isEnabled;

  const ProjectNavItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.tooltip,
    this.color,
    this.isEnabled = true,
  });
}
