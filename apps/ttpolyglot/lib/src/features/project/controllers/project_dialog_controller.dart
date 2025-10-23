import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目弹窗控制器
class ProjectDialogController extends GetxController {
  final ProjectApi _projectApi = Get.find<ProjectApi>();
  final LanguageApi _languageApi = Get.find<LanguageApi>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final _selectedPrimaryLanguage = Rxn<Language>();
  final _selectedTargetLanguages = <Language>[].obs;
  final _availableLanguages = <Language>[].obs;
  final _isLoading = false.obs;
  final _isLoadingLanguages = false.obs;
  final _nameError = Rxn<String>();
  final _isEditMode = false.obs;
  final _editingProject = Rxn<Project>();

  // Getters
  Language? get selectedPrimaryLanguage => _selectedPrimaryLanguage.value;
  List<Language> get selectedTargetLanguages => _selectedTargetLanguages;
  List<Language> get availableLanguages => _availableLanguages;
  bool get isLoading => _isLoading.value;
  bool get isLoadingLanguages => _isLoadingLanguages.value;
  String? get nameError => _nameError.value;
  bool get isEditMode => _isEditMode.value;
  Project? get editingProject => _editingProject.value;

  @override
  void onInit() {
    super.onInit();
    _initializeLanguages();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  /// 将 LanguageModel 转换为 Language
  List<Language> _convertToLanguages(List<LanguageModel> models) {
    return models.map((model) {
      return Language(
        code: model.code.code,
        name: model.name,
        nativeName: model.nativeName ?? model.name,
        isRtl: model.isRtl,
        sortIndex: model.sortOrder,
      );
    }).toList();
  }

  /// 初始化语言列表
  Future<void> _initializeLanguages() async {
    try {
      _isLoadingLanguages.value = true;

      // 尝试从 API 获取语言列表
      try {
        final apiLanguages = await _languageApi.getLanguages();
        if (apiLanguages.isNotEmpty) {
          _availableLanguages.assignAll(_convertToLanguages(apiLanguages));
          Logger.info('从 API 加载 ${apiLanguages.length} 个语言');
        } else {
          // API 返回空数据，使用默认语言列表
          final defaultLanguages = LanguageEnum.toArray();
          _availableLanguages.assignAll(_convertToLanguages(defaultLanguages));
          Logger.warning('API 返回空数据，使用默认语言列表');
        }
      } catch (error, stackTrace) {
        // API 请求失败，使用默认语言列表
        Logger.error('从 API 加载语言失败，使用默认语言列表', error: error, stackTrace: stackTrace);
        final defaultLanguages = LanguageEnum.toArray();
        _availableLanguages.assignAll(_convertToLanguages(defaultLanguages));
      }

      // 设置主语言为中文
      _selectedPrimaryLanguage.value = _availableLanguages.firstWhere(
        (lang) => lang.code == 'zh-CN',
        orElse: () => _availableLanguages.first,
      );
    } finally {
      _isLoadingLanguages.value = false;
    }
  }

  /// 显示创建项目弹窗
  static Future<void> showCreateDialog() async {
    final tag = 'project_dialog_controller_${DateTime.now().millisecondsSinceEpoch}_project_create';
    final controller = Get.put(ProjectDialogController(), tag: tag);
    controller._resetForCreate();
    await Get.dialog(
      ProjectDialog(tag: tag),
      barrierDismissible: false,
    );

    if (Get.isRegistered<ProjectDialogController>(tag: tag)) {
      Get.delete<ProjectDialogController>(tag: tag);
    }
  }

  /// 显示编辑项目弹窗
  static Future<void> showEditDialog(Project project) async {
    final tag = 'project_dialog_controller_${DateTime.now().millisecondsSinceEpoch}_project_${project.id}';
    final controller = Get.put(ProjectDialogController(), tag: tag);
    controller._resetForEdit(project);
    await Get.dialog(
      ProjectDialog(tag: tag),
      barrierDismissible: false,
    );
    if (Get.isRegistered<ProjectDialogController>(tag: tag)) {
      Get.delete<ProjectDialogController>(tag: tag);
    }

    _refreshProject(project.id);
  }

  /// 显示编辑项目目标语言弹窗
  static Future<void> showEditTargetLanguagesDialog(Project project) async {
    final tag = 'project_dialog_controller_${DateTime.now().millisecondsSinceEpoch}_project_${project.id}';
    final controller = Get.put(ProjectDialogController(), tag: tag);
    controller._resetForEdit(project);
    await Get.dialog(
      ProjectDialog(
        tag: tag,
        dialogModule: const [ProjectDialogModule.targetLanguages],
      ),
      barrierDismissible: false,
    );
    if (Get.isRegistered<ProjectDialogController>(tag: tag)) {
      Get.delete<ProjectDialogController>(tag: tag);
    }

    _refreshProject(project.id);
  }

  /// 显示编辑项目主语言弹窗
  static Future<void> showEditDefaultLanguagesDialog(Project project) async {
    final tag = 'project_dialog_controller_${DateTime.now().millisecondsSinceEpoch}_project_${project.id}';
    final controller = Get.put(ProjectDialogController(), tag: tag);
    controller._resetForEdit(project);
    await Get.dialog(
      ProjectDialog(
        tag: tag,
        dialogModule: const [ProjectDialogModule.defaultLanguage],
      ),
      barrierDismissible: false,
    );
    if (Get.isRegistered<ProjectDialogController>(tag: tag)) {
      Get.delete<ProjectDialogController>(tag: tag);
    }

    _refreshProject(project.id);
  }

  /// 显示编辑项目名称弹窗
  static Future<void> showEditNameDialog(Project project) async {
    final tag = 'project_dialog_controller_${DateTime.now().millisecondsSinceEpoch}_project_${project.id}';
    final controller = Get.put(ProjectDialogController(), tag: tag);
    controller._resetForEdit(project);
    await Get.dialog(
      ProjectDialog(
        tag: tag,
        dialogModule: const [ProjectDialogModule.name],
      ),
      barrierDismissible: false,
    );
    if (Get.isRegistered<ProjectDialogController>(tag: tag)) {
      Get.delete<ProjectDialogController>(tag: tag);
    }

    _refreshProject(project.id);
  }

  /// 显示编辑项目描述弹窗
  static Future<void> showEditDescriptionDialog(Project project) async {
    final tag = 'project_dialog_controller_${DateTime.now().millisecondsSinceEpoch}_project_${project.id}';
    final controller = Get.put(ProjectDialogController(), tag: tag);
    controller._resetForEdit(project);
    await Get.dialog(
      ProjectDialog(
        tag: tag,
        dialogModule: const [ProjectDialogModule.description],
      ),
      barrierDismissible: false,
    );
    if (Get.isRegistered<ProjectDialogController>(tag: tag)) {
      Get.delete<ProjectDialogController>(tag: tag);
    }

    _refreshProject(project.id);
  }

  /// 刷新项目数据
  static void _refreshProject(String projectId) {
    if (Get.isRegistered<ProjectController>(tag: projectId)) {
      final controller = Get.find<ProjectController>(tag: projectId);
      controller.loadProject();
    }
  }

  /// 重置表单为创建模式
  void _resetForCreate() {
    _isEditMode.value = false;
    _editingProject.value = null;

    // 清空表单数据
    nameController.clear();
    descriptionController.clear();

    // 重置为默认主语言（中文）
    final presetLanguages = ProjectsController.getPresetLanguages();
    _selectedPrimaryLanguage.value = presetLanguages.firstWhere(
      (lang) => lang.code == 'zh-CN',
      orElse: () => presetLanguages.first,
    );

    // 清空目标语言
    _selectedTargetLanguages.clear();

    _nameError.value = null;
  }

  /// 重置表单为编辑模式
  void _resetForEdit(Project project) {
    _isEditMode.value = true;
    _editingProject.value = project;

    // 填充表单数据
    nameController.text = project.name;
    descriptionController.text = project.description;

    // 设置主语言（编辑模式下不可修改）
    _selectedPrimaryLanguage.value = _availableLanguages.firstWhere(
      (lang) => lang.code == project.primaryLanguage.code,
      orElse: () => _availableLanguages.first,
    );

    // 设置目标语言
    _selectedTargetLanguages.clear();
    for (final targetLang in project.targetLanguages) {
      final lang = _availableLanguages.firstWhere(
        (lang) => lang.code == targetLang.code,
        orElse: () => targetLang,
      );
      _selectedTargetLanguages.add(lang);
    }

    _nameError.value = null;
  }

  /// 设置主语言
  void setPrimaryLanguage(Language? language) {
    _selectedPrimaryLanguage.value = language;
    if (language != null) {
      _selectedTargetLanguages.remove(language);
    }
  }

  /// 切换目标语言
  void toggleTargetLanguage(Language language) {
    if (_selectedTargetLanguages.contains(language)) {
      _selectedTargetLanguages.remove(language);
    } else {
      _selectedTargetLanguages.add(language);
    }
  }

  /// 移除目标语言
  void removeTargetLanguage(Language language) {
    _selectedTargetLanguages.remove(language);
  }

  /// 提交表单
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    if (_selectedPrimaryLanguage.value == null) {
      Get.snackbar('错误', '请选择主语言');
      return;
    }

    if (_selectedTargetLanguages.isEmpty) {
      Get.snackbar('错误', '请至少选择一个目标语言');
      return;
    }

    // 检查主语言是否在目标语言中
    if (_selectedTargetLanguages.contains(_selectedPrimaryLanguage.value)) {
      Get.snackbar('错误', '主语言不能同时作为目标语言');
      return;
    }

    _isLoading.value = true;
    _nameError.value = null;

    try {
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      final primaryLanguageCode = _selectedPrimaryLanguage.value!.code;

      if (_isEditMode.value) {
        // 编辑模式：检查名称是否与其他项目冲突
        if (name != _editingProject.value!.name) {
          final projectId = int.tryParse(_editingProject.value!.id);
          final isNameAvailable = await _projectApi.checkProjectNameAvailable(
            name,
            excludeProjectId: projectId,
          );
          if (!isNameAvailable) {
            _nameError.value = '项目名称已存在';
            _isLoading.value = false;
            return;
          }
        }

        final projectId = int.parse(_editingProject.value!.id);
        await _projectApi.updateProject(
          projectId: projectId,
          name: name,
          description: description,
        );

        Get.back(closeOverlays: true);
        Get.snackbar('成功', '项目更新成功');

        // 刷新项目列表
        await _refreshProjectsList();
      } else {
        // 创建模式：检查项目名称是否可用
        final isNameAvailable = await _projectApi.checkProjectNameAvailable(name);
        if (!isNameAvailable) {
          _nameError.value = '项目名称已存在';
          _isLoading.value = false;
          return;
        }

        await _projectApi.createProject(
          name: name,
          description: description,
          primaryLanguageCode: primaryLanguageCode,
          visibility: 'private',
        );

        Get.back(closeOverlays: true);
        Get.snackbar('成功', '项目创建成功');

        // 刷新项目列表
        await _refreshProjectsList();
      }
    } catch (error, stackTrace) {
      Logger.error(_isEditMode.value ? '更新项目失败' : '创建项目失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '${_isEditMode.value ? '更新' : '创建'}项目失败: $error');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 刷新项目列表
  Future<void> _refreshProjectsList() async {
    try {
      if (Get.isRegistered<ProjectsController>()) {
        await ProjectsController.loadProjects();
      }
    } catch (error, stackTrace) {
      Logger.error('刷新项目列表失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 关闭弹窗
  void closeDialog() {
    Get.back();
  }
}

enum ProjectDialogModule {
  name,
  description,
  defaultLanguage,
  targetLanguages,
}

/// 项目弹窗组件
class ProjectDialog extends StatelessWidget {
  const ProjectDialog({
    super.key,
    required this.tag,
    this.dialogModule = const [
      ProjectDialogModule.name,
      ProjectDialogModule.description,
      ProjectDialogModule.defaultLanguage,
      ProjectDialogModule.targetLanguages,
    ],
  });

  final String tag;
  final List<ProjectDialogModule> dialogModule;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectDialogController>(
      tag: tag,
      builder: (controller) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            width: 640.0,
            height: 720.0,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                          controller.isEditMode ? '编辑项目' : '创建新项目',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                    IconButton(
                      onPressed: controller.closeDialog,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // 表单
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Form(
                      key: controller.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (dialogModule.contains(ProjectDialogModule.name)) ...[
                              // 项目名称
                              Text(
                                '项目名称',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                              Obx(
                                () => TextFormField(
                                  controller: controller.nameController,
                                  decoration: InputDecoration(
                                    hintText: '请输入项目名称',
                                    errorText: controller.nameError,
                                    contentPadding: const EdgeInsets.all(12.0),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return '项目名称不能为空';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                            if (dialogModule.contains(ProjectDialogModule.description)) ...[
                              // 项目描述
                              Text(
                                '项目描述',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: controller.descriptionController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: '请输入项目描述',
                                  contentPadding: EdgeInsets.all(12.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return '项目描述不能为空';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16.0),
                            ],
                            if (dialogModule.contains(ProjectDialogModule.defaultLanguage)) ...[
                              // 主语言
                              Text(
                                '主语言',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                              Obx(() => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainer,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: DropdownButton<Language>(
                                      value: controller.selectedPrimaryLanguage != null &&
                                              controller.availableLanguages
                                                  .any((lang) => lang.code == controller.selectedPrimaryLanguage!.code)
                                          ? controller.availableLanguages.firstWhere(
                                              (lang) => lang.code == controller.selectedPrimaryLanguage!.code)
                                          : null,
                                      isExpanded: true,
                                      menuMaxHeight: 240.0,
                                      underline: const SizedBox(),
                                      hint: const Text('选择主语言'),
                                      items: controller.availableLanguages.map((language) {
                                        return DropdownMenuItem<Language>(
                                          value: language,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24.0,
                                                height: 16.0,
                                                margin: const EdgeInsets.only(right: 8.0),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(2.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    language.code.split('-')[0].toUpperCase(),
                                                    style: const TextStyle(fontSize: 10.0),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text('${language.name} (${language.nativeName})'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: controller.setPrimaryLanguage,
                                    ),
                                  )),
                              const SizedBox(height: 16.0),
                            ],
                            if (dialogModule.contains(ProjectDialogModule.targetLanguages)) ...[
                              // 目标语言
                              Text(
                                '目标语言',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8.0),

                              // 目标语言选择 dropdown
                              Obx(
                                () => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: DropdownButton<Language>(
                                    value: null,
                                    isExpanded: true,
                                    menuMaxHeight: 240.0,
                                    underline: const SizedBox(),
                                    hint: const Text('选择目标语言'),
                                    items: controller.availableLanguages.map(
                                      (language) {
                                        final isPrimaryLanguage = controller.selectedPrimaryLanguage == language;
                                        final isAlreadySelected = controller.selectedTargetLanguages.contains(language);
                                        final isDisabled = isPrimaryLanguage || isAlreadySelected;

                                        return DropdownMenuItem<Language>(
                                          value: language,
                                          enabled: !isDisabled,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24.0,
                                                height: 16.0,
                                                margin: const EdgeInsets.only(right: 8.0),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(2.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    language.code.split('-')[0].toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: isDisabled ? Theme.of(context).disabledColor : null,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${language.name} (${language.nativeName})',
                                                  style: TextStyle(
                                                    color: isDisabled ? Theme.of(context).disabledColor : null,
                                                  ),
                                                ),
                                              ),
                                              if (isPrimaryLanguage)
                                                const Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    '主语言',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              if (isAlreadySelected)
                                                const Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 16.0,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (language) {
                                      if (language != null) {
                                        controller.toggleTargetLanguage(language);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // 已选择的目标语言
                              Obx(
                                () => controller.selectedTargetLanguages.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '已选择的目标语言',
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children: controller.selectedTargetLanguages.map(
                                              (language) {
                                                return Chip(
                                                  backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                                                  avatar: Container(
                                                    width: 24.0,
                                                    height: 16.0,
                                                    margin: const EdgeInsets.only(right: 4.0),
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(2.0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        language.code.split('-')[0].toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: Theme.of(context).colorScheme.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  avatarBoxConstraints: const BoxConstraints(
                                                    maxWidth: 48.0,
                                                    maxHeight: 16.0,
                                                  ),
                                                  label: Text('${language.name} (${language.nativeName})'),
                                                  deleteIcon: const Icon(Icons.close, size: 16.0),
                                                  onDeleted: () => controller.removeTargetLanguage(language),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                          const SizedBox(height: 8.0),
                                        ],
                                      )
                                    : const SizedBox(),
                              ),

                              const SizedBox(height: 16.0),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                // 按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                      () => TextButton(
                        onPressed: controller.isLoading ? null : controller.closeDialog,
                        child: const Text('取消'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading ? null : controller.submitForm,
                        child: controller.isLoading
                            ? const SizedBox(
                                width: 16.0,
                                height: 16.0,
                                child: CircularProgressIndicator(strokeWidth: 2.0),
                              )
                            : Text(controller.isEditMode ? '更新项目' : '创建项目'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
