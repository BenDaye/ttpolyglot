/// 存储配额信息
class StorageQuota {
  /// 总容量（字节）
  final int total;

  /// 已使用容量（字节）
  final int used;

  /// 可用容量（字节）
  final int available;

  const StorageQuota({
    required this.total,
    required this.used,
    required this.available,
  });

  /// 使用率（0-1）
  double get usageRatio => total > 0 ? used / total : 0.0;

  /// 使用百分比（0-100）
  double get usagePercentage => usageRatio * 100.0;

  /// 是否接近满（超过80%）
  bool get isNearlyFull => usagePercentage > 80.0;

  /// 是否已满（超过95%）
  bool get isFull => usagePercentage > 95.0;

  @override
  String toString() {
    return 'StorageQuota(total: $total, used: $used, available: $available, usage: ${usagePercentage.toStringAsFixed(1)}%)';
  }
}
