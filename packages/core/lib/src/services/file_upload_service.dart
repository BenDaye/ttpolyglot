import 'package:ttpolyglot_model/model.dart';

/// 文件上传服务接口
abstract class FileUploadService {
  /// 创建文件上传记录
  Future<FileUploadModel> createFileUpload(CreateFileUploadRequest request);

  /// 获取文件上传记录
  Future<FileUploadModel?> getFileUpload(int fileId);

  /// 获取用户的所有文件上传记录
  Future<List<FileUploadModel>> getUserFileUploads(
    String userId, {
    String? uploadType,
    bool? isProcessed,
    int? limit,
    int? offset,
  });

  /// 更新文件上传状态
  Future<FileUploadModel> updateFileUploadStatus(
    int fileId, {
    bool? isProcessed,
    String? processingStatus,
  });

  /// 删除文件上传记录
  Future<void> deleteFileUpload(int fileId);

  /// 清理过期的文件上传记录
  Future<int> cleanupExpiredFileUploads();

  /// 根据文件哈希查找文件
  Future<FileUploadModel?> findFileByHash(String fileHash);
}
