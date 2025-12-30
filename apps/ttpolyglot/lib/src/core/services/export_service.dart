import 'package:ttpolyglot_model/model.dart';

import 'export_options.dart';

/// 导出服务抽象接口
abstract class ExportService {
  /// 导出 JSON 格式的翻译文件
  Future<bool> exportTranslationsJson({
    required ProjectModel project,
    required List<TranslationEntryModel> entries,
    ExportOptions options = const ExportOptions(),
  });

  /// 导出 YAML 格式的翻译文件
  Future<bool> exportTranslationsYaml({
    required ProjectModel project,
    required List<TranslationEntryModel> entries,
    ExportOptions options = const ExportOptions(),
  });

  /// 导出 CSV 格式的翻译文件
  Future<bool> exportTranslationsCsv({
    required ProjectModel project,
    required List<TranslationEntryModel> entries,
    ExportOptions options = const ExportOptions(),
  });

  /// 导出 ARB 格式的翻译文件
  Future<bool> exportTranslationsArb({
    required ProjectModel project,
    required List<TranslationEntryModel> entries,
    ExportOptions options = const ExportOptions(),
  });

  /// 导出 Properties 格式的翻译文件
  Future<bool> exportTranslationsProperties({
    required ProjectModel project,
    required List<TranslationEntryModel> entries,
    ExportOptions options = const ExportOptions(),
  });

  /// 导出 PO 格式的翻译文件
  Future<bool> exportTranslationsPo({
    required ProjectModel project,
    required List<TranslationEntryModel> entries,
    ExportOptions options = const ExportOptions(),
  });
}
