import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/services/translation_service_impl.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_utils/utils.dart';

class ProjectController extends GetxController {
  int projectId;
  ProjectController({required this.projectId});

  static ProjectController getInstance(int projectId) {
    return Get.isRegistered<ProjectController>(tag: projectId.toString())
        ? Get.find<ProjectController>(tag: projectId.toString())
        : Get.put(ProjectController(projectId: projectId), tag: projectId.toString());
  }

  final TextEditingController _deleteProjectNameTextController = TextEditingController();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();
  final ProjectApi _projectApi = Get.find<ProjectApi>();
  final NotificationSettingsApi _notificationSettingsApi = Get.find<NotificationSettingsApi>();
  final FileApi _fileApi = Get.find<FileApi>();

  // 响应式项目对象
  final _project = Rxn<ProjectModel>();
  ProjectModel? get project => _project.value;
  final _isLoading = false.obs;
  final _members = <ProjectMemberModel>[].obs;

  // 通知设置
  final _notificationSettings = <NotificationSettingsModel>[].obs;
  final _isLoadingNotificationSettings = false.obs;

  // Getters
  Rxn<ProjectModel> get projectObs => _project;
  bool get isLoading => _isLoading.value;
  List<ProjectMemberModel> get members => _members;
  List<NotificationSettingsModel> get notificationSettings => _notificationSettings;
  bool get isLoadingNotificationSettings => _isLoadingNotificationSettings.value;

  /// 检查当前用户是否是项目所有者
  bool get isCurrentUserOwner {
    final currentUsername = Get.find<AuthService>().currentUser?.username;
    if (currentUsername == null || _project.value == null) {
      return false;
    }

    // 从成员列表中找到所有者（通过 userId 匹配 ownerId）
    final owner = _project.value!.members.firstWhereOrNull(
      (member) => member.userId == _project.value!.ownerId,
    );

    // 比较当前用户的 username 与所有者的 username
    return owner != null && owner.username == currentUsername;
  }

  String get title => _project.value?.name ?? '-';
  String get description => _project.value?.description ?? '-';
  int get languageCount => _project.value?.languages.length ?? 0;
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

  /// 添加导入记录并上报到服务端
  void addImportRecordModel(ImportRecordModel record) {
    _importRecords.insert(0, record); // 最新记录插在最前面

    // 最多保留5条记录
    if (_importRecords.length > 5) {
      _importRecords.removeRange(5, _importRecords.length);
    }

    // 异步上报到服务端
    _fileApi.createBatchJobRecord(
      projectId: projectId,
      jobType: 'import',
      status: record.status == ImportRecordStatus.failure ? 'failed' : 'completed',
      totalItems: record.totalCount,
      successItems: record.importedCount,
      failedItems: record.skippedCount + record.conflictCount,
      config: {
        'file_name': record.fileName,
        'language': record.language,
        'format': record.fileName.split('.').last,
      },
      result: {
        'imported': record.importedCount,
        'conflicts': record.conflictCount,
        'skipped': record.skippedCount,
        'message': record.message,
      },
      errorMessage: record.status == ImportRecordStatus.failure ? record.message : null,
    );
  }

  // 允许的文件扩展名
  List<String> get allowedExtensions => ['json', 'csv', 'xlsx', 'xls', 'arb', 'po'];

  @override
  void onInit() {
    super.onInit();
    final paramProjectId = int.tryParse(Get.parameters['projectId'] ?? '0');
    if (paramProjectId != null) {
      projectId = paramProjectId;
    }
    // 如果构造函数中已经传入了有效的 projectId，就保持不变
  }

  @override
  void onReady() {
    super.onReady();
    LoggerUtils.info('ProjectController onReady: $projectId');
    loadProject();
    loadNotificationSettings();
  }

  @override
  void onClose() {
    _deleteProjectNameTextController.dispose();
    super.onClose();
  }

