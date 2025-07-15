import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_dialog_controller.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';
import 'package:ttpolyglot/src/features/projects/services/project_service_impl.dart';
import 'package:ttpolyglot_core/core.dart';

class ProjectController extends GetxController {
  late final String projectId;
  late final ProjectServiceImpl _projectService;

  // 响应式项目对象
  final _project = Rxn<Project>();
  final _isLoading = false.obs;
  final _error = ''.obs;

  // Getters
  Project? get project => _project.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    projectId = Get.parameters['projectId'] ?? '';
    _initializeService();
  }

  @override
  void onReady() {
    super.onReady();
    log('ProjectController onReady: $projectId');
  }

  /// 初始化项目服务
  Future<void> _initializeService() async {
    try {
      _projectService = await ProjectServiceImpl.create();
      await loadProject();
    } catch (error, stackTrace) {
      _error.value = '初始化项目服务失败: $error';
      log('初始化项目服务失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 加载项目详情
  Future<void> loadProject() async {
    if (projectId.isEmpty) {
      _error.value = '项目ID不能为空';
      return;
    }

    _isLoading.value = true;
    _error.value = '';

    try {
      final project = await _projectService.getProject(projectId);
      if (project != null) {
        _project.value = project;
        // 更新项目最后访问时间
        await _projectService.updateProjectLastAccessed(projectId, 'default-user');
        return;
      }

      _error.value = '项目不存在: $projectId';
    } catch (error, stackTrace) {
      _error.value = '加载项目失败: $error';
      log('加载项目失败', error: error, stackTrace: stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 刷新项目详情
  Future<void> refreshProject() async {
    await loadProject();
  }

  /// 更新项目信息
  Future<void> updateProject({
    String? name,
    String? description,
    Language? defaultLanguage,
    List<Language>? targetLanguages,
    bool? isActive,
  }) async {
    if (_project.value == null) return;

    try {
      final request = UpdateProjectRequest(
        name: name,
        description: description,
        defaultLanguage: defaultLanguage,
        targetLanguages: targetLanguages,
        isActive: isActive,
      );

      final updatedProject = await _projectService.updateProject(projectId, request);
      _project.value = updatedProject;

      Get.snackbar('成功', '项目更新成功');
    } catch (error, stackTrace) {
      _error.value = '更新项目失败: $error';
      Get.snackbar('错误', _error.value);
      log('更新项目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 获取项目统计信息
  Future<ProjectStats> getProjectStats() async {
    try {
      return await _projectService.getProjectStats(projectId);
    } catch (error, stackTrace) {
      log('获取项目统计失败', error: error, stackTrace: stackTrace);
      return ProjectStats(
        totalEntries: 0,
        completedEntries: 0,
        pendingEntries: 0,
        reviewingEntries: 0,
        completionRate: 0.0,
        languageCount: 0,
        memberCount: 1,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// 检查项目是否存在
  Future<bool> projectExists() async {
    try {
      return await _projectService.projectExists(projectId);
    } catch (error, stackTrace) {
      log('检查项目存在性失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  Future<void> deleteProject() async {
    final result = await Get.dialog(
      AlertDialog(
        title: const Text('删除项目'),
        content: const Text('确定要删除这个项目吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('确定'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (result == true) {
      await _projectService.deleteProject(projectId);

      if (Get.isRegistered<ProjectsController>()) {
        final controller = Get.find<ProjectsController>();
        controller.setSelectedProjectId(null);
        controller.loadProjects();
      }

      Get.back(closeOverlays: true);
    }
  }

  Future<void> editProject() async {
    if (_project.value == null) return;
    await ProjectDialogController.showEditDialog(_project.value!);
    await loadProject();
  }
}
