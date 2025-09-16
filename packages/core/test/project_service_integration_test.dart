import 'package:test/test.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('ProjectService Integration Tests', () {
    late Language english;
    late Language chinese;
    late Language japanese;
    late User user;

    setUp(() {
      english = Language.getLanguageByCode('en-US')!;
      chinese = Language.getLanguageByCode('zh-CN')!;
      japanese = Language.getLanguageByCode('ja-JP')!;

      user = User(
        id: 'test-user',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    group('CreateProjectRequest Validation', () {
      test('should validate primary language in create request', () {
        final request = CreateProjectRequest(
          name: 'Test Project',
          description: 'Test project description',
          primaryLanguage: english,
          targetLanguages: [chinese, japanese],
          ownerId: user.id,
        );

        expect(request.isValid, isTrue);
        expect(request.validate(), isEmpty);
      });

      test('should reject invalid primary language', () {
        final invalidLanguage = Language(
          code: 'en',
          name: 'English',
          nativeName: 'English',
        );

        final request = CreateProjectRequest(
          name: 'Test Project',
          description: 'Test project description',
          primaryLanguage: invalidLanguage,
          targetLanguages: [chinese],
          ownerId: user.id,
        );

        expect(request.isValid, isFalse);
        expect(request.validate(), anyElement(contains('主语言代码格式错误')));
      });

      test('should reject primary language as target language', () {
        final request = CreateProjectRequest(
          name: 'Test Project',
          description: 'Test project description',
          primaryLanguage: english,
          targetLanguages: [english, chinese], // Primary language in targets
          ownerId: user.id,
        );

        expect(request.isValid, isFalse);
        expect(request.validate(), contains('主语言不能同时作为目标语言'));
      });
    });

    group('UpdateProjectRequest Validation', () {
      test('should validate update request without primary language', () {
        final request = UpdateProjectRequest(
          name: 'Updated Project',
          description: 'Updated description',
          targetLanguages: [chinese, japanese],
        );

        expect(request.isValid, isTrue);
        expect(request.validate(), isEmpty);
      });

      test('should validate update request with only target languages', () {
        final request = UpdateProjectRequest(
          targetLanguages: [chinese],
        );

        expect(request.isValid, isTrue);
        expect(request.validate(), isEmpty);
      });

      test('should validate update request with empty target languages', () {
        final request = UpdateProjectRequest(
          targetLanguages: [],
        );

        expect(request.isValid, isFalse);
        expect(request.validate(), contains('至少需要选择一个目标语言'));
      });
    });

    group('Project Model Integration', () {
      test('should create project with primary language', () {
        final project = Project(
          id: 'test-project-1',
          name: 'Test Project',
          description: 'Test project description',
          primaryLanguage: english,
          targetLanguages: [chinese, japanese],
          owner: user,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(project.primaryLanguage.code, equals('en-US'));
        expect(project.targetLanguages.length, equals(2));
        expect(project.allLanguages.length, equals(3));
        expect(project.allLanguages.map((lang) => lang.code), contains('en-US'));
        expect(project.allLanguages.map((lang) => lang.code), contains('zh-CN'));
        expect(project.allLanguages.map((lang) => lang.code), contains('ja-JP'));
      });

      test('should maintain primary language when copying', () {
        final originalProject = Project(
          id: 'test-project-1',
          name: 'Original Project',
          description: 'Original description',
          primaryLanguage: english,
          targetLanguages: [chinese, japanese],
          owner: user,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final copiedProject = originalProject.copyWith(
          name: 'Copied Project',
          description: 'Copied description',
          targetLanguages: [chinese], // Remove one target language
        );

        expect(copiedProject.primaryLanguage.code, equals('en-US'));
        expect(copiedProject.name, equals('Copied Project'));
        expect(copiedProject.targetLanguages.length, equals(1));
        expect(copiedProject.targetLanguages.first.code, equals('zh-CN'));
      });

      test('should serialize and deserialize with primary language', () {
        final originalProject = Project(
          id: 'test-project-1',
          name: 'Test Project',
          description: 'Test project description',
          primaryLanguage: english,
          targetLanguages: [chinese],
          owner: user,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final jsonString = originalProject.toJson();
        final deserializedProject = Project.fromJson(jsonString);

        expect(deserializedProject.primaryLanguage.code, equals('en-US'));
        expect(deserializedProject.name, equals('Test Project'));
        expect(deserializedProject.targetLanguages.length, equals(1));
        expect(deserializedProject.targetLanguages.first.code, equals('zh-CN'));
      });
    });

    group('SourceLanguageValidator Integration', () {
      late Project project;
      late List<TranslationEntry> entries;

      setUp(() {
        project = Project(
          id: 'test-project-1',
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
            projectId: 'test-project-1',
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
            projectId: 'test-project-1',
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

      test('should validate consistent project source languages', () {
        final inconsistentEntries = SourceLanguageValidator.validateProjectSourceLanguage(project, entries);

        expect(inconsistentEntries.length, equals(0));
      });

      test('should detect inconsistent source languages', () {
        final inconsistentEntry = TranslationEntry(
          id: 'entry-3',
          key: 'common.farewell',
          projectId: 'test-project-1',
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

      test('should fix inconsistent source languages', () {
        final inconsistentEntry = TranslationEntry(
          id: 'entry-3',
          key: 'common.farewell',
          projectId: 'test-project-1',
          sourceLanguage: chinese,
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

      test('should generate comprehensive source language report', () {
        final report = SourceLanguageValidator.generateSourceLanguageReport(project, entries);

        expect(report['projectId'], equals('test-project-1'));
        expect(report['primaryLanguage'], equals('en-US'));
        expect(report['totalEntries'], equals(2));
        expect(report['inconsistentEntriesCount'], equals(0));
        expect(report['consistencyRate'], equals(1.0));
        expect(report['recommendations'], contains('项目源语言数据完全一致，无需修复'));
      });
    });

    group('TranslationUtils Integration', () {
      test('should create translation key request with primary language', () {
        final request = TranslationUtils.createTranslationKeyRequestFromProject(
          projectId: 'test-project-1',
          key: 'common.greeting',
          primaryLanguage: english,
          targetLanguages: [chinese, japanese],
          sourceText: 'Hello, World!',
          context: 'Greeting message',
        );

        expect(request.projectId, equals('test-project-1'));
        expect(request.key, equals('common.greeting'));
        expect(request.sourceLanguage.code, equals('en-US'));
        expect(request.targetLanguages.length, equals(2));
        expect(request.sourceText, equals('Hello, World!'));
        expect(request.context, equals('Greeting message'));
        expect(request.isValid, isTrue);
      });

      test('should generate translation entries with correct source language', () {
        final request = CreateTranslationKeyRequest(
          projectId: 'test-project-1',
          key: 'common.greeting',
          sourceLanguage: english,
          sourceText: 'Hello, World!',
          targetLanguages: [chinese, japanese],
          generateForDefaultLanguage: true,
        );

        final generatedEntries = TranslationUtils.generateTranslationEntries(request);

        expect(generatedEntries.length, equals(3)); // 2 targets + 1 primary

        // Check that all entries have the correct source language
        for (final entry in generatedEntries) {
          expect(entry.sourceLanguage.code, equals('en-US'));
          expect(entry.sourceText, equals('Hello, World!'));
        }

        // Check primary language entry
        final primaryEntry = generatedEntries.firstWhere(
          (entry) => entry.targetLanguage.code == 'en-US',
        );
        expect(primaryEntry.status, equals(TranslationStatus.completed));
        expect(primaryEntry.targetText, equals('Hello, World!'));

        // Check target language entries
        final chineseEntry = generatedEntries.firstWhere(
          (entry) => entry.targetLanguage.code == 'zh-CN',
        );
        expect(chineseEntry.status, equals(TranslationStatus.pending));
        expect(chineseEntry.targetText, equals(''));
      });
    });
  });
}
