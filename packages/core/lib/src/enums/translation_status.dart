/// 翻译状态枚举
enum TranslationStatus {
  /// 待翻译
  pending,

  /// 翻译中
  translating,

  /// 待审核
  reviewing,

  /// 已完成
  completed,

  /// 需要修改
  needsRevision,

  /// 已拒绝
  rejected,

  /// 已过期
  outdated,
}

/// 翻译状态扩展
extension TranslationStatusExtension on TranslationStatus {
  /// 获取状态的中文显示名称
  String get displayName {
    switch (this) {
      case TranslationStatus.pending:
        return '待翻译';
      case TranslationStatus.translating:
        return '翻译中';
      case TranslationStatus.reviewing:
        return '待审核';
      case TranslationStatus.completed:
        return '已完成';
      case TranslationStatus.needsRevision:
        return '需要修改';
      case TranslationStatus.rejected:
        return '已拒绝';
      case TranslationStatus.outdated:
        return '已过期';
    }
  }

  /// 获取状态颜色
  String get colorCode {
    switch (this) {
      case TranslationStatus.pending:
        return '#FFA500'; // 橙色
      case TranslationStatus.translating:
        return '#1E90FF'; // 蓝色
      case TranslationStatus.reviewing:
        return '#FFD700'; // 金色
      case TranslationStatus.completed:
        return '#32CD32'; // 绿色
      case TranslationStatus.needsRevision:
        return '#FF6347'; // 番茄红
      case TranslationStatus.rejected:
        return '#DC143C'; // 深红色
      case TranslationStatus.outdated:
        return '#808080'; // 灰色
    }
  }

  /// 是否为最终状态
  bool get isFinal {
    return this == TranslationStatus.completed || this == TranslationStatus.rejected;
  }

  /// 是否可编辑
  bool get isEditable {
    return this != TranslationStatus.completed && this != TranslationStatus.rejected;
  }
}
