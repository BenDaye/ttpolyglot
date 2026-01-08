import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../../services/business/batch_import_service.dart';
import '../../services/business/batch_job_service.dart';
import '../../services/business/stream_export_service.dart';
import '../base_controller.dart';

class FileController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;
  late final BatchImportService _batchImportService;
  late final StreamExportService _streamExportService;
  late final BatchJobService _batchJobService;

  FileController({
    required this.databaseService,
    required this.redisService,
  })  : _batchImportService = BatchImportService(databaseService: databaseService),
        _streamExportService = StreamExportService(
          translationService: TranslationService(databaseService: databaseService),
        ),
        _batchJobService = BatchJobService(databaseService: databaseService),
        super('FileController');

  Future<Response> uploadFile(Request request) async {
    return execute(
      () async {
        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '未授权访问');
        }

        // 解析 multipart 请求
        final contentType = request.headers['content-type'] ?? '';
        if (!contentType.contains('multipart/form-data')) {
          throw ValidationException(message: '请求格式错误，需要 multipart/form-data');
        }

        // 这里简化处理，实际应该使用 shelf_multipart 或其他库来解析
        // 由于 shelf 本身不直接支持 multipart，这里提供一个基础实现
        // 实际实现需要使用 multipart 解析库

        return ResponseUtils.success(
          message: '文件上传功能需要 multipart 解析库支持',
          data: {'note': '请使用 shelf_multipart 或类似库来实现文件上传'},
        );
      },
      operationName: 'uploadFile',
    );
  }

  Future<Response> getFile(Request request, String id) async {
    return execute(
      () async {
        // 从数据库查询文件信息
        final result = await databaseService.query(
          'SELECT * FROM {files} WHERE id = @id',
          {'id': id},
        );

        if (result.isEmpty) {
          throw NotFoundException(message: '文件不存在');
        }

        return ResponseUtils.success(
          message: '获取文件信息成功',
          data: result.first.toColumnMap(),
        );
      },
      operationName: 'getFile',
    );
  }

  Future<Response> downloadFile(Request request, String id) async {
    return execute(
      () async {
        // 从数据库查询文件信息
        final result = await databaseService.query(
          'SELECT * FROM {files} WHERE id = @id',
          {'id': id},
        );

        if (result.isEmpty) {
          throw NotFoundException(message: '文件不存在');
        }

        final fileData = result.first.toColumnMap();
        final filePath = fileData['path']?.toString();

        if (filePath == null) {
          throw NotFoundException(message: '文件路径不存在');
        }

        final file = File(filePath);
        if (!await file.exists()) {
          throw NotFoundException(message: '文件不存在');
        }

        final fileBytes = await file.readAsBytes();
        final contentType = fileData['type']?.toString() ?? 'application/octet-stream';

        return Response.ok(
          fileBytes,
          headers: {
            'Content-Type': contentType,
            'Content-Disposition': 'attachment; filename="${fileData['name'] ?? id}"',
            'Content-Length': fileBytes.length.toString(),
          },
        );
      },
      operationName: 'downloadFile',
    );
  }

  Future<Response> deleteFile(Request request, String id) async {
    return execute(
      () async {
        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '未授权访问');
        }

        // 从数据库查询文件信息
        final result = await databaseService.query(
          'SELECT * FROM {files} WHERE id = @id',
          {'id': id},
        );

        if (result.isEmpty) {
          throw NotFoundException(message: '文件不存在');
        }

        final fileData = result.first.toColumnMap();
        final filePath = fileData['path']?.toString();

        // 删除文件
        if (filePath != null) {
          final file = File(filePath);
          if (await file.exists()) {
            await file.delete();
          }
        }

        // 删除数据库记录
        await databaseService.query(
          'DELETE FROM {files} WHERE id = @id',
          {'id': id},
        );

        return ResponseUtils.success(message: '删除文件成功');
      },
      operationName: 'deleteFile',
    );
  }

  Future<Response> importTranslations(Request request, String id) async {
    return execute(
      () async {
        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '未授权访问');
        }

        final projectId = int.tryParse(id);
        if (projectId == null) {
          throw ValidationException(message: '项目ID格式无效');
        }

        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        // 支持两种格式：直接传递 entries 数组，或传递文件路径
        List<Map<String, dynamic>> entries;
        if (data.containsKey('entries') && data['entries'] is List) {
          entries = (data['entries'] as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
        } else if (data.containsKey('file_path')) {
          // 从文件读取
          final filePath = data['file_path'] as String;
          final file = File(filePath);
          if (!await file.exists()) {
            throw NotFoundException(message: '文件不存在');
          }

          final fileContent = await file.readAsString();
          final fileData = jsonDecode(fileContent);
          if (fileData is List) {
            entries = fileData.map((e) => e as Map<String, dynamic>).toList();
          } else if (fileData is Map && fileData.containsKey('entries')) {
            entries = (fileData['entries'] as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
          } else {
            throw ValidationException(message: '文件格式无效');
          }
        } else {
          throw ValidationException(message: '缺少 entries 或 file_path 参数');
        }

        final overrideExisting = data['override_existing'] as bool? ?? false;

        final jobId = await _batchImportService.batchImportEntries(
          projectId: projectId,
          entries: entries,
          userId: userId,
          overrideExisting: overrideExisting,
        );

        return ResponseUtils.success(
          message: '导入任务已创建',
          data: {'job_id': jobId},
        );
      },
      operationName: 'importTranslations',
    );
  }

  Future<Response> exportTranslations(Request request, String id) async {
    return execute(
      () async {
        final projectId = int.tryParse(id);
        if (projectId == null) {
          throw ValidationException(message: '项目ID格式无效');
        }

        final params = request.url.queryParameters;
        final format = params['format'] ?? 'json'; // json, csv, excel
        final languageCode = params['language_code'];

        String filePath;
        switch (format) {
          case 'json':
            filePath = await _streamExportService.exportToJsonFile(
              projectId: projectId,
              languageCode: languageCode,
            );
            break;
          case 'csv':
            filePath = await _streamExportService.exportToCsvFile(
              projectId: projectId,
              languageCode: languageCode,
            );
            break;
          case 'excel':
            filePath = await _streamExportService.exportToExcel(
              projectId: projectId,
              languageCode: languageCode,
            );
            break;
          default:
            throw ValidationException(message: '不支持的导出格式: $format');
        }

        // 保存文件记录到数据库
        final fileName = filePath.split('/').last;
        final fileSize = await _streamExportService.getExportFileSize(filePath);
        final fileResult = await databaseService.query(
          '''
          INSERT INTO {files} (name, path, size, type, created_by, created_at, updated_at)
          VALUES (@name, @path, @size, @type, @created_by, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
          RETURNING *
          ''',
          {
            'name': fileName,
            'path': filePath,
            'size': fileSize,
            'type': 'application/$format',
            'created_by': getCurrentUserId(request),
          },
        );

        return ResponseUtils.success(
          message: '导出成功',
          data: {
            'file_id': fileResult.first.toColumnMap()['id'],
            'file_path': filePath,
            'file_name': fileName,
          },
        );
      },
      operationName: 'exportTranslations',
    );
  }

  Future<Response> getExportStatus(Request request, String id, String taskId) async {
    return execute(
      () async {
        final job = await _batchJobService.getBatchJobById(taskId);
        if (job == null) {
          throw NotFoundException(message: '导出任务不存在');
        }

        return ResponseUtils.success(
          message: '获取导出状态成功',
          data: job,
        );
      },
      operationName: 'getExportStatus',
    );
  }
}
