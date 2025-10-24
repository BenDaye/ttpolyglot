import 'package:ttpolyglot_core/core.dart';
import 'package:uuid/uuid.dart';

import '../constants/file_formats.dart';
import '../exceptions/parser_exception.dart';
import '../parser_interface.dart';
import '../parser_result.dart';
import '../utils/file_utils.dart';

/// Properties 格式解析器
class PropertiesParser implements TranslationParser {
  static const _uuid = Uuid();

  @override
  String get format => FileFormats.properties;

  @override
  String get displayName => 'Properties';

  @override
  List<String> get supportedExtensions => ['.properties'];

  @override
  Future<ParserResult> parseFile(String filePath) async {
    try {
      final content = await FileUtils.readFile(filePath);
      final fileName = FileUtils.getFileNameWithoutExtension(filePath);
      final language = _inferLanguageFromFileName(fileName);

      return await parseString(content, language);
    } catch (e) {
      throw FileReadException('Failed to parse Properties file: $filePath', cause: e);
    }
  }

  @override
  Future<ParserResult> parseString(
    String content,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    try {
      final entries = <TranslationEntry>[];
      final warnings = <String>[];
      final lines = content.split('\n');

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        final lineNumber = i + 1;

        // 跳过空行和注释
        if (line.isEmpty || line.startsWith('#') || line.startsWith('!')) {
          continue;
        }

        // 查找等号或冒号分隔符
        int separatorIndex = -1;
        for (int j = 0; j < line.length; j++) {
          final char = line[j];
          if (char == '=' || char == ':') {
            // 确保不是转义的分隔符
            if (j == 0 || line[j - 1] != '\\') {
              separatorIndex = j;
              break;
            }
          }
        }

        if (separatorIndex == -1) {
          warnings.add('Line $lineNumber: No separator found, skipping');
          continue;
        }

        final key = line.substring(0, separatorIndex).trim();
        final value = line.substring(separatorIndex + 1).trim();

        if (key.isEmpty) {
          warnings.add('Line $lineNumber: Empty key, skipping');
          continue;
        }

        // 处理转义字符
        final unescapedKey = _unescapeProperties(key);
        final unescapedValue = _unescapeProperties(value);

        entries.add(TranslationEntry(
          id: _uuid.v4(),
          key: unescapedKey,
          projectId: 'unknown',
          sourceLanguage: language,
          targetLanguage: language,
          sourceText: unescapedValue,
          targetText: unescapedValue,
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }

      return ParserResult(
        entries: entries,
        language: language,
        warnings: warnings,
      );
    } catch (e) {
      throw FileParseException('Failed to parse Properties content', cause: e);
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
        message: 'Properties file written successfully',
      );
    } catch (e) {
      return WriteResult(
        filePath: filePath,
        success: false,
        message: 'Failed to write Properties file: $e',
      );
    }
  }

  @override
  Future<String> writeString(
    List<TranslationEntry> entries,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    final separator = options?['separator'] as String? ?? '=';
    final sortKeys = options?['sortKeys'] as bool? ?? true;
    final includeTimestamp = options?['includeTimestamp'] as bool? ?? true;

    final buffer = StringBuffer();

    // 添加时间戳注释
    if (includeTimestamp) {
      buffer.writeln('# Generated on ${DateTime.now().toIso8601String()}');
      buffer.writeln('# Language: ${language.code}');
      buffer.writeln();
    }

    // 获取要写入的条目
    final filteredEntries = entries.where((entry) => entry.targetLanguage.code == language.code).toList();

    if (sortKeys) {
      filteredEntries.sort((a, b) => a.key.compareTo(b.key));
    }

    for (final entry in filteredEntries) {
      final escapedKey = _escapeProperties(entry.key);
      final escapedValue = _escapeProperties(entry.targetText);
      buffer.writeln('$escapedKey$separator$escapedValue');
    }

    return buffer.toString();
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
      final lines = content.split('\n');

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#') || trimmed.startsWith('!')) {
          continue;
        }

        // 检查是否有分隔符
        if (!trimmed.contains('=') && !trimmed.contains(':')) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, String> getOptionsDescription() {
    return {
      'separator': 'Properties 分隔符（默认: "="）',
      'sortKeys': '是否对键进行排序（默认: true）',
      'includeTimestamp': '是否包含时间戳注释（默认: true）',
    };
  }

  /// 从文件名推断语言
  Language _inferLanguageFromFileName(String fileName) {
    // Properties 文件通常命名为 messages_en.properties, strings_zh.properties 等
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

  /// 转义 Properties 特殊字符
  String _escapeProperties(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t')
        .replaceAll('=', '\\=')
        .replaceAll(':', '\\:')
        .replaceAll('#', '\\#')
        .replaceAll('!', '\\!');
  }

  /// 反转义 Properties 特殊字符
  String _unescapeProperties(String text) {
    return text
        .replaceAll('\\\\', '\\')
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\r')
        .replaceAll('\\t', '\t')
        .replaceAll('\\=', '=')
        .replaceAll('\\:', ':')
        .replaceAll('\\#', '#')
        .replaceAll('\\!', '!');
  }
}
