import 'package:ttpolyglot_core/core.dart';

void main() {
  Logger.info('TTPolyglot 翻译键创建示例');
  Logger.info('=' * 50);

  // 1. 创建项目和语言
  Logger.info('\n1. 创建项目和语言设置:');

  final english = Language.getLanguageByCode('en-US')!;
  final chinese = Language.getLanguageByCode('zh-CN')!;
  final japanese = Language.getLanguageByCode('ja-JP')!;
  final korean = Language.getLanguageByCode('ko-KR')!;

  Logger.info('默认语言: ${english.code} (${english.name})');
  Logger.info('目标语言:');
  Logger.info('  - ${chinese.code}: ${chinese.name}');
  Logger.info('  - ${japanese.code}: ${japanese.name}');
  Logger.info('  - ${korean.code}: ${korean.name}');

  // 2. 创建翻译键请求
  Logger.info('\n2. 创建翻译键请求:');

  final request = CreateTranslationKeyRequest(
    projectId: 'project-1',
    key: 'common.greeting',
    sourceLanguage: english,
    sourceText: 'Hello, welcome to our application!',
    targetLanguages: [chinese, japanese, korean],
    context: '应用程序的欢迎消息',
    comment: '这是用户首次打开应用时看到的问候语',
    maxLength: 100,
    generateForDefaultLanguage: true,
  );

  Logger.info('项目 ID: ${request.projectId}');
  Logger.info('翻译键: ${request.key}');
  Logger.info('源语言: ${request.sourceLanguage.code}');
  Logger.info('源文本: ${request.sourceText}');
  Logger.info('目标语言: ${request.targetLanguages.map((l) => l.code).join(', ')}');
  Logger.info('上下文: ${request.context}');
  Logger.info('备注: ${request.comment}');
  Logger.info('最大长度: ${request.maxLength}');
  Logger.info('为默认语言生成条目: ${request.generateForDefaultLanguage}');

  // 3. 验证请求
  Logger.info('\n3. 验证翻译键请求:');

  final validationErrors = request.validate();
  if (validationErrors.isEmpty) {
    Logger.info('✅ 请求验证通过');
  } else {
    Logger.info('❌ 请求验证失败:');
    for (final error in validationErrors) {
      Logger.info('  - $error');
    }
  }

  // 4. 生成翻译条目
  Logger.info('\n4. 生成翻译条目:');

  final entries = TranslationUtils.generateTranslationEntries(request);
  Logger.info('生成了 ${entries.length} 个翻译条目:');

  for (final entry in entries) {
    Logger.info('  - ${entry.id}');
    Logger.info('    键: ${entry.key}');
    Logger.info('    源语言: ${entry.sourceLanguage.code}');
    Logger.info('    目标语言: ${entry.targetLanguage.code}');
    Logger.info('    源文本: ${entry.sourceText}');
    Logger.info('    目标文本: ${entry.targetText}');
    Logger.info('    状态: ${entry.status.displayName}');
    Logger.info('    上下文: ${entry.context}');
    Logger.info('    备注: ${entry.comment}');
    Logger.info('');
  }

  // 5. 批量验证翻译条目
  Logger.info('5. 批量验证翻译条目:');

  final validationResults = TranslationUtils.batchValidateTranslationEntries(entries);
  if (validationResults.isEmpty) {
    Logger.info('✅ 所有翻译条目验证通过');
  } else {
    Logger.info('❌ 发现验证错误:');
    for (final entryId in validationResults.keys) {
      Logger.info('  条目 $entryId:');
      for (final error in validationResults[entryId]!) {
        Logger.info('    - $error');
      }
    }
  }

  // 6. 演示不同场景的翻译键创建
  Logger.info('\n6. 不同场景的翻译键创建:');

  // 场景1: 复数形式的翻译
  Logger.info('\n场景1: 复数形式的翻译');
  final pluralRequest = CreateTranslationKeyRequest(
    projectId: 'project-1',
    key: 'item.count',
    sourceLanguage: english,
    sourceText: '{count} items',
    targetLanguages: [chinese, japanese],
    isPlural: true,
    pluralForms: {
      'one': '{count} item',
      'other': '{count} items',
    },
    generateForDefaultLanguage: false,
  );

  final pluralEntries = TranslationUtils.generateTranslationEntries(pluralRequest);
  Logger.info('复数形式翻译条目数量: ${pluralEntries.length}');

  // 场景2: 长度限制的翻译
  Logger.info('\n场景2: 长度限制的翻译');
  final limitedRequest = CreateTranslationKeyRequest(
    projectId: 'project-1',
    key: 'button.submit',
    sourceLanguage: english,
    sourceText: 'Submit',
    targetLanguages: [chinese, japanese, korean],
    maxLength: 10,
    context: '提交按钮文本',
    generateForDefaultLanguage: true,
  );

  final limitedEntries = TranslationUtils.generateTranslationEntries(limitedRequest);
  Logger.info('长度限制翻译条目数量: ${limitedEntries.length}');

  // 场景3: 带占位符的翻译
  Logger.info('\n场景3: 带占位符的翻译');
  final placeholderRequest = CreateTranslationKeyRequest(
    projectId: 'project-1',
    key: 'user.welcome',
    sourceLanguage: english,
    sourceText: 'Welcome back, {username}!',
    targetLanguages: [chinese, japanese],
    context: '用户登录后的欢迎消息',
    generateForDefaultLanguage: true,
  );

  final placeholderEntries = TranslationUtils.generateTranslationEntries(placeholderRequest);
  Logger.info('带占位符翻译条目数量: ${placeholderEntries.length}');

  // 提取占位符
  final placeholders = TranslationUtils.extractPlaceholders(placeholderRequest.sourceText);
  Logger.info('检测到的占位符: ${placeholders.join(', ')}');

  // 7. 从项目信息创建翻译键请求
  Logger.info('\n7. 从项目信息创建翻译键请求:');

  final projectRequest = TranslationUtils.createTranslationKeyRequestFromProject(
    projectId: 'project-1',
    key: 'error.network',
    primaryLanguage: english,
    targetLanguages: [chinese, japanese, korean],
    sourceText: 'Network connection failed. Please try again.',
    context: '网络连接失败时显示的错误消息',
    comment: '这是一个重要的错误消息，需要准确翻译',
    maxLength: 80,
    initialStatus: TranslationStatus.pending,
    generateForDefaultLanguage: true,
  );

  Logger.info('从项目信息创建的请求:');
  Logger.info('  键: ${projectRequest.key}');
  Logger.info('  源文本: ${projectRequest.sourceText}');
  Logger.info('  目标语言数量: ${projectRequest.targetLanguages.length}');
  Logger.info('  验证结果: ${projectRequest.isValid ? '✅ 有效' : '❌ 无效'}');

  // 8. 演示无效的翻译键请求
  Logger.info('\n8. 演示无效的翻译键请求:');

  final invalidRequest = CreateTranslationKeyRequest(
    projectId: '', // 空的项目 ID
    key: '', // 空的键名
    sourceLanguage: english,
    sourceText: '', // 空的源文本
    targetLanguages: [], // 空的目标语言列表
  );

  final invalidErrors = invalidRequest.validate();
  Logger.info('无效请求的验证错误:');
  for (final error in invalidErrors) {
    Logger.info('  - $error');
  }

  // 9. 翻译键验证
  Logger.info('\n9. 翻译键验证:');

  final testKeys = [
    'common.greeting', // 有效
    'user.profile.name', // 有效
    'button_submit', // 有效（下划线）
    'error-message', // 有效（连字符）
    '123invalid', // 无效（数字开头）
    'special@key', // 无效（特殊字符）
    '', // 无效（空字符串）
    'valid.key.name', // 有效（多级命名空间）
  ];

  for (final key in testKeys) {
    final isValid = TranslationUtils.isValidTranslationKey(key);
    final status = isValid ? '✅' : '❌';
    Logger.info('  $status "$key": ${isValid ? '有效' : '无效'}');
  }

  // 10. 统计信息
  Logger.info('\n10. 翻译条目统计:');

  final allEntries = [
    ...entries,
    ...pluralEntries,
    ...limitedEntries,
    ...placeholderEntries,
  ];

  final stats = TranslationUtils.generateStatistics(allEntries);
  Logger.info('总条目数: ${stats['total']}');
  Logger.info('已完成: ${stats['completed']}');
  Logger.info('待翻译: ${stats['pending']}');
  Logger.info('完成率: ${(stats['completionRate'] * 100).toStringAsFixed(1)}%');
  Logger.info('涉及语言数: ${stats['languageCount']}');

  final statusBreakdown = stats['statusBreakdown'] as Map<String, int>;
  Logger.info('状态分布:');
  for (final status in statusBreakdown.keys) {
    Logger.info('  $status: ${statusBreakdown[status]}');
  }

  final languageBreakdown = stats['languageBreakdown'] as Map<String, int>;
  Logger.info('语言分布:');
  for (final language in languageBreakdown.keys) {
    Logger.info('  $language: ${languageBreakdown[language]}');
  }

  Logger.info('\n✅ 翻译键创建示例完成！');
  Logger.info('\n总结:');
  Logger.info('- 支持为多个语言批量创建翻译条目');
  Logger.info('- 支持复数形式、长度限制、占位符等高级功能');
  Logger.info('- 提供完整的验证机制');
  Logger.info('- 支持从项目信息快速创建翻译键请求');
  Logger.info('- 提供详细的统计信息');
}
