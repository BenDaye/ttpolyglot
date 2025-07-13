import 'dart:convert';
import 'dart:typed_data';

/// 编码工具类
class EncodingUtils {
  EncodingUtils._();

  /// 检测文件编码
  static String detectEncoding(Uint8List bytes) {
    // 检查 BOM
    if (bytes.length >= 3) {
      if (bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF) {
        return 'utf-8';
      }
    }

    if (bytes.length >= 2) {
      if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
        return 'utf-16le';
      }
      if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
        return 'utf-16be';
      }
    }

    // 尝试 UTF-8 解码
    try {
      utf8.decode(bytes);
      return 'utf-8';
    } catch (e) {
      // UTF-8 解码失败，假设是 Latin-1
      return 'latin-1';
    }
  }

  /// 将字节数组转换为字符串
  static String bytesToString(Uint8List bytes, {String? encoding}) {
    encoding ??= detectEncoding(bytes);

    switch (encoding.toLowerCase()) {
      case 'utf-8':
        return utf8.decode(bytes);
      case 'utf-16le':
        return String.fromCharCodes(bytes);
      case 'utf-16be':
        return String.fromCharCodes(bytes);
      case 'latin-1':
        return latin1.decode(bytes);
      default:
        return utf8.decode(bytes);
    }
  }

  /// 将字符串转换为字节数组
  static Uint8List stringToBytes(String text, {String encoding = 'utf-8'}) {
    switch (encoding.toLowerCase()) {
      case 'utf-8':
        return Uint8List.fromList(utf8.encode(text));
      case 'latin-1':
        return Uint8List.fromList(latin1.encode(text));
      default:
        return Uint8List.fromList(utf8.encode(text));
    }
  }

  /// 验证字符串是否为有效的 UTF-8
  static bool isValidUtf8(String text) {
    try {
      utf8.encode(text);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 清理无效字符
  static String cleanInvalidCharacters(String text) {
    return text.replaceAll(RegExp(r'[^\x00-\x7F\u0080-\uFFFF]'), '');
  }

  /// 转换为安全的文件名
  static String toSafeFileName(String text) {
    return text.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').replaceAll(RegExp(r'\s+'), '_').toLowerCase();
  }

  /// 转义特殊字符
  static String escapeSpecialCharacters(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  /// 反转义特殊字符
  static String unescapeSpecialCharacters(String text) {
    return text
        .replaceAll('\\\\', '\\')
        .replaceAll('\\"', '"')
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\r')
        .replaceAll('\\t', '\t');
  }
}
