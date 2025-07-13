/// 同步状态枚举
enum SyncStatus {
  /// 已同步
  synced,

  /// 有本地更改
  localChanges,

  /// 有远程更改
  remoteChanges,

  /// 有冲突
  conflicts,

  /// 同步中
  syncing,

  /// 同步失败
  syncFailed,

  /// 离线
  offline,
}

/// 同步状态扩展
extension SyncStatusExtension on SyncStatus {
  /// 获取状态的中文显示名称
  String get displayName {
    switch (this) {
      case SyncStatus.synced:
        return '已同步';
      case SyncStatus.localChanges:
        return '有本地更改';
      case SyncStatus.remoteChanges:
        return '有远程更改';
      case SyncStatus.conflicts:
        return '有冲突';
      case SyncStatus.syncing:
        return '同步中';
      case SyncStatus.syncFailed:
        return '同步失败';
      case SyncStatus.offline:
        return '离线';
    }
  }

  /// 获取状态图标
  String get icon {
    switch (this) {
      case SyncStatus.synced:
        return '✅';
      case SyncStatus.localChanges:
        return '📝';
      case SyncStatus.remoteChanges:
        return '📥';
      case SyncStatus.conflicts:
        return '⚠️';
      case SyncStatus.syncing:
        return '🔄';
      case SyncStatus.syncFailed:
        return '❌';
      case SyncStatus.offline:
        return '📴';
    }
  }

  /// 是否需要用户操作
  bool get needsAction {
    return this == SyncStatus.localChanges ||
        this == SyncStatus.remoteChanges ||
        this == SyncStatus.conflicts ||
        this == SyncStatus.syncFailed;
  }
}
