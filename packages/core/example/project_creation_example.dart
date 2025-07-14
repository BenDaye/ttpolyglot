import 'package:ttpolyglot_core/core.dart';

void main() {
  print('TTPolyglot 项目创建示例');
  print('=' * 40);

  // 1. 展示支持的语言列表
  print('\n1. 支持的语言列表:');
  print('总共支持 ${Language.supportedLanguages.length} 种语言');

  // 显示一些常用语言
  final commonLanguages = ['en-US', 'zh-CN', 'ja-JP', 'ko-KR', 'fr-FR', 'de-DE', 'es-ES', 'it-IT'];

  print('\n常用语言:');
  for (final code in commonLanguages) {
    final language = Language.getLanguageByCode(code);
    if (language != null) {
      print('  - ${language.code}: ${language.name} (${language.nativeName})');
    }
  }

  // 2. 创建一个有效的项目请求
  print('\n2. 创建项目请求:');

  final defaultLanguage = Language.getLanguageByCode('en-US')!;
  final targetLanguages = [
    Language.getLanguageByCode('zh-CN')!,
    Language.getLanguageByCode('ja-JP')!,
    Language.getLanguageByCode('ko-KR')!,
  ];

  final validRequest = CreateProjectRequest(
    name: '多语言翻译项目',
    description: '支持英语、中文、日语和韩语的翻译项目',
    defaultLanguage: defaultLanguage,
    targetLanguages: targetLanguages,
    ownerId: 'user-123',
  );

  print('项目名称: ${validRequest.name}');
  print('项目描述: ${validRequest.description}');
  print('默认语言: ${validRequest.defaultLanguage.code} (${validRequest.defaultLanguage.name})');
  print('目标语言:');
  for (final lang in validRequest.targetLanguages) {
    print('  - ${lang.code}: ${lang.name}');
  }
  print('请求验证结果: ${validRequest.isValid ? '✅ 有效' : '❌ 无效'}');

  // 3. 演示无效的项目请求
  print('\n3. 无效的项目请求示例:');

  // 使用无效的语言代码格式
  final invalidLanguage = Language(
    code: 'en', // 错误格式，应该是 en-US
    name: 'English',
    nativeName: 'English',
  );

  final invalidRequest = CreateProjectRequest(
    name: '无效项目',
    description: '使用无效语言代码的项目',
    defaultLanguage: invalidLanguage,
    targetLanguages: [Language.getLanguageByCode('zh-CN')!],
    ownerId: 'user-123',
  );

  print('请求验证结果: ${invalidRequest.isValid ? '✅ 有效' : '❌ 无效'}');
  if (!invalidRequest.isValid) {
    print('验证错误:');
    for (final error in invalidRequest.validate()) {
      print('  - $error');
    }
  }

  // 4. 演示重复语言的错误
  print('\n4. 重复语言错误示例:');

  final duplicateRequest = CreateProjectRequest(
    name: '重复语言项目',
    description: '包含重复目标语言的项目',
    defaultLanguage: Language.getLanguageByCode('en-US')!,
    targetLanguages: [
      Language.getLanguageByCode('zh-CN')!,
      Language.getLanguageByCode('zh-CN')!, // 重复
    ],
    ownerId: 'user-123',
  );

  print('请求验证结果: ${duplicateRequest.isValid ? '✅ 有效' : '❌ 无效'}');
  if (!duplicateRequest.isValid) {
    print('验证错误:');
    for (final error in duplicateRequest.validate()) {
      print('  - $error');
    }
  }

  // 5. 演示默认语言不能作为目标语言
  print('\n5. 默认语言作为目标语言错误示例:');

  final sameLanguageRequest = CreateProjectRequest(
    name: '相同语言项目',
    description: '默认语言和目标语言相同的项目',
    defaultLanguage: Language.getLanguageByCode('en-US')!,
    targetLanguages: [
      Language.getLanguageByCode('en-US')!, // 与默认语言相同
      Language.getLanguageByCode('zh-CN')!,
    ],
    ownerId: 'user-123',
  );

  print('请求验证结果: ${sameLanguageRequest.isValid ? '✅ 有效' : '❌ 无效'}');
  if (!sameLanguageRequest.isValid) {
    print('验证错误:');
    for (final error in sameLanguageRequest.validate()) {
      print('  - $error');
    }
  }

  // 6. 演示语言搜索功能
  print('\n6. 语言搜索功能:');

  final searchQueries = ['Chinese', 'English', 'German', 'French'];
  for (final query in searchQueries) {
    final results = Language.searchSupportedLanguages(query);
    print('搜索 "$query" 的结果 (${results.length} 个):');
    for (final lang in results.take(3)) {
      // 只显示前3个结果
      print('  - ${lang.code}: ${lang.name}');
    }
    if (results.length > 3) {
      print('  ... 还有 ${results.length - 3} 个结果');
    }
  }

  // 7. 演示按语言分组功能
  print('\n7. 按语言分组功能:');

  final grouped = Language.supportedLanguagesByGroup;
  final sampleGroups = ['en', 'zh', 'fr', 'de'];

  for (final groupKey in sampleGroups) {
    if (grouped.containsKey(groupKey)) {
      final languages = grouped[groupKey]!;
      print('$groupKey 语言组 (${languages.length} 个变体):');
      for (final lang in languages) {
        print('  - ${lang.code}: ${lang.name}');
      }
    }
  }

  // 8. 演示语言验证功能
  print('\n8. 语言代码验证:');

  final testCodes = [
    'en-US', // 有效
    'zh-CN', // 有效
    'en', // 无效格式
    'zh', // 无效格式
    'xx-XX', // 无效（不支持）
    'EN-US', // 无效格式（大小写错误）
  ];

  for (final code in testCodes) {
    final isValidFormat = Language.isValidLanguageCode(code);
    final isSupported = Language.isLanguageSupported(code);
    final status = isValidFormat && isSupported ? '✅' : '❌';
    print('  $status $code: 格式${isValidFormat ? '正确' : '错误'}, ${isSupported ? '支持' : '不支持'}');
  }

  print('\n✅ 项目创建示例完成！');
  print('\n总结:');
  print('- 支持 ${Language.supportedLanguages.length} 种语言');
  print('- 语言代码必须是 xx-XX 格式');
  print('- 提供了搜索、分组、验证等功能');
  print('- 创建项目时会自动验证语言支持');
}
