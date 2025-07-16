import 'package:ttpolyglot_core/core.dart';

abstract class ExportService {
  /// 快捷导出所有语言到 json 文件
  Future<bool> exportTranslationsShortcutJson({
    required Project project,
    required List<TranslationEntry> entries,
  });

  /// 快捷导出所有语言到 yaml 文件
  Future<bool> exportTranslationsShortcutYaml({
    required Project project,
    required List<TranslationEntry> entries,
  });

  /// 快捷导出所有语言到 csv 文件
  Future<bool> exportTranslationsShortcutCsv({
    required Project project,
    required List<TranslationEntry> entries,
  });

  /// 快捷导出所有语言到 arb 文件
  Future<bool> exportTranslationsShortcutArb({
    required Project project,
    required List<TranslationEntry> entries,
  });

  /// 快捷导出所有语言到 properties 文件
  Future<bool> exportTranslationsShortcutProperties({
    required Project project,
    required List<TranslationEntry> entries,
  });

  /// 快捷导出所有语言到 po 文件
  Future<bool> exportTranslationsShortcutPo({
    required Project project,
    required List<TranslationEntry> entries,
  });
}
