 import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:ttpolyglot_core/core.dart';

/// 文件系统存储服务实现（桌面端）
class FileSystemStorageServiceImpl extends FileSystemStorageService {
  late final Directory _rootDirectory;
  late final Directory _configDirectory;
  late final Directory _projectsDirectory;
  
  bool _initialized = false;

  /// 初始化存储服务
  Future<void> initialize() async {
    if (_initialized) return;

    // 获取应用数据目录
    final appDataDir = await getApplicationSupportDirectory();
    _rootDirectory = Directory(path.join(appDataDir.path, 'ttpolyglot'));
    _configDirectory = Directory(path.join(_rootDirectory.path, 'config'));
    _projectsDirectory = Directory(path.join(_rootDirectory.path, 'projects'));

    // 确保目录存在
    await _rootDirectory.create(recursive: true);
    await _configDirectory.create(recursive: true);
    await _projectsDirectory.create(recursive: true);

    _initialized = true;
  }

  @override
  Future<void> write(String key, String data) async {
    await _ensureInitialized();
    
    final file = await _getFileForKey(key);
    await file.parent.create(recursive: true);
    await file.writeAsString(data, encoding: utf8);
  }

  @override
  Future<String?> read(String key) async {
    await _ensureInitialized();
    
    final file = await _getFileForKey(key);
    if (!await file.exists()) return null;
    
    try {
      return await file.readAsString(encoding: utf8);
    } catch (e, stackTrace) {
      log('Error reading file for key $key: $e', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    await _ensureInitialized();
    
    final file = await _getFileForKey(key);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<List<String>> listKeys(String prefix) async {
    await _ensureInitialized();
    
    final keys = <String>[];
    
    // 递归遍历目录
    await for (final entity in _rootDirectory.list(recursive: true)) {
      if (entity is File) {
        final relativePath = path.relative(entity.path, from: _rootDirectory.path);
        final key = relativePath.replaceAll(path.separator, '.');
        final keyWithoutExtension = key.replaceAll('.json', '');
        
        if (keyWithoutExtension.startsWith(prefix)) {
          keys.add(keyWithoutExtension);
        }
      }
    }
    
    return keys;
  }

  @override
  Future<bool> exists(String key) async {
    await _ensureInitialized();
    
    final file = await _getFileForKey(key);
    return await file.exists();
  }

  @override
  Future<void> clear() async {
    await _ensureInitialized();
    
    if (await _rootDirectory.exists()) {
      await _rootDirectory.delete(recursive: true);
      await initialize(); // 重新初始化
    }
  }

  @override
  Future<int> getSize() async {
    await _ensureInitialized();
    
    int totalSize = 0;
    await for (final entity in _rootDirectory.list(recursive: true)) {
      if (entity is File) {
        final stat = await entity.stat();
        totalSize += stat.size;
      }
    }
    
    return totalSize;
  }

  @override
  Future<Map<String, String>> exportData() async {
    await _ensureInitialized();
    
    final data = <String, String>{};
    final keys = await listKeys('');
    
    for (final key in keys) {
      final value = await read(key);
      if (value != null) {
        data[key] = value;
      }
    }
    
    return data;
  }

  @override
  Future<void> importData(Map<String, String> data) async {
    await _ensureInitialized();
    
    for (final entry in data.entries) {
      await write(entry.key, entry.value);
    }
  }

  @override
  Future<String> getStorageRoot() async {
    await _ensureInitialized();
    return _rootDirectory.path;
  }

  @override
  Future<String> getConfigDirectory() async {
    await _ensureInitialized();
    return _configDirectory.path;
  }

  @override
  Future<String> getProjectDirectory(String projectId) async {
    await _ensureInitialized();
    final projectDir = Directory(path.join(_projectsDirectory.path, projectId));
    return projectDir.path;
  }

  @override
  Future<void> ensureDirectoryExists(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// 确保已初始化
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  /// 根据键获取文件
  Future<File> _getFileForKey(String key) async {
    // 将点分隔的键转换为文件路径
    final segments = key.split('.');
    final fileName = '${segments.last}.json';
    final dirSegments = segments.sublist(0, segments.length - 1);
    
    String filePath;
    if (dirSegments.isEmpty) {
      filePath = path.join(_rootDirectory.path, fileName);
    } else {
      final dirPath = path.join(_rootDirectory.path, dirSegments.join(path.separator));
      filePath = path.join(dirPath, fileName);
    }
    
    return File(filePath);
  }
}