import 'package:ttpolyglot_core/core.dart';

void main() {
  Logger.info('TTPolyglot 项目创建示例');
  Logger.info('=' * 40);

  // 1. 展示支持的语言列表
  Logger.info('\n1. 支持的语言列表:');
  Logger.info('总共支持 ${Language.supportedLanguages.length} 种语言');

  // 显示一些常用语言
  final commonLanguages = ['en-US', 'zh-CN', 'ja-JP', 'ko-KR', 'fr-FR', 'de-DE', 'es-ES', 'it-IT'];

  Logger.info('\n常用语言:');
  for (final code in commonLanguages) {
    final language = Language.getLanguageByCode(code);
    if (language != null) {
      Logger.info('  - ${language.code}: ${language.name} (${language.nativeName})');
    }
  }

  // 2. 创建一个有效的项目请求
  Logger.info('\n2. 创建项目请求:');

  final defaultLanguage = Language.getLanguageByCode('en-US')!;
  final targetLanguages = [
    Language.getLanguageByCode('zh-CN')!,
    Language.getLanguageByCode('ja-JP')!,
    Language.getLanguageByCode('ko-KR')!,
  ];

  final validRequest = CreateProjectRequest(
    name: '多语言翻译项目',
    description: '支持英语、中文、日语和韩语的翻译项目',
    primaryLanguage: defaultLanguage,
    targetLanguages: targetLanguages,
    ownerId: 'user-123',
  );

  Logger.info('项目名称: ${validRequest.name}');
  Logger.info('项目描述: ${validRequest.description}');
  Logger.info('默认语言: ${validRequest.primaryLanguage.code} (${validRequest.primaryLanguage.name})');
  Logger.info('目标语言:');
  for (final lang in validRequest.targetLanguages) {
    Logger.info('  - ${lang.code}: ${lang.name}');
  }
  Logger.info('请求验证结果: ${validRequest.isValid ? '✅ 有效' : '❌ 无效'}');

  // 3. 演示无效的项目请求
  Logger.info('\n3. 无效的项目请求示例:');

  // 使用无效的语言代码格式
  final invalidLanguage = Language(
    code: 'en', // 错误格式，应该是 en-US
    name: 'English',
    nativeName: 'English',
  );

  final invalidRequest = CreateProjectRequest(
    name: '无效项目',
    description: '使用无效语言代码的项目',
    primaryLanguage: invalidLanguage,
    targetLanguages: [Language.getLanguageByCode('zh-CN')!],
    ownerId: 'user-123',
  );

  Logger.info('请求验证结果: ${invalidRequest.isValid ? '✅ 有效' : '❌ 无效'}');
  if (!invalidRequest.isValid) {
    Logger.info('验证错误:');
    for (final error in invalidRequest.validate()) {
      Logger.info('  - $error');
    }
  }

  // 4. 演示重复语言的错误
  Logger.info('\n4. 重复语言错误示例:');

  final duplicateRequest = CreateProjectRequest(
    name: '重复语言项目',
    description: '包含重复目标语言的项目',
    primaryLanguage: Language.getLanguageByCode('en-US')!,
    targetLanguages: [
      Language.getLanguageByCode('zh-CN')!,
      Language.getLanguageByCode('zh-CN')!, // 重复
    ],
    ownerId: 'user-123',
  );

  Logger.info('请求验证结果: ${duplicateRequest.isValid ? '✅ 有效' : '❌ 无效'}');
  if (!duplicateRequest.isValid) {
    Logger.info('验证错误:');
    for (final error in duplicateRequest.validate()) {
      Logger.info('  - $error');
    }
  }

  // 5. 演示默认语言不能作为目标语言
  Logger.info('\n5. 默认语言作为目标语言错误示例:');

  final sameLanguageRequest = CreateProjectRequest(
    name: '相同语言项目',
    description: '默认语言和目标语言相同的项目',
    primaryLanguage: Language.getLanguageByCode('en-US')!,
    targetLanguages: [
      Language.getLanguageByCode('en-US')!, // 与默认语言相同
      Language.getLanguageByCode('zh-CN')!,
    ],
    ownerId: 'user-123',
  );

  Logger.info('请求验证结果: ${sameLanguageRequest.isValid ? '✅ 有效' : '❌ 无效'}');
  if (!sameLanguageRequest.isValid) {
    Logger.info('验证错误:');
    for (final error in sameLanguageRequest.validate()) {
      Logger.info('  - $error');
    }
  }

  // 6. 演示语言搜索功能
  Logger.info('\n6. 语言搜索功能:');

  final searchQueries = ['Chinese', 'English', 'German', 'French'];
  for (final query in searchQueries) {
    final results = Language.searchSupportedLanguages(query);
    Logger.info('搜索 "$query" 的结果 (${results.length} 个):');
    for (final lang in results.take(3)) {
      // 只显示前3个结果
      Logger.info('  - ${lang.code}: ${lang.name}');
    }
    if (results.length > 3) {
      Logger.info('  ... 还有 ${results.length - 3} 个结果');
    }
  }

  // 7. 演示按语言分组功能
  Logger.info('\n7. 按语言分组功能:');

  final grouped = Language.supportedLanguagesByGroup;
  final sampleGroups = ['en', 'zh', 'fr', 'de'];

  for (final groupKey in sampleGroups) {
    if (grouped.containsKey(groupKey)) {
      final languages = grouped[groupKey]!;
      Logger.info('$groupKey 语言组 (${languages.length} 个变体):');
      for (final lang in languages) {
        Logger.info('  - ${lang.code}: ${lang.name}');
      }
    }
  }

  // 8. 演示语言验证功能
  Logger.info('\n8. 语言代码验证:');

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
    Logger.info('  $status $code: 格式${isValidFormat ? '正确' : '错误'}, ${isSupported ? '支持' : '不支持'}');
  }

  Logger.info('\n✅ 项目创建示例完成！');
  Logger.info('\n总结:');
  Logger.info('- 支持 ${Language.supportedLanguages.length} 种语言');
  Logger.info('- 语言代码必须是 xx-XX 格式');
  Logger.info('- 提供了搜索、分组、验证等功能');
  Logger.info('- 创建项目时会自动验证语言支持');
}
