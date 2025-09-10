import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/conflict_detection_service.dart';
import 'package:ttpolyglot/src/core/services/translation_service_impl.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';
import 'package:ttpolyglot_core/core.dart';

class ProjectController extends GetxController {
  late final String projectId;

  final TextEditingController _deleteProjectNameTextController = TextEditingController();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();

  // 响应式项目对象
  final _project = Rxn<Project>();
  final _isLoading = false.obs;

  // Getters
  Project? get project => _project.value;
  Rxn<Project> get projectObs => _project;
  bool get isLoading => _isLoading.value;

  // Files
  final RxList<PlatformFile> _files = <PlatformFile>[].obs;
  List<PlatformFile> get files => _files.toList();
  void setFiles(List<PlatformFile> files) => _files.assignAll(files);

  // 允许的文件扩展名
  List<String> get allowedExtensions => ['json', 'csv', 'xlsx', 'xls', 'arb', 'po'];

  @override
  void onInit() {
    super.onInit();
    projectId = Get.parameters['projectId'] ?? '';
  }

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

  Future<void> importFiles(Map<String, Language> languageMap, Map<String, Map<String, String>> translationMap) async {
    try {
      log('开始批量导入翻译文件', name: 'ProjectController');

      final allImportedEntries = <TranslationEntry>[];
      final allConflicts = <TranslationConflict>[];
      int totalSkipped = 0;

      // 获取现有翻译条目用于冲突检测
      final existingEntries = await _translationService.getTranslationEntries(projectId);

      // 处理每个文件的翻译
      for (final fileEntry in translationMap.entries) {
        final fileName = fileEntry.key;
        final translations = fileEntry.value;
        final selectedLanguage = languageMap[fileName];

        if (selectedLanguage == null) {
          log('跳过文件 $fileName：未选择语言', name: 'ProjectController');
          totalSkipped += translations.length;
          continue;
        }

        log('处理文件 $fileName，语言: ${selectedLanguage.code}，条目数: ${translations.length}', name: 'ProjectController');

        // 将翻译键值对转换为 TranslationEntry
        final importedEntries = <TranslationEntry>[];
        for (final translation in translations.entries) {
          final key = translation.key;
          final value = translation.value;

          if (key.trim().isEmpty) {
            log('跳过空键', name: 'ProjectController');
            totalSkipped++;
            continue;
          }

          // 创建翻译条目
          final entry = TranslationEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() +
                (DateTime.now().microsecond % 1000).toString().padLeft(3, '0'),
            projectId: projectId,
            key: key.trim(),
            sourceLanguage: selectedLanguage.code == _project.value!.defaultLanguage.code
                ? selectedLanguage
                : _project.value!.defaultLanguage,
            targetLanguage: selectedLanguage,
            sourceText:
                selectedLanguage.code == _project.value!.defaultLanguage.code ? value : key, // 如果不是默认语言，使用键作为源文本
            targetText: value,
            status: value.trim().isEmpty ? TranslationStatus.pending : TranslationStatus.completed,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          importedEntries.add(entry);
        }

        if (importedEntries.isEmpty) {
          log('文件 $fileName 没有有效的翻译条目', name: 'ProjectController');
          continue;
        }

        // 使用冲突检测服务检测冲突
        final conflictResult = await ConflictDetectionService.detectConflicts(
          existingEntries,
          importedEntries,
        );

        log('文件 $fileName 冲突检测结果: ${conflictResult.conflictCount} 个冲突，${conflictResult.newEntryCount} 个新条目',
            name: 'ProjectController');

        // 添加新条目（无冲突的）
        if (conflictResult.newEntries.isNotEmpty) {
          final createdEntries = await _translationService.batchCreateTranslationEntries(conflictResult.newEntries);
          allImportedEntries.addAll(createdEntries);
        }

        // 记录冲突（暂时跳过，后续可实现冲突解决UI）
        if (conflictResult.conflicts.isNotEmpty) {
          allConflicts.addAll(conflictResult.conflicts);
          log('发现 ${conflictResult.conflicts.length} 个冲突，暂时跳过', name: 'ProjectController');
        }
      }

      // 清空文件列表
      setFiles([]);

      // 显示导入结果
      if (allImportedEntries.isEmpty && allConflicts.isEmpty) {
        Get.snackbar('提示', '没有导入任何翻译内容');
      } else {
        final message = StringBuffer();
        if (allImportedEntries.isNotEmpty) {
          message.write('成功导入 ${allImportedEntries.length} 个翻译条目');
        }
        if (allConflicts.isNotEmpty) {
          if (message.isNotEmpty) message.write('，');
          message.write('发现 ${allConflicts.length} 个冲突（已跳过）');
        }
        if (totalSkipped > 0) {
          if (message.isNotEmpty) message.write('，');
          message.write('跳过 $totalSkipped 个无效条目');
        }

        Get.snackbar(
          allConflicts.isNotEmpty ? '部分成功' : '成功',
          message.toString(),
          duration: const Duration(seconds: 5),
        );
      }

      log('导入完成：成功 ${allImportedEntries.length}，冲突 ${allConflicts.length}，跳过 $totalSkipped', name: 'ProjectController');
    } catch (error, stackTrace) {
      log('导入文件失败', error: error, stackTrace: stackTrace, name: 'ProjectController');
      Get.snackbar('错误', '导入文件失败: $error');
    }
  }
}
