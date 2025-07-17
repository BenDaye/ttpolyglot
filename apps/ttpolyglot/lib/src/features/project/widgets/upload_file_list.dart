import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot_core/core.dart';

class UploadFileList extends StatefulWidget {
  final List<PlatformFile> files;
  final List<Language> languages;
  final List<String> allowedExtensions;
  final VoidCallback? onClear; // 清空文件列表
  final Function(Map<String, Language>, Map<String, Map<String, String>>)? onImport; // 导入文件
  final Function(int index)? onDelete; // 删除文件

  const UploadFileList({
    super.key,
    this.files = const [],
    this.languages = const [],
    this.allowedExtensions = const [],
    this.onClear,
    this.onImport,
    this.onDelete,
  });

  @override
  State<UploadFileList> createState() => _UploadFileListState();
}

class _UploadFileListState extends State<UploadFileList> {
  final Map<String, Language> _fileLanguageMap = {};
  final Map<String, Map<String, String>> _fileTranslationMap = {};

  @override
  void initState() {
    super.initState();
    _importFiles(widget.files);
  }

  @override
  void didUpdateWidget(UploadFileList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.files != widget.files) {
      _importFiles(widget.files);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fileTranslationMap.clear();
    _fileLanguageMap.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 表格标题
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              spacing: 10.0,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '语言',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '文件名',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      '翻译数量',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '已解决/冲突',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ),
                const SizedBox(width: 48.0), // 为删除按钮留出空间
              ],
            ),
          ),

          // 文件列表
          if (widget.files.isNotEmpty) ...[
            ...(widget.files.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return _buildFileTableRow(file, index);
            })),
          ],

          // 底部操作按钮
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    widget.onClear?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: const Text('取消导入'),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    widget.onImport?.call(_fileLanguageMap, _fileTranslationMap);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('导入'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTableRow(PlatformFile file, int index) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        spacing: 10.0,
        children: [
          // 语言
          Expanded(
            flex: 2,
            child: _buildLanguageSelector(file),
          ),
          // 文件名
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          // 翻译数量
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _fileTranslationMap[file.name]?.length.toString() ?? '0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
            ),
          ),
          // 已解决/冲突
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '0 / 0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          // 删除按钮
          SizedBox(
            width: 48.0,
            child: IconButton(
              onPressed: () {
                widget.onDelete?.call(index);
              },
              icon: const Icon(Icons.delete_outline, size: 18.0),
              iconSize: 18.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(
                minWidth: 48.0,
                minHeight: 48.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(PlatformFile file) {
    final selectedLanguage = _fileLanguageMap[file.name];
    final availableLanguages = widget.languages;

    // 如果没有选择语言，尝试自动匹配
    if (selectedLanguage == null && availableLanguages.isNotEmpty) {
      final matchedLanguage = _matchLanguageFromFileName(file.name);
      if (matchedLanguage != null) {
        _fileLanguageMap[file.name] = matchedLanguage;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButton<Language>(
        value: _fileLanguageMap[file.name],
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, size: 16.0),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
        hint: const Text('选择语言'),
        items: availableLanguages
            .map(
              (language) => DropdownMenuItem<Language>(
                value: language,
                child: Text(
                  '${language.nativeName} (${language.code})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
            .toList(),
        onChanged: (language) {
          if (language != null) {
            setState(() {
              _fileLanguageMap[file.name] = language;
            });
          }
        },
      ),
    );
  }

  Language? _matchLanguageFromFileName(String fileName) {
    if (widget.languages.isEmpty) return null;

    final fileNameLower = fileName.toLowerCase();

    // 尝试匹配语言代码
    for (final language in widget.languages) {
      final code = language.code.toLowerCase();
      final languageCode = code.split('-').first;
      if (code == fileName || fileNameLower.contains(languageCode)) {
        log('根据文件名匹配到语言: ${language.nativeName} (${language.code})');
        return language;
      }
    }

    // 如果没有匹配到，返回第一个语言
    log('未匹配到语言，使用默认语言: ${widget.languages.first.nativeName} (${widget.languages.first.code})');
    return widget.languages.first;
  }

  Future<void> _importFiles(List<PlatformFile> files) async {
    _fileTranslationMap.clear();
    for (final file in files) {
      // 获取文件扩展名
      final extension = file.name.split('.').last;
      if (!widget.allowedExtensions.contains(extension)) {
        Get.snackbar('错误', '文件 ${file.name} 不支持的文件类型');
        continue;
      }
      // 根据不同的文件类型，调用不同的导入方法
      switch (extension) {
        case 'json':
          final jsonContent = utf8.decode(file.bytes ?? []);
          final json = jsonDecode(jsonContent);
          if (json is Map<String, dynamic>) {
            _fileTranslationMap[file.name] = json.map(
              (key, value) => MapEntry(
                key,
                value is String ? value : value.toString(),
              ),
            );
            setState(() {});
          } else {
            Get.snackbar('错误', '文件 ${file.name} 不是有效的 JSON 格式');
          }
          break;
        case 'csv':
          final csvContent = utf8.decode(file.bytes ?? []);
          final csvRows = const CsvToListConverter().convert(csvContent);
          // _fileTranslationMap[file.name] = csvRows;
          log('csv: $csvRows');
          break;
        case 'xlsx':
          final excelData = excel.Excel.decodeBytes(file.bytes ?? []);
          // _fileTranslationMap[file.name] = excelData;
          log('xlsx: $excelData');
          break;
        case 'xls':
          final excelData = excel.Excel.decodeBytes(file.bytes ?? []);
          // _fileTranslationMap[file.name] = excelData;
          log('xls: $excelData');
          break;
        case 'arb':
          final arbContent = utf8.decode(file.bytes ?? []);
          // _fileTranslationMap[file.name] = arbContent;
          log('arb: $arbContent');
          break;
        case 'po':
          final poContent = utf8.decode(file.bytes ?? []);
          // _fileTranslationMap[file.name] = poContent;
          log('po: $poContent');
          break;
        default:
          Get.snackbar('错误', '文件 ${file.name} 不支持的文件类型');
          continue;
      }
    }
  }
}
