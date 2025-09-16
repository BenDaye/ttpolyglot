import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/translation_service_impl.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
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

  // 导入设置
  final _overrideExisting = false.obs; // 覆盖现有翻译
  final _autoReview = true.obs; // 自动审核
  final _ignoreEmpty = true.obs; // 忽略空值

  // 导入设置 Getters & Setters
  bool get overrideExisting => _overrideExisting.value;
  bool get autoReview => _autoReview.value;
  bool get ignoreEmpty => _ignoreEmpty.value;

  void setOverrideExisting(bool value) => _overrideExisting.value = value;
  void setAutoReview(bool value) => _autoReview.value = value;
  void setIgnoreEmpty(bool value) => _ignoreEmpty.value = value;

  // 导入记录
  final RxList<ImportRecord> _importRecords = <ImportRecord>[].obs;
  List<ImportRecord> get importRecords => _importRecords.toList();

  /// 添加导入记录
  void addImportRecord(ImportRecord record) {
    _importRecords.insert(0, record); // 最新记录插在最前面

    // 最多保留5条记录
    if (_importRecords.length > 5) {
      _importRecords.removeRange(5, _importRecords.length);
    }

    // TODO: 可以在这里添加持久化存储逻辑
  }

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

        // 验证项目源语言数据一致性
        await _validateProjectSourceLanguageConsistency(project);

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
      await refreshProject(); // 刷新项目数据
    }
  }

  /// 验证项目源语言数据一致性
  Future<void> _validateProjectSourceLanguageConsistency(Project project) async {
    try {
      // 这里可以集成SourceLanguageValidator进行更详细的验证
      // 暂时只记录日志，提醒主语言不可修改
      log(
        '项目源语言验证',
        error: '项目ID: ${project.id}, 主语言: ${project.primaryLanguage.code} (不可修改)',
        name: 'ProjectController',
      );

      // TODO: 如果需要，可以在这里集成完整的翻译条目验证
      // 使用 SourceLanguageValidator.validateProjectSourceLanguage()
    } catch (error, stackTrace) {
      log(
        '验证项目源语言一致性失败',
        error: error,
        stackTrace: stackTrace,
        name: 'ProjectController',
      );
      // 不阻止项目加载，只是记录错误
    }
  }

  Future<void> importFiles(Map<String, Language> languageMap, Map<String, Map<String, String>> translationMap) async {
    final startTime = DateTime.now();
    try {
      log('开始批量导入翻译文件，设置：覆盖现有翻译=$overrideExisting，自动审核=$autoReview，忽略空值=$ignoreEmpty', name: 'ProjectController');

      final allImportedEntries = <TranslationEntry>[];
      final allSkippedEntries = <String>[];
      final allUpdatedEntries = <TranslationEntry>[];
      int totalSkipped = 0;

      // 获取现有翻译条目用于精确检查
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

        // 处理每个翻译条目
        final importedEntries = <TranslationEntry>[];
        final updatedEntries = <TranslationEntry>[];
        final skippedKeys = <String>[];

        for (final translation in translations.entries) {
          final key = translation.key;
          final value = translation.value;

          if (key.trim().isEmpty) {
            log('跳过空键', name: 'ProjectController');
            totalSkipped++;
            continue;
          }

          // 根据"忽略空值"设置处理空值
          if (ignoreEmpty && value.trim().isEmpty) {
            log('跳过空值: $key', name: 'ProjectController');
            totalSkipped++;
            continue;
          }

          // 1. 判断key值是否已经存在
          TranslationEntry? existingEntryForKey;
          try {
            existingEntryForKey = existingEntries.firstWhere(
              (entry) => entry.key == key.trim(),
            );
          } catch (e) {
            existingEntryForKey = null;
          }

          if (existingEntryForKey == null) {
            // key不存在，直接创建新条目
            log('key "$key" 不存在，将创建新条目', name: 'ProjectController');

            // 根据"自动审核"设置确定状态
            TranslationStatus entryStatus;
            if (value.trim().isEmpty) {
              entryStatus = TranslationStatus.pending;
            } else if (autoReview) {
              entryStatus = TranslationStatus.completed;
            } else {
              entryStatus = TranslationStatus.reviewing;
            }

            final newEntry = TranslationEntry(
              id: DateTime.now().millisecondsSinceEpoch.toString() +
                  (DateTime.now().microsecond % 1000).toString().padLeft(3, '0'),
              projectId: projectId,
              key: key.trim(),
              sourceLanguage: selectedLanguage.code == _project.value!.defaultLanguage.code
                  ? selectedLanguage
                  : _project.value!.defaultLanguage,
              targetLanguage: selectedLanguage,
              sourceText: selectedLanguage.code == _project.value!.defaultLanguage.code ? value : key,
              targetText: value,
              status: entryStatus,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            importedEntries.add(newEntry);
          } else {
            // 2. key存在，判断当前语言的值是否存在
            TranslationEntry? existingTranslationForLanguage;
            try {
              existingTranslationForLanguage = existingEntries.firstWhere(
                (entry) => entry.key == key.trim() && entry.targetLanguage.code == selectedLanguage.code,
              );
            } catch (e) {
              existingTranslationForLanguage = null;
            }

            if (existingTranslationForLanguage == null) {
              // 3. 当前语言的值不存在，直接写入
              log('key "$key" 存在但语言 "${selectedLanguage.code}" 的值不存在，将创建新条目', name: 'ProjectController');

              TranslationStatus entryStatus;
              if (value.trim().isEmpty) {
                entryStatus = TranslationStatus.pending;
              } else if (autoReview) {
                entryStatus = TranslationStatus.completed;
              } else {
                entryStatus = TranslationStatus.reviewing;
              }

              final newEntry = TranslationEntry(
                id: DateTime.now().millisecondsSinceEpoch.toString() +
                    (DateTime.now().microsecond % 1000).toString().padLeft(3, '0'),
                projectId: projectId,
                key: key.trim(),
                sourceLanguage: selectedLanguage.code == _project.value!.defaultLanguage.code
                    ? selectedLanguage
                    : _project.value!.defaultLanguage,
                targetLanguage: selectedLanguage,
                sourceText: selectedLanguage.code == _project.value!.defaultLanguage.code ? value : key,
                targetText: value,
                status: entryStatus,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              importedEntries.add(newEntry);
            } else {
              // 4. 当前语言的值存在，根据配置判断是否需要覆盖
              if (overrideExisting) {
                // 覆盖现有翻译
                log('key "$key" 的语言 "${selectedLanguage.code}" 值存在，根据配置将覆盖现有翻译', name: 'ProjectController');

                TranslationStatus entryStatus;
                if (value.trim().isEmpty) {
                  entryStatus = TranslationStatus.pending;
                } else if (autoReview) {
                  entryStatus = TranslationStatus.completed;
                } else {
                  entryStatus = TranslationStatus.reviewing;
                }

                final updatedEntry = existingTranslationForLanguage.copyWith(
                  sourceText: selectedLanguage.code == _project.value!.defaultLanguage.code ? value : key,
                  targetText: value,
                  status: entryStatus,
                  updatedAt: DateTime.now(),
                );

                updatedEntries.add(updatedEntry);
              } else {
                // 不覆盖，跳过此条目
                log('key "$key" 的语言 "${selectedLanguage.code}" 值存在，根据配置跳过覆盖', name: 'ProjectController');
                skippedKeys.add(key.trim());
                totalSkipped++;
              }
            }
          }
        }

        // 批量创建新条目
        if (importedEntries.isNotEmpty) {
          final createdEntries = await _translationService.batchCreateTranslationEntries(importedEntries);
          allImportedEntries.addAll(createdEntries);
          log('文件 $fileName 创建了 ${createdEntries.length} 个新翻译条目', name: 'ProjectController');
        }

        // 批量更新现有条目
        if (updatedEntries.isNotEmpty) {
          final updatedResult = await _translationService.batchUpdateTranslationEntries(updatedEntries);
          allUpdatedEntries.addAll(updatedResult);
          log('文件 $fileName 更新了 ${updatedResult.length} 个现有翻译条目', name: 'ProjectController');
        }

        // 记录跳过的条目
        if (skippedKeys.isNotEmpty) {
          allSkippedEntries.addAll(skippedKeys);
          log('文件 $fileName 跳过了 ${skippedKeys.length} 个现有翻译条目', name: 'ProjectController');
        }
      }

      // 清空文件列表
      setFiles([]);

      // 刷新翻译列表（如果翻译控制器已注册）
      if (allImportedEntries.isNotEmpty) {
        try {
          if (Get.isRegistered<TranslationController>(tag: projectId)) {
            final translationController = Get.find<TranslationController>(tag: projectId);
            await translationController.refreshTranslationEntries();
            log('已通知翻译控制器刷新数据', name: 'ProjectController');
          }
        } catch (error, stackTrace) {
          log('通知翻译控制器刷新失败', error: error, stackTrace: stackTrace, name: 'ProjectController');
          // 不影响主要流程，继续执行
        }
      }

      // 显示导入结果
      if (allImportedEntries.isEmpty && allUpdatedEntries.isEmpty && allSkippedEntries.isEmpty) {
        Get.snackbar('提示', '没有导入任何翻译内容');
      } else {
        final message = StringBuffer();

        // 统计创建的新条目数量
        final newEntriesCount = allImportedEntries.length;

        // 统计更新的条目数量
        final updatedEntriesCount = allUpdatedEntries.length;

        // 统计跳过的条目数量
        final skippedEntriesCount = allSkippedEntries.length;

        if (newEntriesCount > 0) {
          message.write('创建了 $newEntriesCount 个新翻译条目');
          if (autoReview) {
            message.write('（已自动审核）');
          }
        }

        if (updatedEntriesCount > 0) {
          if (message.isNotEmpty) message.write('，');
          message.write('更新了 $updatedEntriesCount 个现有翻译');
          if (autoReview) {
            message.write('（已自动审核）');
          }
        }

        if (skippedEntriesCount > 0) {
          if (message.isNotEmpty) message.write('，');
          if (overrideExisting) {
            message.write('跳过 $skippedEntriesCount 个空值或无效条目');
          } else {
            message.write('跳过 $skippedEntriesCount 个现有翻译（未启用覆盖）');
          }
        }

        if (totalSkipped > skippedEntriesCount) {
          final additionalSkipped = totalSkipped - skippedEntriesCount;
          if (message.isNotEmpty) message.write('，');
          message.write('跳过 $additionalSkipped 个无效条目');
        }

        Get.snackbar(
          skippedEntriesCount > 0 && !overrideExisting ? '部分成功' : '成功',
          message.toString(),
          duration: const Duration(seconds: 5),
        );
      }

      // 创建导入记录
      _createImportRecords(
        languageMap,
        translationMap,
        allImportedEntries.length,
        allUpdatedEntries.length,
        allSkippedEntries.length,
        totalSkipped,
        startTime,
        success: true,
      );

      log('导入完成：创建 ${allImportedEntries.length}，更新 ${allUpdatedEntries.length}，跳过 ${allSkippedEntries.length + (totalSkipped - allSkippedEntries.length)}',
          name: 'ProjectController');
    } catch (error, stackTrace) {
      log('导入文件失败', error: error, stackTrace: stackTrace, name: 'ProjectController');

      // 创建失败记录
      _createImportRecords(
        languageMap,
        translationMap,
        0,
        0,
        0,
        0,
        startTime,
        success: false,
        errorMessage: error.toString(),
      );

      Get.snackbar('错误', '导入文件失败: $error');
    }
  }

  /// 创建导入记录
  void _createImportRecords(
    Map<String, Language> languageMap,
    Map<String, Map<String, String>> translationMap,
    int totalCreatedCount,
    int totalUpdatedCount,
    int totalSkippedExistingCount,
    int totalSkippedCount,
    DateTime startTime, {
    required bool success,
    String? errorMessage,
  }) {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime).inMilliseconds;

    // 如果有多个文件，为每个文件创建记录
    if (translationMap.isNotEmpty) {
      for (final fileEntry in translationMap.entries) {
        final fileName = fileEntry.key;
        final translations = fileEntry.value;
        final selectedLanguage = languageMap[fileName];

        // 计算当前文件的统计数据（简化处理）
        final fileTranslationCount = translations.length;
        final fileCreatedCount = success
            ? (totalCreatedCount *
                    fileTranslationCount /
                    translationMap.values.fold<int>(0, (sum, map) => sum + map.length))
                .round()
            : 0;
        final fileUpdatedCount = success
            ? (totalUpdatedCount *
                    fileTranslationCount /
                    translationMap.values.fold<int>(0, (sum, map) => sum + map.length))
                .round()
            : 0;
        final fileSkippedExistingCount = success
            ? (totalSkippedExistingCount *
                    fileTranslationCount /
                    translationMap.values.fold<int>(0, (sum, map) => sum + map.length))
                .round()
            : 0;
        final fileSkippedCount = success
            ? (totalSkippedCount *
                    fileTranslationCount /
                    translationMap.values.fold<int>(0, (sum, map) => sum + map.length))
                .round()
            : 0;

        ImportRecordStatus status;
        String message;

        if (!success) {
          status = ImportRecordStatus.failure;
          message = errorMessage ?? '导入失败';
        } else if (fileSkippedExistingCount > 0 || fileSkippedCount > fileSkippedExistingCount) {
          status = ImportRecordStatus.partial;
          message = '成功处理翻译';
          if (fileCreatedCount > 0) {
            message += '，创建 $fileCreatedCount 条新翻译';
          }
          if (fileUpdatedCount > 0) {
            message += '，更新 $fileUpdatedCount 条翻译';
          }
          if (fileSkippedExistingCount > 0) {
            message += '，${overrideExisting ? "" : "跳过"} $fileSkippedExistingCount 个现有翻译';
          }
          if (fileSkippedCount > fileSkippedExistingCount) {
            final additionalSkipped = fileSkippedCount - fileSkippedExistingCount;
            message += '，跳过 $additionalSkipped 个无效条目';
          }
        } else {
          status = ImportRecordStatus.success;
          message = '成功处理 $fileCreatedCount 条翻译';
          if (fileUpdatedCount > 0) {
            message += '，更新 $fileUpdatedCount 条翻译';
          }
          if (autoReview) {
            message += '（已自动审核）';
          }
        }

        final record = ImportRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString() +
              (DateTime.now().microsecond % 1000).toString().padLeft(3, '0'),
          fileName: fileName,
          status: status,
          message: message,
          importedCount: fileCreatedCount,
          conflictCount: fileUpdatedCount,
          skippedCount: fileSkippedCount,
          timestamp: startTime,
          language: selectedLanguage?.code,
          duration: duration,
        );

        addImportRecord(record);
      }
    } else {
      // 如果没有文件，创建一个通用的失败记录
      final record = ImportRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fileName: '未知文件',
        status: ImportRecordStatus.failure,
        message: errorMessage ?? '导入失败：没有有效文件',
        importedCount: 0,
        conflictCount: 0,
        skippedCount: 0,
        timestamp: startTime,
        duration: duration,
      );

      addImportRecord(record);
    }

    log('已创建导入记录，当前记录数: ${_importRecords.length}', name: 'ProjectController');
  }
}
