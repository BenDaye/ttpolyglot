/// 翻译键样式
enum TranslationKeyStyle {
  /// 嵌套样式（例如: { "user": { "name": "Name" } }）
  nested,

  /// 扁平样式（例如: { "user.name": "Name" }）
  flat,
}

/// 导出选项
class ExportOptions {
  /// 要导出的语言列表（为空表示导出所有语言）
  final List<String> languages;

  /// 键样式
  final TranslationKeyStyle keyStyle;

  /// 是否将第一级键分离到不同文件中
  final bool separateFirstLevelKeyIntoFiles;

  /// 是否使用语言代码作为文件夹名称
  final bool useLanguageCodeAsFolderName;

  const ExportOptions({
    this.languages = const [],
    this.keyStyle = TranslationKeyStyle.nested,
    this.separateFirstLevelKeyIntoFiles = false,
    this.useLanguageCodeAsFolderName = false,
  });

  /// 复制并修改选项
  ExportOptions copyWith({
    List<String>? languages,
    TranslationKeyStyle? keyStyle,
    bool? separateFirstLevelKeyIntoFiles,
    bool? useLanguageCodeAsFolderName,
  }) {
    return ExportOptions(
      languages: languages ?? this.languages,
      keyStyle: keyStyle ?? this.keyStyle,
      separateFirstLevelKeyIntoFiles: separateFirstLevelKeyIntoFiles ?? this.separateFirstLevelKeyIntoFiles,
      useLanguageCodeAsFolderName: useLanguageCodeAsFolderName ?? this.useLanguageCodeAsFolderName,
    );
  }

  @override
  String toString() {
    return 'ExportOptions(languages: $languages, keyStyle: $keyStyle, '
        'separateFirstLevelKeyIntoFiles: $separateFirstLevelKeyIntoFiles, '
        'useLanguageCodeAsFolderName: $useLanguageCodeAsFolderName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExportOptions &&
        other.languages == languages &&
        other.keyStyle == keyStyle &&
        other.separateFirstLevelKeyIntoFiles == separateFirstLevelKeyIntoFiles &&
        other.useLanguageCodeAsFolderName == useLanguageCodeAsFolderName;
  }

  @override
  int get hashCode {
    return languages.hashCode ^
        keyStyle.hashCode ^
        separateFirstLevelKeyIntoFiles.hashCode ^
        useLanguageCodeAsFolderName.hashCode;
  }
}
