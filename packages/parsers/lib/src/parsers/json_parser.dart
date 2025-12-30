import 'dart:convert';

import 'package:ttpolyglot_model/model.dart';
import 'package:uuid/uuid.dart';

import '../constants/file_formats.dart';
import '../exceptions/parser_exception.dart';
import '../parser_interface.dart';
import '../parser_result.dart';
import '../utils/file_utils.dart';

/// JSON 格式解析器
class JsonParser implements TranslationParser {
  static const _uuid = Uuid();

  @override
  String get format => FileFormats.json;

  @override
  String get displayName => 'JSON';

  @override
  List<String> get supportedExtensions => ['.json'];

  @override
  Future<ParserResult> parseFile(String filePath) async {
    try {
      final content = await FileUtils.readFile(filePath);
      final fileName = FileUtils.getFileNameWithoutExtension(filePath);
      final language = _inferLanguageFromFileName(fileName);

      return await parseString(content, language);
    } catch (e) {
      throw FileReadException('Failed to parse JSON file: $filePath', cause: e);
    }
  }

  @override
  Future<ParserResult> parseString(
    String content,
    LanguageEnum language, {
    Map<String, dynamic>? options,
  }) async {
    try {
      final jsonData = json.decode(content);
      final entries = <TranslationEntryModel>[];
      final warnings = <String>[];

      if (jsonData is Map<String, dynamic>) {
        _parseJsonObject(jsonData, entries, language, warnings);
      } else {
        throw FileParseException('JSON root must be an object');
      }

      return ParserResult(
        entries: entries,
        language: language,
        warnings: warnings,
      );
    } catch (e) {
      throw FileParseException('Failed to parse JSON content', cause: e);
    }
  }

  @override
  Future<WriteResult> writeFile(
    String filePath,
    List<TranslationEntryModel> entries,
    LanguageEnum language, {
    Map<String, dynamic>? options,
  }) async {
    try {
      final content = await writeString(entries, language, options: options);
      await FileUtils.writeFile(filePath, content);

      return WriteResult(
        filePath: filePath,
        success: true,
        message: 'JSON file written successfully',
      );
    } catch (e) {
      return WriteResult(
        filePath: filePath,
        success: false,
        message: 'Failed to write JSON file: $e',
      );
    }
  }

  @override
  Future<String> writeString(
    List<TranslationEntryModel> entries,
    LanguageEnum language, {
    Map<String, dynamic>? options,
  }) async {
    final jsonObject = <String, dynamic>{};
    final indent = options?['indent'] as String? ?? '  ';
    final sortKeys = options?['sortKeys'] as bool? ?? true;
    final nestedKeyStyle = options?['nestedKeyStyle'] as bool? ?? true;

    for (final entry in entries) {
      if (entry.targetLanguage == language) {
        if (nestedKeyStyle) {
          _setNestedValue(jsonObject, entry.entryKey, entry.targetText);
        } else {
          jsonObject[entry.entryKey] = entry.targetText;
        }
      }
    }

    final encoder = JsonEncoder.withIndent(indent);
    if (sortKeys) {
      return encoder.convert(_sortJsonObject(jsonObject));
    }
    return encoder.convert(jsonObject);
  }

  @override
  Future<bool> validateFile(String filePath) async {
    try {
      final content = await FileUtils.readFile(filePath);
      return await validateString(content);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> validateString(String content) async {
    try {
      final jsonData = json.decode(content);
      return jsonData is Map<String, dynamic>;
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, String> getOptionsDescription() {
    return {
      'indent': 'JSON 缩进字符串（默认: "  "）',
      'sortKeys': '是否对键进行排序（默认: true）',
    };
  }

  /// 从文件名推断语言
  LanguageEnum _inferLanguageFromFileName(String fileName) {
    // 检查文件名是否包含语言代码模式（如 en-US, zh-CN 等）
    final langCodeRegex = RegExp(r'^[a-z]{2}(-[A-Z]{2})?$');

    if (langCodeRegex.hasMatch(fileName)) {
      return LanguageEnum.fromValue(fileName);
    }

    // 如果文件名包含点号，尝试从最后一部分推断
    final parts = fileName.split('.');
    if (parts.length > 1) {
      final langCode = parts.last;
      if (langCodeRegex.hasMatch(langCode)) {
        return LanguageEnum.fromValue(langCode);
      }
    }

    // 默认返回英语
    return LanguageEnum.enUS;
  }

  /// 解析 JSON 对象
  void _parseJsonObject(
    Map<String, dynamic> jsonData,
    List<TranslationEntryModel> entries,
    LanguageEnum language,
    List<String> warnings, {
    String prefix = '',
  }) {
    jsonData.forEach((key, value) {
      final fullKey = prefix.isEmpty ? key : '$prefix.$key';

      if (value is String) {
        entries.add(TranslationEntryModel(
          uuid: _uuid.v4(),
          entryKey: fullKey,
          projectId: 'unknown',
          targetLanguage: language,
          sourceText: value,
          targetText: value,
          status: TranslationStatusEnum.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      } else if (value is Map<String, dynamic>) {
        _parseJsonObject(value, entries, language, warnings, prefix: fullKey);
      } else if (value is List) {
        // 处理数组
        for (int i = 0; i < value.length; i++) {
          final item = value[i];
          if (item is String) {
            entries.add(TranslationEntryModel(
              uuid: _uuid.v4(),
              entryKey: '$fullKey[$i]',
              projectId: 'unknown',
              targetLanguage: language,
              sourceText: item,
              targetText: item,
              status: TranslationStatusEnum.completed,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ));
          } else {
            warnings.add('Array item at $fullKey[$i] is not a string, skipping');
          }
        }
      } else {
        warnings.add('Value at $fullKey is not a string or object, skipping');
      }
    });
  }

  /// 设置嵌套值
  void _setNestedValue(Map<String, dynamic> obj, String key, dynamic value) {
    final parts = key.split('.');
    Map<String, dynamic> current = obj;

    for (int i = 0; i < parts.length - 1; i++) {
      final part = parts[i];
      if (!current.containsKey(part) || current[part] is! Map<String, dynamic>) {
        current[part] = <String, dynamic>{};
      }
      current = current[part] as Map<String, dynamic>;
    }

    current[parts.last] = value;
  }

  /// 排序 JSON 对象
  Map<String, dynamic> _sortJsonObject(Map<String, dynamic> obj) {
    final sorted = <String, dynamic>{};
    final keys = obj.keys.toList()..sort();

    for (final key in keys) {
      final value = obj[key];
      if (value is Map<String, dynamic>) {
        sorted[key] = _sortJsonObject(value);
      } else {
        sorted[key] = value;
      }
    }

    return sorted;
  }
}
