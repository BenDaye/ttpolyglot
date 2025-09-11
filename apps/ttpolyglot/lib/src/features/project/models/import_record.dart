import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 导入记录状态
enum ImportRecordStatus {
  /// 成功
  success,

  /// 失败
  failure,

  /// 部分成功
  partial,
}

/// 导入记录状态扩展
extension ImportRecordStatusExtension on ImportRecordStatus {
  /// 获取状态的中文显示名称
  String get displayName {
    switch (this) {
      case ImportRecordStatus.success:
        return '成功';
      case ImportRecordStatus.failure:
        return '失败';
      case ImportRecordStatus.partial:
        return '部分成功';
    }
  }

  /// 获取状态图标
  String get iconName {
    switch (this) {
      case ImportRecordStatus.success:
        return 'check_circle';
      case ImportRecordStatus.failure:
        return 'error';
      case ImportRecordStatus.partial:
        return 'warning';
    }
  }
}

/// 导入记录
class ImportRecord {
  const ImportRecord({
    required this.id,
    required this.fileName,
    required this.status,
    required this.message,
    required this.importedCount,
    required this.conflictCount,
    required this.skippedCount,
    required this.timestamp,
    this.language,
    this.fileSize,
    this.duration,
  });

  /// 记录ID
  final String id;

  /// 文件名
  final String fileName;

  /// 导入状态
  final ImportRecordStatus status;

  /// 导入消息
  final String message;

  /// 成功导入数量
  final int importedCount;

  /// 冲突数量
  final int conflictCount;

  /// 跳过数量
  final int skippedCount;

  /// 导入时间
  final DateTime timestamp;

  /// 语言代码（可选）
  final String? language;

  /// 文件大小（字节，可选）
  final int? fileSize;

  /// 导入耗时（毫秒，可选）
  final int? duration;

  /// 总条目数
  int get totalCount => importedCount + conflictCount + skippedCount;

  /// 成功率
  double get successRate => totalCount > 0 ? importedCount / totalCount : 0.0;

  /// 格式化时间显示
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} 分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} 小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} 天前';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }

  /// 格式化文件大小
  String? get formattedFileSize {
    if (fileSize == null) return null;

    final size = fileSize!;
    if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  /// 格式化耗时
  String? get formattedDuration {
    if (duration == null) return null;

    final ms = duration!;
    if (ms < 1000) {
      return '${ms}ms';
    } else {
      return '${(ms / 1000).toStringAsFixed(1)}s';
    }
  }

  /// 创建副本
  ImportRecord copyWith({
    String? id,
    String? fileName,
    ImportRecordStatus? status,
    String? message,
    int? importedCount,
    int? conflictCount,
    int? skippedCount,
    DateTime? timestamp,
    String? language,
    int? fileSize,
    int? duration,
  }) {
    return ImportRecord(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      status: status ?? this.status,
      message: message ?? this.message,
      importedCount: importedCount ?? this.importedCount,
      conflictCount: conflictCount ?? this.conflictCount,
      skippedCount: skippedCount ?? this.skippedCount,
      timestamp: timestamp ?? this.timestamp,
      language: language ?? this.language,
      fileSize: fileSize ?? this.fileSize,
      duration: duration ?? this.duration,
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'status': status.index,
      'message': message,
      'importedCount': importedCount,
      'conflictCount': conflictCount,
      'skippedCount': skippedCount,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'language': language,
      'fileSize': fileSize,
      'duration': duration,
    };
  }

  /// 从 Map 创建
  factory ImportRecord.fromMap(Map<String, dynamic> map) {
    return ImportRecord(
      id: map['id'] ?? '',
      fileName: map['fileName'] ?? '',
      status: ImportRecordStatus.values[map['status'] ?? 0],
      message: map['message'] ?? '',
      importedCount: map['importedCount']?.toInt() ?? 0,
      conflictCount: map['conflictCount']?.toInt() ?? 0,
      skippedCount: map['skippedCount']?.toInt() ?? 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      language: map['language'],
      fileSize: map['fileSize']?.toInt(),
      duration: map['duration']?.toInt(),
    );
  }

  /// 转换为 JSON
  String toJson() => json.encode(toMap());

  /// 从 JSON 创建
  factory ImportRecord.fromJson(String source) => ImportRecord.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ImportRecord(id: $id, fileName: $fileName, status: $status, message: $message, importedCount: $importedCount, conflictCount: $conflictCount, skippedCount: $skippedCount, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImportRecord &&
        other.id == id &&
        other.fileName == fileName &&
        other.status == status &&
        other.message == message &&
        other.importedCount == importedCount &&
        other.conflictCount == conflictCount &&
        other.skippedCount == skippedCount &&
        other.timestamp == timestamp &&
        other.language == language &&
        other.fileSize == fileSize &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fileName.hashCode ^
        status.hashCode ^
        message.hashCode ^
        importedCount.hashCode ^
        conflictCount.hashCode ^
        skippedCount.hashCode ^
        timestamp.hashCode ^
        language.hashCode ^
        fileSize.hashCode ^
        duration.hashCode;
  }
}

/// 导入历史记录数据模型
class ImportHistoryItem {
  final String filename;
  final String description;
  final DateTime timestamp;
  final bool success;
  final String format;
  final int recordCount;

  ImportHistoryItem({
    required this.filename,
    required this.description,
    required this.timestamp,
    required this.success,
    required this.format,
    required this.recordCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'success': success,
      'format': format,
      'recordCount': recordCount,
    };
  }

  factory ImportHistoryItem.fromJson(Map<String, dynamic> json) {
    return ImportHistoryItem(
      filename: json['filename'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      success: json['success'],
      format: json['format'],
      recordCount: json['recordCount'],
    );
  }
}

/// 导入历史缓存服务
class ImportHistoryCache {
  static const String _cacheKey = 'import_history';
  static const int _maxHistoryPerProject = 5;

  static Future<void> saveImportHistory(String projectId, ImportHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';

    // 获取现有历史记录
    final historyList = await getImportHistory(projectId);

    // 添加新记录到开头
    historyList.insert(0, item);

    // 限制每个项目最多5条记录
    if (historyList.length > _maxHistoryPerProject) {
      historyList.removeRange(_maxHistoryPerProject, historyList.length);
    }

    // 保存到缓存
    final jsonList = historyList.map((item) => item.toJson()).toList();
    await prefs.setString(key, jsonEncode(jsonList));
  }

  static Future<List<ImportHistoryItem>> getImportHistory(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';

    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => ImportHistoryItem.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearImportHistory(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';
    await prefs.remove(key);
  }
}
