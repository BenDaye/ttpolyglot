import '../enums/sync_status.dart';
import '../models/translation_entry.dart';

/// 同步服务接口
abstract class SyncService {
  /// 推送本地更改到远程
  Future<SyncResult> pushToRemote(String projectId);

  /// 从远程拉取更改到本地
  Future<SyncResult> pullFromRemote(String projectId);

  /// 获取同步状态
  Future<SyncStatus> getSyncStatus(String projectId);

  /// 检查是否有冲突
  Future<List<ConflictEntry>> checkConflicts(String projectId);

  /// 解决冲突
  Future<void> resolveConflicts(
    String projectId,
    List<ConflictResolution> resolutions,
  );

  /// 监听远程更改
  Stream<SyncEvent> watchRemoteChanges(String projectId);

  /// 获取同步历史
  Future<List<SyncHistory>> getSyncHistory(String projectId);
}

/// 同步结果
class SyncResult {
  const SyncResult({
    required this.success,
    required this.timestamp,
    this.message,
    this.conflictCount = 0,
    this.updatedCount = 0,
    this.errors = const [],
  });

  final bool success;
  final DateTime timestamp;
  final String? message;
  final int conflictCount;
  final int updatedCount;
  final List<String> errors;
}

/// 冲突条目
class ConflictEntry {
  const ConflictEntry({
    required this.entryId,
    required this.localEntry,
    required this.remoteEntry,
    required this.conflictType,
  });

  final String entryId;
  final TranslationEntry localEntry;
  final TranslationEntry remoteEntry;
  final ConflictType conflictType;
}

/// 冲突类型
enum ConflictType {
  textConflict,
  statusConflict,
  metadataConflict,
}

/// 冲突解决方案
class ConflictResolution {
  const ConflictResolution({
    required this.entryId,
    required this.resolution,
    this.customEntry,
  });

  final String entryId;
  final ResolutionType resolution;
  final TranslationEntry? customEntry;
}

/// 解决方案类型
enum ResolutionType {
  useLocal,
  useRemote,
  useCustom,
}

/// 同步事件
class SyncEvent {
  const SyncEvent({
    required this.type,
    required this.timestamp,
    required this.projectId,
    this.data,
  });

  final SyncEventType type;
  final DateTime timestamp;
  final String projectId;
  final Map<String, dynamic>? data;
}

/// 同步事件类型
enum SyncEventType {
  translationUpdated,
  translationAdded,
  translationDeleted,
  statusChanged,
  conflictDetected,
}

/// 同步历史
class SyncHistory {
  const SyncHistory({
    required this.id,
    required this.projectId,
    required this.timestamp,
    required this.type,
    required this.success,
    this.message,
    this.details,
  });

  final String id;
  final String projectId;
  final DateTime timestamp;
  final SyncType type;
  final bool success;
  final String? message;
  final Map<String, dynamic>? details;
}

/// 同步类型
enum SyncType {
  push,
  pull,
  autoSync,
}
