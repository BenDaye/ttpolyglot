import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/projects/controllers/projects_controller.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目弹窗控制器
class ProjectDialogController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final _selectedDefaultLanguage = Rxn<Language>();
  final _selectedTargetLanguages = <Language>[].obs;
  final _availableLanguages = <Language>[].obs;
  final _isLoading = false.obs;
  final _nameError = Rxn<String>();
  final _isEditMode = false.obs;
  final _editingProject = Rxn<Project>();

  // Getters
  Language? get selectedDefaultLanguage => _selectedDefaultLanguage.value;
  List<Language> get selectedTargetLanguages => _selectedTargetLanguages;
  List<Language> get availableLanguages => _availableLanguages;
  bool get isLoading => _isLoading.value;
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

  /// 初始化语言列表
  void _initializeLanguages() {
    final controller = Get.find<ProjectsController>();
    final presetLanguages = controller.getPresetLanguages();
    _availableLanguages.assignAll(presetLanguages);
    // 设置默认语言为中文
    _selectedDefaultLanguage.value = presetLanguages.firstWhere(
      (lang) => lang.code == 'zh-CN',
      orElse: () => presetLanguages.first,
    );
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
  }

  /// 显示编辑项目默认语言弹窗
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
  }

  /// 重置表单为创建模式
  void _resetForCreate() {
    _isEditMode.value = false;
    _editingProject.value = null;
    _resetForm();
  }

  /// 重置表单为编辑模式
  void _resetForEdit(Project project) {
    _isEditMode.value = true;
    _editingProject.value = project;

    // 填充表单数据
    nameController.text = project.name;
    descriptionController.text = project.description;

    // 设置默认语言
    _selectedDefaultLanguage.value = _availableLanguages.firstWhere(
      (lang) => lang.code == project.defaultLanguage.code,
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

  /// 重置表单
  void _resetForm() {
    nameController.clear();
    descriptionController.clear();
    _selectedTargetLanguages.clear();
    _nameError.value = null;

    // 重置默认语言为中文
    _selectedDefaultLanguage.value = _availableLanguages.firstWhere(
      (lang) => lang.code == 'zh-CN',
      orElse: () => _availableLanguages.first,
    );
  }

  /// 设置默认语言
  void setDefaultLanguage(Language? language) {
    _selectedDefaultLanguage.value = language;
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

    if (_selectedDefaultLanguage.value == null) {
      Get.snackbar('错误', '请选择默认语言');
      return;
    }

    if (_selectedTargetLanguages.isEmpty) {
      Get.snackbar('错误', '请至少选择一个目标语言');
      return;
    }

    // 检查默认语言是否在目标语言中
    if (_selectedTargetLanguages.contains(_selectedDefaultLanguage.value)) {
      Get.snackbar('错误', '默认语言不能同时作为目标语言');
      return;
    }

    _isLoading.value = true;
    _nameError.value = null;

    try {
      final controller = Get.find<ProjectsController>();
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();

      if (_isEditMode.value) {
        // 编辑模式：检查名称是否与其他项目冲突
        if (name != _editingProject.value!.name) {
          final isNameAvailable = await controller.isProjectNameAvailable(name);
          if (!isNameAvailable) {
            _nameError.value = '项目名称已存在';
            _isLoading.value = false;
            return;
          }
        }

        await controller.updateProject(
          _editingProject.value!,
          name: name,
          description: description,
          defaultLanguage: _selectedDefaultLanguage.value!,
          targetLanguages: _selectedTargetLanguages.toList()..sort((a, b) => a.sortIndex.compareTo(b.sortIndex)),
        );

        Get.back(closeOverlays: true);
        Get.snackbar('成功', '项目更新成功');
      } else {
        // 创建模式：检查项目名称是否可用
        final isNameAvailable = await controller.isProjectNameAvailable(name);
        if (!isNameAvailable) {
          _nameError.value = '项目名称已存在';
          _isLoading.value = false;
          return;
        }

        await controller.createProject(
          name: name,
          description: description,
          defaultLanguage: _selectedDefaultLanguage.value!,
          targetLanguages: _selectedTargetLanguages.toList()..sort((a, b) => a.sortIndex.compareTo(b.sortIndex)),
        );

        Get.back(closeOverlays: true);
        Get.snackbar('成功', '项目创建成功');
      }
    } catch (error, stackTrace) {
      log(_isEditMode.value ? '更新项目失败' : '创建项目失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '${_isEditMode.value ? '更新' : '创建'}项目失败: $error');
    } finally {
      _isLoading.value = false;
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
                              // 默认语言
                              Text(
                                '默认语言',
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
                                      value: controller.selectedDefaultLanguage != null &&
                                              controller.availableLanguages
                                                  .any((lang) => lang.code == controller.selectedDefaultLanguage!.code)
                                          ? controller.availableLanguages.firstWhere(
                                              (lang) => lang.code == controller.selectedDefaultLanguage!.code)
                                          : null,
                                      isExpanded: true,
                                      menuMaxHeight: 240.0,
                                      underline: const SizedBox(),
                                      hint: const Text('选择默认语言'),
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
                                      onChanged: controller.setDefaultLanguage,
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
                                        final isDefaultLanguage = controller.selectedDefaultLanguage == language;
                                        final isAlreadySelected = controller.selectedTargetLanguages.contains(language);
                                        final isDisabled = isDefaultLanguage || isAlreadySelected;

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
                                              if (isDefaultLanguage)
                                                const Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    '默认',
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

/*
使用示例：

// 1. 创建新项目
await ProjectDialogController.showCreateDialog();

// 2. 编辑现有项目
final project = await projectsController.getProject(projectId);
if (project != null) {
  await ProjectDialogController.showEditDialog(project);
}

// 3. 在任何地方都可以调用，不需要手动管理控制器生命周期
// 控制器会自动创建和销毁
*/
