import 'package:ttpolyglot_core/core.dart';

/// 解析结果类
class ParserResult {
  const ParserResult({
    required this.entries,
    required this.language,
    this.metadata = const {},
    this.warnings = const [],
  });

  /// 解析出的翻译条目
  final List<TranslationEntry> entries;

  /// 语言信息
  final Language language;

  /// 元数据信息
  final Map<String, dynamic> metadata;

  /// 警告信息
  final List<String> warnings;

  /// 是否有警告
  bool get hasWarnings => warnings.isNotEmpty;

  /// 条目数量
  int get entryCount => entries.length;

  /// 复制并更新结果
  ParserResult copyWith({
    List<TranslationEntry>? entries,
    Language? language,
    Map<String, dynamic>? metadata,
    List<String>? warnings,
  }) {
    return ParserResult(
      entries: entries ?? this.entries,
      language: language ?? this.language,
      metadata: metadata ?? this.metadata,
      warnings: warnings ?? this.warnings,
    );
  }

  @override
  String toString() {
    return 'ParserResult(entries: ${entries.length}, language: ${language.code}, warnings: ${warnings.length})';
  }
}

/// 写入结果类
class WriteResult {
  const WriteResult({
    required this.filePath,
    required this.success,
    this.message,
    this.warnings = const [],
  });

  /// 写入的文件路径
  final String filePath;

  /// 是否成功
  final bool success;

  /// 结果消息
  final String? message;

  /// 警告信息
  final List<String> warnings;

  /// 是否有警告
  bool get hasWarnings => warnings.isNotEmpty;

  @override
  String toString() {
    return 'WriteResult(filePath: $filePath, success: $success, warnings: ${warnings.length})';
  }
}
