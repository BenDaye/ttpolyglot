import 'dart:developer' as developer;

import '../enums/translation_status.dart';
import '../models/language.dart';
import '../models/translation_entry.dart';
import '../services/translation_service.dart';

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

  /// 根据创建翻译键请求生成翻译条目列表
  static List<TranslationEntry> generateTranslationEntries(
    CreateTranslationKeyRequest request,
  ) {
    try {
      final entries = <TranslationEntry>[];
      final now = DateTime.now();

      // 为每个目标语言生成翻译条目
      for (final targetLanguage in request.targetLanguages) {
        final entry = TranslationEntry(
          id: _generateEntryId(request.projectId, request.key, targetLanguage.code),
          key: request.key,
          projectId: request.projectId,
          sourceLanguage: request.sourceLanguage,
          targetLanguage: targetLanguage,
          sourceText: request.sourceText,
          targetText: '', // 初始为空，等待翻译
          status: request.initialStatus,
          createdAt: now,
          updatedAt: now,
          context: request.context,
          comment: request.comment,
          maxLength: request.maxLength,
          isPlural: request.isPlural,
          pluralForms: request.pluralForms,
        );
        entries.add(entry);
      }

      // 如果需要为默认语言也生成条目
      if (request.generateForDefaultLanguage) {
        final defaultEntry = TranslationEntry(
          id: _generateEntryId(request.projectId, request.key, request.sourceLanguage.code),
          key: request.key,
          projectId: request.projectId,
          sourceLanguage: request.sourceLanguage,
          targetLanguage: request.sourceLanguage,
          sourceText: request.sourceText,
          targetText: request.sourceText, // 默认语言的翻译就是源文本
          status: TranslationStatus.completed, // 默认语言条目直接标记为完成
          createdAt: now,
          updatedAt: now,
          context: request.context,
          comment: request.comment,
          maxLength: request.maxLength,
          isPlural: request.isPlural,
          pluralForms: request.pluralForms,
        );
        entries.add(defaultEntry);
      }

      developer.log(
        'generateTranslationEntries',
        name: 'TranslationUtils',
        error: null,
        stackTrace: null,
      );

      return entries;
    } catch (error, stackTrace) {
      developer.log(
        'generateTranslationEntries',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 生成翻译条目 ID
  static String _generateEntryId(String projectId, String key, String languageCode) {
    return '${projectId}_${key}_$languageCode';
  }

  /// 验证翻译键是否符合规范
  static bool isValidTranslationKey(String key, {String? pattern}) {
    if (key.trim().isEmpty) return false;

    final defaultPattern = r'^[a-zA-Z][a-zA-Z0-9._-]*$';
    final regex = RegExp(pattern ?? defaultPattern);

    return regex.hasMatch(key);
  }

  /// 批量验证翻译条目
  static Map<String, List<String>> batchValidateTranslationEntries(
    List<TranslationEntry> entries,
  ) {
    final validationResults = <String, List<String>>{};

    for (final entry in entries) {
      final errors = <String>[];

      // 验证键名
      if (!isValidTranslationKey(entry.key)) {
        errors.add('翻译键名格式不正确: ${entry.key}');
      }

      // 验证语言代码
      if (!Language.isValidLanguageCode(entry.sourceLanguage.code)) {
        errors.add('源语言代码格式错误: ${entry.sourceLanguage.code}');
      }

      if (!Language.isValidLanguageCode(entry.targetLanguage.code)) {
        errors.add('目标语言代码格式错误: ${entry.targetLanguage.code}');
      }

      // 验证源文本
      if (entry.sourceText.trim().isEmpty) {
        errors.add('源文本不能为空');
      }

      // 验证翻译文本（如果状态为已完成）
      if (entry.status == TranslationStatus.completed && entry.targetText.trim().isEmpty) {
        errors.add('已完成的翻译条目不能有空的目标文本');
      }

      // 验证长度限制
      if (entry.maxLength != null && entry.targetText.length > entry.maxLength!) {
        errors.add('目标文本长度超过限制 (${entry.maxLength} 字符)');
      }

      if (errors.isNotEmpty) {
        validationResults[entry.id] = errors;
      }
    }

    return validationResults;
  }

  /// 根据项目语言生成翻译键请求
  static CreateTranslationKeyRequest createTranslationKeyRequestFromProject({
    required String projectId,
    required String key,
    required Language primaryLanguage,
    required List<Language> targetLanguages,
    required String sourceText,
    String? context,
    String? comment,
    int? maxLength,
    bool isPlural = false,
    Map<String, String>? pluralForms,
    TranslationStatus initialStatus = TranslationStatus.pending,
    bool generateForDefaultLanguage = true,
  }) {
    return CreateTranslationKeyRequest(
      projectId: projectId,
      key: key,
      sourceLanguage: primaryLanguage,
      sourceText: sourceText,
      targetLanguages: targetLanguages,
      context: context,
      comment: comment,
      maxLength: maxLength,
      isPlural: isPlural,
      pluralForms: pluralForms,
      initialStatus: initialStatus,
      generateForDefaultLanguage: generateForDefaultLanguage,
    );
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