  /// 加载项目详情
  Future<void> loadProject() async {
    LoggerUtils.info('开始加载项目: $projectId');
    _isLoading.value = true;

    try {
      // 将 String 类型的 projectId 转换为 int
      // 从 API 获取项目详情
      final projectModel = await _projectApi.getProject(projectId);
      if (projectModel != null) {
        _project.value = projectModel;
        // 保存成员列表
        _members.value = projectModel.members;
        //
        LoggerUtils.info('项目成员加载成功: ${projectModel.members.length} 个成员');
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
  Future<ProjectStatisticsModel?> getProjectStats() async {
    try {
      return await ProjectsController.getProjectStats(projectId);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目统计失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 加载通知设置
  Future<void> loadNotificationSettings() async {
    _isLoadingNotificationSettings.value = true;
    try {
      final settings = await _notificationSettingsApi.getProjectNotificationSettings(
        projectId: projectId,
      );
      _notificationSettings.value = settings;
      LoggerUtils.info('通知设置加载成功: ${settings.length} 条', name: 'ProjectController');
    } catch (error, stackTrace) {
      LoggerUtils.error('[loadNotificationSettings]', error: error, stackTrace: stackTrace, name: 'ProjectController');
    } finally {
      _isLoadingNotificationSettings.value = false;
    }
  }

  /// 更新通知设置
  Future<void> updateNotificationSetting({
    required NotificationTypeEnum notificationType,
    required NotificationChannelEnum channel,
    required bool isEnabled,
  }) async {
    try {
      await _notificationSettingsApi.updateProjectNotificationSetting(
        projectId: projectId,
        notificationType: notificationType,
        channel: channel,
        isEnabled: isEnabled,
      );

      // 重新加载通知设置
      await loadNotificationSettings();
    } catch (error, stackTrace) {
      LoggerUtils.error('[updateNotificationSetting]', error: error, stackTrace: stackTrace, name: 'ProjectController');
      rethrow;
    }
  }

  /// 检查通知设置是否启用
  bool isNotificationEnabled(NotificationTypeEnum notificationType, NotificationChannelEnum channel) {
    final setting = _notificationSettings.firstWhereOrNull(
      (s) => s.notificationType == notificationType && s.channel == channel,
    );
    return setting?.isEnabled ?? true; // 默认启用
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

  /// 转移项目所有权
  Future<void> transferProjectOwnership() async {
    if (_project.value == null) return;

    // 只有项目所有者才能转移所有权
    if (!isCurrentUserOwner) {
      Get.snackbar('错误', '只有项目所有者才能转移所有权');
      return;
    }

    // 显示成员选择对话框
    final selectedMember = await Get.dialog<ProjectMemberModel>(
      AlertDialog(
        title: const Text('转移项目所有权'),
        content: SizedBox(
          width: 400.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('选择新的项目所有者：'),
              const SizedBox(height: 16.0),
              // 成员列表
              Builder(
                builder: (context) {
                  final availableMembers = _members.where((m) => m.role != ProjectRoleEnum.owner).toList();
                  if (availableMembers.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('没有可转移的成员'),
                      ),
                    );
                  }
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableMembers.length,
                      itemBuilder: (context, index) {
                        final member = availableMembers[index];
                        final username = member.username ?? '';
                        final firstLetter = username.isNotEmpty ? username.substring(0, 1).toUpperCase() : '?';
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(firstLetter),
                          ),
                          title: Text(username.isNotEmpty ? username : '未命名用户'),
                          subtitle: Text(member.email ?? '无邮箱'),
                          trailing: Text(_getRoleText(member.role)),
                          onTap: () => Get.back(result: member),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 20.0),
                        SizedBox(width: 8.0),
                        Text(
                          '注意事项',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '• 转移后，您将成为项目管理员\n'
                      '• 新所有者将拥有所有权限\n'
                      '• 此操作不可撤销',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (selectedMember == null) return;

    // 二次确认
    final selectedUsername = selectedMember.username ?? '未命名用户';
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('确认转移所有权'),
        content: Text('确定要将项目所有权转移给 $selectedUsername 吗？此操作不可撤销！'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('确定转移'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed != true) return;

    try {
      final newOwnerId = selectedMember.userId;
      if (newOwnerId == null) {
        Get.snackbar('错误', '无效的用户ID');
        return;
      }

      final success = await _projectApi.transferProjectOwnership(
        projectId: projectId,
        newOwnerId: newOwnerId,
      );

      if (success) {
        Get.snackbar('成功', '项目所有权已转移给 $selectedUsername');
        await refreshProject();
      } else {
        Get.snackbar('失败', '转移项目所有权失败');
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('[transferProjectOwnership]', error: error, stackTrace: stackTrace, name: 'ProjectController');
      Get.snackbar('错误', '转移项目所有权失败: $error');
    }
  }

  /// 获取角色文本
  String _getRoleText(ProjectRoleEnum role) {
    switch (role) {
      case ProjectRoleEnum.owner:
        return '所有者';
      case ProjectRoleEnum.admin:
        return '管理员';
      case ProjectRoleEnum.member:
        return '成员';
      case ProjectRoleEnum.viewer:
        return '查看者';
    }
  }

  Future<void> editProject() async {
    if (_project.value == null) return;
    await ProjectDialogController.showEditDialog(_project.value!);
    await refreshProject();
  }

  Future<void> removeTargetLanguage(LanguageEnum language) async {
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
        final success = await _projectApi.removeProjectLanguage(
          projectId: projectId,
          languageId: _project.value?.languages.firstWhere((lang) => lang.code == language).id ?? 0,
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
  Future<void> importFiles(
    Map<String, LanguageModel> languageMap,
    Map<String, Map<String, String>> translationMap,
  ) async {
    final startTime = DateTime.now();
    try {
      LoggerUtils.info(
        '开始批量导入翻译文件，设置：覆盖现有翻译=$overrideExisting，自动审核=$autoReview，忽略空值=$ignoreEmpty',
        name: 'ProjectController',
      );

      final allImportedEntries = <TranslationEntryModel>[];
      final allSkippedEntries = <String>[];
      final allUpdatedEntries = <TranslationEntryModel>[];
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

        LoggerUtils.info(
          '处理文件 $fileName，语言: ${selectedLanguage.code}，条目数: ${translations.length}',
          name: 'ProjectController',
        );

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
          keyValueMap[trimmedKey]![selectedLanguage.code.code] = value;
        }
      }

      // 获取项目的全部语言
      final allProjectLanguages = _project.value!.languages;

      // 处理每个键，为缺少的语言创建翻译条目
      for (final key in allKeys) {
        LoggerUtils.info('处理键: "$key"');

        // 检查该键在每个项目语言中的现有条目
        final existingEntriesForKey = existingEntries.where((entry) => entry.entryKey == key).toList();

        // 为每个项目语言检查是否需要创建或更新条目
        for (final language in allProjectLanguages) {
          final languageCode = language.code;
          final hasValue = keyValueMap[key]?.containsKey(languageCode.code) ?? false;
          final value = keyValueMap[key]?[languageCode.code] ?? '';

          // 查找该语言的现有条目（检查是否有该语言的目标翻译）
          final existingEntryForLanguage = existingEntriesForKey.where((entry) {
            return entry.targetLanguages.any((t) => t.language.code == languageCode.code);
          }).toList();

          if (existingEntryForLanguage.isEmpty) {
            // 该语言的条目不存在，需要创建或添加到现有条目
            LoggerUtils.info('键 "$key" 缺少语言 "$languageCode" 的条目，将创建新条目');

            // 检查是否已有该键的条目（但缺少这个语言）
            final existingEntryForKey = existingEntriesForKey.isNotEmpty ? existingEntriesForKey.first : null;

            if (existingEntryForKey != null) {
              // 已有条目，添加新的目标语言
              final newTargetLang = TranslationTargetLanguageModel(
                language: language.code,
                text: value,
              );
              final updatedEntry = existingEntryForKey.copyWith(
                targetLanguages: [...existingEntryForKey.targetLanguages, newTargetLang],
                updatedAt: DateTime.now(),
              );
              allUpdatedEntries.add(updatedEntry);
            } else {
              // 创建新条目
              final newEntry = TranslationEntryModel(
                uuid: DateTime.now().millisecondsSinceEpoch.toString() +
                    (DateTime.now().microsecond % 1000).toString().padLeft(3, '0'),
                projectId: projectId,
                entryKey: key,
                sourceLanguage: languageCode == _project.value!.primaryLanguage.code
                    ? language.code
                    : _project.value!.primaryLanguage.code,
                sourceText: languageCode == _project.value!.primaryLanguage.code ? value : key,
                targetLanguages: [
                  TranslationTargetLanguageModel(
                    language: language.code,
                    text: value,
                  ),
                ],
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              allImportedEntries.add(newEntry);
            }
          } else if (hasValue && overrideExisting) {
            // 该语言的条目存在，且有值且允许覆盖，需要更新
            LoggerUtils.info('键 "$key" 的语言 "$languageCode" 条目存在，根据配置将覆盖现有翻译');

            final existingEntry = existingEntryForLanguage.first;
            // 更新目标语言列表
            final updatedTargetLanguages = existingEntry.targetLanguages.map((t) {
              if (t.language.code == languageCode.code) {
                return t.copyWith(text: value);
              }
              return t;
            }).toList();

            // 如果该语言不存在，添加它
            if (!updatedTargetLanguages.any((t) => t.language.code == languageCode.code)) {
              updatedTargetLanguages.add(
                TranslationTargetLanguageModel(
                  language: language.code,
                  text: value,
                ),
              );
            }

            final updatedEntry = existingEntry.copyWith(
              sourceText: languageCode == _project.value!.primaryLanguage.code ? value : key,
              targetLanguages: updatedTargetLanguages,
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
          if (Get.isRegistered<TranslationController>(tag: projectId.toString())) {
            final translationController = Get.find<TranslationController>(tag: projectId.toString());
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
        }

        if (updatedEntriesCount > 0) {
          if (message.isNotEmpty) message.write('，');
          message.write('更新了 $updatedEntriesCount 个现有翻译');
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
        name: 'ProjectController',
      );
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
    Map<String, LanguageModel> languageMap,
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
          language: selectedLanguage?.code.code,
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
