import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot_core/core.dart';

/// 语言选择弹窗
class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({
    super.key,
    required this.availableLanguages,
    required this.onLanguageSelected,
    this.title = '选择源语言',
    this.subtitle = '请选择要翻译的源语言',
  });

  final List<Language> availableLanguages;
  final Function(Language) onLanguageSelected;
  final String title;
  final String subtitle;

  /// 显示语言选择弹窗
  static Future<Language?> show({
    required BuildContext context,
    required List<Language> availableLanguages,
    String title = '选择源语言',
    String subtitle = '请选择要翻译的源语言',
  }) {
    return Get.dialog<Language>(
      LanguageSelectionDialog(
        availableLanguages: availableLanguages,
        onLanguageSelected: (language) => Get.back(result: language),
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.language,
            color: Theme.of(context).primaryColor,
            size: 24.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16.0),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300.0,
              minHeight: 200.0,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: availableLanguages.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                final language = availableLanguages[index];
                return _buildLanguageItem(context, language);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('取消'),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
    );
  }

  /// 构建语言选项
  Widget _buildLanguageItem(BuildContext context, Language language) {
    return InkWell(
      onTap: () => onLanguageSelected(language),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // 语言标识
            Container(
              width: 32.0,
              height: 24.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  language.code.split('-')[0].toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.0,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            // 语言信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${language.nativeName} (${language.code})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            // 选择图标
            Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
