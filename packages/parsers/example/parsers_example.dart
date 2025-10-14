import 'dart:io';

import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  Logger.info('TTPolyglot Parsers Example');
  Logger.info('=' * 30);
  Logger.info('Current directory: ${Directory.current.path}');
  Logger.info('');

  // Test with user-provided JSON files
  await testUserJsonFiles();

  // Original examples
  await runOriginalExamples();
}

Future<void> testUserJsonFiles() async {
  Logger.info('🧪 Testing User-Provided JSON Files:');
  Logger.info('-' * 40);

  // 创建语言
  final english = Language(
    code: 'en-US',
    name: 'English',
    nativeName: 'English',
  );

  final chinese = Language(
    code: 'zh-CN',
    name: 'Chinese',
    nativeName: '中文',
  );

  // Test en-US.json
  final enFile = File('example/en-US.json');
  Logger.info('Looking for file: ${enFile.absolute.path}');
  Logger.info('File exists: ${await enFile.exists()}');

  if (await enFile.exists()) {
    Logger.info('📄 Testing en-US.json...');
    try {
      final content = await enFile.readAsString();
      Logger.info('File size: ${content.length} characters');

      // 修复：使用 getParserForFile 方法或直接传入格式名称
      final parser = ParserFactory.getParserForFile('en-US.json') ?? ParserFactory.getParser('json');
      Logger.info('Using parser: ${parser.runtimeType}');

      final result = await parser.parseString(content, english);

      Logger.info('✅ Successfully parsed ${result.entries.length} entries');
      Logger.info('📊 Sample entries:');

      // Show first 10 entries
      for (final entry in result.entries.take(10)) {
        Logger.info('  ${entry.key}: ${entry.targetText}');
      }

      if (result.entries.length > 10) {
        Logger.info('  ... and ${result.entries.length - 10} more entries');
      }

      Logger.info('🌍 Language: ${result.language.name} (${result.language.code})');
      Logger.info('');
    } catch (error, stackTrace) {
      Logger.error('❌ Error parsing en-US.json', error: error, stackTrace: stackTrace);
      Logger.info('');
    }
  } else {
    Logger.info('❌ en-US.json not found');
    Logger.info('');
  }

  // Test zh-CN.json
  final zhFile = File('example/zh-CN.json');
  Logger.info('Looking for file: ${zhFile.absolute.path}');
  Logger.info('File exists: ${await zhFile.exists()}');

  if (await zhFile.exists()) {
    Logger.info('📄 Testing zh-CN.json...');
    try {
      final content = await zhFile.readAsString();
      Logger.info('File size: ${content.length} characters');

      // 修复：使用 getParserForFile 方法或直接传入格式名称
      final parser = ParserFactory.getParserForFile('zh-CN.json') ?? ParserFactory.getParser('json');
      Logger.info('Using parser: ${parser.runtimeType}');

      final result = await parser.parseString(content, chinese);

      Logger.info('✅ Successfully parsed ${result.entries.length} entries');
      Logger.info('📊 Sample entries:');

      // Show first 10 entries
      for (final entry in result.entries.take(10)) {
        Logger.info('  ${entry.key}: ${entry.targetText}');
      }

      if (result.entries.length > 10) {
        Logger.info('  ... and ${result.entries.length - 10} more entries');
      }

      Logger.info('🌍 Language: ${result.language.name} (${result.language.code})');
      Logger.info('');
    } catch (error, stackTrace) {
      Logger.error('❌ Error parsing zh-CN.json', error: error, stackTrace: stackTrace);
      Logger.info('');
    }
  } else {
    Logger.info('❌ zh-CN.json not found');
    Logger.info('');
  }
}

Future<void> runOriginalExamples() async {
  Logger.info('🔧 Original Examples:');
  Logger.info('-' * 20);

  // 创建语言
  final english = Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
  );

  // 1. JSON Parser Example
  Logger.info('1. JSON Parser Example:');
  // 修复：直接传入格式名称而不是文件名
  final jsonParser = ParserFactory.getParser('json');
  Logger.info('Parser: ${jsonParser.format}');
  Logger.info('Supported extensions: ${jsonParser.supportedExtensions}');

  const jsonContent = '''
{
  "welcome": "Welcome to TTPolyglot",
  "navigation": {
    "home": "Home",
    "about": "About"
  },
  "items": ["item1", "item2", "item3"]
}
''';

  final jsonResult = await jsonParser.parseString(jsonContent, english);
  Logger.info('Parsed ${jsonResult.entries.length} entries');
  for (final entry in jsonResult.entries.take(3)) {
    Logger.info('  ${entry.key}: ${entry.targetText}');
  }
  Logger.info('');

  // 2. YAML Parser Example
  Logger.info('2. YAML Parser Example:');
  // 修复：直接传入格式名称而不是文件名
  final yamlParser = ParserFactory.getParser('yaml');
  Logger.info('Parser: ${yamlParser.format}');

  const yamlContent = '''
app:
  title: TTPolyglot
  description: Translation Management Platform
navigation:
  home: Home
  about: About
version: 1.0.0
''';

  final yamlResult = await yamlParser.parseString(yamlContent, english);
  Logger.info('Parsed ${yamlResult.entries.length} entries');
  for (final entry in yamlResult.entries.take(3)) {
    Logger.info('  ${entry.key}: ${entry.targetText}');
  }
  Logger.info('');

  // 3. Supported Formats
  Logger.info('3. Supported Formats:');
  for (final format in FileFormats.allFormats) {
    final extension = FileFormats.getFileExtension(format);
    Logger.info('  ${FileFormats.getDisplayName(format)}: $extension');
  }
  Logger.info('');
}
