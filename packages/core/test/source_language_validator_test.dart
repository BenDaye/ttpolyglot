import 'package:test/test.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('SourceLanguageValidator', () {
    late Language english;
    late Language chinese;
    late Language japanese;
    late Project project;
    late List<TranslationEntry> entries;

    setUp(() {
      english = Language.getLanguageByCode('en-US')!;
      chinese = Language.getLanguageByCode('zh-CN')!;
      japanese = Language.getLanguageByCode('ja-JP')!;

      final user = User(
        id: 'user-1',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      project = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese, japanese],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      entries = [
        TranslationEntry(
          id: 'entry-1',
          key: 'common.greeting',
          projectId: 'project-1',
          sourceLanguage: english,
          targetLanguage: chinese,
          sourceText: 'Hello',
          targetText: '你好',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TranslationEntry(
          id: 'entry-2',
          key: 'common.greeting',
          projectId: 'project-1',
          sourceLanguage: english,
          targetLanguage: japanese,
          sourceText: 'Hello',
          targetText: 'こんにちは',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    });

    test('should validate consistent source languages', () {
      final inconsistentEntries = SourceLanguageValidator.validateProjectSourceLanguage(project, entries);

      expect(inconsistentEntries.length, equals(0));
    });

    test('should detect inconsistent source languages', () {
      // Create an entry with wrong source language
      final inconsistentEntry = TranslationEntry(
        id: 'entry-3',
        key: 'common.farewell',
        projectId: 'project-1',
        sourceLanguage: chinese, // Wrong source language
        targetLanguage: japanese,
        sourceText: 'Goodbye',
        targetText: 'さようなら',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final allEntries = [...entries, inconsistentEntry];
      final inconsistentEntries = SourceLanguageValidator.validateProjectSourceLanguage(project, allEntries);

      expect(inconsistentEntries.length, equals(1));
      expect(inconsistentEntries.first.id, equals('entry-3'));
    });

    test('should identify consistent source language', () {
      final entry = entries.first;
      final isConsistent = SourceLanguageValidator.isSourceLanguageConsistent(entry, english);

      expect(isConsistent, isTrue);
    });

    test('should identify inconsistent source language', () {
      final entry = entries.first;
      final isConsistent = SourceLanguageValidator.isSourceLanguageConsistent(entry, chinese);

      expect(isConsistent, isFalse);
    });

    test('should fix inconsistent source languages', () {
      // Create an entry with wrong source language
      final inconsistentEntry = TranslationEntry(
        id: 'entry-3',
        key: 'common.farewell',
        projectId: 'project-1',
        sourceLanguage: chinese, // Wrong source language
        targetLanguage: japanese,
        sourceText: 'Goodbye',
        targetText: 'さようなら',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final fixedEntries = SourceLanguageValidator.fixInconsistentSourceLanguages(
        project,
        [inconsistentEntry],
      );

      expect(fixedEntries.length, equals(1));
      expect(fixedEntries.first.sourceLanguage.code, equals('en-US'));
      expect(fixedEntries.first.targetLanguage.code, equals('ja-JP'));
    });

    test('should validate translation entries source languages', () {
      // Create an entry with wrong source language
      final inconsistentEntry = TranslationEntry(
        id: 'entry-3',
        key: 'common.farewell',
        projectId: 'project-1',
        sourceLanguage: chinese, // Wrong source language
        targetLanguage: japanese,
        sourceText: 'Goodbye',
        targetText: 'さようなら',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final allEntries = [...entries, inconsistentEntry];
      final validationResults = SourceLanguageValidator.validateTranslationEntriesSourceLanguage(
        allEntries,
        english,
      );

      expect(validationResults.containsKey('entry-1'), isFalse);
      expect(validationResults.containsKey('entry-2'), isFalse);
      expect(validationResults.containsKey('entry-3'), isTrue);
      expect(validationResults['entry-3']!.length, equals(1));
      expect(validationResults['entry-3']!.first, contains('源语言'));
    });

    test('should generate source language report for consistent project', () {
      final report = SourceLanguageValidator.generateSourceLanguageReport(project, entries);

      expect(report['projectId'], equals('project-1'));
      expect(report['primaryLanguage'], equals('en-US'));
      expect(report['totalEntries'], equals(2));
      expect(report['inconsistentEntriesCount'], equals(0));
      expect(report['consistencyRate'], equals(1.0));
      expect(report['inconsistentEntries'], isEmpty);
      expect(report['recommendations'], contains('项目源语言数据完全一致，无需修复'));
    });

    test('should generate source language report for inconsistent project', () {
      // Create an entry with wrong source language
      final inconsistentEntry = TranslationEntry(
        id: 'entry-3',
        key: 'common.farewell',
        projectId: 'project-1',
        sourceLanguage: chinese, // Wrong source language
        targetLanguage: japanese,
        sourceText: 'Goodbye',
        targetText: 'さようなら',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final allEntries = [...entries, inconsistentEntry];
      final report = SourceLanguageValidator.generateSourceLanguageReport(project, allEntries);

      expect(report['totalEntries'], equals(3));
      expect(report['inconsistentEntriesCount'], equals(1));
      expect(report['consistencyRate'], closeTo(2 / 3, 0.01));
      expect(report['inconsistentEntries'].length, equals(1));
      expect(report['recommendations'], contains('建议使用 fixInconsistentSourceLanguages 方法自动修复'));
    });

    test('should detect project that needs source language fix', () {
      final needsFix = SourceLanguageValidator.projectNeedsSourceLanguageFix(project, entries);
      expect(needsFix, isFalse);

      // Create an entry with wrong source language
      final inconsistentEntry = TranslationEntry(
        id: 'entry-3',
        key: 'common.farewell',
        projectId: 'project-1',
        sourceLanguage: chinese, // Wrong source language
        targetLanguage: japanese,
        sourceText: 'Goodbye',
        targetText: 'さようなら',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final allEntries = [...entries, inconsistentEntry];
      final needsFixWithInconsistent = SourceLanguageValidator.projectNeedsSourceLanguageFix(project, allEntries);
      expect(needsFixWithInconsistent, isTrue);
    });

    test('should handle empty entries list', () {
      final inconsistentEntries = SourceLanguageValidator.validateProjectSourceLanguage(project, []);
      expect(inconsistentEntries.length, equals(0));

      final report = SourceLanguageValidator.generateSourceLanguageReport(project, []);
      expect(report['totalEntries'], equals(0));
      expect(report['consistencyRate'], equals(1.0));
    });

    test('should handle entries from different projects', () {
      final otherProjectEntry = TranslationEntry(
        id: 'entry-other',
        key: 'other.greeting',
        projectId: 'project-2', // Different project
        sourceLanguage: chinese,
        targetLanguage: english,
        sourceText: '你好',
        targetText: 'Hello',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final allEntries = [...entries, otherProjectEntry];
      final inconsistentEntries = SourceLanguageValidator.validateProjectSourceLanguage(project, allEntries);

      // Should only check entries from the specified project
      expect(inconsistentEntries.length, equals(0));
    });

    test('should provide proper recommendations for different consistency levels', () {
      // Test high consistency (80%)
      final mostlyConsistentEntries = entries.take(4).toList(); // 4 out of 5 entries
      final report = SourceLanguageValidator.generateSourceLanguageReport(project, mostlyConsistentEntries);

      if (report['consistencyRate'] < 0.8) {
        expect(report['recommendations'], contains('源语言一致性不足'));
      }

      // Test low consistency (50%)
      final mixedEntries = [
        ...entries,
        TranslationEntry(
          id: 'entry-3',
          key: 'common.farewell',
          projectId: 'project-1',
          sourceLanguage: chinese,
          targetLanguage: japanese,
          sourceText: 'Goodbye',
          targetText: 'さようなら',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      final lowConsistencyReport = SourceLanguageValidator.generateSourceLanguageReport(project, mixedEntries);

      if (lowConsistencyReport['consistencyRate'] < 0.5) {
        expect(lowConsistencyReport['recommendations'], contains('源语言一致性严重不足'));
      }
    });
  });
}
