import 'package:ttpolyglot_core/core.dart';
import 'package:uuid/uuid.dart';

import '../constants/file_formats.dart';
import '../exceptions/parser_exception.dart';
import '../parser_interface.dart';
import '../parser_result.dart';
import '../utils/file_utils.dart';

/// PO (Portable Object) 格式解析器
class PoParser implements TranslationParser {
  static const _uuid = Uuid();

  @override
  String get format => FileFormats.po;

  @override
  String get displayName => 'PO';

  @override
  List<String> get supportedExtensions => ['.po'];

  @override
  Future<ParserResult> parseFile(String filePath) async {
    try {
      final content = await FileUtils.readFile(filePath);
      final fileName = FileUtils.getFileNameWithoutExtension(filePath);
      final language = _inferLanguageFromFileName(fileName);

      return await parseString(content, language);
    } catch (e) {
      throw FileReadException('Failed to parse PO file: $filePath', cause: e);
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
      final metadata = <String, dynamic>{};

      final lines = content.split('\n');
      int i = 0;

      // 解析头部信息
      while (i < lines.length) {
        final line = lines[i].trim();
        if (line.isEmpty || line.startsWith('#')) {
          i++;
          continue;
        }
        if (line.startsWith('msgid ""') || line.startsWith('msgstr ""')) {
          break;
        }
        i++;
      }

      // 解析翻译条目
      while (i < lines.length) {
        final entry = _parsePoEntry(lines, i);
        if (entry != null) {
          final (translationEntry, nextIndex) = entry;
          entries.add(translationEntry);
          i = nextIndex;
        } else {
          i++;
        }
      }

      return ParserResult(
        entries: entries,
        language: language,
        metadata: metadata,
        warnings: warnings,
      );
    } catch (e) {
      throw FileParseException('Failed to parse PO content', cause: e);
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
        message: 'PO file written successfully',
      );
    } catch (e) {
      return WriteResult(
        filePath: filePath,
        success: false,
        message: 'Failed to write PO file: $e',
      );
    }
  }

  @override
  Future<String> writeString(
    List<TranslationEntry> entries,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    final includeHeader = options?['includeHeader'] as bool? ?? true;
    final sortKeys = options?['sortKeys'] as bool? ?? true;

    final buffer = StringBuffer();

    // 添加 PO 文件头部
    if (includeHeader) {
      buffer.writeln('# Translation file for ${language.code}');
      buffer.writeln('# Generated on ${DateTime.now().toIso8601String()}');
      buffer.writeln('#');
      buffer.writeln('msgid ""');
      buffer.writeln('msgstr ""');
      buffer.writeln('"Content-Type: text/plain; charset=UTF-8\\n"');
      buffer.writeln('"Language: ${language.code}\\n"');
      buffer.writeln('"MIME-Version: 1.0\\n"');
      buffer.writeln('"Content-Transfer-Encoding: 8bit\\n"');
      buffer.writeln();
    }

    // 获取要写入的条目
    final filteredEntries = entries.where((entry) => entry.targetLanguage.code == language.code).toList();

    if (sortKeys) {
      filteredEntries.sort((a, b) => a.key.compareTo(b.key));
    }

    for (final entry in filteredEntries) {
      // 添加注释
      if (entry.comment != null && entry.comment!.isNotEmpty) {
        buffer.writeln('# ${entry.comment}');
      }
      if (entry.context != null && entry.context!.isNotEmpty) {
        buffer.writeln('#: ${entry.context}');
      }

      // 添加 msgid 和 msgstr
      buffer.writeln('msgid "${_escapePoString(entry.sourceText)}"');
      buffer.writeln('msgstr "${_escapePoString(entry.targetText)}"');
      buffer.writeln();
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
      bool foundMsgid = false;
      bool foundMsgstr = false;

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.startsWith('msgid ')) {
          foundMsgid = true;
        }
        if (trimmed.startsWith('msgstr ')) {
          foundMsgstr = true;
        }
      }

      return foundMsgid && foundMsgstr;
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, String> getOptionsDescription() {
    return {
      'includeHeader': '是否包含 PO 文件头部（默认: true）',
      'sortKeys': '是否对键进行排序（默认: true）',
    };
  }

  /// 从文件名推断语言
  Language _inferLanguageFromFileName(String fileName) {
    // PO 文件通常命名为 messages.po, zh_CN.po 等
    if (fileName.contains('_') || fileName.contains('-')) {
      final parts = fileName.split(RegExp(r'[_-]'));
      if (parts.length > 1) {
        final langCode = parts.last;
        return Language(
          code: langCode,
          name: langCode.toUpperCase(),
          nativeName: langCode,
        );
      }
    }

    return const Language(
      code: 'en',
      name: 'English',
      nativeName: 'English',
    );
  }

  /// 解析单个 PO 条目
  (TranslationEntry, int)? _parsePoEntry(List<String> lines, int startIndex) {
    int i = startIndex;
    String? comment;
    String? context;
    String? msgid;
    String? msgstr;

    // 跳过空行和注释
    while (i < lines.length) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        i++;
        continue;
      }

      if (line.startsWith('#')) {
        if (line.startsWith('# ')) {
          comment = line.substring(2);
        } else if (line.startsWith('#: ')) {
          context = line.substring(3);
        }
        i++;
        continue;
      }

      break;
    }

    // 解析 msgid
    if (i < lines.length && lines[i].trim().startsWith('msgid ')) {
      msgid = _parsePoString(lines, i, 'msgid ');
      i = _findNextPoDirective(lines, i);
    }

    // 解析 msgstr
    if (i < lines.length && lines[i].trim().startsWith('msgstr ')) {
      msgstr = _parsePoString(lines, i, 'msgstr ');
      i = _findNextPoDirective(lines, i);
    }

    if (msgid != null && msgstr != null && msgid.isNotEmpty) {
      final entry = TranslationEntry(
        id: _uuid.v4(),
        key: msgid,
        projectId: 'unknown',
        sourceLanguage: const Language(code: 'en', name: 'English', nativeName: 'English'),
        targetLanguage: const Language(code: 'en', name: 'English', nativeName: 'English'),
        sourceText: msgid,
        targetText: msgstr,
        status: msgstr.isEmpty ? TranslationStatus.pending : TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        comment: comment,
        context: context,
      );

      return (entry, i);
    }

    return null;
  }

  /// 解析 PO 字符串
  String _parsePoString(List<String> lines, int startIndex, String prefix) {
    final buffer = StringBuffer();
    int i = startIndex;

    // 解析第一行
    final firstLine = lines[i].trim();
    if (firstLine.startsWith(prefix)) {
      final quotedString = firstLine.substring(prefix.length).trim();
      if (quotedString.startsWith('"') && quotedString.endsWith('"')) {
        buffer.write(_unescapePoString(quotedString.substring(1, quotedString.length - 1)));
      }
    }

    i++;

    // 解析续行
    while (i < lines.length) {
      final line = lines[i].trim();
      if (line.startsWith('"') && line.endsWith('"')) {
        buffer.write(_unescapePoString(line.substring(1, line.length - 1)));
        i++;
      } else {
        break;
      }
    }

    return buffer.toString();
  }

  /// 查找下一个 PO 指令
  int _findNextPoDirective(List<String> lines, int startIndex) {
    int i = startIndex;

    while (i < lines.length) {
      final line = lines[i].trim();
      if (line.startsWith('msgid ') || line.startsWith('msgstr ') || line.isEmpty) {
        break;
      }
      i++;
    }

    return i;
  }

  /// 转义 PO 字符串
  String _escapePoString(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  /// 反转义 PO 字符串
  String _unescapePoString(String text) {
    return text
        .replaceAll('\\\\', '\\')
        .replaceAll('\\"', '"')
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\r')
        .replaceAll('\\t', '\t');
  }
}
