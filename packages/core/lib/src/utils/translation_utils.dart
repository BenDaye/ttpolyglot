import '../enums/translation_status.dart';
import '../models/language.dart';
import '../models/translation_entry.dart';

/// 翻译工具类
class TranslationUtils {
  TranslationUtils._();

  /// 生成翻译键
  static String generateKey(String namespace, String key) {
    return namespace.isEmpty ? key : '$namespace.$key';
  }

  /// 解析翻译键
  static (String namespace, String key) parseKey(String fullKey) {
    final parts = fullKey.split('.');
    if (parts.length == 1) {
      return ('', parts[0]);
    }
    return (parts.sublist(0, parts.length - 1).join('.'), parts.last);
  }

  /// 计算翻译完成度
  static double calculateCompletionRate(List<TranslationEntry> entries) {
    if (entries.isEmpty) return 0.0;

    final completedCount = entries.where((entry) => entry.status == TranslationStatus.completed).length;

    return completedCount / entries.length;
  }

  /// 按状态分组翻译条目
  static Map<TranslationStatus, List<TranslationEntry>> groupByStatus(
    List<TranslationEntry> entries,
  ) {
    final Map<TranslationStatus, List<TranslationEntry>> grouped = {};

    for (final entry in entries) {
      grouped.putIfAbsent(entry.status, () => []).add(entry);
    }

    return grouped;
  }

  /// 按语言分组翻译条目
  static Map<Language, List<TranslationEntry>> groupByLanguage(
    List<TranslationEntry> entries,
  ) {
    final Map<Language, List<TranslationEntry>> grouped = {};

    for (final entry in entries) {
      grouped.putIfAbsent(entry.targetLanguage, () => []).add(entry);
    }

    return grouped;
  }

  /// 验证翻译文本
  static List<String> validateTranslation(
    String sourceText,
    String targetText, {
    int? maxLength,
    List<String>? requiredPlaceholders,
  }) {
    final errors = <String>[];

    // 检查是否为空
    if (targetText.trim().isEmpty) {
      errors.add('翻译文本不能为空');
    }

    // 检查长度限制
    if (maxLength != null && targetText.length > maxLength) {
      errors.add('翻译文本长度超过限制 ($maxLength 字符)');
    }

    // 检查必需的占位符
    if (requiredPlaceholders != null) {
      for (final placeholder in requiredPlaceholders) {
        if (sourceText.contains(placeholder) && !targetText.contains(placeholder)) {
          errors.add('缺少必需的占位符: $placeholder');
        }
      }
    }

    return errors;
  }

  /// 提取占位符
  static List<String> extractPlaceholders(String text) {
    final placeholders = <String>[];
    final regexPatterns = [
      r'\{\{[^}]+\}\}', // {{placeholder}}
      r'\{[^}]+\}', // {placeholder}
      r'%[a-zA-Z]+%', // %placeholder%
      r'%\d+\$[a-zA-Z]', // %1$s, %2$d
    ];

    for (final pattern in regexPatterns) {
      final regex = RegExp(pattern);
      final matches = regex.allMatches(text);
      placeholders.addAll(matches.map((match) => match.group(0)!));
    }

    return placeholders.toSet().toList();
  }

  /// 计算翻译相似度
  static double calculateSimilarity(String text1, String text2) {
    if (text1 == text2) return 1.0;
    if (text1.isEmpty || text2.isEmpty) return 0.0;

    final longer = text1.length > text2.length ? text1 : text2;
    final shorter = text1.length > text2.length ? text2 : text1;

    final editDistance = _levenshteinDistance(longer, shorter);
    return (longer.length - editDistance) / longer.length;
  }

  /// 计算编辑距离
  static int _levenshteinDistance(String s1, String s2) {
    final matrix = List.generate(
      s1.length + 1,
      (i) => List.generate(s2.length + 1, (j) => 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }

    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// 生成翻译统计报告
  static Map<String, dynamic> generateStatistics(
    List<TranslationEntry> entries,
  ) {
    final statusGroups = groupByStatus(entries);
    final languageGroups = groupByLanguage(entries);

    return {
      'total': entries.length,
      'completed': statusGroups[TranslationStatus.completed]?.length ?? 0,
      'pending': statusGroups[TranslationStatus.pending]?.length ?? 0,
      'reviewing': statusGroups[TranslationStatus.reviewing]?.length ?? 0,
      'completionRate': calculateCompletionRate(entries),
      'languageCount': languageGroups.length,
      'statusBreakdown': statusGroups.map(
        (status, entries) => MapEntry(status.name, entries.length),
      ),
      'languageBreakdown': languageGroups.map(
        (language, entries) => MapEntry(language.code, entries.length),
      ),
    };
  }
}
