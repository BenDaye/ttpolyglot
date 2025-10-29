import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 冲突类型
enum ConflictType {
  /// 翻译键已存在
  keyExists,

  /// 翻译内容不同
  textDifference,

  /// 翻译状态不同
  statusDifference,

  /// 元数据不同
  metadataDifference,
}

/// 冲突解决策略
enum ConflictResolutionStrategy {
  /// 保留现有翻译
  keepExisting,

  /// 使用导入的翻译
  useImported,

  /// 智能合并
  merge,

  /// 询问用户
  askUser,

  /// 跳过冲突项
  skip,
}

/// 翻译冲突信息
class TranslationConflict {
  const TranslationConflict({
    required this.key,
    required this.existingEntry,
    required this.importedEntry,
    required this.conflictType,
    this.description,
  });

  /// 冲突的翻译键
  final String key;

  /// 现有的翻译条目
  final TranslationEntry existingEntry;

  /// 导入的翻译条目
  final TranslationEntry importedEntry;

  /// 冲突类型
  final ConflictType conflictType;

  /// 冲突描述
  final String? description;

  /// 获取冲突类型的显示名称
  String get conflictTypeDisplayName {
    switch (conflictType) {
      case ConflictType.keyExists:
        return '翻译键已存在';
      case ConflictType.textDifference:
        return '翻译内容不同';
      case ConflictType.statusDifference:
        return '翻译状态不同';
      case ConflictType.metadataDifference:
        return '元数据不同';
    }
  }

  @override
  String toString() {
    return 'TranslationConflict(key: $key, type: $conflictTypeDisplayName)';
  }
}

/// 冲突解决方案
class ConflictResolution {
  const ConflictResolution({
    required this.key,
    required this.strategy,
    this.resolvedEntry,
  });

  /// 冲突的翻译键
  final String key;

  /// 解决策略
  final ConflictResolutionStrategy strategy;

  /// 解决后的翻译条目（当策略为 merge 或自定义时使用）
  final TranslationEntry? resolvedEntry;
}

/// 冲突检测结果
class ConflictDetectionResult {
  const ConflictDetectionResult({
    required this.conflicts,
    required this.newEntries,
    this.summary,
  });

  /// 检测到的冲突列表
  final List<TranslationConflict> conflicts;

  /// 新的（无冲突的）翻译条目
  final List<TranslationEntry> newEntries;

  /// 检测结果摘要
  final String? summary;

  /// 是否有冲突
  bool get hasConflicts => conflicts.isNotEmpty;

  /// 冲突数量
  int get conflictCount => conflicts.length;

  /// 新条目数量
  int get newEntryCount => newEntries.length;

  @override
  String toString() {
    return 'ConflictDetectionResult(conflicts: $conflictCount, newEntries: $newEntryCount)';
  }
}

