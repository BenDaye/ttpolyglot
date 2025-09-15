import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot_core/core.dart';

import '../controllers/translation_config_controller.dart';

/// 翻译接口弹窗模式
enum ProviderDialogMode {
  /// 添加模式
  add,

  /// 编辑模式
  edit,
}

/// 统一的翻译接口弹窗组件
class ProviderDialog extends StatefulWidget {
  const ProviderDialog({
    super.key,
    required this.controller,
    required this.mode,
    this.config,
    this.onSuccess,
  });

  /// 翻译配置控制器
  final TranslationConfigController controller;

  /// 弹窗模式
  final ProviderDialogMode mode;

  /// 编辑模式时的配置（仅编辑模式需要）
  final TranslationProviderConfig? config;

  /// 成功回调
  final VoidCallback? onSuccess;

  @override
  State<ProviderDialog> createState() => _ProviderDialogState();
}

class _ProviderDialogState extends State<ProviderDialog> {
  late TranslationProvider selectedProvider;
  late TextEditingController nameController;
  late TextEditingController appIdController;
  late TextEditingController appKeyController;
  late TextEditingController apiUrlController;
  late bool isDefault;

  // 错误状态
  String? nameError;
  String? appIdError;
  String? appKeyError;
  String? apiUrlError;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// 初始化控制器
  void _initializeControllers() {
    if (widget.mode == ProviderDialogMode.edit && widget.config != null) {
      // 编辑模式：使用现有配置初始化
      final config = widget.config!;
      selectedProvider = config.provider;
      nameController = TextEditingController(text: config.name);
      appIdController = TextEditingController(text: config.appId);
      appKeyController = TextEditingController(text: config.appKey);
      apiUrlController = TextEditingController(text: config.apiUrl ?? '');
      isDefault = config.isDefault;
    } else {
      // 添加模式：使用默认值
      selectedProvider = TranslationProvider.google;
      nameController = TextEditingController();
      appIdController = TextEditingController();
      appKeyController = TextEditingController();
      apiUrlController = TextEditingController();
      isDefault = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    appIdController.dispose();
    appKeyController.dispose();
    apiUrlController.dispose();
    super.dispose();
  }

  /// 验证输入
  bool _validateInputs() {
    bool isValid = true;

    // 重置错误状态
    nameError = null;
    appIdError = null;
    appKeyError = null;
    apiUrlError = null;

    // 验证名称
    if (nameController.text.trim().isEmpty) {
      nameError = '请输入翻译接口名称';
      isValid = false;
    } else {
      // 检查名称唯一性
      final nameExists = widget.controller.config.providers.any((p) {
        // 编辑模式时排除当前配置
        if (widget.mode == ProviderDialogMode.edit && widget.config != null) {
          return p.id != widget.config!.id && p.name?.toLowerCase() == nameController.text.trim().toLowerCase();
        }
        return p.name?.toLowerCase() == nameController.text.trim().toLowerCase();
      });

      if (nameExists) {
        nameError = '该名称已存在，请使用其他名称';
        isValid = false;
      }
    }

    // 验证App ID（谷歌翻译不需要）
    if (selectedProvider != TranslationProvider.google && appIdController.text.trim().isEmpty) {
      appIdError = selectedProvider == TranslationProvider.custom ? '请输入API密钥' : '请输入应用ID';
      isValid = false;
    }

    // 验证App Key（非自定义翻译和谷歌翻译）
    if (selectedProvider != TranslationProvider.custom &&
        selectedProvider != TranslationProvider.google &&
        appKeyController.text.trim().isEmpty) {
      appKeyError = '请输入应用密钥';
      isValid = false;
    }

    // 验证API URL（仅自定义翻译）
    if (selectedProvider == TranslationProvider.custom && apiUrlController.text.trim().isEmpty) {
      apiUrlError = '请输入API地址';
      isValid = false;
    }

    // 验证API URL格式（仅自定义翻译）
    if (selectedProvider == TranslationProvider.custom &&
        apiUrlController.text.trim().isNotEmpty &&
        !apiUrlController.text.trim().startsWith('http')) {
      apiUrlError = 'API地址必须以http或https开头';
      isValid = false;
    }

    return isValid;
  }

  /// 保存配置
  void _saveConfig() {
    if (!_validateInputs()) {
      setState(() {});
      return;
    }

    try {
      if (widget.mode == ProviderDialogMode.add) {
        // 添加模式
        widget.controller.addTranslationProvider(
          provider: selectedProvider,
          name: nameController.text.trim(),
          appId: appIdController.text.trim(),
          appKey: selectedProvider != TranslationProvider.custom ? appKeyController.text.trim() : null,
          apiUrl: selectedProvider == TranslationProvider.custom ? apiUrlController.text.trim() : null,
          isDefault: isDefault,
        );

        // // 显示成功提示
        Future.microtask(() {
          Get.snackbar(
            '成功',
            '翻译接口 "${nameController.text.trim()}" 添加成功',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withValues(alpha: 0.9),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16.0),
            borderRadius: 8.0,
          );
        });

        // 调用成功回调来展开列表
        widget.onSuccess?.call();
      } else {
        // 编辑模式
        widget.controller.updateProviderConfigById(
          widget.config!.id,
          name: nameController.text.trim(),
          appId: appIdController.text.trim(),
          appKey: widget.config!.provider != TranslationProvider.custom ? appKeyController.text.trim() : null,
          apiUrl: widget.config!.provider == TranslationProvider.custom ? apiUrlController.text.trim() : null,
          isDefault: isDefault,
        );
      }
      Get.back();
    } catch (error, stackTrace) {
      log('保存翻译接口配置失败', error: error, stackTrace: stackTrace, name: 'ProviderDialog');
      Get.snackbar(
        '错误',
        '保存失败，请重试',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(
            widget.mode == ProviderDialogMode.add ? '添加翻译接口' : '编辑翻译接口',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close,
              color: Colors.grey.shade600,
              size: 24.0,
            ),
            padding: const EdgeInsets.all(8.0),
            constraints: const BoxConstraints(),
            splashRadius: 28.0,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8.0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      content: Container(
        width: 480.0,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 翻译提供商选择
              _buildProviderSelector(),
              const SizedBox(height: 16.0),

              // 名称输入框
              _buildNameField(),
              const SizedBox(height: 20.0),

              // App ID 输入框
              _buildAppIdField(),
              const SizedBox(height: 20.0),

              // App Key 输入框（非自定义翻译）
              if (selectedProvider != TranslationProvider.custom) ...[
                _buildAppKeyField(),
                const SizedBox(height: 16.0),
              ],

              // API URL 输入框（仅自定义翻译）
              if (selectedProvider == TranslationProvider.custom) ...[
                _buildApiUrlField(),
                const SizedBox(height: 16.0),
              ],

              // 默认翻译开关
              _buildDefaultSwitch(),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            '取消',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: _saveConfig,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 2.0,
            shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
          child: Text(
            widget.mode == ProviderDialogMode.add ? '添加' : '保存',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建翻译提供商选择器
  Widget _buildProviderSelector() {
    if (widget.mode == ProviderDialogMode.edit) {
      // 编辑模式：只读显示
      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.translate,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
              size: 20.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '翻译提供商',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    selectedProvider.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.lock,
              color: Colors.grey.shade400,
              size: 16.0,
            ),
          ],
        ),
      );
    } else {
      // 添加模式：可选择
      return DropdownButtonFormField<TranslationProvider>(
        value: selectedProvider,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12.0),
          labelText: '翻译提供商',
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.translate,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
            size: 20.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
          ),
        ),
        items: TranslationProvider.values.map((provider) {
          return DropdownMenuItem(
            value: provider,
            child: Text(provider.name),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedProvider = value!;
          });
        },
      );
    }
  }

  /// 构建名称输入框
  Widget _buildNameField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.0),
        labelText: '名称',
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
          size: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        hintText: '输入翻译接口名称',
        hintStyle: TextStyle(
          color: Colors.grey.withValues(alpha: 0.6),
          fontSize: 14.0,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        errorText: nameError,
      ),
    );
  }

  /// 构建App ID输入框
  Widget _buildAppIdField() {
    return TextField(
      controller: appIdController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.0),
        labelText: selectedProvider == TranslationProvider.custom ? 'API Key' : 'App ID',
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.account_circle,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
          size: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        hintText: selectedProvider == TranslationProvider.custom ? '输入API密钥' : '输入应用ID',
        hintStyle: TextStyle(
          color: Colors.grey.withValues(alpha: 0.6),
          fontSize: 14.0,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        errorText: appIdError,
      ),
    );
  }

  /// 构建App Key输入框
  Widget _buildAppKeyField() {
    return TextField(
      controller: appKeyController,
      maxLines: 3,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.0),
        labelText: 'App Key',
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
          size: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        hintText: '输入应用密钥',
        hintStyle: TextStyle(
          color: Colors.grey.withValues(alpha: 0.6),
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        errorText: appKeyError,
      ),
    );
  }

  /// 构建API URL输入框
  Widget _buildApiUrlField() {
    return TextField(
      controller: apiUrlController,
      maxLines: 3,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12.0),
        labelText: 'API 地址',
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.link,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
          size: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        hintText: '输入自定义翻译API地址',
        hintStyle: TextStyle(
          color: Colors.grey.withValues(alpha: 0.6),
          fontSize: 14.0,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        errorText: apiUrlError,
      ),
    );
  }

  /// 构建默认翻译开关
  Widget _buildDefaultSwitch() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: Theme.of(context).primaryColor,
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          const Expanded(
            child: Text(
              '设为默认翻译接口',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: isDefault,
            onChanged: (value) {
              setState(() {
                isDefault = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
