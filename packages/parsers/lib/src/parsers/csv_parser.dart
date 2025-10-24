import 'package:csv/csv.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:uuid/uuid.dart';

import '../constants/file_formats.dart';
import '../exceptions/parser_exception.dart';
import '../parser_interface.dart';
import '../parser_result.dart';
import '../utils/file_utils.dart';

/// CSV 格式解析器
class CsvParser implements TranslationParser {
  static const _uuid = Uuid();

  @override
  String get format => FileFormats.csv;

  @override
  String get displayName => 'CSV';

  @override
  List<String> get supportedExtensions => ['.csv'];

  @override
  Future<ParserResult> parseFile(String filePath) async {
    try {
      final content = await FileUtils.readFile(filePath);
      final fileName = FileUtils.getFileNameWithoutExtension(filePath);
      final language = _inferLanguageFromFileName(fileName);

      return await parseString(content, language);
    } catch (e) {
      throw FileReadException('Failed to parse CSV file: $filePath', cause: e);
    }
  }

  @override
  Future<ParserResult> parseString(
    String content,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    try {
      final delimiter = options?['delimiter'] as String? ?? ',';
      final hasHeader = options?['hasHeader'] as bool? ?? true;
      final keyColumn = options?['keyColumn'] as int? ?? 0;
      final valueColumn = options?['valueColumn'] as int? ?? 1;

      final converter = CsvToListConverter(
        fieldDelimiter: delimiter,
        eol: '\n',
        shouldParseNumbers: false,
      );

      final rows = converter.convert(content);
      final entries = <TranslationEntry>[];
      final warnings = <String>[];

      if (rows.isEmpty) {
        return ParserResult(
          entries: entries,
          language: language,
          warnings: ['CSV file is empty'],
        );
      }

      final startRow = hasHeader ? 1 : 0;

      for (int i = startRow; i < rows.length; i++) {
        final row = rows[i];

        if (row.length <= keyColumn || row.length <= valueColumn) {
          warnings.add('Row $i has insufficient columns, skipping');
          continue;
        }

        final key = row[keyColumn]?.toString().trim() ?? '';
        final value = row[valueColumn]?.toString().trim() ?? '';

        if (key.isEmpty) {
          warnings.add('Row $i has empty key, skipping');
          continue;
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
        ));
      }

      return ParserResult(
        entries: entries,
        language: language,
        warnings: warnings,
      );
    } catch (e) {
      throw FileParseException('Failed to parse CSV content', cause: e);
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
        message: 'CSV file written successfully',
      );
    } catch (e) {
      return WriteResult(
        filePath: filePath,
        success: false,
        message: 'Failed to write CSV file: $e',
      );
    }
  }

  @override
  Future<String> writeString(
    List<TranslationEntry> entries,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    final delimiter = options?['delimiter'] as String? ?? ',';
    final includeHeader = options?['includeHeader'] as bool? ?? true;
    final keyHeader = options?['keyHeader'] as String? ?? 'key';
    final valueHeader = options?['valueHeader'] as String? ?? 'value';

    final converter = ListToCsvConverter(
      fieldDelimiter: delimiter,
    );

    final rows = <List<String>>[];

    if (includeHeader) {
      rows.add([keyHeader, valueHeader]);
    }

    for (final entry in entries) {
      if (entry.targetLanguage.code == language.code) {
        rows.add([entry.key, entry.targetText]);
      }
    }

    return converter.convert(rows);
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
      final converter = CsvToListConverter();
      final rows = converter.convert(content);
      return rows.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, String> getOptionsDescription() {
    return {
      'delimiter': 'CSV 分隔符（默认: ","）',
      'hasHeader': '是否包含标题行（默认: true）',
      'keyColumn': '键列索引（默认: 0）',
      'valueColumn': '值列索引（默认: 1）',
      'includeHeader': '写入时是否包含标题行（默认: true）',
      'keyHeader': '键列标题（默认: "key"）',
      'valueHeader': '值列标题（默认: "value"）',
    };
  }

  /// 从文件名推断语言
  Language _inferLanguageFromFileName(String fileName) {
    final parts = fileName.split('.');
    if (parts.length > 1) {
      final langCode = parts.last;
      // 标准化语言代码格式为 xx-XX
      final standardizedCode = _standardizeLanguageCode(langCode);
      return Language(
        id: Language.supportedLanguages.firstWhere((lang) => lang.code == standardizedCode).id,
        code: standardizedCode,
        name: standardizedCode.toUpperCase(),
        nativeName: standardizedCode,
      );
    }

    return Language.supportedLanguages.first;
  }

  /// 标准化语言代码格式为 xx-XX
  String _standardizeLanguageCode(String langCode) {
    // 如果已经是正确格式，直接返回
    if (langCode.contains('-') && langCode.length >= 5) {
      return langCode;
    }

    // 如果只有语言代码（如 zh），添加默认地区
    final langCodeMap = {
      'zh': 'zh-CN',
      'en': 'en-US',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'es': 'es-ES',
      'it': 'it-IT',
      'pt': 'pt-PT',
      'ru': 'ru-RU',
      'ar': 'ar-SA',
      'hi': 'hi-IN',
      'th': 'th-TH',
      'vi': 'vi-VN',
    };

    return langCodeMap[langCode.toLowerCase()] ?? 'en-US';
  }
}