/// 冲突检测服务
class ConflictDetectionService {
  /// 检测翻译冲突
  static Future<ConflictDetectionResult> detectConflicts(
    List<TranslationEntry> existingEntries,
    List<TranslationEntry> importedEntries,
  ) async {
    try {
      LoggerUtils.info('开始检测翻译冲突，现有条目: ${existingEntries.length}，导入条目: ${importedEntries.length}');

      final conflicts = <TranslationConflict>[];
      final newEntries = <TranslationEntry>[];

      // 创建现有条目的键值映射
      final existingMap = <String, TranslationEntry>{};
      for (final entry in existingEntries) {
        existingMap[entry.key] = entry;
      }

      // 检查每个导入的条目
      for (final importedEntry in importedEntries) {
        final existingEntry = existingMap[importedEntry.key];

        if (existingEntry == null) {
          // 新条目，无冲突
          newEntries.add(importedEntry);
        } else {
          // 发现冲突，分析冲突类型
          final conflictType = _analyzeConflictType(existingEntry, importedEntry);

          final conflict = TranslationConflict(
            key: importedEntry.key,
            existingEntry: existingEntry,
            importedEntry: importedEntry,
            conflictType: conflictType,
            description: _generateConflictDescription(existingEntry, importedEntry, conflictType),
          );

          conflicts.add(conflict);
          LoggerUtils.info('检测到冲突: ${conflict.key} - ${conflict.conflictTypeDisplayName}');
        }
      }

      final result = ConflictDetectionResult(
        conflicts: conflicts,
        newEntries: newEntries,
        summary: _generateSummary(conflicts.length, newEntries.length),
      );

      LoggerUtils.info('冲突检测完成: ${result.toString()}');
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('冲突检测失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 解决冲突
  static List<TranslationEntry> resolveConflicts(
    List<TranslationConflict> conflicts,
    List<ConflictResolution> resolutions,
  ) {
    try {
      final resolvedEntries = <TranslationEntry>[];

      // 创建解决方案映射
      final resolutionMap = <String, ConflictResolution>{};
      for (final resolution in resolutions) {
        resolutionMap[resolution.key] = resolution;
      }

      for (final conflict in conflicts) {
        final resolution = resolutionMap[conflict.key];
        if (resolution == null) {
          // 没有解决方案，跳过
          LoggerUtils.info('跳过未解决的冲突: ${conflict.key}');
          continue;
        }

        TranslationEntry? resolvedEntry;

        switch (resolution.strategy) {
          case ConflictResolutionStrategy.keepExisting:
            resolvedEntry = conflict.existingEntry;
            break;
          case ConflictResolutionStrategy.useImported:
            resolvedEntry = conflict.importedEntry;
            break;
          case ConflictResolutionStrategy.merge:
            resolvedEntry = _mergeEntries(conflict.existingEntry, conflict.importedEntry);
            break;
          case ConflictResolutionStrategy.askUser:
            // 用户自定义解决方案
            resolvedEntry = resolution.resolvedEntry ?? conflict.existingEntry;
            break;
          case ConflictResolutionStrategy.skip:
            // 跳过这个冲突
            continue;
        }

        resolvedEntries.add(resolvedEntry.copyWith(updatedAt: DateTime.now()));
        LoggerUtils.info('解决冲突: ${conflict.key} 使用策略 ${resolution.strategy}');
      }

      LoggerUtils.info('冲突解决完成，共解决 ${resolvedEntries.length} 个冲突');
      return resolvedEntries;
    } catch (error, stackTrace) {
      LoggerUtils.error('冲突解决失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 分析冲突类型
  static ConflictType _analyzeConflictType(
    TranslationEntry existing,
    TranslationEntry imported,
  ) {
    // 检查翻译内容
    if (existing.targetText != imported.targetText) {
      return ConflictType.textDifference;
    }

    // 检查翻译状态
    if (existing.status != imported.status) {
      return ConflictType.statusDifference;
    }

    // 检查元数据
    if (existing.comment != imported.comment ||
        existing.context != imported.context ||
        existing.maxLength != imported.maxLength) {
      return ConflictType.metadataDifference;
    }

    // 默认为键已存在
    return ConflictType.keyExists;
  }

  /// 生成冲突描述
  static String _generateConflictDescription(
    TranslationEntry existing,
    TranslationEntry imported,
    ConflictType type,
  ) {
    switch (type) {
      case ConflictType.keyExists:
        return '翻译键 "${existing.key}" 已存在';
      case ConflictType.textDifference:
        return '翻译内容不同：现有 "${existing.targetText}" vs 导入 "${imported.targetText}"';
      case ConflictType.statusDifference:
        return '翻译状态不同：现有 ${existing.status.displayName} vs 导入 ${imported.status.displayName}';
      case ConflictType.metadataDifference:
        return '元数据不同（注释、上下文或最大长度）';
    }
  }

  /// 生成摘要信息
  static String _generateSummary(int conflictCount, int newEntryCount) {
    return '检测完成：发现 $conflictCount 个冲突，$newEntryCount 个新条目';
  }

  /// 智能合并两个翻译条目
  static TranslationEntry _mergeEntries(
    TranslationEntry existing,
    TranslationEntry imported,
  ) {
    return existing.copyWith(
      // 优先使用导入的翻译文本（如果不为空）
      targetText: imported.targetText.isNotEmpty ? imported.targetText : existing.targetText,
      // 使用更新的状态
      status: imported.status != TranslationStatus.pending ? imported.status : existing.status,
      // 合并注释
      comment: imported.comment?.isNotEmpty == true ? imported.comment : existing.comment,
      // 合并上下文
      context: imported.context?.isNotEmpty == true ? imported.context : existing.context,
      // 使用导入的最大长度（如果设置了）
      maxLength: imported.maxLength ?? existing.maxLength,
      // 更新时间
      updatedAt: DateTime.now(),
    );
  }
}
