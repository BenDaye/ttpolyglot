import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';
import 'package:ttpolyglot_utils/utils.dart';

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
  static Future<String?> exportTranslationsShortcutJson({
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
        LoggerUtils.info('用户取消了文件保存');
        return null;
      }

      // 创建导出任务参数
      final taskParams = ExportTaskParams(
        project: project,
        entries: entries,
      );

      // 在 isolate 中执行导出任务
      final result = await compute(_executeExportTask, taskParams);

      if (!result.success) {
        LoggerUtils.error('导出任务失败: ${result.error}');
        return null;
      }

      // 在主线程中写入文件
      final zipFile = File(savePath);
      await zipFile.writeAsBytes(result.archiveData!);

      LoggerUtils.info('导出完成: $savePath');
      return savePath; // 返回保存路径
    } catch (error, stackTrace) {
      LoggerUtils.error('导出翻译文件失败', error: error, stackTrace: stackTrace);
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
            'nestedKeyStyle': false, // 使用扁平格式，与导入demo保持一致
          },
        );

        // 创建压缩文件条目
        final fileName = '${language.code}.json';
        final contentBytes = utf8.encode(jsonString);
        final file = ArchiveFile(fileName, contentBytes.length, contentBytes);
        archive.addFile(file);

        LoggerUtils.info('导出翻译文件: $fileName');
      }

      // 编码为 ZIP 数据
      final zipData = ZipEncoder().encode(archive);

      return ExportTaskResult(
        success: true,
        archiveData: zipData,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('导出任务执行失败', error: error, stackTrace: stackTrace);
      return ExportTaskResult(
        success: false,
        error: error.toString(),
      );
    }
  }

  /// 使用 isolate 导出翻译文件 (CSV格式)
  static Future<String?> exportTranslationsShortcutCsv({
    required Project project,
    required List<TranslationEntry> entries,
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
        LoggerUtils.info('用户取消了文件保存');
        return null;
      }

      // 创建导出任务参数
      final taskParams = ExportTaskParams(
        project: project,
        entries: entries,
      );

      // 在 isolate 中执行导出任务
      final result = await compute(_executeExportTaskCsv, taskParams);

      if (!result.success) {
        LoggerUtils.error('导出任务失败: ${result.error}');
        return null;
      }

      // 在主线程中写入文件
      final zipFile = File(savePath);
      await zipFile.writeAsBytes(result.archiveData!);

      LoggerUtils.info('导出完成: $savePath');
      return savePath; // 返回保存路径
    } catch (error, stackTrace) {
      LoggerUtils.error('导出CSV翻译文件失败', error: error, stackTrace: stackTrace);
      throw Exception('导出CSV翻译文件失败: $error');
    }
  }

  /// 使用 isolate 导出翻译文件 (Excel格式)
  static Future<String?> exportTranslationsShortcutExcel({
    required Project project,
    required List<TranslationEntry> entries,
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
        LoggerUtils.info('用户取消了文件保存');
        return null;
      }

      // 创建导出任务参数
      final taskParams = ExportTaskParams(
        project: project,
        entries: entries,
      );

      // 在 isolate 中执行导出任务
      final result = await compute(_executeExportTaskExcel, taskParams);

      if (!result.success) {
        LoggerUtils.error('导出任务失败: ${result.error}');
        return null;
      }

      // 在主线程中写入文件
      final zipFile = File(savePath);
      await zipFile.writeAsBytes(result.archiveData!);

      LoggerUtils.info('导出完成: $savePath');
      return savePath; // 返回保存路径
    } catch (error, stackTrace) {
      LoggerUtils.error('导出Excel翻译文件失败', error: error, stackTrace: stackTrace);
      throw Exception('导出Excel翻译文件失败: $error');
    }
  }

  /// 使用 isolate 导出翻译文件 (ARB格式)
  static Future<String?> exportTranslationsShortcutArb({
    required Project project,
    required List<TranslationEntry> entries,
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
        LoggerUtils.info('用户取消了文件保存');
        return null;
      }

      // 创建导出任务参数
      final taskParams = ExportTaskParams(
        project: project,
        entries: entries,
      );

      // 在 isolate 中执行导出任务
      final result = await compute(_executeExportTaskArb, taskParams);

      if (!result.success) {
        LoggerUtils.error('导出任务失败: ${result.error}');
        return null;
      }

      // 在主线程中写入文件
      final zipFile = File(savePath);
      await zipFile.writeAsBytes(result.archiveData!);

      LoggerUtils.info('导出完成: $savePath');
      return savePath; // 返回保存路径
    } catch (error, stackTrace) {
      LoggerUtils.error('导出ARB翻译文件失败', error: error, stackTrace: stackTrace);
      throw Exception('导出ARB翻译文件失败: $error');
    }
  }

  /// 使用 isolate 导出翻译文件 (PO格式)
  static Future<String?> exportTranslationsShortcutPo({
    required Project project,
    required List<TranslationEntry> entries,
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
        LoggerUtils.info('用户取消了文件保存');
        return null;
      }

      // 创建导出任务参数
      final taskParams = ExportTaskParams(
        project: project,
        entries: entries,
      );

      // 在 isolate 中执行导出任务
      final result = await compute(_executeExportTaskPo, taskParams);

      if (!result.success) {
        LoggerUtils.error('导出任务失败: ${result.error}');
        return null;
      }

      // 在主线程中写入文件
      final zipFile = File(savePath);
      await zipFile.writeAsBytes(result.archiveData!);

      LoggerUtils.info('导出完成: $savePath');
      return savePath; // 返回保存路径
    } catch (error, stackTrace) {
      LoggerUtils.error('导出PO翻译文件失败', error: error, stackTrace: stackTrace);
      throw Exception('导出PO翻译文件失败: $error');
    }
  }

  /// 在 isolate 中执行CSV导出任务
  static Future<ExportTaskResult> _executeExportTaskCsv(ExportTaskParams params) async {
    try {
      final allLanguages = [params.project.primaryLanguage, ...params.project.targetLanguages];
      final Archive archive = Archive();

      // 处理每个语言的翻译
      for (final language in allLanguages) {
        // 过滤当前语言的翻译条目
        final filterEntries = params.entries.where((entry) => entry.targetLanguage.code == language.code).toList();

        // 按键排序
        filterEntries.sort((a, b) => a.key.compareTo(b.key));

        // 使用 CSV 解析器生成内容
        final csvParser = ParserFactory.getParser(FileFormats.csv);
        final csvString = await csvParser.writeString(
          filterEntries,
          language,
          options: {},
        );

        // 创建压缩文件条目
        final fileName = '${language.code}.csv';
        final contentBytes = utf8.encode(csvString);
        final file = ArchiveFile(fileName, contentBytes.length, contentBytes);
        archive.addFile(file);

        LoggerUtils.info('导出CSV翻译文件: $fileName');
      }

      // 编码为 ZIP 数据
      final zipData = ZipEncoder().encode(archive);

      return ExportTaskResult(
        success: true,
        archiveData: zipData,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('CSV导出任务执行失败', error: error, stackTrace: stackTrace);
      return ExportTaskResult(
        success: false,
        error: error.toString(),
      );
    }
  }

  /// 在 isolate 中执行Excel导出任务
  static Future<ExportTaskResult> _executeExportTaskExcel(ExportTaskParams params) async {
    try {
      final allLanguages = [params.project.primaryLanguage, ...params.project.targetLanguages];
      final Archive archive = Archive();

      // 处理每个语言的翻译
      for (final language in allLanguages) {
        // 过滤当前语言的翻译条目
        final filterEntries = params.entries.where((entry) => entry.targetLanguage.code == language.code).toList();

        // 按键排序
        filterEntries.sort((a, b) => a.key.compareTo(b.key));

        // 使用 Excel 解析器生成内容
        final excelParser = ParserFactory.getParser(FileFormats.csv); // 先使用CSV格式，因为Excel可能不支持
        final excelString = await excelParser.writeString(
          filterEntries,
          language,
          options: {},
        );
        final excelBytes = utf8.encode(excelString);

        // 创建压缩文件条目
        final fileName = '${language.code}.xlsx';
        final file = ArchiveFile(fileName, excelBytes.length, excelBytes);
        archive.addFile(file);

        LoggerUtils.info('导出Excel翻译文件: $fileName');
      }

      // 编码为 ZIP 数据
      final zipData = ZipEncoder().encode(archive);

      return ExportTaskResult(
        success: true,
        archiveData: zipData,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('Excel导出任务执行失败', error: error, stackTrace: stackTrace);
      return ExportTaskResult(
        success: false,
        error: error.toString(),
      );
    }
  }

  /// 在 isolate 中执行ARB导出任务
  static Future<ExportTaskResult> _executeExportTaskArb(ExportTaskParams params) async {
    try {
      final allLanguages = [params.project.primaryLanguage, ...params.project.targetLanguages];
      final Archive archive = Archive();

      // 处理每个语言的翻译
      for (final language in allLanguages) {
        // 过滤当前语言的翻译条目
        final filterEntries = params.entries.where((entry) => entry.targetLanguage.code == language.code).toList();

        // 按键排序
        filterEntries.sort((a, b) => a.key.compareTo(b.key));

        // 使用 ARB 解析器生成内容
        final arbParser = ParserFactory.getParser(FileFormats.arb);
        final arbString = await arbParser.writeString(
          filterEntries,
          language,
          options: {},
        );

        // 创建压缩文件条目
        final fileName = 'app_${language.code}.arb';
        final contentBytes = utf8.encode(arbString);
        final file = ArchiveFile(fileName, contentBytes.length, contentBytes);
        archive.addFile(file);

        LoggerUtils.info('导出ARB翻译文件: $fileName');
      }

      // 编码为 ZIP 数据
      final zipData = ZipEncoder().encode(archive);

      return ExportTaskResult(
        success: true,
        archiveData: zipData,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('ARB导出任务执行失败', error: error, stackTrace: stackTrace);
      return ExportTaskResult(
        success: false,
        error: error.toString(),
      );
    }
  }

  /// 在 isolate 中执行PO导出任务
  static Future<ExportTaskResult> _executeExportTaskPo(ExportTaskParams params) async {
    try {
      final allLanguages = [params.project.primaryLanguage, ...params.project.targetLanguages];
      final Archive archive = Archive();

      // 处理每个语言的翻译
      for (final language in allLanguages) {
        // 过滤当前语言的翻译条目
        final filterEntries = params.entries.where((entry) => entry.targetLanguage.code == language.code).toList();

        // 按键排序
        filterEntries.sort((a, b) => a.key.compareTo(b.key));

        // 使用 PO 解析器生成内容
        final poParser = ParserFactory.getParser(FileFormats.po);
        final poString = await poParser.writeString(
          filterEntries,
          language,
          options: {},
        );

        // 创建压缩文件条目
        final fileName = '${language.code}.po';
        final contentBytes = utf8.encode(poString);
        final file = ArchiveFile(fileName, contentBytes.length, contentBytes);
        archive.addFile(file);

        LoggerUtils.info('导出PO翻译文件: $fileName');
      }

      // 编码为 ZIP 数据
      final zipData = ZipEncoder().encode(archive);

      return ExportTaskResult(
        success: true,
        archiveData: zipData,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('PO导出任务执行失败', error: error, stackTrace: stackTrace);
      return ExportTaskResult(
        success: false,
        error: error.toString(),
      );
    }
  }
}
