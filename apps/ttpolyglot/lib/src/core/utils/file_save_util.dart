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
}
