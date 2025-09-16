import 'dart:developer' as developer;

import '../models/language.dart';
import '../models/project.dart';
import '../models/translation_entry.dart';
import 'source_language_validator.dart';

/// 数据迁移验证器
///
/// 验证现有项目数据在升级到新版本后的源语言一致性
class DataMigrationValidator {
  DataMigrationValidator._();

  /// 验证项目数据迁移
  ///
  /// 检查项目及其翻译条目是否符合新的源语言设计要求
  static MigrationValidationResult validateProjectMigration(
    Project project,
    List<TranslationEntry> entries,
  ) {
    try {
      final issues = <MigrationIssue>[];
      var needsMigration = false;

      // 验证项目结构
      if (!project.primaryLanguage.code.isNotEmpty) {
        issues.add(MigrationIssue(
          type: MigrationIssueType.missingPrimaryLanguage,
          severity: MigrationSeverity.error,
          description: '项目缺少主语言设置',
          projectId: project.id,
        ));
        needsMigration = true;
      }

      // 验证翻译条目源语言一致性
      final inconsistentEntries = SourceLanguageValidator.validateProjectSourceLanguage(project, entries);

      if (inconsistentEntries.isNotEmpty) {
        issues.add(MigrationIssue(
          type: MigrationIssueType.inconsistentSourceLanguage,
          severity: MigrationSeverity.warning,
          description: '发现 ${inconsistentEntries.length} 个源语言不一致的翻译条目',
          projectId: project.id,
          affectedEntries: inconsistentEntries.map((e) => e.id).toList(),
        ));
        needsMigration = true;
      }

      // 检查是否有空的源文本
      final emptySourceEntries = entries.where((entry) => entry.sourceText.trim().isEmpty).toList();
      if (emptySourceEntries.isNotEmpty) {
        issues.add(MigrationIssue(
          type: MigrationIssueType.emptySourceText,
          severity: MigrationSeverity.warning,
          description: '发现 ${emptySourceEntries.length} 个翻译条目缺少源文本',
          projectId: project.id,
          affectedEntries: emptySourceEntries.map((e) => e.id).toList(),
        ));
      }

      // 检查是否有不支持的语言
      final unsupportedLanguages = <String>[];
      for (final entry in entries) {
        if (!Language.isLanguageSupported(entry.sourceLanguage.code)) {
          if (!unsupportedLanguages.contains(entry.sourceLanguage.code)) {
            unsupportedLanguages.add(entry.sourceLanguage.code);
          }
        }
        if (!Language.isLanguageSupported(entry.targetLanguage.code)) {
          if (!unsupportedLanguages.contains(entry.targetLanguage.code)) {
            unsupportedLanguages.add(entry.targetLanguage.code);
          }
        }
      }

      if (unsupportedLanguages.isNotEmpty) {
        issues.add(MigrationIssue(
          type: MigrationIssueType.unsupportedLanguage,
          severity: MigrationSeverity.error,
          description: '发现不支持的语言代码: ${unsupportedLanguages.join(', ')}',
          projectId: project.id,
        ));
        needsMigration = true;
      }

      final result = MigrationValidationResult(
        projectId: project.id,
        isValid: issues.where((issue) => issue.severity == MigrationSeverity.error).isEmpty,
        needsMigration: needsMigration,
        issues: issues,
        totalEntries: entries.length,
        inconsistentEntriesCount: inconsistentEntries.length,
      );

      developer.log(
        '数据迁移验证完成',
        error: '项目: ${project.id}, 是否有效: ${result.isValid}, 需要迁移: ${result.needsMigration}',
        name: 'DataMigrationValidator',
      );

      return result;
    } catch (error, stackTrace) {
      developer.log(
        '数据迁移验证失败',
        error: error,
        stackTrace: stackTrace,
        name: 'DataMigrationValidator',
      );
      return MigrationValidationResult(
        projectId: project.id,
        isValid: false,
        needsMigration: true,
        issues: [
          MigrationIssue(
            type: MigrationIssueType.unknown,
            severity: MigrationSeverity.error,
            description: '数据迁移验证过程中发生错误: $error',
            projectId: project.id,
          ),
        ],
        totalEntries: 0,
        inconsistentEntriesCount: 0,
      );
    }
  }

