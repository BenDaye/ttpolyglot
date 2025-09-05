import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';

class ProjectController extends GetxController {
  final String projectId;
  ProjectController({required this.projectId});

  static ProjectController getInstance(String projectId) {
    return Get.isRegistered<ProjectController>(tag: projectId)
        ? Get.find<ProjectController>(tag: projectId)
        : Get.put(ProjectController(projectId: projectId), tag: projectId);
  }

  final TextEditingController _deleteProjectNameTextController = TextEditingController();

  // 响应式项目对象
  final _project = Rxn<Project>();
  final _isLoading = false.obs;

  // Getters
  Project? get project => _project.value;
  Rxn<Project> get projectObs => _project;
  bool get isLoading => _isLoading.value;

  String get title => _project.value?.name ?? '-';
  String get description => _project.value?.description ?? '-';
  int get languageCount => _project.value?.allLanguages.length ?? 0;
  int get translationCount => 0;

  @override
  void onReady() {
    super.onReady();
    log('ProjectController onReady: $projectId', name: 'ProjectController');
    loadProject();
  }

  @override
  void onClose() {
    _deleteProjectNameTextController.dispose();
    super.onClose();
  }

  /// 加载项目详情
  Future<void> loadProject() async {
    if (projectId.isEmpty) {
      Get.snackbar('错误', '项目ID不能为空');
      return;
    }

    _isLoading.value = true;

    try {
      final project = await ProjectsController.getProject(projectId);
      if (project != null) {
        _project.value = project;
        // 更新项目最后访问时间
        await ProjectsController.updateProjectLastAccessed(projectId);
        return;
      }

      Get.snackbar('错误', '项目不存在: $projectId');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '加载项目失败: $error');
      log('加载项目失败', error: error, stackTrace: stackTrace, name: 'ProjectController');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 刷新项目详情
  Future<void> refreshProject() async {
    await loadProject();
  }

  /// 获取项目统计信息
  Future<ProjectStats> getProjectStats() async {
    try {
      return await ProjectsController.getProjectStats(projectId);
    } catch (error, stackTrace) {
      log('获取项目统计失败', error: error, stackTrace: stackTrace, name: 'ProjectController');
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

  Future<void> deleteProject() async {
    final result = await Get.dialog(
      AlertDialog(
        title: const Text('删除项目'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            const Text('确定要删除这个项目吗？'),
            TextField(
              controller: _deleteProjectNameTextController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 14.0),
              decoration: InputDecoration(
                hintText: '${_project.value?.name}',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (_deleteProjectNameTextController.text == _project.value?.name) {
                Get.back(result: true);
              } else {
                Get.snackbar('错误', '项目名称不正确');
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    _deleteProjectNameTextController.clear();

    if (result == true) {
      await ProjectsController.deleteProject(projectId);
      Get.back(closeOverlays: true);
    }
  }

  Future<void> editProject() async {
    if (_project.value == null) return;
    await ProjectDialogController.showEditDialog(_project.value!);
    await refreshProject();
  }

  Future<void> removeTargetLanguage(Language language) async {
    if (_project.value == null) return;

    final result = await Get.dialog(
      AlertDialog(
        title: const Text('删除目标语言'),
        content: const Text('确定要删除这个目标语言吗？'),
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
      final newTargetLanguages = _project.value!.targetLanguages.where((lang) => lang.code != language.code).toList();
      await ProjectsController.updateProject(projectId, targetLanguages: newTargetLanguages);
    }
  }
}
