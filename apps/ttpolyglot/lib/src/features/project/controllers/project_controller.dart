import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';
import 'package:ttpolyglot/src/features/projects/projects.dart';
import 'package:ttpolyglot_core/core.dart';

class ProjectController extends GetxController {
  late final String projectId;

  final TextEditingController _deleteProjectNameTextController = TextEditingController();

  // 响应式项目对象
  final _project = Rxn<Project>();
  final _isLoading = false.obs;

  // Getters
  Project? get project => _project.value;
  Rxn<Project> get projectObs => _project;
  bool get isLoading => _isLoading.value;

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
    log('ProjectController onReady: $projectId');
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
      log('加载项目失败', error: error, stackTrace: stackTrace);
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

  Future<void> importFiles(List<PlatformFile> files, Map<String, Language> languageMap) async {
    for (final file in files) {
      final language = languageMap[file.name];
      if (language == null) {
        Get.snackbar('错误', '文件 ${file.name} 没有匹配到语言');
        continue;
      }

      // 获取文件扩展名
      final extension = file.name.split('.').last;
      // 根据不同的文件类型，调用不同的导入方法
      if (!allowedExtensions.contains(extension)) {
        Get.snackbar('错误', '文件 ${file.name} 不支持的文件类型');
        continue;
      }

      // 根据不同的文件类型，调用不同的导入方法
      switch (extension) {
        case 'json':
          await importJsonFile(file, language);
          break;
        case 'csv':
          await importCsvFile(file, language);
          break;
        case 'xlsx':
          await importXlsxFile(file, language);
          break;
        case 'xls':
          await importXlsFile(file, language);
          break;
        case 'arb':
          await importArbFile(file, language);
          break;
        case 'po':
          await importPoFile(file, language);
          break;
        default:
          Get.snackbar('错误', '文件 ${file.name} 不支持的文件类型');
          continue;
      }
    }
  }

  Future<void> importJsonFile(PlatformFile file, Language language) async {
    // log('importJsonFile: $file, language: $language');
    // 获取json文件内容
    final jsonContent = utf8.decode(file.bytes!);
    // 解析json
    final json = jsonDecode(jsonContent);
    log('json: $json');
    // 将json内容导入到项目中
  }

  Future<void> importCsvFile(PlatformFile file, Language language) async {
    // log('importCsvFile: $file, language: $language');
    // 获取csv文件内容
    final csvContent = utf8.decode(file.bytes!);
    // 解析csv
    final csvRows = const CsvToListConverter().convert(csvContent);
    log('csv: $csvRows');
    // 将csv内容导入到项目中
  }

  Future<void> importXlsxFile(PlatformFile file, Language language) async {
    // log('importXlsxFile: $file, language: $language');
    // 解析xlsx
    final excel = Excel.decodeBytes(file.bytes!);
    log('xlsx: $excel');
    // 将xlsx内容导入到项目中
  }

  Future<void> importXlsFile(PlatformFile file, Language language) async {
    // log('importXlsFile: $file, language: $language');
    // 解析xls
    final excel = Excel.decodeBytes(file.bytes!);
    log('xls: $excel');
    // 将xls内容导入到项目中
  }

  Future<void> importArbFile(PlatformFile file, Language language) async {
    // log('importArbFile: $file, language: $language');
    // 获取arb文件内容
    final arbContent = utf8.decode(file.bytes!);
    log('arb: $arbContent');
    // 将arb内容导入到项目中
  }

  Future<void> importPoFile(PlatformFile file, Language language) async {
    // log('importPoFile: $file, language: $language');
    // 获取po文件内容
    final poContent = utf8.decode(file.bytes!);
    log('po: $poContent');
    // 将po内容导入到项目中
  }

  // 
}
