import 'package:ttpolyglot_core/core.dart';

abstract class ExportService {
  /// 快捷导出所有语言到 json 文件
  Future<bool> exportTranslationsJson({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.nested,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  });

  /// 快捷导出所有语言到 yaml 文件
  Future<bool> exportTranslationsYaml({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.nested,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  });

  /// 快捷导出所有语言到 csv 文件
  Future<bool> exportTranslationsCsv({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.flat,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  });

  /// 快捷导出所有语言到 arb 文件
  Future<bool> exportTranslationsArb({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.nested,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  });

  /// 快捷导出所有语言到 properties 文件
  Future<bool> exportTranslationsProperties({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.flat,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  });

  /// 快捷导出所有语言到 po 文件
  Future<bool> exportTranslationsPo({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.flat,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  });
}
