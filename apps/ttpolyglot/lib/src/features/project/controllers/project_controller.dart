import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/services/translation_service_impl.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_utils/utils.dart';

class ProjectController extends GetxController {
  String projectId;
  ProjectController({required this.projectId});

  static ProjectController getInstance(String projectId) {
    return Get.isRegistered<ProjectController>(tag: projectId)
        ? Get.find<ProjectController>(tag: projectId)
        : Get.put(ProjectController(projectId: projectId), tag: projectId);
  }

  final TextEditingController _deleteProjectNameTextController = TextEditingController();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();
  final ProjectApi _projectApi = Get.find<ProjectApi>();

  // 响应式项目对象
  final _project = Rxn<Project>();
  final _projectModel = Rxn<ProjectModel>(); // 保存 API 模型，包含 memberLimit 等额外信息
  final _isLoading = false.obs;
  final _members = <ProjectMemberModel>[].obs;

  // Getters
  Project? get project => _project.value;
  ProjectModel? get projectModel => _projectModel.value; // 用于访问 memberLimit 等信息
  Rxn<Project> get projectObs => _project;
  bool get isLoading => _isLoading.value;
  List<ProjectMemberModel> get members => _members;

  String get title => _project.value?.name ?? '-';
  String get description => _project.value?.description ?? '-';
  int get languageCount => _project.value?.allLanguages.length ?? 0;
  int get translationCount => 0;

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
  final RxList<ImportRecordModel> _importRecords = <ImportRecordModel>[].obs;
  List<ImportRecordModel> get importRecords => _importRecords.toList();

  /// 添加导入记录
  void addImportRecordModel(ImportRecordModel record) {
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
    final paramProjectId = Get.parameters['projectId'];
    if (paramProjectId != null && paramProjectId.isNotEmpty) {
      projectId = paramProjectId;
    }
    // 如果构造函数中已经传入了有效的 projectId，就保持不变
  }

  @override
  void onReady() {
    super.onReady();
    LoggerUtils.info('ProjectController onReady: $projectId');
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
      LoggerUtils.info('项目ID为空，跳过项目加载');
      return;
    }

    LoggerUtils.info('开始加载项目: $projectId');
    _isLoading.value = true;

