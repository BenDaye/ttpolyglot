import 'dart:io';

import 'package:path/path.dart' as path;

/// 文件工具类
class FileUtils {
  FileUtils._();

  /// 读取文件内容
  static Future<String> readFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileSystemException('File not found', filePath);
      }
      return await file.readAsString();
    } catch (e) {
      throw FileSystemException('Failed to read file: $e', filePath);
    }
  }

  /// 写入文件内容
  static Future<void> writeFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      final directory = file.parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      await file.writeAsString(content);
    } catch (e) {
      throw FileSystemException('Failed to write file: $e', filePath);
    }
  }

  /// 检查文件是否存在
  static Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  /// 获取文件扩展名
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  /// 获取文件名（不含扩展名）
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  /// 获取文件目录
  static String getFileDirectory(String filePath) {
    return path.dirname(filePath);
  }

  /// 规范化路径
  static String normalizePath(String filePath) {
    return path.normalize(filePath);
  }

  /// 连接路径
  static String joinPath(String part1, String part2) {
    return path.join(part1, part2);
  }

  /// 检查是否为绝对路径
  static bool isAbsolutePath(String filePath) {
    return path.isAbsolute(filePath);
  }

  /// 获取相对路径
  static String getRelativePath(String from, String to) {
    return path.relative(to, from: from);
  }

  /// 确保目录存在
  static Future<void> ensureDirectoryExists(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// 列出目录下的文件
  static Future<List<String>> listFiles(String directoryPath, {String? extension}) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return [];
    }

    final files = <String>[];
    await for (final entity in directory.list()) {
      if (entity is File) {
        final filePath = entity.path;
        if (extension == null || getFileExtension(filePath) == extension) {
          files.add(filePath);
        }
      }
    }
    return files;
  }

  /// 递归列出目录下的文件
  static Future<List<String>> listFilesRecursively(String directoryPath, {String? extension}) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return [];
    }

    final files = <String>[];
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) {
        final filePath = entity.path;
        if (extension == null || getFileExtension(filePath) == extension) {
          files.add(filePath);
        }
      }
    }
    return files;
  }
}
