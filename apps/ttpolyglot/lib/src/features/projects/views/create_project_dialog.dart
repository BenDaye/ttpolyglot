import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot_core/core.dart';

import 'package:ttpolyglot/src/features/projects/controllers/projects_controller.dart';

/// 创建项目弹窗
class CreateProjectDialog extends StatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Language? _selectedDefaultLanguage;
  final List<Language> _selectedTargetLanguages = [];
  final List<Language> _availableLanguages = [];
  bool _isLoading = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _initializeLanguages();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeLanguages() {
    final controller = Get.find<ProjectsController>();
    final presetLanguages = controller.getPresetLanguages();
    setState(() {
      _availableLanguages.addAll(presetLanguages);
      // 设置默认语言为中文，确保使用列表中的同一个对象
      _selectedDefaultLanguage = presetLanguages.firstWhere(
        (lang) => lang.code == 'zh-CN',
        orElse: () => presetLanguages.first,
      );
    });
  }

  void _toggleTargetLanguage(Language language) {
    setState(() {
      if (_selectedTargetLanguages.contains(language)) {
        _selectedTargetLanguages.remove(language);
      } else {
        _selectedTargetLanguages.add(language);
      }
    });
  }

  void _removeTargetLanguage(Language language) {
    setState(() {
      _selectedTargetLanguages.remove(language);
    });
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _selectedTargetLanguages.clear();
    _nameError = null;
    // 重置默认语言为中文
    _selectedDefaultLanguage = _availableLanguages.firstWhere(
      (lang) => lang.code == 'zh-CN',
      orElse: () => _availableLanguages.first,
    );
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDefaultLanguage == null) {
      Get.snackbar('错误', '请选择默认语言');
      return;
    }

    if (_selectedTargetLanguages.isEmpty) {
      Get.snackbar('错误', '请至少选择一个目标语言');
      return;
    }

    // 检查默认语言是否在目标语言中
    if (_selectedTargetLanguages.contains(_selectedDefaultLanguage)) {
      Get.snackbar('错误', '默认语言不能同时作为目标语言');
      return;
    }

    setState(() {
      _isLoading = true;
      _nameError = null;
    });

    try {
      final controller = Get.find<ProjectsController>();

      // 检查项目名称是否可用
      final isNameAvailable = await controller.isProjectNameAvailable(_nameController.text.trim());
      if (!isNameAvailable) {
        setState(() {
          _nameError = '项目名称已存在';
          _isLoading = false;
        });
        return;
      }

      await controller.createProject(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        defaultLanguage: _selectedDefaultLanguage!,
        targetLanguages: _selectedTargetLanguages,
      );

      // 重置表单
      _resetForm();

      // 关闭弹窗
      Get.back(closeOverlays: true);

      Get.snackbar('成功', '项目创建成功');
    } catch (error, stackTrace) {
      log('创建项目失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '创建项目失败: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 700,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '创建新项目',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 表单 - 添加滚动功能
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 项目名称
                        Text(
                          '项目名称',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: '请输入项目名称',
                            errorText: _nameError,
                            contentPadding: const EdgeInsets.all(12.0),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '项目名称不能为空';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 项目描述
                        Text(
                          '项目描述',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: '请输入项目描述',
                            contentPadding: const EdgeInsets.all(12.0),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '项目描述不能为空';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 默认语言
                        Text(
                          '默认语言',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButton<Language>(
                            value: _selectedDefaultLanguage != null &&
                                    _availableLanguages.any((lang) => lang.code == _selectedDefaultLanguage!.code)
                                ? _availableLanguages.firstWhere((lang) => lang.code == _selectedDefaultLanguage!.code)
                                : null,
                            isExpanded: true,
                            menuMaxHeight: 240,
                            underline: const SizedBox(),
                            hint: const Text('选择默认语言'),
                            items: _availableLanguages.map((language) {
                              return DropdownMenuItem<Language>(
                                value: language,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 16,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          language.code.split('-')[0].toUpperCase(),
                                          style: const TextStyle(fontSize: 10),
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
                            onChanged: (language) {
                              setState(() {
                                _selectedDefaultLanguage = language;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 目标语言
                        Text(
                          '目标语言',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),

                        // 目标语言选择 dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<Language>(
                            value: null, // 始终为空，因为选择后会添加到列表中
                            isExpanded: true,
                            menuMaxHeight: 240,
                            underline: const SizedBox(),
                            hint: const Text('选择目标语言'),
                            items: _availableLanguages.map((language) {
                              final isDefaultLanguage = _selectedDefaultLanguage == language;
                              final isAlreadySelected = _selectedTargetLanguages.contains(language);
                              final isDisabled = isDefaultLanguage || isAlreadySelected;

                              return DropdownMenuItem<Language>(
                                value: language,
                                enabled: !isDisabled,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 16,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          language.code.split('-')[0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
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
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text(
                                          '默认',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    if (isAlreadySelected)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (language) {
                              if (language != null) {
                                _toggleTargetLanguage(language);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 已选择的目标语言
                        if (_selectedTargetLanguages.isNotEmpty) ...[
                          Text(
                            '已选择的目标语言',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedTargetLanguages.map((language) {
                              return Chip(
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                                avatar: Container(
                                  width: 24,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      language.code.split('-')[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                avatarBoxConstraints: BoxConstraints(
                                  maxWidth: 48,
                                  maxHeight: 16,
                                ),
                                label: Text('${language.name} (${language.nativeName})'),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => _removeTargetLanguage(language),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                        ],

                        const SizedBox(height: 16), // 底部间距
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Get.back(),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createProject,
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('创建项目'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
