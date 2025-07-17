import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

class ProjectExportController extends GetxController {
  final String projectId;
  ProjectExportController({required this.projectId});

  static ProjectExportController getInstance(String projectId) {
    return Get.isRegistered<ProjectExportController>(tag: projectId)
        ? Get.find<ProjectExportController>(tag: projectId)
        : Get.put(ProjectExportController(projectId: projectId), tag: projectId);
  }

  final ProjectServiceImpl _projectService = Get.find<ProjectServiceImpl>();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();
  final ExportServiceImpl _exportService = Get.find<ExportServiceImpl>();

  Future<(Project, List<TranslationEntry>)> _getProjectAndEntries(String projectId) async {
    // 获取项目信息
    final project = await _projectService.getProject(
      projectId,
    );
    if (project == null) {
      throw Exception('项目不存在');
    }

    final entries = await _translationService.getTranslationEntries(
      projectId,
      includeSourceLanguage: true,
    );

    return (project, entries);
  }

  Future<bool> exportTranslationsJson({
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.nested,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  }) async {
    final controller = getInstance(projectId);

    try {
      final (project, entries) = await controller._getProjectAndEntries(projectId);

      final success = await controller._exportService.exportTranslationsJson(
        project: project,
        entries: entries,
        options: options,
      );

      return success;
    } catch (error, stackTrace) {
      log('exportTranslationsShortcutJson', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出翻译文件失败: $error');
      return false;
    }
  }

  /// 导出格式
  /// ------------------------------------------------------------
  /// - [FileFormats.json] 表示 JSON 格式
  ///
  /// - [FileFormats.yaml] 表示 YAML 格式
  ///
  /// - [FileFormats.csv] 表示 CSV 格式
  ///
  /// - [FileFormats.arb] 表示 ARB 格式
  ///
  /// - [FileFormats.properties] 表示 Properties 格式
  ///
  /// - [FileFormats.po] 表示 PO 格式
  ///
  /// ------------------------------------------------------------
  final RxString _exportFormat = FileFormats.json.obs;
  String get exportFormat => _exportFormat.value;
  set exportFormat(String value) {
    if (!FileFormats.isSupported(value)) {
      Get.snackbar('错误', '不支持的格式: $value');
      return;
    }
    _exportFormat.value = value;
  }

  /// 导出语言
  final RxList<Language> _exportLanguages = <Language>[].obs;
  List<Language> get exportLanguages => _exportLanguages;
  set exportLanguages(List<Language> value) {
    _exportLanguages.value = value;
  }

  /// 导出键值风格
  /// ------------------------------------------------------------
  /// - [TranslationKeyStyle.nested] 表示嵌套键值风格
  ///
  /// - [TranslationKeyStyle.flat] 表示扁平键值风格
  ///
  /// ------------------------------------------------------------
  final Rx<TranslationKeyStyle> _exportKeyStyle = TranslationKeyStyle.nested.obs;
  TranslationKeyStyle get exportKeyStyle => _exportKeyStyle.value;
  set exportKeyStyle(TranslationKeyStyle value) {
    _exportKeyStyle.value = value;
  }

  /// 是否将第一级键值拆分成多个文件
  /// ------------------------------------------------------------
  /// 如果 [_separateFirstLevelKeyIntoFiles] 为 true,
  ///
  /// 则将第一级键值拆分成多个文件
  /// 例如：
  /// - auth.json
  /// - user.json
  /// - settings.json
  /// - ...
  /// ------------------------------------------------------------
  /// 如果 [_separateFirstLevelKeyIntoFiles] 为 false,
  ///
  /// 则将所有键值放在一个文件中
  /// 例如:
  /// - translations.json
  final RxBool _separateFirstLevelKeyIntoFiles = false.obs;
  bool get separateFirstLevelKeyIntoFiles => _separateFirstLevelKeyIntoFiles.value;
  set separateFirstLevelKeyIntoFiles(bool value) {
    if (!_useLanguageCodeAsFolderName.value) {
      _separateFirstLevelKeyIntoFiles.value = false;
      return;
    }
    _separateFirstLevelKeyIntoFiles.value = value;
  }

  /// 是否将 language.code 作为文件夹名
  /// ------------------------------------------------------------
  /// 如果 [_useLanguageCodeAsFolderName] 为 true,
  ///
  /// 且 [_separateFirstLevelKeyIntoFiles] 为 false,
  ///
  /// 则使用 [translations.json] 作为文件名.
  /// 例如:
  /// - en-US/translations.json
  /// - zh-CN/translations.json
  /// - ja-JP/translations.json
  /// - ...
  /// ------------------------------------------------------------
  /// 如果 [_useLanguageCodeAsFolderName] 为 true,
  ///
  /// 且 [_separateFirstLevelKeyIntoFiles] 为 true,
  ///
  /// 则按 [_separateFirstLevelKeyIntoFiles] 的逻辑处理
  /// 例如:
  /// - en-US/auth.json
  /// - en-US/user.json
  /// - en-US/settings.json
  /// - zh-CN/auth.json
  /// - zh-CN/user.json
  /// - zh-CN/settings.json
  /// - ja-JP/auth.json
  /// - ja-JP/user.json
  /// - ja-JP/settings.json
  /// - ...
  ///
  /// ------------------------------------------------------------
  ///
  /// 如果 [_useLanguageCodeAsFolderName] 为 false,
  ///
  /// 则忽略判断 [_separateFirstLevelKeyIntoFiles] 的值,
  ///
  /// 直接使用 [language.code] 作为文件名.
  /// 例如:
  /// - en-US.json
  /// - zh-CN.json
  /// - ja-JP.json
  /// - ...
  final RxBool _useLanguageCodeAsFolderName = false.obs;
  bool get useLanguageCodeAsFolderName => _useLanguageCodeAsFolderName.value;
  set useLanguageCodeAsFolderName(bool value) {
    _useLanguageCodeAsFolderName.value = value;
    _separateFirstLevelKeyIntoFiles.value = false;
  }

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  /// 重置表单
  void _resetForm() {
    _exportFormat.value = FileFormats.json;
    _exportLanguages.value = [];
    _exportKeyStyle.value = TranslationKeyStyle.nested;
    _separateFirstLevelKeyIntoFiles.value = false;
    _useLanguageCodeAsFolderName.value = false;
  }

  Future<void> submitForm() async {
    if (!FileFormats.isSupported(exportFormat)) {
      Get.snackbar('错误', '不支持的格式: $exportFormat');
      return;
    }

    if (exportLanguages.isEmpty) {
      Get.snackbar('错误', '请选择导出语言');
      return;
    }

    if (exportLanguages.length != exportLanguages.toSet().length) {
      Get.snackbar('错误', '导出语言不能重复');
      return;
    }

    _isLoading.value = true;

    try {
      final ExportOptions options = ExportOptions(
        languages: exportLanguages,
        keyStyle: exportKeyStyle,
        separateFirstLevelKeyIntoFiles: separateFirstLevelKeyIntoFiles,
        useLanguageCodeAsFolderName: useLanguageCodeAsFolderName,
      );

      bool success = false;

      switch (exportFormat) {
        case FileFormats.json:
          {
            success = await exportTranslationsJson(options: options);
          }

          break;
        case FileFormats.yaml:
        case FileFormats.csv:
        case FileFormats.arb:
        case FileFormats.properties:
        case FileFormats.po:
        default:
          throw UnimplementedError();
      }

      if (!success) return;

      _resetForm();
      Get.snackbar('成功', '翻译文件导出成功');
    } catch (error, stackTrace) {
      log('submitForm', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出翻译文件失败: $error');
    }
  }
}
