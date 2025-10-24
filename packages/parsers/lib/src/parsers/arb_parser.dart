import 'dart:convert';

import 'package:ttpolyglot_core/core.dart';
import 'package:uuid/uuid.dart';

import '../constants/file_formats.dart';
import '../exceptions/parser_exception.dart';
import '../parser_interface.dart';
import '../parser_result.dart';
import '../utils/file_utils.dart';

/// ARB (Application Resource Bundle) 格式解析器
class ArbParser implements TranslationParser {
  static const _uuid = Uuid();

  @override
  String get format => FileFormats.arb;

  @override
  String get displayName => 'ARB';

  @override
  List<String> get supportedExtensions => ['.arb'];

  @override
  Future<ParserResult> parseFile(String filePath) async {
    try {
      final content = await FileUtils.readFile(filePath);
      final fileName = FileUtils.getFileNameWithoutExtension(filePath);
      final language = _inferLanguageFromFileName(fileName);

      return await parseString(content, language);
    } catch (e) {
      throw FileReadException('Failed to parse ARB file: $filePath', cause: e);
    }
  }

  @override
  Future<ParserResult> parseString(
    String content,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    try {
      final arbData = json.decode(content) as Map<String, dynamic>;
      final entries = <TranslationEntry>[];
      final warnings = <String>[];
      final metadata = <String, dynamic>{};

      // 提取 ARB 元数据
      if (arbData.containsKey('@@locale')) {
        metadata['locale'] = arbData['@@locale'];
      }
      if (arbData.containsKey('@@last_modified')) {
        metadata['lastModified'] = arbData['@@last_modified'];
      }

      arbData.forEach((key, value) {
        // 跳过元数据键
        if (key.startsWith('@@') || key.startsWith('@')) {
          return;
        }

        if (value is String) {
          // 检查是否有对应的元数据
          final metadataKey = '@$key';
          Map<String, dynamic>? entryMetadata;

          if (arbData.containsKey(metadataKey)) {
            final meta = arbData[metadataKey];
            if (meta is Map<String, dynamic>) {
              entryMetadata = meta;
            }
          }

          entries.add(TranslationEntry(
            id: _uuid.v4(),
            key: key,
            projectId: 'unknown',
            sourceLanguage: language,
            targetLanguage: language,
            sourceText: value,
            targetText: value,
            status: TranslationStatus.completed,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            comment: entryMetadata?['description'] as String?,
            context: entryMetadata?['context'] as String?,
          ));
        } else {
          warnings.add('Value for key $key is not a string, skipping');
        }
      });

      return ParserResult(
        entries: entries,
        language: language,
        metadata: metadata,
        warnings: warnings,
      );
    } catch (e) {
      throw FileParseException('Failed to parse ARB content', cause: e);
    }
  }

  @override
  Future<WriteResult> writeFile(
    String filePath,
    List<TranslationEntry> entries,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    try {
      final content = await writeString(entries, language, options: options);
      await FileUtils.writeFile(filePath, content);

      return WriteResult(
        filePath: filePath,
        success: true,
        message: 'ARB file written successfully',
      );
    } catch (e) {
      return WriteResult(
        filePath: filePath,
        success: false,
        message: 'Failed to write ARB file: $e',
      );
    }
  }

  @override
  Future<String> writeString(
    List<TranslationEntry> entries,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    final arbObject = <String, dynamic>{};
    final includeMetadata = options?['includeMetadata'] as bool? ?? true;
    final sortKeys = options?['sortKeys'] as bool? ?? true;
    final indent = options?['indent'] as String? ?? '  ';

    // 添加 ARB 元数据
    if (includeMetadata) {
      arbObject['@@locale'] = language.code;
      arbObject['@@last_modified'] = DateTime.now().toIso8601String();
    }

    // 添加翻译条目
    for (final entry in entries) {
      if (entry.targetLanguage.code == language.code) {
        arbObject[entry.key] = entry.targetText;

        // 添加条目元数据
        if (entry.comment != null || entry.context != null) {
          final metadataKey = '@${entry.key}';
          final metadata = <String, dynamic>{};

          if (entry.comment != null) {
            metadata['description'] = entry.comment;
          }
          if (entry.context != null) {
            metadata['context'] = entry.context;
          }

          arbObject[metadataKey] = metadata;
        }
      }
    }

    final encoder = JsonEncoder.withIndent(indent);
    if (sortKeys) {
      return encoder.convert(_sortArbObject(arbObject));
    }
    return encoder.convert(arbObject);
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
      final arbData = json.decode(content);
      return arbData is Map<String, dynamic>;
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, String> getOptionsDescription() {
    return {
      'includeMetadata': '是否包含 ARB 元数据（默认: true）',
      'sortKeys': '是否对键进行排序（默认: true）',
      'indent': 'JSON 缩进字符串（默认: "  "）',
    };
  }

  /// 从文件名推断语言
  Language _inferLanguageFromFileName(String fileName) {
    // ARB 文件通常命名为 app_en.arb, intl_zh.arb 等
    final parts = fileName.split('_');
    if (parts.length > 1) {
      final langCode = parts.last;
      return Language(
        id: Language.supportedLanguages.firstWhere((lang) => lang.code == langCode).id,
        code: langCode,
        name: langCode.toUpperCase(),
        nativeName: langCode,
      );
    }

    return Language.supportedLanguages.first;
  }

  /// 排序 ARB 对象，确保元数据在前
  Map<String, dynamic> _sortArbObject(Map<String, dynamic> obj) {
    final sorted = <String, dynamic>{};
    final keys = obj.keys.toList();

    // 首先添加全局元数据
    final globalMetaKeys = keys.where((k) => k.startsWith('@@')).toList()..sort();
    for (final key in globalMetaKeys) {
      sorted[key] = obj[key];
    }

    // 然后添加翻译条目和它们的元数据
    final entryKeys = keys.where((k) => !k.startsWith('@')).toList()..sort();
    for (final key in entryKeys) {
      sorted[key] = obj[key];

      // 添加对应的元数据
      final metaKey = '@$key';
      if (obj.containsKey(metaKey)) {
        sorted[metaKey] = obj[metaKey];
      }
    }

    return sorted;
  }
}
