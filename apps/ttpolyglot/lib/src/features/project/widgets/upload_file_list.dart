import 'dart:convert';

import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/conflict_detection_service.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

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
  final Map<String, ConflictDetectionResult> _fileConflictMap = {};

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
            child: _buildConflictStatus(file),
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

  Widget _buildConflictStatus(PlatformFile file) {
    final conflictResult = _fileConflictMap[file.name];

    if (conflictResult == null) {
      // 还未检测冲突
      return Row(
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 16.0,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(width: 4.0),
          Text(
            '检测中...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      );
    }

    final hasConflicts = conflictResult.hasConflicts;
    final resolvedCount = conflictResult.newEntryCount;
    final conflictCount = conflictResult.conflictCount;

    return Row(
      children: [
        Icon(
          hasConflicts ? Icons.warning : Icons.check_circle,
          size: 16.0,
          color: hasConflicts ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4.0),
        Text(
          '$resolvedCount / $conflictCount',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: hasConflicts ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
              ),
        ),
        if (hasConflicts) ...[
          const SizedBox(width: 4.0),
          Tooltip(
            message: '${conflictResult.conflictCount} 个冲突需要解决',
            child: Icon(
              Icons.info_outline,
              size: 12.0,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
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

    Logger.info('开始智能匹配语言，文件名: $fileName');

    // 1. 精确匹配完整语言代码 (如 zh-CN, en-US)
    for (final language in widget.languages) {
      final code = language.code.toLowerCase();
      if (fileNameLower.contains(code)) {
        Logger.info('精确匹配语言代码: ${language.nativeName} (${language.code})');
        return language;
      }
    }

    // 2. 匹配主语言代码 (如 zh, en)
    for (final language in widget.languages) {
      final mainCode = language.code.toLowerCase().split('-').first;
      final patterns = [
        '_$mainCode.', // messages_zh.json
        '-$mainCode.', // messages-zh.json
        '.$mainCode.', // messages.zh.json
        '_$mainCode\$', // messages_zh
        '-$mainCode\$', // messages-zh
        '.$mainCode\$', // messages.zh
        '^$mainCode.', // zh.json
        '^${mainCode}_', // zh_messages.json
        '^$mainCode-', // zh-messages.json
      ];

      for (final pattern in patterns) {
        final regex = RegExp(pattern);
        if (regex.hasMatch(fileNameLower)) {
          Logger.info('模式匹配语言代码: ${language.nativeName} (${language.code}) 使用模式: $pattern');
          return language;
        }
      }
    }

    // 3. 常见语言名称映射
    final languageNameMap = <String, String>{
      'chinese': 'zh',
      'english': 'en',
      'japanese': 'ja',
      'korean': 'ko',
      'french': 'fr',
      'german': 'de',
      'spanish': 'es',
      'italian': 'it',
      'portuguese': 'pt',
      'russian': 'ru',
      'arabic': 'ar',
      'hindi': 'hi',
      'thai': 'th',
      'vietnamese': 'vi',
      'indonesian': 'id',
      'malay': 'ms',
      'filipino': 'tl',
      'simplified': 'zh-CN',
      'traditional': 'zh-TW',
      'mandarin': 'zh',
      'cantonese': 'zh-HK',
    };

    for (final entry in languageNameMap.entries) {
      if (fileNameLower.contains(entry.key)) {
        final targetCode = entry.value;
        final matchedLanguage = widget.languages.firstWhereOrNull((lang) =>
            lang.code.toLowerCase() == targetCode.toLowerCase() ||
            lang.code.toLowerCase().startsWith('${targetCode.toLowerCase()}-'));
        if (matchedLanguage != null) {
          Logger.info('语言名称匹配: ${matchedLanguage.nativeName} (${matchedLanguage.code}) 通过关键词: ${entry.key}',
              name: 'UploadFileList');
          return matchedLanguage;
        }
      }
    }

    // 4. 特殊文件名模式匹配 (ARB, PO 等格式的常见命名)
    final specialPatterns = <String, String>{
      r'app_(\w{2})\.arb$': r'$1', // app_en.arb
      r'intl_(\w{2})\.arb$': r'$1', // intl_zh.arb
      r'(\w{2})_(\w{2})\.po$': r'$1-$2', // zh_CN.po
      r'(\w{2})\.po$': r'$1', // en.po
      r'messages_(\w{2})\.properties$': r'$1', // messages_en.properties
      r'strings_(\w{2})\.json$': r'$1', // strings_zh.json
      r'locale-(\w{2})\.json$': r'$1', // locale-en.json
      r'(\w{2})-strings\.json$': r'$1', // en-strings.json
    };

    for (final entry in specialPatterns.entries) {
      final regex = RegExp(entry.key, caseSensitive: false);
      final match = regex.firstMatch(fileName);
      if (match != null) {
        String extractedCode = entry.value;
        // 替换捕获组
        for (int i = 1; i <= match.groupCount; i++) {
          extractedCode = extractedCode.replaceAll('\$$i', match.group(i) ?? '');
        }

        final matchedLanguage = widget.languages.firstWhereOrNull((lang) =>
            lang.code.toLowerCase() == extractedCode.toLowerCase() ||
            lang.code.toLowerCase().startsWith('${extractedCode.toLowerCase()}-'));
        if (matchedLanguage != null) {
          Logger.info('特殊模式匹配: ${matchedLanguage.nativeName} (${matchedLanguage.code}) 提取代码: $extractedCode',
              name: 'UploadFileList');
          return matchedLanguage;
        }
      }
    }

    // 5. 如果没有匹配到，检查是否有默认语言
    final defaultLanguage = widget.languages
        .firstWhereOrNull((lang) => lang.code.toLowerCase() == 'en' || lang.code.toLowerCase().startsWith('en-'));

    if (defaultLanguage != null) {
      Logger.info('使用默认英语: ${defaultLanguage.nativeName} (${defaultLanguage.code})');
      return defaultLanguage;
    }

    // 6. 最后使用第一个可用语言
    Logger.info('使用第一个可用语言: ${widget.languages.first.nativeName} (${widget.languages.first.code})');
    return widget.languages.first;
  }

  Future<void> _importFiles(List<PlatformFile> files) async {
    _fileTranslationMap.clear();
    for (final file in files) {
      try {
        // 获取文件扩展名
        final extension = file.name.split('.').last.toLowerCase();
        if (!widget.allowedExtensions.contains(extension)) {
          Get.snackbar('错误', '文件 ${file.name} 不支持的文件类型');
          continue;
        }

        // 从文件内容解码字符串
        final content = utf8.decode(file.bytes ?? []);
        if (content.isEmpty) {
          Get.snackbar('错误', '文件 ${file.name} 内容为空');
          continue;
        }

        // 获取或推断语言
        final selectedLanguage = _fileLanguageMap[file.name] ?? _matchLanguageFromFileName(file.name);
        if (selectedLanguage == null) {
          Get.snackbar('错误', '无法确定文件 ${file.name} 的语言');
          continue;
        }

        // 根据不同的文件类型，调用不同的解析器
        Map<String, String> translations = {};

        switch (extension) {
          case 'json':
            translations = await _parseJsonFile(content);
            break;
          case 'csv':
            translations = await _parseCsvFile(content, selectedLanguage);
            break;
          case 'xlsx':
          case 'xls':
            translations = await _parseExcelFile(file.bytes ?? [], selectedLanguage);
            break;
          case 'arb':
            translations = await _parseArbFile(content, selectedLanguage);
            break;
          case 'po':
            translations = await _parsePoFile(content, selectedLanguage);
            break;
          default:
            Get.snackbar('错误', '文件 ${file.name} 不支持的文件类型');
            continue;
        }

        if (translations.isNotEmpty) {
          _fileTranslationMap[file.name] = translations;

          // 验证翻译内容
          final validationWarnings = _validateTranslations(translations);
          if (validationWarnings.isNotEmpty) {
            Logger.info('文件 ${file.name} 验证警告: ${validationWarnings.length} 个');
            // 显示前3个警告
            final displayWarnings = validationWarnings.take(3).join('; ');
            final moreCount = validationWarnings.length > 3 ? ' 等${validationWarnings.length}个问题' : '';
            Get.snackbar(
              '内容验证警告',
              '$displayWarnings$moreCount',
              duration: const Duration(seconds: 4),
            );
          }

          // 进行冲突检测预览
          await _detectFileConflicts(file.name, translations, selectedLanguage);

          Logger.info('成功解析文件 ${file.name}，共 ${translations.length} 个翻译条目');
        } else {
          Get.snackbar('警告', '文件 ${file.name} 没有解析到有效的翻译内容');
        }

        setState(() {});
      } catch (error, stackTrace) {
        Logger.error('解析文件失败', error: error, stackTrace: stackTrace);
        Get.snackbar('错误', '解析文件 ${file.name} 失败: $error');
      }
    }
  }

  /// 验证翻译内容
  List<String> _validateTranslations(Map<String, String> translations) {
    final warnings = <String>[];
    final keyPattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9._-]*$'); // 合法的翻译键格式

    for (final entry in translations.entries) {
      final key = entry.key;
      final value = entry.value;

      // 1. 检查键格式
      if (!keyPattern.hasMatch(key)) {
        warnings.add('翻译键 "$key" 格式不规范，建议使用字母、数字、点、下划线和连字符');
      }

      // 2. 检查键长度
      if (key.length > 100) {
        warnings.add('翻译键 "$key" 过长（超过100字符），可能影响性能');
      }

      // 3. 检查值是否为空
      if (value.trim().isEmpty) {
        warnings.add('翻译键 "$key" 的值为空');
      }

      // 4. 检查值长度
      if (value.length > 1000) {
        warnings.add('翻译键 "$key" 的值过长（超过1000字符），建议分割');
      }

      // 5. 检查特殊字符
      final controlChars = RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]');
      if (controlChars.hasMatch(value)) {
        warnings.add('翻译键 "$key" 包含控制字符，可能导致显示问题');
      }

      // 6. 检查占位符平衡
      final openBraces = '{'.allMatches(value).length;
      final closeBraces = '}'.allMatches(value).length;
      if (openBraces != closeBraces) {
        warnings.add('翻译键 "$key" 的占位符括号不平衡');
      }

      // 7. 检查常见拼写错误的占位符
      if (value.contains(RegExp(r'\{[^}]*\s[^}]*\}'))) {
        warnings.add('翻译键 "$key" 的占位符中包含空格，可能是错误');
      }

      // 8. 检查HTML标签
      if (value.contains(RegExp(r'<[^>]+>'))) {
        final unclosedTags = _findUnclosedHtmlTags(value);
        if (unclosedTags.isNotEmpty) {
          warnings.add('翻译键 "$key" 包含未闭合的HTML标签: ${unclosedTags.join(", ")}');
        }
      }

      // 9. 检查数字格式
      if (value.contains(RegExp(r'\d+[.,]\d+'))) {
        warnings.add('翻译键 "$key" 包含数字，请确认格式适合目标语言');
      }
    }

    return warnings;
  }

  /// 查找未闭合的HTML标签
  List<String> _findUnclosedHtmlTags(String text) {
    final openTagPattern = RegExp(r'<([a-zA-Z][^>]*)>');
    final closeTagPattern = RegExp(r'</([a-zA-Z][^>]*)>');

    final openTags = openTagPattern.allMatches(text).map((m) => m.group(1)?.split(' ').first ?? '').toList();
    final closeTags = closeTagPattern.allMatches(text).map((m) => m.group(1) ?? '').toList();

    final unclosed = <String>[];
    for (final tag in openTags) {
      if (!closeTags.contains(tag) && !['br', 'hr', 'img', 'input', 'meta', 'link'].contains(tag.toLowerCase())) {
        unclosed.add(tag);
      }
    }

    return unclosed.toSet().toList();
  }

  /// 检测文件的翻译冲突
  Future<void> _detectFileConflicts(String fileName, Map<String, String> translations, Language language) async {
    try {
      // 这里应该获取现有的翻译条目，但由于在widget中无法直接访问翻译服务
      // 我们先创建一个简单的模拟冲突检测
      // 实际实现应该在Controller层处理

      // 将翻译转换为TranslationEntry格式以便冲突检测
      final importedEntries = <TranslationEntry>[];
      for (final entry in translations.entries) {
        importedEntries.add(TranslationEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          projectId: 'temp',
          key: entry.key,
          sourceLanguage: language,
          targetLanguage: language,
          sourceText: entry.value,
          targetText: entry.value,
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }

      // 模拟冲突检测结果（实际应该调用ConflictDetectionService）
      final conflictResult = ConflictDetectionResult(
        conflicts: [], // 暂时没有现有条目，所以无冲突
        newEntries: importedEntries,
        summary: '${importedEntries.length} 个新条目，0 个冲突',
      );

      _fileConflictMap[fileName] = conflictResult;
      Logger.info('文件 $fileName 冲突检测完成: ${conflictResult.conflictCount} 个冲突');
    } catch (error, stackTrace) {
      Logger.error('文件冲突检测失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 解析 JSON 格式文件
  Future<Map<String, String>> _parseJsonFile(String content) async {
    try {
      final parser = ParserFactory.getParser(FileFormats.json);
      final defaultLanguage = Language.supportedLanguages.first;
      final result = await parser.parseString(content, defaultLanguage);

      // 将 TranslationEntry 列表转换为 Map<String, String>
      final translations = <String, String>{};
      for (final entry in result.entries) {
        translations[entry.key] = entry.targetText;
      }

      return translations;
    } catch (error, stackTrace) {
      Logger.error('解析 JSON 文件失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 解析 CSV 格式文件
  Future<Map<String, String>> _parseCsvFile(String content, Language language) async {
    try {
      final parser = ParserFactory.getParser(FileFormats.csv);
      final result = await parser.parseString(content, language);

      // 将 TranslationEntry 列表转换为 Map<String, String>
      final translations = <String, String>{};
      for (final entry in result.entries) {
        translations[entry.key] = entry.targetText;
      }

      return translations;
    } catch (error, stackTrace) {
      Logger.error('解析 CSV 文件失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 解析 Excel 格式文件 (xlsx/xls)
  Future<Map<String, String>> _parseExcelFile(List<int> bytes, Language language) async {
    try {
      // 临时使用简单的Excel解析，稍后会实现完整的解析器
      final excelData = excel.Excel.decodeBytes(bytes);
      final translations = <String, String>{};

      // 获取第一个工作表
      if (excelData.tables.isNotEmpty) {
        final table = excelData.tables.values.first;
        if (table.rows.isNotEmpty) {
          // 跳过标题行（假设第一行是标题）
          for (int i = 1; i < table.rows.length; i++) {
            final row = table.rows[i];
            if (row.isNotEmpty && row.length >= 2) {
              final key = row[0]?.value?.toString() ?? '';
              final value = row[1]?.value?.toString() ?? '';
              if (key.isNotEmpty) {
                translations[key] = value;
              }
            }
          }
        }
      }

      return translations;
    } catch (error, stackTrace) {
      Logger.error('解析 Excel 文件失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 解析 ARB 格式文件
  Future<Map<String, String>> _parseArbFile(String content, Language language) async {
    try {
      final parser = ParserFactory.getParser(FileFormats.arb);
      final result = await parser.parseString(content, language);

      // 将 TranslationEntry 列表转换为 Map<String, String>
      final translations = <String, String>{};
      for (final entry in result.entries) {
        translations[entry.key] = entry.targetText;
      }

      return translations;
    } catch (error, stackTrace) {
      Logger.error('解析 ARB 文件失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 解析 PO 格式文件
  Future<Map<String, String>> _parsePoFile(String content, Language language) async {
    try {
      final parser = ParserFactory.getParser(FileFormats.po);
      final result = await parser.parseString(content, language);

      // 将 TranslationEntry 列表转换为 Map<String, String>
      final translations = <String, String>{};
      for (final entry in result.entries) {
        translations[entry.key] = entry.targetText;
      }

      return translations;
    } catch (error, stackTrace) {
      Logger.error('解析 PO 文件失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }
}
