import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../base_service.dart';
import 'translation_service.dart';

/// 流式导出服务
///
/// 使用流式处理导出大量翻译数据，避免内存溢出
class StreamExportService extends BaseService {
  final TranslationService _translationService;

  StreamExportService({
    required TranslationService translationService,
  })  : _translationService = translationService,
        super('StreamExportService');

  /// 流式导出翻译条目
  ///
  /// 使用游标分页逐批读取数据，返回Stream
  Stream<List<Map<String, dynamic>>> streamExportEntries({
    required int projectId,
    int? targetLanguageId,
    String? status,
    int batchSize = 1000,
  }) async* {
    logInfo('开始流式导出', context: {
      'project_id': projectId,
      'target_language_id': targetLanguageId,
      'batch_size': batchSize,
    });

    String? cursor;
    bool hasMore = true;
    int totalExported = 0;

    while (hasMore) {
      try {
        // 使用游标分页获取数据
        final result = await _translationService.getTranslationEntriesCursor(
          projectId: projectId.toString(),
          cursor: cursor,
          limit: batchSize,
          targetLanguageId: targetLanguageId,
          status: status,
        );

        final entries = result['entries'] as List<dynamic>;
        final cursorInfo = result['cursor'] as Map<String, dynamic>;

        if (entries.isNotEmpty) {
          totalExported += entries.length;

          logInfo('导出批次', context: {
            'count': entries.length,
            'total': totalExported,
          });

          yield entries.map((e) => e as Map<String, dynamic>).toList();
        }

        cursor = cursorInfo['nextCursor'] as String?;
        hasMore = cursorInfo['hasNextPage'] as bool;
      } catch (error, stackTrace) {
        log('[StreamExportService.streamExportEntries]',
            error: error, stackTrace: stackTrace, name: 'StreamExportService');
        rethrow;
      }
    }

    logInfo('流式导出完成', context: {'total_exported': totalExported});
  }

  /// 导出到JSON文件
  ///
  /// 使用流式处理写入文件，避免内存溢出
  Future<String> exportToJsonFile({
    required int projectId,
    int? targetLanguageId,
    String? status,
    String? outputPath,
  }) async {
    return execute(
      () async {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = outputPath ?? '/tmp/export_project_${projectId}_$timestamp.json';

        logInfo('开始导出到文件', context: {
          'file_path': filePath,
          'project_id': projectId,
        });

        final file = File(filePath);
        final sink = file.openWrite();

        try {
          // 写入JSON数组开始
          sink.write('[\n');

          bool isFirst = true;
          int totalCount = 0;

          // 流式读取和写入
          await for (final batch in streamExportEntries(
            projectId: projectId,
            targetLanguageId: targetLanguageId,
            status: status,
          )) {
            for (final entry in batch) {
              if (!isFirst) {
                sink.write(',\n');
              }
              sink.write('  ${jsonEncode(entry)}');
              isFirst = false;
              totalCount++;
            }
          }

          // 写入JSON数组结束
          sink.write('\n]\n');

          await sink.flush();
          await sink.close();

          logInfo('导出完成', context: {
            'file_path': filePath,
            'total_count': totalCount,
          });

          return filePath;
        } catch (error, stackTrace) {
          log('[StreamExportService.exportToJsonFile]',
              error: error, stackTrace: stackTrace, name: 'StreamExportService');

          await sink.close();

          // 清理失败的文件
          if (await file.exists()) {
            await file.delete();
          }

          rethrow;
        }
      },
      operationName: 'exportToJsonFile',
    );
  }

  /// 导出到CSV文件
  ///
  /// CSV格式导出，适合Excel查看
  Future<String> exportToCsvFile({
    required int projectId,
    int? targetLanguageId,
    String? status,
    String? outputPath,
  }) async {
    return execute(
      () async {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = outputPath ?? '/tmp/export_project_${projectId}_$timestamp.csv';

        logInfo('开始导出到CSV', context: {
          'file_path': filePath,
          'project_id': projectId,
        });

        final file = File(filePath);
        final sink = file.openWrite();

        try {
          // 写入CSV头部
          sink.write(
              'ID,Key,Source Language ID,Target Language ID,Source Text,Target Text,Status,Created At,Updated At\n');

          int totalCount = 0;

          // 流式读取和写入
          await for (final batch in streamExportEntries(
            projectId: projectId,
            targetLanguageId: targetLanguageId,
            status: status,
          )) {
            for (final entry in batch) {
              final id = entry['id'] ?? '';
              final key = _escapeCsv(entry['entry_key'] ?? entry['key'] ?? '');
              final sourceLangId = entry['source_language_id'] ?? '';
              final targetLangId = entry['target_language_id'] ?? '';
              final sourceText = _escapeCsv(entry['source_text'] ?? '');
              final targetText = _escapeCsv(entry['target_text'] ?? '');
              final entryStatus = entry['status'] ?? '';
              final createdAt = entry['created_at'] ?? '';
              final updatedAt = entry['updated_at'] ?? '';

              sink.write(
                  '$id,$key,$sourceLangId,$targetLangId,$sourceText,$targetText,$entryStatus,$createdAt,$updatedAt\n');

              totalCount++;
            }
          }

          await sink.flush();
          await sink.close();

          logInfo('CSV导出完成', context: {
            'file_path': filePath,
            'total_count': totalCount,
          });

          return filePath;
        } catch (error, stackTrace) {
          log('[StreamExportService.exportToCsvFile]',
              error: error, stackTrace: stackTrace, name: 'StreamExportService');

          await sink.close();

          // 清理失败的文件
          if (await file.exists()) {
            await file.delete();
          }

          rethrow;
        }
      },
      operationName: 'exportToCsvFile',
    );
  }

  /// 导出到Excel文件（使用CSV格式，Excel可直接打开）
  Future<String> exportToExcel({
    required int projectId,
    int? targetLanguageId,
    String? status,
    String? outputPath,
  }) async {
    // 实际上输出CSV格式，Excel可以直接打开
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = outputPath ?? '/tmp/export_project_${projectId}_$timestamp.xlsx.csv';

    return await exportToCsvFile(
      projectId: projectId,
      targetLanguageId: targetLanguageId,
      status: status,
      outputPath: filePath,
    );
  }

  /// 转义CSV字段
  String _escapeCsv(String text) {
    // 如果包含逗号、引号或换行符，需要用引号包裹
    if (text.contains(',') || text.contains('"') || text.contains('\n') || text.contains('\r')) {
      // 引号需要转义为两个引号
      final escaped = text.replaceAll('"', '""');
      return '"$escaped"';
    }
    return text;
  }

  /// 获取导出文件大小
  Future<int> getExportFileSize(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }

  /// 删除导出文件
  Future<void> deleteExportFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      logInfo('导出文件已删除', context: {'file_path': filePath});
    }
  }

  /// 批量清理旧的导出文件
  Future<int> cleanupOldExports({
    String directory = '/tmp',
    int daysOld = 7,
  }) async {
    return execute(
      () async {
        final dir = Directory(directory);
        final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
        int deletedCount = 0;

        if (await dir.exists()) {
          final entities = dir.listSync();

          for (final entity in entities) {
            if (entity is File && entity.path.contains('export_project_')) {
              final stat = await entity.stat();
              if (stat.modified.isBefore(cutoffDate)) {
                await entity.delete();
                deletedCount++;
              }
            }
          }
        }

        logInfo('清理旧导出文件', context: {'deleted': deletedCount});
        return deletedCount;
      },
      operationName: 'cleanupOldExports',
    );
  }
}
