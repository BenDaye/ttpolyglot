import 'package:test/test.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('Language', () {
    test('should create language with correct properties', () {
      final language = Language(
        code: 'en',
        name: 'English',
        nativeName: 'English',
      );

      expect(language.code, equals('en'));
      expect(language.name, equals('English'));
      expect(language.nativeName, equals('English'));
      expect(language.isRtl, isFalse);
    });

    test('should support JSON serialization', () {
      final language = Language(
        code: 'ar',
        name: 'Arabic',
        nativeName: 'العربية',
        isRtl: true,
      );

      final json = language.toJson();
      final restored = Language.fromJson(json);

      expect(restored, equals(language));
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

  group('TranslationUtils', () {
    test('should generate and parse keys correctly', () {
      final fullKey = TranslationUtils.generateKey('common', 'hello');
      expect(fullKey, equals('common.hello'));

      final (namespace, key) = TranslationUtils.parseKey(fullKey);
      expect(namespace, equals('common'));
      expect(key, equals('hello'));
    });

    test('should extract placeholders correctly', () {
      final placeholders = TranslationUtils.extractPlaceholders(
        'Hello, {name}! You have {{count}} messages.',
      );
      expect(placeholders, contains('{name}'));
      expect(placeholders, contains('{{count}}'));
    });

    test('should calculate completion rate correctly', () {
      final entries = [
        _createEntry(TranslationStatus.completed),
        _createEntry(TranslationStatus.completed),
        _createEntry(TranslationStatus.pending),
      ];

      final rate = TranslationUtils.calculateCompletionRate(entries);
      expect(rate, closeTo(0.67, 0.01));
    });
  });
}

TranslationEntry _createEntry(TranslationStatus status) {
  return TranslationEntry(
    id: 'test-id',
    key: 'test.key',
    projectId: 'test-project',
    sourceLanguage: Language(
      code: 'en',
      name: 'English',
      nativeName: 'English',
    ),
    targetLanguage: Language(
      code: 'zh-CN',
      name: 'Chinese',
      nativeName: '中文',
    ),
    sourceText: 'Test',
    targetText: '测试',
    status: status,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