  /// 执行数据迁移修复
  ///
  /// 自动修复发现的迁移问题
  static MigrationFixResult fixProjectMigration(
    Project project,
    List<TranslationEntry> entries,
  ) {
    try {
      final fixedEntries = <TranslationEntry>[];
      final fixes = <MigrationFix>[];
      var entriesModified = 0;

      // 修复源语言不一致的条目
      final inconsistentEntries = SourceLanguageValidator.validateProjectSourceLanguage(project, entries);
      if (inconsistentEntries.isNotEmpty) {
        final fixedInconsistentEntries = SourceLanguageValidator.fixInconsistentSourceLanguages(
          project,
          inconsistentEntries,
        );
        fixedEntries.addAll(fixedInconsistentEntries);
        entriesModified += fixedInconsistentEntries.length;

        fixes.add(MigrationFix(
          type: MigrationFixType.fixedInconsistentSourceLanguages,
          description: '修复了 ${fixedInconsistentEntries.length} 个源语言不一致的翻译条目',
          entriesAffected: fixedInconsistentEntries.length,
        ));
      }

      // 移除修复后的条目，避免重复
      final remainingEntries =
          entries.where((entry) => !inconsistentEntries.any((inconsistent) => inconsistent.id == entry.id)).toList();

      fixedEntries.addAll(remainingEntries);

      final result = MigrationFixResult(
        projectId: project.id,
        success: true,
        entriesModified: entriesModified,
        totalEntries: entries.length,
        fixes: fixes,
        fixedEntries: fixedEntries,
      );

      developer.log(
        '数据迁移修复完成',
        error: '项目: ${project.id}, 修改条目数: $entriesModified',
        name: 'DataMigrationValidator',
      );

      return result;
    } catch (error, stackTrace) {
      developer.log(
        '数据迁移修复失败',
        error: error,
        stackTrace: stackTrace,
        name: 'DataMigrationValidator',
      );
      return MigrationFixResult(
        projectId: project.id,
        success: false,
        entriesModified: 0,
        totalEntries: entries.length,
        fixes: [
          MigrationFix(
            type: MigrationFixType.unknown,
            description: '数据迁移修复过程中发生错误: $error',
            entriesAffected: 0,
          ),
        ],
        fixedEntries: entries,
      );
    }
  }

  /// 生成迁移报告
  static String generateMigrationReport(MigrationValidationResult validationResult) {
    final buffer = StringBuffer();

    buffer.writeln('=== 数据迁移验证报告 ===');
    buffer.writeln('项目ID: ${validationResult.projectId}');
    buffer.writeln('总条目数: ${validationResult.totalEntries}');
    buffer.writeln('不一致条目数: ${validationResult.inconsistentEntriesCount}');
    buffer.writeln('是否有效: ${validationResult.isValid ? '是' : '否'}');
    buffer.writeln('需要迁移: ${validationResult.needsMigration ? '是' : '否'}');
    buffer.writeln();

    if (validationResult.issues.isNotEmpty) {
      buffer.writeln('发现的问题:');
      for (final issue in validationResult.issues) {
        final severity = issue.severity == MigrationSeverity.error ? '错误' : '警告';
        buffer.writeln('• [$severity] ${issue.description}');
        if (issue.affectedEntries != null && issue.affectedEntries!.isNotEmpty) {
          buffer.writeln('  影响条目: ${issue.affectedEntries!.join(', ')}');
        }
      }
      buffer.writeln();
    }

    buffer.writeln('建议的修复措施:');
    if (validationResult.inconsistentEntriesCount > 0) {
      buffer.writeln('• 运行 fixInconsistentSourceLanguages 来修复源语言不一致问题');
    }
    if (!validationResult.isValid) {
      buffer.writeln('• 解决所有错误级别的问题后再进行数据迁移');
    }
    buffer.writeln('• 备份数据后再进行迁移操作');

    return buffer.toString();
  }
}

/// 迁移验证结果
class MigrationValidationResult {
  const MigrationValidationResult({
    required this.projectId,
    required this.isValid,
    required this.needsMigration,
    required this.issues,
    required this.totalEntries,
    required this.inconsistentEntriesCount,
  });

  final String projectId;
  final bool isValid;
  final bool needsMigration;
  final List<MigrationIssue> issues;
  final int totalEntries;
  final int inconsistentEntriesCount;

  /// 获取错误数量
  int get errorCount => issues.where((issue) => issue.severity == MigrationSeverity.error).length;

  /// 获取警告数量
  int get warningCount => issues.where((issue) => issue.severity == MigrationSeverity.warning).length;
}

/// 迁移修复结果
class MigrationFixResult {
  const MigrationFixResult({
    required this.projectId,
    required this.success,
    required this.entriesModified,
    required this.totalEntries,
    required this.fixes,
    required this.fixedEntries,
  });

  final String projectId;
  final bool success;
  final int entriesModified;
  final int totalEntries;
  final List<MigrationFix> fixes;
  final List<TranslationEntry> fixedEntries;
}

/// 迁移问题
class MigrationIssue {
  const MigrationIssue({
    required this.type,
    required this.severity,
    required this.description,
    required this.projectId,
    this.affectedEntries,
  });

  final MigrationIssueType type;
  final MigrationSeverity severity;
  final String description;
  final String projectId;
  final List<String>? affectedEntries;
}

/// 迁移修复
class MigrationFix {
  const MigrationFix({
    required this.type,
    required this.description,
    required this.entriesAffected,
  });

  final MigrationFixType type;
  final String description;
  final int entriesAffected;
}

/// 迁移问题类型
enum MigrationIssueType {
  missingPrimaryLanguage,
  inconsistentSourceLanguage,
  emptySourceText,
  unsupportedLanguage,
  unknown,
}

/// 迁移问题严重程度
enum MigrationSeverity {
  error,
  warning,
}

/// 迁移修复类型
enum MigrationFixType {
  fixedInconsistentSourceLanguages,
  unknown,
}
