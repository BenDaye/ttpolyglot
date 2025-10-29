import 'dart:io';
import 'dart:typed_data';

import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

/// 文件上传服务
class FileUploadService extends BaseService {
  final String _uploadDir;

  FileUploadService()
      : _uploadDir = 'uploads/avatars',
        super('FileUploadService');

  /// 上传头像
  Future<FileModel?> uploadAvatar({
    required String userId,
    required Uint8List fileData,
    required String fileName,
    required String contentType,
  }) async {
    try {
      // final logger = LoggerFactory.getLogger('FileUploadService');
      ServerLogger.info('开始上传头像: $userId, 文件名: $fileName');

      // 验证文件类型
      if (!_isValidImageType(contentType)) {
        throw FileUploadException(message: '只支持图片文件');
      }

      // 验证文件大小
      if (fileData.length > 5 * 1024 * 1024) {
        // 5MB
        throw FileUploadException(message: '文件大小不能超过5MB');
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

      ServerLogger.info('头像上传成功: $avatarUrl');

      final fileModel = FileModel(
        id: uniqueFileName,
        name: uniqueFileName,
        path: filePath,
        size: fileData.length,
        type: contentType,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return fileModel;
    } catch (error, stackTrace) {
      ServerLogger.error('头像上传失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 删除头像
  Future<bool> deleteAvatar(String filePath) async {
    try {
      // final logger = LoggerFactory.getLogger('FileUploadService');
      ServerLogger.info('删除头像: $filePath');

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        ServerLogger.info('头像删除成功: $filePath');
        return true;
      }

      ServerLogger.warning('头像文件不存在: $filePath');
      return false;
    } catch (error, stackTrace) {
      ServerLogger.error('删除头像失败', error: error, stackTrace: stackTrace);
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
      ServerLogger.info('清理用户旧头像: $userId');

      final uploadDir = Directory(_uploadDir);
      if (!await uploadDir.exists()) return;

      final files = await uploadDir.list().toList();
      for (final file in files) {
        if (file is File && file.path.contains('${userId}_')) {
          await file.delete();
          ServerLogger.info('删除旧头像: ${file.path}');
        }
      }
    } catch (error, stackTrace) {
      ServerLogger.error('清理旧头像失败', error: error, stackTrace: stackTrace);
    }
  }
}
