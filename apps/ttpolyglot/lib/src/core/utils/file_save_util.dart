import 'dart:io';

import 'file_save_util_stub.dart' if (dart.library.html) 'file_save_util_html.dart' as impl;

class FileSaveUtil {
  /// 保存文本文件
  static Future<bool> saveTextFile({
    required String fileName,
    required String content,
    String mimeType = 'text/plain',
  }) async {
    return await impl.saveTextFile(fileName: fileName, content: content, mimeType: mimeType);
  }

  /// 保存字节文件
  static Future<bool> saveBytesFile({
    required String fileName,
    required List<int> bytes,
    String mimeType = 'application/octet-stream',
  }) async {
    return await impl.saveBytesFile(fileName: fileName, bytes: bytes, mimeType: mimeType);
  }

  /// 从文件路径下载文件
  static Future<bool> downloadFileFromPath({
    required String filePath,
    String? customFileName,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return false;
      }

      final bytes = await file.readAsBytes();
      final fileName = customFileName ?? file.path.split('/').last;

      return await saveBytesFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: _getMimeTypeFromExtension(fileName),
      );
    } catch (e) {
      return false;
    }
  }

  /// 根据文件扩展名获取 MIME 类型
  static String _getMimeTypeFromExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'json':
        return 'application/json';
      case 'csv':
        return 'text/csv';
      case 'xlsx':
      case 'xls':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'zip':
        return 'application/zip';
      case 'arb':
        return 'application/json'; // ARB 文件本质上是 JSON
      case 'po':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }
}
