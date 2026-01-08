import 'package:ttpolyglot_model/model.dart';
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
  final TranslationEntryModel existingEntry;

  /// 导入的翻译条目
  final TranslationEntryModel importedEntry;

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
  final TranslationEntryModel? resolvedEntry;
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
  final List<TranslationEntryModel> newEntries;

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
    List<TranslationEntryModel> existingEntries,
    List<TranslationEntryModel> importedEntries,
  ) async {
    try {
      LoggerUtils.info('开始检测翻译冲突，现有条目: ${existingEntries.length}，导入条目: ${importedEntries.length}');

      final conflicts = <TranslationConflict>[];
      final newEntries = <TranslationEntryModel>[];

      // 创建现有条目的键值映射
      final existingMap = <String, TranslationEntryModel>{};
      for (final entry in existingEntries) {
        existingMap[entry.entryKey] = entry;
      }

      // 检查每个导入的条目
      for (final importedEntry in importedEntries) {
        final existingEntry = existingMap[importedEntry.entryKey];

        if (existingEntry == null) {
          // 新条目，无冲突
          newEntries.add(importedEntry);
        } else {
          // 发现冲突，分析冲突类型
          final conflictType = _analyzeConflictType(existingEntry, importedEntry);

          final conflict = TranslationConflict(
            key: importedEntry.entryKey,
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
  static List<TranslationEntryModel> resolveConflicts(
    List<TranslationConflict> conflicts,
    List<ConflictResolution> resolutions,
  ) {
    try {
      final resolvedEntries = <TranslationEntryModel>[];

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

        TranslationEntryModel? resolvedEntry;

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
    TranslationEntryModel existing,
    TranslationEntryModel imported,
  ) {
    // 检查翻译内容（比较相同语言的翻译）
    for (final importedTarget in imported.targetLanguages) {
      final existingTarget = existing.targetLanguages.firstWhere(
        (t) => t.language == importedTarget.language,
        orElse: () => TranslationTargetLanguageModel(language: importedTarget.language, text: ''),
      );
      if (existingTarget.text != importedTarget.text) {
        return ConflictType.textDifference;
      }
    }

    // 检查翻译状态（比较相同语言的翻译状态）
    for (final importedTarget in imported.targetLanguages) {
      final existingTarget = existing.targetLanguages.firstWhere(
        (t) => t.language == importedTarget.language,
        orElse: () => TranslationTargetLanguageModel(language: importedTarget.language, text: ''),
      );
      if (existingTarget.status != importedTarget.status) {
        return ConflictType.statusDifference;
      }
    }

    // 检查元数据
    if (existing.context != imported.context) {
      return ConflictType.metadataDifference;
    }

    // 默认为键已存在
    return ConflictType.keyExists;
  }

  /// 生成冲突描述
  static String _generateConflictDescription(
    TranslationEntryModel existing,
    TranslationEntryModel imported,
    ConflictType type,
  ) {
    switch (type) {
      case ConflictType.keyExists:
        return '翻译键 "${existing.entryKey}" 已存在';
      case ConflictType.textDifference:
        // 找到第一个不同的翻译
        for (final importedTarget in imported.targetLanguages) {
          final existingTarget = existing.targetLanguages.firstWhere(
            (t) => t.language == importedTarget.language,
            orElse: () => TranslationTargetLanguageModel(language: importedTarget.language, text: ''),
          );
          if (existingTarget.text != importedTarget.text) {
            return '翻译内容不同（${importedTarget.language.code}）：现有 "${existingTarget.text}" vs 导入 "${importedTarget.text}"';
          }
        }
        return '翻译内容不同';
      case ConflictType.statusDifference:
        // 找到第一个不同的状态
        for (final importedTarget in imported.targetLanguages) {
          final existingTarget = existing.targetLanguages.firstWhere(
            (t) => t.language == importedTarget.language,
            orElse: () => TranslationTargetLanguageModel(language: importedTarget.language, text: ''),
          );
          if (existingTarget.status != importedTarget.status) {
            return '翻译状态不同（${importedTarget.language.code}）：现有 ${existingTarget.status} vs 导入 ${importedTarget.status}';
          }
        }
        return '翻译状态不同';
      case ConflictType.metadataDifference:
        return '元数据不同（注释、上下文或最大长度）';
    }
  }

  /// 生成摘要信息
  static String _generateSummary(int conflictCount, int newEntryCount) {
    return '检测完成：发现 $conflictCount 个冲突，$newEntryCount 个新条目';
  }

  /// 智能合并两个翻译条目
  static TranslationEntryModel _mergeEntries(
    TranslationEntryModel existing,
    TranslationEntryModel imported,
  ) {
    // 合并目标语言列表
    final mergedTargetLanguages = <TranslationTargetLanguageModel>[];

    // 先添加现有的目标语言
    for (final existingTarget in existing.targetLanguages) {
      final importedTarget = imported.targetLanguages.firstWhere(
        (t) => t.language == existingTarget.language,
        orElse: () => TranslationTargetLanguageModel(language: existingTarget.language, text: ''),
      );

      // 优先使用导入的翻译文本（如果不为空）
      mergedTargetLanguages.add(
        existingTarget.copyWith(
          text: importedTarget.text.isNotEmpty ? importedTarget.text : existingTarget.text,
        ),
      );
    }

    // 添加导入中新增的目标语言
    for (final importedTarget in imported.targetLanguages) {
      if (!mergedTargetLanguages.any((t) => t.language == importedTarget.language)) {
        mergedTargetLanguages.add(importedTarget);
      }
    }

    return existing.copyWith(
      targetLanguages: mergedTargetLanguages,
      context: imported.context.isNotEmpty ? imported.context : existing.context,
      updatedAt: DateTime.now(),
    );
  }
}
