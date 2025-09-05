import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

/// 导出任务参数
class ExportTaskParams {
  const ExportTaskParams({
    required this.project,
    required this.entries,
  });

  final Project project;
  final List<TranslationEntry> entries;
}

/// 导出任务结果
class ExportTaskResult {
  const ExportTaskResult({
    required this.success,
    this.archiveData,
    this.error,
  });

  final bool success;
  final List<int>? archiveData;
  final String? error;
}

class ExportServiceImplDesktop {
  /// 使用 isolate 导出翻译文件
  static Future<bool> exportTranslationsJson({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.nested,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  }) async {
    try {
      // 生成默认文件名
      final defaultFileName = '${project.name}_translations.zip';

      // 在主线程中选择保存位置
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

      // 创建导出任务参数
      final taskParams = ExportTaskParams(
        project: project,
        entries: entries,
      );

      // 在 isolate 中执行导出任务
      final result = await compute(_executeExportTask, taskParams);

      if (!result.success) {
        log('导出任务失败: ${result.error}', name: 'ExportServiceImplDesktop');
        return false;
      }

      // 在主线程中写入文件
      final zipFile = File(savePath);
      await zipFile.writeAsBytes(result.archiveData!);

      log('导出完成: $savePath', name: 'ExportServiceImplDesktop');
      return true;
    } catch (error, stackTrace) {
      log('导出翻译文件失败', error: error, stackTrace: stackTrace, name: 'ExportServiceImplDesktop');
      throw Exception('导出翻译文件失败: $error');
    }
  }

  /// 在 isolate 中执行导出任务
  static Future<ExportTaskResult> _executeExportTask(ExportTaskParams params) async {
    try {
      final allLanguages = [params.project.primaryLanguage, ...params.project.targetLanguages];
      final Archive archive = Archive();

      // 处理每个语言的翻译
      for (final language in allLanguages) {
        // 过滤当前语言的翻译条目
        final filterEntries = params.entries.where((entry) => entry.targetLanguage.code == language.code).toList();

        // 按键排序
        filterEntries.sort((a, b) => a.key.compareTo(b.key));

        // 使用 JSON 解析器生成内容
        final jsonParser = ParserFactory.getParser(FileFormats.json);
        final jsonString = await jsonParser.writeString(
          filterEntries,
          language,
          options: {
            'nestedKeyStyle': true,
          },
        );

        // 创建压缩文件条目
        final fileName = '${language.code}.json';
        final contentBytes = utf8.encode(jsonString);
        final file = ArchiveFile(fileName, contentBytes.length, contentBytes);
        archive.addFile(file);

        log('导出翻译文件: $fileName', name: 'ExportServiceImplDesktop');
      }

      // 编码为 ZIP 数据
      final zipData = ZipEncoder().encode(archive);

      return ExportTaskResult(
        success: true,
        archiveData: zipData,
      );
    } catch (error, stackTrace) {
      log('导出任务执行失败', error: error, stackTrace: stackTrace, name: 'ExportServiceImplDesktop');
      return ExportTaskResult(
        success: false,
        error: error.toString(),
      );
    }
  }
}
