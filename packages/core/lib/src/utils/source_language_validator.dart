import 'dart:developer' as developer;

import '../models/language.dart';
import '../models/project.dart';
import '../models/translation_entry.dart';

/// 源语言验证器
///
/// 提供项目源语言数据一致性验证和修复功能
class SourceLanguageValidator {
  SourceLanguageValidator._();

  /// 验证项目源语言一致性
  ///
  /// 检查项目的翻译条目是否都使用正确的源语言
  /// 返回不一致的翻译条目列表
  static List<TranslationEntry> validateProjectSourceLanguage(
    Project project,
    List<TranslationEntry> entries,
  ) {
    try {
      final inconsistentEntries = <TranslationEntry>[];

      for (final entry in entries) {
        if (entry.projectId == project.id) {
          if (!isSourceLanguageConsistent(entry, project.primaryLanguage)) {
            inconsistentEntries.add(entry);
          }
        }
      }

      if (inconsistentEntries.isNotEmpty) {
        developer.log(
          'validateProjectSourceLanguage',
          error: '发现 ${inconsistentEntries.length} 个源语言不一致的翻译条目',
          name: 'SourceLanguageValidator',
        );
      }

      return inconsistentEntries;
    } catch (error, stackTrace) {
      developer.log(
        'validateProjectSourceLanguage',
        error: error,
        stackTrace: stackTrace,
        name: 'SourceLanguageValidator',
      );
      return [];
    }
  }

  /// 检查翻译条目的源语言是否与项目主语言一致
  static bool isSourceLanguageConsistent(
    TranslationEntry entry,
    Language primaryLanguage,
  ) {
    try {
      return entry.sourceLanguage.code == primaryLanguage.code;
    } catch (error, stackTrace) {
      developer.log(
        'isSourceLanguageConsistent',
        error: error,
        stackTrace: stackTrace,
        name: 'SourceLanguageValidator',
      );
      return false;
    }
  }

  /// 修复源语言不一致的翻译条目
  ///
  /// 将不一致的翻译条目更新为正确的源语言
  /// 返回修复后的翻译条目列表
  static List<TranslationEntry> fixInconsistentSourceLanguages(
    Project project,
    List<TranslationEntry> inconsistentEntries,
  ) {
    try {
      final fixedEntries = <TranslationEntry>[];

      for (final entry in inconsistentEntries) {
        if (entry.projectId == project.id) {
          final fixedEntry = entry.copyWith(
            sourceLanguage: project.primaryLanguage,
            updatedAt: DateTime.now(),
          );
          fixedEntries.add(fixedEntry);
        }
      }

      if (fixedEntries.isNotEmpty) {
        developer.log(
          'fixInconsistentSourceLanguages',
          error: '修复了 ${fixedEntries.length} 个源语言不一致的翻译条目',
          name: 'SourceLanguageValidator',
        );
      }

      return fixedEntries;
    } catch (error, stackTrace) {
      developer.log(
        'fixInconsistentSourceLanguages',
        error: error,
        stackTrace: stackTrace,
        name: 'SourceLanguageValidator',
      );
      return [];
    }
  }

  /// 验证翻译条目列表的源语言一致性
  ///
  /// 返回包含验证结果的映射，key为条目ID，value为错误信息列表
  static Map<String, List<String>> validateTranslationEntriesSourceLanguage(
    List<TranslationEntry> entries,
    Language primaryLanguage,
  ) {
    try {
      final validationResults = <String, List<String>>{};

      for (final entry in entries) {
        final errors = <String>[];

        if (!isSourceLanguageConsistent(entry, primaryLanguage)) {
          errors.add('源语言 (${entry.sourceLanguage.code}) 与项目主语言 (${primaryLanguage.code}) 不一致');
        }

        if (errors.isNotEmpty) {
          validationResults[entry.id] = errors;
        }
      }

      return validationResults;
    } catch (error, stackTrace) {
      developer.log(
        'validateTranslationEntriesSourceLanguage',
        error: error,
        stackTrace: stackTrace,
        name: 'SourceLanguageValidator',
      );
      return {};
    }
  }

  /// 生成源语言一致性报告
  ///
  /// 分析项目的翻译数据并生成详细的源语言一致性报告
  static Map<String, dynamic> generateSourceLanguageReport(
    Project project,
    List<TranslationEntry> entries,
  ) {
    try {
      final inconsistentEntries = validateProjectSourceLanguage(project, entries);
      final validationResults = validateTranslationEntriesSourceLanguage(entries, project.primaryLanguage);

      final report = {
        'projectId': project.id,
        'primaryLanguage': project.primaryLanguage.code,
        'totalEntries': entries.length,
        'inconsistentEntriesCount': inconsistentEntries.length,
        'consistencyRate': entries.isEmpty ? 1.0 : (entries.length - inconsistentEntries.length) / entries.length,
        'inconsistentEntries': inconsistentEntries
            .map((entry) => {
                  'id': entry.id,
                  'key': entry.key,
                  'currentSourceLanguage': entry.sourceLanguage.code,
                  'expectedSourceLanguage': project.primaryLanguage.code,
                })
            .toList(),
        'validationErrors': validationResults,
        'recommendations': _generateRecommendations(inconsistentEntries.length, entries.length),
      };

      developer.log(
        'generateSourceLanguageReport',
        error: '源语言一致性报告已生成，项目: ${project.id}',
        name: 'SourceLanguageValidator',
      );

      return report;
    } catch (error, stackTrace) {
      developer.log(
        'generateSourceLanguageReport',
        error: error,
        stackTrace: stackTrace,
        name: 'SourceLanguageValidator',
      );
      return {};
    }
  }

  /// 生成修复建议
  static List<String> _generateRecommendations(int inconsistentCount, int totalCount) {
    final recommendations = <String>[];

    if (inconsistentCount == 0) {
      recommendations.add('项目源语言数据完全一致，无需修复');
      return recommendations;
    }

    final consistencyRate = totalCount > 0 ? (totalCount - inconsistentCount) / totalCount : 0.0;

    if (consistencyRate < 0.5) {
      recommendations.add('⚠️ 源语言一致性严重不足，建议进行全面数据修复');
    } else if (consistencyRate < 0.8) {
      recommendations.add('⚠️ 源语言一致性不足，建议修复不一致的数据');
    } else {
      recommendations.add('ℹ️ 发现少量源语言不一致，建议修复相关条目');
    }

    recommendations.add('建议使用 fixInconsistentSourceLanguages 方法自动修复');
    recommendations.add('修复后重新验证数据一致性');

    return recommendations;
  }

  /// 检查项目是否需要源语言修复
  ///
  /// 返回 true 如果项目存在源语言不一致的问题
  static bool projectNeedsSourceLanguageFix(
    Project project,
    List<TranslationEntry> entries,
  ) {
    try {
      final inconsistentEntries = validateProjectSourceLanguage(project, entries);
      return inconsistentEntries.isNotEmpty;
    } catch (error, stackTrace) {
      developer.log(
        'projectNeedsSourceLanguageFix',
        error: error,
        stackTrace: stackTrace,
        name: 'SourceLanguageValidator',
      );
      return false;
    }
  }
}
