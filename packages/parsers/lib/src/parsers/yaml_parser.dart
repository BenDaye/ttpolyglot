import 'package:ttpolyglot_core/core.dart';
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';

import '../constants/file_formats.dart';
import '../exceptions/parser_exception.dart';
import '../parser_interface.dart';
import '../parser_result.dart';
import '../utils/file_utils.dart';

/// YAML 格式解析器
class YamlParser implements TranslationParser {
  static const _uuid = Uuid();

  @override
  String get format => FileFormats.yaml;

  @override
  String get displayName => 'YAML';

  @override
  List<String> get supportedExtensions => ['.yaml', '.yml'];

  @override
  Future<ParserResult> parseFile(String filePath) async {
    try {
      final content = await FileUtils.readFile(filePath);
      final fileName = FileUtils.getFileNameWithoutExtension(filePath);
      final language = _inferLanguageFromFileName(fileName);

      return await parseString(content, language);
    } catch (e) {
      throw FileReadException('Failed to parse YAML file: $filePath', cause: e);
    }
  }

  @override
  Future<ParserResult> parseString(
    String content,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    try {
      final yamlData = loadYaml(content);
      final entries = <TranslationEntry>[];
      final warnings = <String>[];

      if (yamlData is Map) {
        _parseYamlObject(yamlData, entries, language, warnings);
      } else {
        throw FileParseException('YAML root must be a map');
      }

      return ParserResult(
        entries: entries,
        language: language,
        warnings: warnings,
      );
    } catch (e) {
      throw FileParseException('Failed to parse YAML content', cause: e);
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
        message: 'YAML file written successfully',
      );
    } catch (e) {
      return WriteResult(
        filePath: filePath,
        success: false,
        message: 'Failed to write YAML file: $e',
      );
    }
  }

  @override
  Future<String> writeString(
    List<TranslationEntry> entries,
    Language language, {
    Map<String, dynamic>? options,
  }) async {
    final yamlObject = <String, dynamic>{};
    final indent = options?['indent'] as int? ?? 2;
    final sortKeys = options?['sortKeys'] as bool? ?? true;

    for (final entry in entries) {
      if (entry.targetLanguage.code == language.code) {
        _setNestedValue(yamlObject, entry.key, entry.targetText);
      }
    }

    return _yamlToString(sortKeys ? _sortYamlObject(yamlObject) : yamlObject, indent);
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
      final yamlData = loadYaml(content);
      return yamlData is Map;
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, String> getOptionsDescription() {
    return {
      'indent': 'YAML 缩进空格数（默认: 2）',
      'sortKeys': '是否对键进行排序（默认: true）',
    };
  }

  /// 从文件名推断语言
  Language _inferLanguageFromFileName(String fileName) {
    final parts = fileName.split('.');
    if (parts.length > 1) {
      final langCode = parts.last;
      return Language(
        code: langCode,
        name: langCode.toUpperCase(),
        nativeName: langCode,
      );
    }

    return const Language(
      code: 'en',
      name: 'English',
      nativeName: 'English',
    );
  }

  /// 解析 YAML 对象
  void _parseYamlObject(
    Map yamlData,
    List<TranslationEntry> entries,
    Language language,
    List<String> warnings, {
    String prefix = '',
  }) {
    yamlData.forEach((key, value) {
      final fullKey = prefix.isEmpty ? key.toString() : '$prefix.${key.toString()}';

      if (value is String) {
        entries.add(TranslationEntry(
          id: _uuid.v4(),
          key: fullKey,
          projectId: 'unknown',
          sourceLanguage: language,
          targetLanguage: language,
          sourceText: value,
          targetText: value,
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      } else if (value is Map) {
        _parseYamlObject(value, entries, language, warnings, prefix: fullKey);
      } else if (value is List) {
        // 处理数组
        for (int i = 0; i < value.length; i++) {
          final item = value[i];
          if (item is String) {
            entries.add(TranslationEntry(
              id: _uuid.v4(),
              key: '$fullKey[$i]',
              projectId: 'unknown',
              sourceLanguage: language,
              targetLanguage: language,
              sourceText: item,
              targetText: item,
              status: TranslationStatus.completed,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ));
          } else {
            warnings.add('Array item at $fullKey[$i] is not a string, skipping');
          }
        }
      } else {
        warnings.add('Value at $fullKey is not a string or map, skipping');
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

  /// 排序 YAML 对象
  Map<String, dynamic> _sortYamlObject(Map<String, dynamic> obj) {
    final sorted = <String, dynamic>{};
    final keys = obj.keys.toList()..sort();

    for (final key in keys) {
      final value = obj[key];
      if (value is Map<String, dynamic>) {
        sorted[key] = _sortYamlObject(value);
      } else {
        sorted[key] = value;
      }
    }

    return sorted;
  }

  /// 将对象转换为 YAML 字符串
  String _yamlToString(Map<String, dynamic> obj, int indent) {
    final buffer = StringBuffer();
    _writeYamlObject(buffer, obj, 0, indent);
    return buffer.toString();
  }

  /// 写入 YAML 对象
  void _writeYamlObject(StringBuffer buffer, Map<String, dynamic> obj, int currentIndent, int indentSize) {
    obj.forEach((key, value) {
      final indentStr = ' ' * currentIndent;

      if (value is Map<String, dynamic>) {
        buffer.writeln('$indentStr$key:');
        _writeYamlObject(buffer, value, currentIndent + indentSize, indentSize);
      } else if (value is List) {
        buffer.writeln('$indentStr$key:');
        for (final item in value) {
          buffer.writeln('$indentStr${' ' * indentSize}- ${_escapeYamlValue(item)}');
        }
      } else {
        buffer.writeln('$indentStr$key: ${_escapeYamlValue(value)}');
      }
    });
  }

  /// 转义 YAML 值
  String _escapeYamlValue(dynamic value) {
    if (value is String) {
      // 检查是否需要引号
      if (value.contains('\n') ||
          value.contains('"') ||
          value.contains("'") ||
          value.startsWith(' ') ||
          value.endsWith(' ') ||
          value.isEmpty) {
        return '"${value.replaceAll('"', '\\"')}"';
      }
      return value;
    }
    return value.toString();
  }
}
