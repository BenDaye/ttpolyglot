import 'package:ttpolyglot_core/core.dart';

import 'parser_result.dart';

/// 翻译文件解析器接口
abstract class TranslationParser {
  /// 解析器支持的文件格式
  String get format;

  /// 解析器的显示名称
  String get displayName;

  /// 支持的文件扩展名
  List<String> get supportedExtensions;

  /// 从文件路径解析翻译条目
  Future<ParserResult> parseFile(String filePath);

  /// 从字符串内容解析翻译条目
  Future<ParserResult> parseString(
    String content,
    Language language, {
    Map<String, dynamic>? options,
  });

  /// 将翻译条目写入文件
  Future<WriteResult> writeFile(
    String filePath,
    List<TranslationEntry> entries,
    Language language, {
    Map<String, dynamic>? options,
  });

  /// 将翻译条目转换为字符串
  Future<String> writeString(
    List<TranslationEntry> entries,
    Language language, {
    Map<String, dynamic>? options,
  });

  /// 验证文件格式
  Future<bool> validateFile(String filePath);

  /// 验证字符串内容
  Future<bool> validateString(String content);

  /// 获取解析选项的描述
  Map<String, String> getOptionsDescription();
}
