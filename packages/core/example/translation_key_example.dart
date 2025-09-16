import 'package:ttpolyglot_core/core.dart';

void main() {
  print('TTPolyglot 翻译键创建示例');
  print('=' * 50);

  // 1. 创建项目和语言
  print('\n1. 创建项目和语言设置:');

  final english = Language.getLanguageByCode('en-US')!;
  final chinese = Language.getLanguageByCode('zh-CN')!;
  final japanese = Language.getLanguageByCode('ja-JP')!;
  final korean = Language.getLanguageByCode('ko-KR')!;

  print('默认语言: ${english.code} (${english.name})');
  print('目标语言:');
  print('  - ${chinese.code}: ${chinese.name}');
  print('  - ${japanese.code}: ${japanese.name}');
  print('  - ${korean.code}: ${korean.name}');

  // 2. 创建翻译键请求
  print('\n2. 创建翻译键请求:');

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

  print('项目 ID: ${request.projectId}');
  print('翻译键: ${request.key}');
  print('源语言: ${request.sourceLanguage.code}');
  print('源文本: ${request.sourceText}');
  print('目标语言: ${request.targetLanguages.map((l) => l.code).join(', ')}');
  print('上下文: ${request.context}');
  print('备注: ${request.comment}');
  print('最大长度: ${request.maxLength}');
  print('为默认语言生成条目: ${request.generateForDefaultLanguage}');

  // 3. 验证请求
  print('\n3. 验证翻译键请求:');

  final validationErrors = request.validate();
  if (validationErrors.isEmpty) {
    print('✅ 请求验证通过');
  } else {
    print('❌ 请求验证失败:');
    for (final error in validationErrors) {
      print('  - $error');
    }
  }

  // 4. 生成翻译条目
  print('\n4. 生成翻译条目:');

  final entries = TranslationUtils.generateTranslationEntries(request);
  print('生成了 ${entries.length} 个翻译条目:');

  for (final entry in entries) {
    print('  - ${entry.id}');
    print('    键: ${entry.key}');
    print('    源语言: ${entry.sourceLanguage.code}');
    print('    目标语言: ${entry.targetLanguage.code}');
    print('    源文本: ${entry.sourceText}');
    print('    目标文本: ${entry.targetText}');
    print('    状态: ${entry.status.displayName}');
    print('    上下文: ${entry.context}');
    print('    备注: ${entry.comment}');
    print('');
  }

  // 5. 批量验证翻译条目
  print('5. 批量验证翻译条目:');

  final validationResults = TranslationUtils.batchValidateTranslationEntries(entries);
  if (validationResults.isEmpty) {
    print('✅ 所有翻译条目验证通过');
  } else {
    print('❌ 发现验证错误:');
    for (final entryId in validationResults.keys) {
      print('  条目 $entryId:');
      for (final error in validationResults[entryId]!) {
        print('    - $error');
      }
    }
  }

  // 6. 演示不同场景的翻译键创建
  print('\n6. 不同场景的翻译键创建:');

  // 场景1: 复数形式的翻译
  print('\n场景1: 复数形式的翻译');
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
  print('复数形式翻译条目数量: ${pluralEntries.length}');

  // 场景2: 长度限制的翻译
  print('\n场景2: 长度限制的翻译');
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
  print('长度限制翻译条目数量: ${limitedEntries.length}');

  // 场景3: 带占位符的翻译
  print('\n场景3: 带占位符的翻译');
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
  print('带占位符翻译条目数量: ${placeholderEntries.length}');

  // 提取占位符
  final placeholders = TranslationUtils.extractPlaceholders(placeholderRequest.sourceText);
  print('检测到的占位符: ${placeholders.join(', ')}');

  // 7. 从项目信息创建翻译键请求
  print('\n7. 从项目信息创建翻译键请求:');

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

  print('从项目信息创建的请求:');
  print('  键: ${projectRequest.key}');
  print('  源文本: ${projectRequest.sourceText}');
  print('  目标语言数量: ${projectRequest.targetLanguages.length}');
  print('  验证结果: ${projectRequest.isValid ? '✅ 有效' : '❌ 无效'}');

  // 8. 演示无效的翻译键请求
  print('\n8. 演示无效的翻译键请求:');

  final invalidRequest = CreateTranslationKeyRequest(
    projectId: '', // 空的项目 ID
    key: '', // 空的键名
    sourceLanguage: english,
    sourceText: '', // 空的源文本
    targetLanguages: [], // 空的目标语言列表
  );

  final invalidErrors = invalidRequest.validate();
  print('无效请求的验证错误:');
  for (final error in invalidErrors) {
    print('  - $error');
  }

  // 9. 翻译键验证
  print('\n9. 翻译键验证:');

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
    print('  $status "$key": ${isValid ? '有效' : '无效'}');
  }

  // 10. 统计信息
  print('\n10. 翻译条目统计:');

  final allEntries = [
    ...entries,
    ...pluralEntries,
    ...limitedEntries,
    ...placeholderEntries,
  ];

  final stats = TranslationUtils.generateStatistics(allEntries);
  print('总条目数: ${stats['total']}');
  print('已完成: ${stats['completed']}');
  print('待翻译: ${stats['pending']}');
  print('完成率: ${(stats['completionRate'] * 100).toStringAsFixed(1)}%');
  print('涉及语言数: ${stats['languageCount']}');

  final statusBreakdown = stats['statusBreakdown'] as Map<String, int>;
  print('状态分布:');
  for (final status in statusBreakdown.keys) {
    print('  $status: ${statusBreakdown[status]}');
  }

  final languageBreakdown = stats['languageBreakdown'] as Map<String, int>;
  print('语言分布:');
  for (final language in languageBreakdown.keys) {
    print('  $language: ${languageBreakdown[language]}');
  }

  print('\n✅ 翻译键创建示例完成！');
  print('\n总结:');
  print('- 支持为多个语言批量创建翻译条目');
  print('- 支持复数形式、长度限制、占位符等高级功能');
  print('- 提供完整的验证机制');
  print('- 支持从项目信息快速创建翻译键请求');
  print('- 提供详细的统计信息');
}
