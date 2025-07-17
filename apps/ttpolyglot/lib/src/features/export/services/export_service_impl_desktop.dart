import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/translation_service_impl.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

class ExportServiceImplDesktop {
  static Future<bool> exportTranslationsShortcutJson({
    required Project project,
    required List<TranslationEntry> entries,
  }) async {
    try {
      final translationService = Get.find<TranslationServiceImpl>();

      // 生成默认文件名
      final defaultFileName = '${project.name}_translations.zip';

      // 让用户选择保存位置
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: '选择保存位置',
        fileName: defaultFileName,
        allowedExtensions: ['zip'],
        type: FileType.custom,
      );

      if (savePath == null) {
        log('用户取消了文件保存', name: 'ExportServiceImplDesktop');
        return false;
      }

      final allLanguages = [project.defaultLanguage, ...project.targetLanguages];
      final Archive archive = Archive();

      Future<void> export(Language language) async {
        final filterEntries = entries.where((entry) => entry.targetLanguage.code == language.code).toList();
        final content = await translationService.exportTranslations(
          project.id,
          language,
          format: FileFormats.json,
          keyStyle: TranslationKeyStyle.nested,
          entries: filterEntries,
        );

        final fileName = '${language.code}.json';
        final contentBytes = utf8.encode(content);
        final file = ArchiveFile(fileName, contentBytes.length, contentBytes);
        archive.addFile(file);
        log('导出翻译文件: $fileName', name: 'ExportServiceImplDesktop');
      }

      await Future.wait(allLanguages.map(export));

      final zipData = ZipEncoder().encode(archive);
      final zipFile = File(savePath);
      await zipFile.writeAsBytes(zipData ?? []);

      return true;
    } catch (error, stackTrace) {
      log('导出翻译文件失败', error: error, stackTrace: stackTrace, name: 'ExportServiceImplDesktop');
      throw Exception('导出翻译文件失败: $error');
    }
  }
}
