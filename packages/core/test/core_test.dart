import 'package:test/test.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('Language', () {
    test('should create language with correct properties', () {
      final language = Language(
        code: 'en-US',
        name: 'English (United States)',
        nativeName: 'English (United States)',
      );

      expect(language.code, equals('en-US'));
      expect(language.name, equals('English (United States)'));
      expect(language.nativeName, equals('English (United States)'));
      expect(language.isRtl, isFalse);
    });

    test('should support JSON serialization', () {
      final language = Language(
        code: 'ar-SA',
        name: 'Arabic (Saudi Arabia)',
        nativeName: 'العربية (السعودية)',
        isRtl: true,
      );

      final json = language.toJson();
      final restored = Language.fromJson(json);

      expect(restored, equals(language));
    });

    test('should validate language code format correctly', () {
      // 有效的语言代码
      expect(Language.isValidLanguageCode('en-US'), isTrue);
      expect(Language.isValidLanguageCode('zh-CN'), isTrue);
      expect(Language.isValidLanguageCode('fr-FR'), isTrue);

      // 无效的语言代码
      expect(Language.isValidLanguageCode('en'), isFalse);
      expect(Language.isValidLanguageCode('zh'), isFalse);
      expect(Language.isValidLanguageCode('EN-US'), isFalse);
      expect(Language.isValidLanguageCode('en-us'), isFalse);
      expect(Language.isValidLanguageCode('en-USA'), isFalse);
      expect(Language.isValidLanguageCode('english'), isFalse);
      expect(Language.isValidLanguageCode(''), isFalse);
    });

    test('should return supported languages list', () {
      final supportedLanguages = Language.supportedLanguages;

      expect(supportedLanguages, isNotEmpty);
      expect(supportedLanguages.length, greaterThan(40));

      // 检查是否包含常见语言
      final languageCodes = supportedLanguages.map((l) => l.code).toList();
      expect(languageCodes, contains('en-US'));
      expect(languageCodes, contains('zh-CN'));
      expect(languageCodes, contains('ja-JP'));
      expect(languageCodes, contains('fr-FR'));
      expect(languageCodes, contains('de-DE'));

      // 检查所有语言代码格式都正确
      for (final language in supportedLanguages) {
        expect(Language.isValidLanguageCode(language.code), isTrue);
      }
    });

    test('should get language by code', () {
      final english = Language.getLanguageByCode('en-US');
      expect(english, isNotNull);
      expect(english!.code, equals('en-US'));
      expect(english.name, equals('English (United States)'));

      final chinese = Language.getLanguageByCode('zh-CN');
      expect(chinese, isNotNull);
      expect(chinese!.code, equals('zh-CN'));
      expect(chinese.name, equals('Chinese (Simplified)'));

      // 不存在的语言代码
      final nonExistent = Language.getLanguageByCode('xx-XX');
      expect(nonExistent, isNull);

      // 无效格式的语言代码
      final invalid = Language.getLanguageByCode('en');
      expect(invalid, isNull);
    });

    test('should check if language is supported', () {
      expect(Language.isLanguageSupported('en-US'), isTrue);
      expect(Language.isLanguageSupported('zh-CN'), isTrue);
      expect(Language.isLanguageSupported('ja-JP'), isTrue);

      expect(Language.isLanguageSupported('xx-XX'), isFalse);
      expect(Language.isLanguageSupported('en'), isFalse);
      expect(Language.isLanguageSupported('invalid'), isFalse);
    });

    test('should group languages by language code', () {
      final grouped = Language.supportedLanguagesByGroup;

      expect(grouped, isNotEmpty);
      expect(grouped.containsKey('en'), isTrue);
      expect(grouped.containsKey('zh'), isTrue);
      expect(grouped.containsKey('fr'), isTrue);

      // 检查英语变体
      final englishVariants = grouped['en']!;
      expect(englishVariants.length, greaterThan(1));
      expect(englishVariants.any((l) => l.code == 'en-US'), isTrue);
      expect(englishVariants.any((l) => l.code == 'en-GB'), isTrue);

      // 检查中文变体
      final chineseVariants = grouped['zh']!;
      expect(chineseVariants.length, greaterThan(1));
      expect(chineseVariants.any((l) => l.code == 'zh-CN'), isTrue);
      expect(chineseVariants.any((l) => l.code == 'zh-TW'), isTrue);
    });

    test('should search supported languages', () {
      // 搜索空字符串应返回所有语言
      final allLanguages = Language.searchSupportedLanguages('');
      expect(allLanguages.length, equals(Language.supportedLanguages.length));

      // 搜索语言代码
      final englishResults = Language.searchSupportedLanguages('en-US');
      expect(englishResults.length, equals(1));
      expect(englishResults.first.code, equals('en-US'));

      // 搜索语言名称
      final chineseResults = Language.searchSupportedLanguages('Chinese');
      expect(chineseResults.length, greaterThan(1));
      expect(chineseResults.every((l) => l.name.contains('Chinese')), isTrue);

      // 搜索本地名称
      final germanResults = Language.searchSupportedLanguages('Deutsch');
      expect(germanResults.length, greaterThan(0));
      expect(germanResults.every((l) => l.nativeName.contains('Deutsch')), isTrue);

      // 搜索不存在的内容
      final noResults = Language.searchSupportedLanguages('NonExistentLanguage');
      expect(noResults, isEmpty);
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
        defaultLanguage: english,
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
        defaultLanguage: english,
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
        defaultLanguage: english,
        targetLanguages: [chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('项目描述不能为空'));
    });

    test('should reject invalid default language code', () {
      final invalidLanguage = Language(
        code: 'en',
        name: 'English',
        nativeName: 'English',
      );

      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        defaultLanguage: invalidLanguage,
        targetLanguages: [chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('默认语言代码格式错误: en'));
    });

    test('should reject unsupported default language', () {
      final unsupportedLanguage = Language(
        code: 'xx-XX',
        name: 'Unknown Language',
        nativeName: 'Unknown Language',
      );

      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        defaultLanguage: unsupportedLanguage,
        targetLanguages: [chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('不支持的默认语言: xx-XX'));
    });

    test('should reject empty target languages', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        defaultLanguage: english,
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
        defaultLanguage: english,
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
        defaultLanguage: english,
        targetLanguages: [unsupportedLanguage],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('不支持的目标语言: yy-YY'));
    });

    test('should reject default language as target language', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        defaultLanguage: english,
        targetLanguages: [english, chinese],
        ownerId: 'user-1',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('默认语言不能同时作为目标语言'));
    });

    test('should reject duplicate target languages', () {
      final request = CreateProjectRequest(
        name: 'Test Project',
        description: 'Test project description',
        defaultLanguage: english,
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
        defaultLanguage: english,
        targetLanguages: [chinese],
        ownerId: '',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('项目所有者ID不能为空'));
    });
  });

  group('UpdateProjectRequest', () {
    late Language english;
    late Language chinese;
    late Language japanese;

    setUp(() {
      english = Language.getLanguageByCode('en-US')!;
      chinese = Language.getLanguageByCode('zh-CN')!;
      japanese = Language.getLanguageByCode('ja-JP')!;
    });

    test('should validate valid request', () {
      final request = UpdateProjectRequest(
        name: 'Updated Project',
        description: 'Updated project description',
        defaultLanguage: english,
        targetLanguages: [chinese, japanese],
      );

      expect(request.isValid, isTrue);
      expect(request.validate(), isEmpty);
    });

    test('should validate empty request', () {
      final request = UpdateProjectRequest();

      expect(request.isValid, isTrue);
      expect(request.validate(), isEmpty);
    });

    test('should reject empty name when provided', () {
      final request = UpdateProjectRequest(
        name: '',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('项目名称不能为空'));
    });

    test('should reject empty description when provided', () {
      final request = UpdateProjectRequest(
        description: '',
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('项目描述不能为空'));
    });

    test('should reject invalid default language code when provided', () {
      final invalidLanguage = Language(
        code: 'en',
        name: 'English',
        nativeName: 'English',
      );

      final request = UpdateProjectRequest(
        defaultLanguage: invalidLanguage,
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('默认语言代码格式错误: en'));
    });

    test('should reject unsupported default language when provided', () {
      final unsupportedLanguage = Language(
        code: 'xx-XX',
        name: 'Unknown Language',
        nativeName: 'Unknown Language',
      );

      final request = UpdateProjectRequest(
        defaultLanguage: unsupportedLanguage,
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('不支持的默认语言: xx-XX'));
    });

    test('should reject empty target languages when provided', () {
      final request = UpdateProjectRequest(
        targetLanguages: [],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('至少需要选择一个目标语言'));
    });

    test('should reject default language as target language when both provided', () {
      final request = UpdateProjectRequest(
        defaultLanguage: english,
        targetLanguages: [english, chinese],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('默认语言不能同时作为目标语言'));
    });

    test('should reject duplicate target languages when provided', () {
      final request = UpdateProjectRequest(
        targetLanguages: [chinese, chinese],
      );

      expect(request.isValid, isFalse);
      expect(request.validate(), contains('目标语言不能重复'));
    });
  });

  group('TranslationStatus', () {
    test('should have correct display names', () {
      expect(TranslationStatus.pending.displayName, equals('待翻译'));
      expect(TranslationStatus.completed.displayName, equals('已完成'));
    });

    test('should identify final states correctly', () {
      expect(TranslationStatus.completed.isFinal, isTrue);
      expect(TranslationStatus.rejected.isFinal, isTrue);
      expect(TranslationStatus.pending.isFinal, isFalse);
    });
  });

  group('UserRole', () {
    test('should have correct permission levels', () {
      expect(UserRole.admin.level, equals(100));
      expect(UserRole.translator.level, equals(40));
      expect(UserRole.viewer.level, equals(20));
    });

    test('should check permissions correctly', () {
      expect(UserRole.admin.canManageProject, isTrue);
      expect(UserRole.translator.canTranslate, isTrue);
      expect(UserRole.viewer.canTranslate, isFalse);
    });
  });

  group('ProjectRole', () {
    test('should have correct display names', () {
      expect(ProjectRole.owner.displayName, equals('项目所有者'));
      expect(ProjectRole.admin.displayName, equals('项目管理员'));
      expect(ProjectRole.translator.displayName, equals('翻译员'));
      expect(ProjectRole.reviewer.displayName, equals('审核员'));
      expect(ProjectRole.viewer.displayName, equals('查看者'));
    });

    test('should have correct permissions', () {
      // 所有角色都能读取
      expect(ProjectRole.owner.canRead, isTrue);
      expect(ProjectRole.admin.canRead, isTrue);
      expect(ProjectRole.translator.canRead, isTrue);
      expect(ProjectRole.reviewer.canRead, isTrue);
      expect(ProjectRole.viewer.canRead, isTrue);

      // 写入权限
      expect(ProjectRole.owner.canWrite, isTrue);
      expect(ProjectRole.admin.canWrite, isTrue);
      expect(ProjectRole.translator.canWrite, isTrue);
      expect(ProjectRole.reviewer.canWrite, isTrue);
      expect(ProjectRole.viewer.canWrite, isFalse);

      // 管理权限
      expect(ProjectRole.owner.canManage, isTrue);
      expect(ProjectRole.admin.canManage, isTrue);
      expect(ProjectRole.translator.canManage, isFalse);
      expect(ProjectRole.reviewer.canManage, isFalse);
      expect(ProjectRole.viewer.canManage, isFalse);

      // 删除权限
      expect(ProjectRole.owner.canDelete, isTrue);
      expect(ProjectRole.admin.canDelete, isFalse);
      expect(ProjectRole.translator.canDelete, isFalse);
      expect(ProjectRole.reviewer.canDelete, isFalse);
      expect(ProjectRole.viewer.canDelete, isFalse);
    });
  });

  group('Project', () {
    test('should create project with supported languages', () {
      final english = Language.getLanguageByCode('en-US')!;
      final chinese = Language.getLanguageByCode('zh-CN')!;

      final user = User(
        id: 'user-1',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final project = Project(
        id: 'project-1',
        name: 'Test Project',
        description: 'Test project description',
        defaultLanguage: english,
        targetLanguages: [chinese],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(project.defaultLanguage.code, equals('en-US'));
      expect(project.targetLanguages.length, equals(1));
      expect(project.targetLanguages.first.code, equals('zh-CN'));
      expect(project.allLanguages.length, equals(2));
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
}
