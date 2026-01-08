import 'package:ttpolyglot_model/model.dart';

/// 翻译工具类
class TranslationUtils {
  TranslationUtils._();

  /// 计算翻译进度百分比
  static double calculateProgress(int translated, int total) {
    if (total == 0.0) return 0.0;
    return (translated / total * 100.0).clamp(0.0, 100.0);
  }

  /// 获取状态显示文本
  static String getStatusDisplayText(TranslationStatusEnum status) {
    return status.displayName;
  }

  /// 获取状态颜色
  static String getStatusColor(TranslationStatusEnum status) {
    switch (status) {
      case TranslationStatusEnum.pending:
        return '#FFA726';
      case TranslationStatusEnum.translating:
        return '#42A5F5';
      case TranslationStatusEnum.completed:
        return '#66BB6A';
      case TranslationStatusEnum.reviewing:
        return '#AB47BC';
      case TranslationStatusEnum.approved:
        return '#26A69A';
    }
  }

  /// 验证翻译文本
  static bool validateTranslation(String text, {int? maxLength}) {
    if (text.trim().isEmpty) return false;
    if (maxLength != null && text.length > maxLength) return false;
    return true;
  }

  /// 格式化语言代码
  static String formatLanguageCode(LanguageEnum language) {
    return language.code;
  }

  /// 获取语言显示名称
  static String getLanguageDisplayName(LanguageEnum language) {
    return language.name;
  }

  /// 获取语言本地名称
  static String getLanguageNativeName(LanguageEnum language) {
    return language.nativeName;
  }

  /// 检查是否需要翻译
  static bool needsTranslation(TranslationEntryModel entry, {LanguageEnum? language}) {
    if (entry.targetLanguages.isEmpty) return true;
    if (language != null) {
      final target = entry.targetLanguages.firstWhere(
        (t) => t.language == language,
        orElse: () => TranslationTargetLanguageModel(language: language, text: ''),
      );
      return target.text.isEmpty || target.status == TranslationStatusEnum.pending;
    }
    // 如果没有指定语言，检查是否有任何未完成的翻译
    return entry.targetLanguages.any((t) => t.text.isEmpty || t.status == TranslationStatusEnum.pending);
  }

  /// 估算翻译成本（按字符数）
  static double estimateCost(int characterCount, {double pricePerChar = 0.0001}) {
    return characterCount * pricePerChar;
  }

  /// 格式化字符数
  static String formatCharacterCount(int count) {
    if (count < 1000) return '$count';
    if (count < 1000000) return '${(count / 1000.0).toStringAsFixed(1)}K';
    return '${(count / 1000000.0).toStringAsFixed(1)}M';
  }

  /// 检查翻译是否过期（基于更新时间）
  static bool isTranslationStale(DateTime? updatedAt, {int staleDays = 30}) {
    if (updatedAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(updatedAt);
    return difference.inDays > staleDays;
  }

  /// 生成翻译键的建议
  static String suggestKey(String text) {
    // 简单的键生成逻辑：移除特殊字符，转小写，用下划线连接
    return text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
  }

  /// 检查两个翻译条目是否冲突
  static bool hasConflict(TranslationEntryModel entry1, TranslationEntryModel entry2) {
    if (entry1.entryKey != entry2.entryKey) return false;

    // 检查是否有相同语言的翻译文本不同
    for (final target1 in entry1.targetLanguages) {
      final target2 = entry2.targetLanguages.firstWhere(
        (t) => t.language == target1.language,
        orElse: () => TranslationTargetLanguageModel(language: target1.language, text: ''),
      );
      if (target1.text != target2.text) {
        return true;
      }
    }
    return false;
  }

  /// 合并翻译条目（选择最新的）
  static TranslationEntryModel mergeEntries(
    TranslationEntryModel entry1,
    TranslationEntryModel entry2,
  ) {
    final updated1 = entry1.updatedAt ?? entry1.createdAt;
    final updated2 = entry2.updatedAt ?? entry2.createdAt;

    if (updated2 != null && updated1 != null && updated2.isAfter(updated1)) {
      return entry2;
    }
    return entry1;
  }

  /// 生成翻译条目列表
  static List<TranslationEntryModel> generateTranslationEntries({
    required int projectId,
    required String entryKey,
    required String sourceText,
    required LanguageEnum sourceLanguage,
    required List<LanguageEnum> targetLanguages,
    String? context,
    String? comment,
    int? maxLength,
    bool isPlural = false,
    String? pluralForms,
  }) {
    final entries = <TranslationEntryModel>[];

    // 为每个目标语言创建一个条目
    for (final targetLanguage in targetLanguages) {
      final entry = TranslationEntryModel(
        uuid: '${DateTime.now().millisecondsSinceEpoch}_${targetLanguage.code}',
        projectId: projectId,
        entryKey: entryKey,
        sourceLanguage: sourceLanguage,
        sourceText: sourceText,
        targetLanguages: [
          TranslationTargetLanguageModel(
            language: targetLanguage,
            text: '',
          ),
        ],
        context: context ?? '',
        comment: comment ?? '',
        sortIndex: targetLanguage.sortIndex,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      entries.add(entry);
    }

    return entries;
  }
}
