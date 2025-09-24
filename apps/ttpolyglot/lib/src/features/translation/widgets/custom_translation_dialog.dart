import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/features/settings/controllers/translation_config_controller.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';

class CustomTranslationDialog extends StatelessWidget {
  const CustomTranslationDialog({
    super.key,
    required this.translationKey,
    required this.entries,
    required this.controller,
  });

  final String translationKey;
  final List<TranslationEntry> entries;
  final TranslationController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Language?>(
      future: controller.getProjectDefaultLanguage(),
      builder: (context, snapshot) {
        final defaultLanguage = snapshot.data;

        return AlertDialog(
          title: Row(
            children: [
              Text(
                '自定义翻译',
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
                  // 选择翻译接口
                  _buildProviderSelector(),
                  const SizedBox(height: 24.0),
                  // 选择源语言
                  _buildSourceLanguageSelector(
                    entries: entries,
                    defaultLanguage: defaultLanguage,
                  ),
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
              onPressed: _saveCustomTranslation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 2.0,
                shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              ),
              child: const Text(
                '开始翻译',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建翻译服务提供商选择器
  Widget _buildProviderSelector() {
    final instance = TranslationConfigController.instance;

    return Obx(() {
      final providers = instance.config.providers;
      final defaultProvider = instance.config.defaultProvider;

      return DropdownButtonFormField<TranslationProviderConfig>(
        value: providers.isEmpty ? null : defaultProvider,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          labelText: '请选择翻译接口',
          labelStyle: TextStyle(
            color: Theme.of(Get.context!).primaryColor,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.translate,
            color: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.7),
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
              color: Theme.of(Get.context!).primaryColor,
              width: 2.0,
            ),
          ),
        ),
        items: providers.map((provider) {
          return DropdownMenuItem<TranslationProviderConfig>(
            value: provider,
            child: Text(provider.displayName),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            // TODO: 实现选择翻译提供商的逻辑
            log('_buildProviderSelector', name: 'CustomTranslationDialog');
          }
        },
      );
    });
  }

  /// 构建源语言选择器
  Widget _buildSourceLanguageSelector({
    required List<TranslationEntry> entries,
    Language? defaultLanguage,
  }) {
    return DropdownButtonFormField<TranslationEntry>(
      value: defaultLanguage != null
          ? entries.firstWhereOrNull((item) => item.targetLanguage.code == defaultLanguage.code)
          : entries.first,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        labelText: '请选择源语言',
        labelStyle: TextStyle(
          color: Theme.of(Get.context!).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.language,
          color: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.7),
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
            color: Theme.of(Get.context!).primaryColor,
            width: 2.0,
          ),
        ),
      ),
      items: entries.map((entry) {
        return DropdownMenuItem<TranslationEntry>(
          value: entry,
          child: SizedBox(
            width: 300.0,
            child: Row(
              spacing: 4.0,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    entry.targetLanguage.code,
                    style: GoogleFonts.notoSansMono(
                      color: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(entry.targetText),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          // TODO: 实现选择翻译提供商的逻辑
          log('_buildSourceLanguageSelector', name: 'CustomTranslationDialog');
        }
      },
    );
  }

  /// 保存自定义翻译设置
  void _saveCustomTranslation() {
    // TODO: 实现自定义翻译逻辑
    log('_saveCustomTranslation', name: 'CustomTranslationDialog');
    Get.back();
  }

  /// 显示自定义翻译弹窗
  static void show({
    required String translationKey,
    required List<TranslationEntry> entries,
    required TranslationController controller,
  }) {
    Get.dialog(
      CustomTranslationDialog(
        translationKey: translationKey,
        entries: entries,
        controller: controller,
      ),
    );
  }
}