    try {
      // 将 String 类型的 projectId 转换为 int
      final projectIdInt = int.tryParse(projectId);
      if (projectIdInt == null) {
        LoggerUtils.error('项目ID格式无效: $projectId');
        return;
      }

      // 从 API 获取项目详情
      final projectDetailModel = await _projectApi.getProject(projectIdInt);
      if (projectDetailModel != null) {
        // 保存 ProjectModel，用于访问 memberLimit 等 API 层信息
        _projectModel.value = projectDetailModel.project;

        // 将 ProjectDetailModel 转换为 Project（包含语言列表）
        final project = ProjectConverter.toProjectFromDetail(projectDetailModel);

        // 保存成员列表
        if (projectDetailModel.members != null) {
          _members.value = projectDetailModel.members!;
          LoggerUtils.info('项目成员加载成功: ${projectDetailModel.members!.length} 个成员');
        } else {
          _members.clear();
        }

        LoggerUtils.info(
            '项目加载成功: ID=${project.id}, 名称="${project.name}", 主语言=${project.primaryLanguage.code}, 目标语言=${project.targetLanguages.length} 个');
        _project.value = project;
        return;
      }

      LoggerUtils.info('项目不存在: $projectId');
    } catch (error, stackTrace) {
      LoggerUtils.error('[loadProject]', error: error, stackTrace: stackTrace, name: 'ProjectController');
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
      LoggerUtils.error('获取项目统计失败', error: error, stackTrace: stackTrace);
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
      try {
        final projectIdInt = int.tryParse(projectId);
        if (projectIdInt == null) {
          Get.snackbar('错误', '项目ID无效');
          return;
        }

        final success = await _projectApi.removeProjectLanguage(
          projectId: projectIdInt,
          languageId: language.id,
        );

        if (success) {
          Get.snackbar('成功', '目标语言已删除');
          await refreshProject(); // 刷新项目数据
        } else {
          Get.snackbar('错误', '删除目标语言失败');
        }
      } catch (error, stackTrace) {
        LoggerUtils.error('[removeTargetLanguage]', error: error, stackTrace: stackTrace, name: 'ProjectController');
        Get.snackbar('错误', '删除目标语言失败: $error');
      }
    }
  }

  /// 导入内容到项目中
  /// 这种设计确保了所有翻译都基于相同的源语言，提高了数据一致性。
  Future<void> importFiles(Map<String, Language> languageMap, Map<String, Map<String, String>> translationMap) async {
    final startTime = DateTime.now();
    try {
      LoggerUtils.info('开始批量导入翻译文件，设置：覆盖现有翻译=$overrideExisting，自动审核=$autoReview，忽略空值=$ignoreEmpty',
          name: 'ProjectController');

      final allImportedEntries = <TranslationEntry>[];
      final allSkippedEntries = <String>[];
      final allUpdatedEntries = <TranslationEntry>[];
      int totalSkipped = 0;

      // 获取现有翻译条目用于精确检查
      final existingEntries = await _translationService.getTranslationEntries(projectId);

      // 收集所有唯一的翻译键
      final allKeys = <String>{};
      final keyValueMap = <String, Map<String, String>>{};

      // 处理每个文件的翻译，收集键和值
      for (final fileEntry in translationMap.entries) {
        final fileName = fileEntry.key;
        final translations = fileEntry.value;
        final selectedLanguage = languageMap[fileName];

        if (selectedLanguage == null) {
          LoggerUtils.info('跳过文件 $fileName：未选择语言');
          totalSkipped += translations.length;
          continue;
        }

        LoggerUtils.info('处理文件 $fileName，语言: ${selectedLanguage.code}，条目数: ${translations.length}',
            name: 'ProjectController');

        for (final translation in translations.entries) {
          final key = translation.key;
          final value = translation.value;

          if (key.trim().isEmpty) {
            LoggerUtils.info('跳过空键');
            totalSkipped++;
            continue;
          }

          // 根据"忽略空值"设置处理空值
          if (ignoreEmpty && value.trim().isEmpty) {
            LoggerUtils.info('跳过空值: $key');
            totalSkipped++;
            continue;
          }

          final trimmedKey = key.trim();
          allKeys.add(trimmedKey);

          // 初始化键的语言映射
          keyValueMap[trimmedKey] ??= {};
          keyValueMap[trimmedKey]![selectedLanguage.code] = value;
        }
      }

      // 获取项目的全部语言
      final allProjectLanguages = _project.value!.allLanguages;

      // 处理每个键，为缺少的语言创建翻译条目
      for (final key in allKeys) {
        LoggerUtils.info('处理键: "$key"');

        // 检查该键在每个项目语言中的现有条目
        final existingEntriesForKey = existingEntries.where((entry) => entry.key == key).toList();

        // 为每个项目语言检查是否需要创建或更新条目
        for (final language in allProjectLanguages) {
          final languageCode = language.code;
          final hasValue = keyValueMap[key]?.containsKey(languageCode) ?? false;
          final value = keyValueMap[key]?[languageCode] ?? '';

          // 查找该语言的现有条目
          final existingEntryForLanguage =
              existingEntriesForKey.where((entry) => entry.targetLanguage.code == languageCode).toList();

          if (existingEntryForLanguage.isEmpty) {
            // 该语言的条目不存在，需要创建
            LoggerUtils.info('键 "$key" 缺少语言 "$languageCode" 的条目，将创建新条目');

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
              key: key,
              sourceLanguage:
                  languageCode == _project.value!.primaryLanguage.code ? language : _project.value!.primaryLanguage,
              targetLanguage: language,
              sourceText: languageCode == _project.value!.primaryLanguage.code ? value : key,
              targetText: value,
              status: entryStatus,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            allImportedEntries.add(newEntry);
          } else if (hasValue && overrideExisting) {
            // 该语言的条目存在，且有值且允许覆盖，需要更新
            LoggerUtils.info('键 "$key" 的语言 "$languageCode" 条目存在，根据配置将覆盖现有翻译');

            TranslationStatus entryStatus;
            if (value.trim().isEmpty) {
              entryStatus = TranslationStatus.pending;
            } else if (autoReview) {
              entryStatus = TranslationStatus.completed;
            } else {
              entryStatus = TranslationStatus.reviewing;
            }

            final updatedEntry = existingEntryForLanguage.first.copyWith(
              sourceText: languageCode == _project.value!.primaryLanguage.code ? value : key,
              targetText: value,
              status: entryStatus,
              updatedAt: DateTime.now(),
            );

            allUpdatedEntries.add(updatedEntry);
          } else if (hasValue && !overrideExisting) {
            // 该语言的条目存在，有值但不允许覆盖，跳过
            LoggerUtils.info('键 "$key" 的语言 "$languageCode" 条目存在，根据配置跳过覆盖');
            allSkippedEntries.add(key);
            totalSkipped++;
          }
          // 如果条目存在但没有新值，则保持原有条目不变
        }
      }

      // 批量创建新条目
      if (allImportedEntries.isNotEmpty) {
        final createdEntries = await _translationService.batchCreateTranslationEntries(allImportedEntries);
        LoggerUtils.info('创建了 ${createdEntries.length} 个新翻译条目');
      }

      // 批量更新现有条目
      if (allUpdatedEntries.isNotEmpty) {
        final updatedResult = await _translationService.batchUpdateTranslationEntries(allUpdatedEntries);
        LoggerUtils.info('更新了 ${updatedResult.length} 个现有翻译条目');
      }

      // 清空文件列表
      setFiles([]);

      // 刷新翻译列表（如果翻译控制器已注册）
      if (allImportedEntries.isNotEmpty) {
        try {
          if (Get.isRegistered<TranslationController>(tag: projectId)) {
            final translationController = Get.find<TranslationController>(tag: projectId);
            await translationController.refreshTranslationEntries();
            LoggerUtils.info('已通知翻译控制器刷新数据');
          }
        } catch (error, stackTrace) {
          LoggerUtils.error('通知翻译控制器刷新失败', error: error, stackTrace: stackTrace);
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

      LoggerUtils.info(
          '导入完成：创建 ${allImportedEntries.length}，更新 ${allUpdatedEntries.length}，跳过 ${allSkippedEntries.length}',
          name: 'ProjectController');
    } catch (error, stackTrace) {
      LoggerUtils.error('导入文件失败', error: error, stackTrace: stackTrace);

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

        final record = ImportRecordModel(
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

        addImportRecordModel(record);
      }
    } else {
      // 如果没有文件，创建一个通用的失败记录
      final record = ImportRecordModel(
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

      addImportRecordModel(record);
    }

    LoggerUtils.info('已创建导入记录，当前记录数: ${_importRecords.length}');
  }
}
