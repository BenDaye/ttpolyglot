import 'dart:io';
import 'dart:typed_data';

import '../base_service.dart';
import '../../config/server_config.dart';

/// 文件上传结果
class FileUploadResult {
  final bool success;
  final String? code;
  final String? message;
  final String? filePath;
  final String? fileName;
  final String? originalFileName;
  final int? fileSize;
  final String? contentType;
  final String? url;

  const FileUploadResult._({
    required this.success,
    this.code,
    this.message,
    this.filePath,
    this.fileName,
    this.originalFileName,
    this.fileSize,
    this.contentType,
    this.url,
  });

  factory FileUploadResult.success({
    required String filePath,
    required String fileName,
    required String originalFileName,
    required int fileSize,
    required String contentType,
    required String url,
  }) {
    return FileUploadResult._(
      success: true,
      filePath: filePath,
      fileName: fileName,
      originalFileName: originalFileName,
      fileSize: fileSize,
      contentType: contentType,
      url: url,
    );
  }

  factory FileUploadResult.failure(String code, String message) {
    return FileUploadResult._(
      success: false,
      code: code,
      message: message,
    );
  }
}

/// 文件上传服务
class FileUploadService extends BaseService {
  final String _uploadDir;

  FileUploadService()
      : _uploadDir = 'uploads/avatars',
        super('FileUploadService');

  /// 上传头像
  Future<FileUploadResult> uploadAvatar({
    required String userId,
    required Uint8List fileData,
    required String fileName,
    required String contentType,
  }) async {
    try {
      // final logger = LoggerFactory.getLogger('FileUploadService');
      logger.info('开始上传头像: $userId, 文件名: $fileName');

      // 验证文件类型
      if (!_isValidImageType(contentType)) {
        return FileUploadResult.failure('INVALID_FILE_TYPE', '只支持图片文件');
      }

      // 验证文件大小
      if (fileData.length > 5 * 1024 * 1024) {
        // 5MB
        return FileUploadResult.failure('FILE_TOO_LARGE', '文件大小不能超过5MB');
      }

      // 创建上传目录
      final uploadDir = Directory(_uploadDir);
      if (!await uploadDir.exists()) {
        await uploadDir.create(recursive: true);
      }

      // 生成唯一文件名
      final fileExtension = _getFileExtension(fileName);
      final uniqueFileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final filePath = '$_uploadDir/$uniqueFileName';

      // 保存文件
      final file = File(filePath);
      await file.writeAsBytes(fileData);

      // 生成访问URL
      final avatarUrl = '${ServerConfig.siteUrl}/$filePath';

      logger.info('头像上传成功: $avatarUrl');

      return FileUploadResult.success(
        filePath: filePath,
        fileName: uniqueFileName,
        originalFileName: fileName,
        fileSize: fileData.length,
        contentType: contentType,
        url: avatarUrl,
      );
    } catch (error, stackTrace) {
      logger.error('头像上传失败', error: error, stackTrace: stackTrace);
      return FileUploadResult.failure('UPLOAD_FAILED', '上传失败，请稍后重试');
    }
  }

  /// 删除头像
  Future<bool> deleteAvatar(String filePath) async {
    try {
      // final logger = LoggerFactory.getLogger('FileUploadService');
      logger.info('删除头像: $filePath');

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        logger.info('头像删除成功: $filePath');
        return true;
      }

      logger.warn('头像文件不存在: $filePath');
      return false;
    } catch (error, stackTrace) {
      logger.error('删除头像失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 验证是否为有效的图片类型
  bool _isValidImageType(String contentType) {
    const validTypes = [
      'image/jpeg',
      'image/jpg',
      'image/png',
      'image/gif',
      'image/webp',
    ];
    return validTypes.contains(contentType.toLowerCase());
  }

  /// 获取文件扩展名
  String _getFileExtension(String fileName) {
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1) return '';
    return fileName.substring(lastDot);
  }

  /// 清理旧的头像文件
  Future<void> cleanupOldAvatars(String userId) async {
    try {
      // final logger = LoggerFactory.getLogger('FileUploadService');
      logger.info('清理用户旧头像: $userId');

      final uploadDir = Directory(_uploadDir);
      if (!await uploadDir.exists()) return;

      final files = await uploadDir.list().toList();
      for (final file in files) {
        if (file is File && file.path.contains('${userId}_')) {
          await file.delete();
          logger.info('删除旧头像: ${file.path}');
        }
      }
    } catch (error, stackTrace) {
      logger.error('清理旧头像失败', error: error, stackTrace: stackTrace);
    }
  }
}
