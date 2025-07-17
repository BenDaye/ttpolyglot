import 'package:flutter_test/flutter_test.dart';
// import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot_core/core.dart';

void main() {
  group('翻译功能测试', () {
    // late TranslationServiceImpl translationService;

    setUp(() async {
      // 这里应该设置测试环境
      // translationService = await TranslationServiceImpl.create();
    });

    test('创建翻译键请求验证', () {
      // 准备测试数据
      final english = Language.getLanguageByCode('en-US')!;
      final chinese = Language.getLanguageByCode('zh-CN')!;
      final japanese = Language.getLanguageByCode('ja-JP')!;

      // 创建翻译键请求
      final request = CreateTranslationKeyRequest(
        projectId: 'test-project',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [chinese, japanese],
        context: '通用问候语',
        comment: '测试翻译键',
        generateForDefaultLanguage: true,
      );

      // 验证请求
      expect(request.isValid, true);
      expect(request.validate(), isEmpty);
    });

    test('生成翻译条目', () {
      // 准备测试数据
      final english = Language.getLanguageByCode('en-US')!;
      final chinese = Language.getLanguageByCode('zh-CN')!;
      final japanese = Language.getLanguageByCode('ja-JP')!;

      final request = CreateTranslationKeyRequest(
        projectId: 'test-project',
        key: 'common.greeting',
        sourceLanguage: english,
        sourceText: 'Hello, World!',
        targetLanguages: [chinese, japanese],
        generateForDefaultLanguage: true,
      );

      // 生成翻译条目
      final entries = TranslationUtils.generateTranslationEntries(request);

      // 验证生成的条目
      expect(entries.length, 3); // 2个目标语言 + 1个默认语言
      expect(entries.every((entry) => entry.key == 'common.greeting'), true);
      expect(entries.every((entry) => entry.sourceText == 'Hello, World!'), true);
      expect(entries.every((entry) => entry.projectId == 'test-project'), true);

      // 验证默认语言条目
      final defaultEntry = entries.firstWhere((entry) => entry.targetLanguage.code == 'en-US');
      expect(defaultEntry.status, TranslationStatus.completed);
      expect(defaultEntry.targetText, 'Hello, World!');

      // 验证目标语言条目
      final chineseEntry = entries.firstWhere((entry) => entry.targetLanguage.code == 'zh-CN');
      expect(chineseEntry.status, TranslationStatus.pending);
      expect(chineseEntry.targetText, '');

      final japaneseEntry = entries.firstWhere((entry) => entry.targetLanguage.code == 'ja-JP');
      expect(japaneseEntry.status, TranslationStatus.pending);
      expect(japaneseEntry.targetText, '');
    });

    test('项目语言变化同步测试', () {
      // 准备测试数据
      // final english = Language.getLanguageByCode('en-US')!;
      final chinese = Language.getLanguageByCode('zh-CN')!;
      final japanese = Language.getLanguageByCode('ja-JP')!;
      final korean = Language.getLanguageByCode('ko-KR')!;

      // 模拟现有的翻译条目
      // final existingEntries = [
      //   TranslationEntry(
      //     id: 'entry-1',
      //     projectId: 'test-project',
      //     key: 'common.greeting',
      //     sourceLanguage: english,
      //     targetLanguage: chinese,
      //     sourceText: 'Hello',
      //     targetText: '你好',
      //     status: TranslationStatus.completed,
      //     createdAt: DateTime.now(),
      //     updatedAt: DateTime.now(),
      //   ),
      //   TranslationEntry(
      //     id: 'entry-2',
      //     projectId: 'test-project',
      //     key: 'common.greeting',
      //     sourceLanguage: english,
      //     targetLanguage: japanese,
      //     sourceText: 'Hello',
      //     targetText: 'こんにちは',
      //     status: TranslationStatus.completed,
      //     createdAt: DateTime.now(),
      //     updatedAt: DateTime.now(),
      //   ),
      // ];

      // 新的目标语言列表（移除日语，添加韩语）
      final newTargetLanguages = [chinese, korean];

      // 验证语言变化检测逻辑
      final oldTargetCodes = [chinese, japanese].map((lang) => lang.code).toSet();
      final newTargetCodes = newTargetLanguages.map((lang) => lang.code).toSet();

      expect(oldTargetCodes.containsAll(newTargetCodes), false); // 应该检测到变化
      expect(newTargetCodes.containsAll(oldTargetCodes), false); // 应该检测到变化

      // 验证需要添加的语言
      final languagesToAdd = newTargetLanguages.where((lang) => !oldTargetCodes.contains(lang.code)).toList();
      expect(languagesToAdd.length, 1);
      expect(languagesToAdd.first.code, 'ko-KR');

      // 验证需要删除的语言
      final languagesToRemove = [chinese, japanese].where((lang) => !newTargetCodes.contains(lang.code)).toList();
      expect(languagesToRemove.length, 1);
      expect(languagesToRemove.first.code, 'ja-JP');
    });

    test('翻译键验证', () {
      // 有效的翻译键
      expect(TranslationUtils.isValidTranslationKey('common.greeting'), true);
      expect(TranslationUtils.isValidTranslationKey('app.title'), true);
      expect(TranslationUtils.isValidTranslationKey('user.profile.name'), true);

      // 无效的翻译键
      expect(TranslationUtils.isValidTranslationKey(''), false);
      expect(TranslationUtils.isValidTranslationKey('123invalid'), false);
      expect(TranslationUtils.isValidTranslationKey('.invalid'), false);
    });

    test('翻译条目统计', () {
      // 创建测试翻译条目
      final english = Language.getLanguageByCode('en-US')!;
      final chinese = Language.getLanguageByCode('zh-CN')!;

      final entries = [
        TranslationEntry(
          id: 'entry1',
          key: 'test.key1',
          projectId: 'test-project',
          sourceLanguage: english,
          targetLanguage: chinese,
          sourceText: 'Test 1',
          targetText: '测试 1',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TranslationEntry(
          id: 'entry2',
          key: 'test.key2',
          projectId: 'test-project',
          sourceLanguage: english,
          targetLanguage: chinese,
          sourceText: 'Test 2',
          targetText: '',
          status: TranslationStatus.pending,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TranslationEntry(
          id: 'entry3',
          key: 'test.key3',
          projectId: 'test-project',
          sourceLanguage: english,
          targetLanguage: chinese,
          sourceText: 'Test 3',
          targetText: '测试 3',
          status: TranslationStatus.reviewing,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // 计算完成率
      final completionRate = TranslationUtils.calculateCompletionRate(entries);
      expect(completionRate, closeTo(0.33, 0.01)); // 1/3 完成

      // 按状态分组
      final groupedByStatus = TranslationUtils.groupByStatus(entries);
      expect(groupedByStatus[TranslationStatus.completed]?.length, 1);
      expect(groupedByStatus[TranslationStatus.pending]?.length, 1);
      expect(groupedByStatus[TranslationStatus.reviewing]?.length, 1);

      // 按语言分组
      final groupedByLanguage = TranslationUtils.groupByLanguage(entries);
      expect(groupedByLanguage[chinese]?.length, 3);
    });

    test('验证翻译键格式', () {
      expect(TranslationUtils.isValidTranslationKey('common.greeting'), true);
      expect(TranslationUtils.isValidTranslationKey('app.buttons.submit'), true);
      expect(TranslationUtils.isValidTranslationKey('errors.network.timeout'), true);
      expect(TranslationUtils.isValidTranslationKey('valid-key'), true); // 破折号是允许的
      expect(TranslationUtils.isValidTranslationKey(''), false);
      expect(TranslationUtils.isValidTranslationKey('invalid key'), false); // 空格不允许
      expect(TranslationUtils.isValidTranslationKey('123invalid'), false); // 不能以数字开头
    });

    test('验证翻译条目批量验证', () {
      final english = Language.getLanguageByCode('en-US')!;
      final chinese = Language.getLanguageByCode('zh-CN')!;

      final validEntry = TranslationEntry(
        id: 'entry-1',
        projectId: 'test-project',
        key: 'common.greeting',
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
        projectId: 'test-project',
        key: 'invalid key', // 无效的键名
        sourceLanguage: english,
        targetLanguage: chinese,
        sourceText: '', // 空的源文本
        targetText: '你好',
        status: TranslationStatus.completed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final validationResults = TranslationUtils.batchValidateTranslationEntries([validEntry, invalidEntry]);

      expect(validationResults.containsKey('entry-1'), false); // 有效条目不应该有错误
      expect(validationResults.containsKey('entry-2'), true); // 无效条目应该有错误
      expect(validationResults['entry-2']!.length, 2); // 应该有2个错误（键名和源文本）
    });
  });
}
