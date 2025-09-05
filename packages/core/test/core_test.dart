import 'package:test/test.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('Language', () {
    test('should support predefined languages', () {
      expect(Language.enUS.code, equals('en-US'));
      expect(Language.zhCN.code, equals('zh-CN'));
      expect(Language.jaJP.code, equals('ja-JP'));
      expect(Language.koKR.code, equals('ko-KR'));
    });

    test('should validate language codes', () {
      expect(Language.isValidLanguageCode('en-US'), isTrue);
      expect(Language.isValidLanguageCode('zh-CN'), isTrue);
      expect(Language.isValidLanguageCode('en'), isFalse);
      expect(Language.isValidLanguageCode('zh'), isFalse);
      expect(Language.isValidLanguageCode('EN-US'), isFalse);
      expect(Language.isValidLanguageCode('en-us'), isFalse);
      expect(Language.isValidLanguageCode(''), isFalse);
    });

    test('should check language support', () {
      expect(Language.isLanguageSupported('en-US'), isTrue);
      expect(Language.isLanguageSupported('zh-CN'), isTrue);
      expect(Language.isLanguageSupported('xx-XX'), isFalse);
    });

    test('should get language by code', () {
      final english = Language.getLanguageByCode('en-US');
      expect(english, isNotNull);
      expect(english!.code, equals('en-US'));
      expect(english.name, equals('English (United States)'));

      final unknown = Language.getLanguageByCode('xx-XX');
      expect(unknown, isNull);
    });

    test('should search supported languages', () {
      final chineseLanguages = Language.searchSupportedLanguages('Chinese');
      expect(chineseLanguages.isNotEmpty, isTrue);
      expect(chineseLanguages.any((lang) => lang.code == 'zh-CN'), isTrue);

      final englishLanguages = Language.searchSupportedLanguages('English');
      expect(englishLanguages.isNotEmpty, isTrue);
      expect(englishLanguages.any((lang) => lang.code == 'en-US'), isTrue);
    });

    test('should group languages by base language', () {
      final grouped = Language.supportedLanguagesByGroup;
      expect(grouped.containsKey('en'), isTrue);
      expect(grouped.containsKey('zh'), isTrue);
      expect(grouped['en']!.any((lang) => lang.code == 'en-US'), isTrue);
      expect(grouped['zh']!.any((lang) => lang.code == 'zh-CN'), isTrue);
    });

    test('should have proper RTL support', () {
      final arabic = Language.getLanguageByCode('ar-SA');
      expect(arabic?.isRtl, isTrue);

      final hebrew = Language.getLanguageByCode('he-IL');
      expect(hebrew?.isRtl, isTrue);

      final english = Language.getLanguageByCode('en-US');
      expect(english?.isRtl, isFalse);
    });

    test('should have all required supported languages', () {
      final supportedLanguages = Language.supportedLanguages;
      expect(supportedLanguages.length, greaterThan(40));

      // Check some key languages
      final requiredLanguages = [
        'en-US',
        'zh-CN',
        'ja-JP',
        'ko-KR',
        'fr-FR',
        'de-DE',
        'es-ES',
        'it-IT',
        'pt-BR',
        'ru-RU',
      ];

      for (final langCode in requiredLanguages) {
        expect(
          supportedLanguages.any((lang) => lang.code == langCode),
          isTrue,
          reason: 'Language $langCode should be supported',
        );
      }
    });

    test('should serialize and deserialize correctly', () {
      final original = Language.getLanguageByCode('en-US')!;
      final json = original.toJson();
      final deserialized = Language.fromJson(json);

      expect(deserialized.code, equals(original.code));
      expect(deserialized.name, equals(original.name));
      expect(deserialized.nativeName, equals(original.nativeName));
      expect(deserialized.isRtl, equals(original.isRtl));
    });

    test('should handle equality correctly', () {
      final lang1 = Language.getLanguageByCode('en-US')!;
      final lang2 = Language.getLanguageByCode('en-US')!;
      final lang3 = Language.getLanguageByCode('zh-CN')!;

      expect(lang1, equals(lang2));
      expect(lang1, isNot(equals(lang3)));
    });

    test('should sort languages correctly', () {
      final languages = [
        Language.getLanguageByCode('zh-CN')!,
        Language.getLanguageByCode('en-US')!,
        Language.getLanguageByCode('ja-JP')!,
      ];

      languages.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));

      expect(languages[0].code, equals('en-US'));
      expect(languages[1].code, equals('zh-CN'));
      expect(languages[2].code, equals('ja-JP'));
    });
  });

  group('CreateProjectRequest', () {
    late Language english;
    late Language chinese;
    late Language japanese;

    setUp(() {
      english = Language.getLanguageByCode('en-US')!;
      chinese = Language.getLanguageByCode('zh-CN')!;
      japanese = Language.getLanguageByCode('ja-JP')!;
    });

    test('should validate valid request', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese, japanese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isTrue);
      expect(request.validate(), isEmpty);
    });

    test('should reject empty name', () {
      final request = CreateProjectRequest(
        name: '',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('项目名称不能为空'));
    });

    test('should reject empty description', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: '',
        primaryLanguage: english,
        targetLanguages: [chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('项目描述不能为空'));
    });

    test('should reject invalid primary language code', () {
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
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('主语言代码格式错误: en'));
    });

    test('should reject unsupported primary language', () {
      final unsupportedLanguage = Language(
        code: 'xx-XX',
        name: 'Unknown Language',
        nativeName: 'Unknown Language',
      );

      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: unsupportedLanguage,
        targetLanguages: [chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('不支持的主语言: xx-XX'));
    });

    test('should reject empty target languages', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('至少需要选择一个目标语言'));
    });

    test('should reject invalid target language code', () {
      final invalidLanguage = Language(
        code: 'zh',
        name: 'Chinese',
        nativeName: '中文',
      );

      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [invalidLanguage],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('目标语言代码格式错误: zh'));
    });

    test('should reject unsupported target language', () {
      final unsupportedLanguage = Language(
        code: 'yy-YY',
        name: 'Unknown Target Language',
        nativeName: 'Unknown Target Language',
      );

      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [unsupportedLanguage],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('不支持的目标语言: yy-YY'));
    });

    test('should reject primary language as target language', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [english, chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('主语言不能同时作为目标语言'));
    });

    test('should reject duplicate target languages', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese, chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('目标语言不能重复'));
    });

    test('should reject empty owner ID', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        ownerId: '',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('项目所有者ID不能为空'));
    });
  });

  group('CreateTranslationKeyRequest', () {
    late Language english;
    late Language chinese;
    late Language japanese;

    setUp(() {
      english = Language.getLanguageByCode('en-US')!;
      chinese = Language.getLanguageByCode('zh-CN')!;
      japanese = Language.getLanguageByCode('ja-JP')!;
    });

    test('should validate valid request', () {
      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [chinese, japanese],
      );

      expect(request.isValid, isTrue);
      expect(request.validate(), isEmpty);
    });

    test('should reject empty project ID', () {
      final request = CreateTranslationKeyRequest(
        projectId: '',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [chinese],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('项目 ID 不能为空'));
    });

    test('should reject empty key', () {
      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: '',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [chinese],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('翻译键名不能为空'));
    });

    test('should reject empty source text', () {
      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: '',
        targetLanguages: [chinese],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('源文本不能为空'));
    });

    test('should reject empty target languages', () {
      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('至少需要指定一个目标语言'));
    });

    test('should reject invalid source language', () {
      final invalidLanguage = Language(
        code: 'en',
        name: 'English',
        nativeName: 'English',
      );

      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: 'common.greeting',
        sourceLanguage: invalidLanguage,
        sourceText: 'Hello, World!',
        targetLanguages: [chinese],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('源语言代码格式错误: en'));
    });

    test('should reject duplicate target languages', () {
      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [chinese, chinese],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('目标语言不能重复'));
    });

    test('should reject source language as target when generateForDefaultLanguage is false', () {
      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [english, chinese],
        generateForDefaultLanguage: false,
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('源语言不能同时作为目标语言'));
    });

    test('should allow source language as target when generateForDefaultLanguage is true', () {
      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [english, chinese],
        generateForDefaultLanguage: true,
      );

      expect(request.isValid, isTrue);
    });
  });

  group('TranslationUtils', () {
    late Language english;
    late Language chinese;
    late Language japanese;

    setUp(() {
      english = Language.getLanguageByCode('en-US')!;
      chinese = Language.getLanguageByCode('zh-CN')!;
      japanese = Language.getLanguageByCode('ja-JP')!;
    });

    test('should generate translation entries correctly', () {
      final request = CreateTranslationKeyRequest(
        projectId: 'project-1',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [chinese, japanese],
        generateForDefaultLanguage: true,
      );

      final entries = TranslationUtils.generateTranslationEntries(request);

      expect(entries.length, equals(3)); // 2 target languages + 1 default language

      // Check target language entries
      final chineseEntry = entries.firstWhere((e) => e.targetLanguage.code == 'zh-CN');
      expect(chineseEntry.key, equals('common.greeting'));
      expect(chineseEntry.sourceText, equals('Hello, World!'));
      expect(chineseEntry.targetText, equals(''));
      expect(chineseEntry.status, equals(TranslationStatus.pending));

      // Check default language entry
      final defaultEntry = entries.firstWhere((e) => e.targetLanguage.code == 'en-US');
      expect(defaultEntry.targetText, equals('Hello, World!'));
      expect(defaultEntry.status, equals(TranslationStatus.completed));
    });

    test('should validate translation keys correctly', () {
      expect(TranslationUtils.isValidTranslationKey('common.greeting'), isTrue);
      expect(TranslationUtils.isValidTranslationKey('user.profile.name'), isTrue);
      expect(TranslationUtils.isValidTranslationKey('button_submit'), isTrue);
      expect(TranslationUtils.isValidTranslationKey('error-message'), isTrue);
      expect(TranslationUtils.isValidTranslationKey('123invalid'), isFalse);
      expect(TranslationUtils.isValidTranslationKey('special@key'), isFalse);
      expect(TranslationUtils.isValidTranslationKey(''), isFalse);
    });

    test('should batch validate translation entries', () {
      final validEntry = TranslationEntry(
        id: 'entry-1',
        key: 'valid.key',
        projectId: 'project-1',
        sourceLanguage: english,
        targetLanguage: chinese,
        sourceText: 'Hello',
        targetText: '你好',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final invalidEntry = TranslationEntry(
        id: 'entry-2',
        key: '123invalid',
        projectId: 'project-1',
        sourceLanguage: english,
        targetLanguage: chinese,
        sourceText: '',
        targetText: '',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final results = TranslationUtils.batchValidateTranslationEntries([validEntry, invalidEntry]);

      expect(results.containsKey('entry-1'), isFalse);
      expect(results.containsKey('entry-2'), isTrue);
      expect(results['entry-2']!.length, greaterThan(0));
    });

    test('should create translation key request from project', () {
      final request = TranslationUtils.createTranslationKeyRequestFromProject(
        projectId: 'project-1',
        key: 'common.greeting',
        primaryLanguage: english,
        targetLanguages: [chinese, japanese],
        sourceText: 'Hello, World!',
        context: 'Greeting message',
        maxLength: 50,
      );

      expect(request.projectId, equals('project-1'));
      expect(request.key, equals('common.greeting'));
      expect(request.sourceLanguage, equals(english));
      expect(request.targetLanguages, equals([chinese, japanese]));
      expect(request.sourceText, equals('Hello, World!'));
      expect(request.context, equals('Greeting message'));
      expect(request.maxLength, equals(50));
      expect(request.isValid, isTrue);
    });

    test('should extract placeholders correctly', () {
      final placeholders1 = TranslationUtils.extractPlaceholders('Hello, {name}!');
      expect(placeholders1, contains('{name}'));

      final placeholders2 = TranslationUtils.extractPlaceholders('Welcome back, {{username}}!');
      expect(placeholders2, contains('{{username}}'));

      final placeholders3 = TranslationUtils.extractPlaceholders('You have %count% messages');
      expect(placeholders3, contains('%count%'));

      final placeholders4 = TranslationUtils.extractPlaceholders('Format: %1\$s - %2\$d');
      expect(placeholders4, contains('%1\$s'));
      expect(placeholders4, contains('%2\$d'));
    });
  });

  group('TranslationEntry', () {
    test('should create translation entry with supported languages', () {
      final english = Language.getLanguageByCode('en-US')!;
      final chinese = Language.getLanguageByCode('zh-CN')!;

      final entry = TranslationEntry(
        id: 'entry-1',
        key: 'test.key',
        projectId: 'project-1',
        sourceLanguage: english,
        targetLanguage: chinese,
        sourceText: 'Hello',
        targetText: '你好',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(entry.sourceLanguage.code, equals('en-US'));
      expect(entry.targetLanguage.code, equals('zh-CN'));
      expect(entry.sourceText, equals('Hello'));
      expect(entry.targetText, equals('你好'));
    });
  });

  group('Project', () {
    late Language english;
    late Language chinese;
    late User user;

    setUp(() {
      english = Language.getLanguageByCode('en-US')!;
      chinese = Language.getLanguageByCode('zh-CN')!;

      user = User(
        id: 'user-1',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    test('should create project with supported languages', () {
      final project = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(project.primaryLanguage.code, equals('en-US'));
      expect(project.targetLanguages.length, equals(1));
      expect(project.targetLanguages.first.code, equals('zh-CN'));
      expect(project.allLanguages.length, equals(2));
    });

    test('should maintain primary language when copying', () {
      final project = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final copiedProject = project.copyWith(
        name: 'Updated Project',
        description: 'Updated description',
        targetLanguages: [],
      );

      expect(copiedProject.primaryLanguage.code, equals('en-US'));
      expect(copiedProject.name, equals('Updated Project'));
      expect(copiedProject.description, equals('Updated description'));
      expect(copiedProject.targetLanguages.length, equals(0));
    });

    test('should serialize and deserialize with primary language', () {
      final originalProject = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final json = originalProject.toJson();
      final deserializedProject = Project.fromJson(json);

      expect(deserializedProject.primaryLanguage.code, equals('en-US'));
      expect(deserializedProject.name, equals('Test Project'));
      expect(deserializedProject.targetLanguages.length, equals(1));
      expect(deserializedProject.targetLanguages.first.code, equals('zh-CN'));
    });

    test('should handle equality with primary language', () {
      final project1 = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final project2 = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        owner: user,
        createdAt: project1.createdAt,
        updatedAt: project1.updatedAt,
      );

      final project3 = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: chinese, // Different primary language
        targetLanguages: [english],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(project1, equals(project2));
      expect(project1, isNot(equals(project3)));
    });

    test('should include primary language in all languages', () {
      final project = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [chinese],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(project.allLanguages.length, equals(2));
      expect(project.allLanguages.map((lang) => lang.code), contains('en-US'));
      expect(project.allLanguages.map((lang) => lang.code), contains('zh-CN'));
    });

    test('should handle empty target languages', () {
      final project = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        primaryLanguage: english,
        targetLanguages: [],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(project.allLanguages.length, equals(1));
      expect(project.allLanguages.first.code, equals('en-US'));
    });
  });
}
