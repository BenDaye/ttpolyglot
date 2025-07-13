import 'dart:io';

import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  print('TTPolyglot Parsers Example');
  print('=' * 30);
  print('Current directory: ${Directory.current.path}');
  print('');

  // Test with user-provided JSON files
  await testUserJsonFiles();

  // Original examples
  await runOriginalExamples();
}

Future<void> testUserJsonFiles() async {
  print('🧪 Testing User-Provided JSON Files:');
  print('-' * 40);

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
  print('Looking for file: ${enFile.absolute.path}');
  print('File exists: ${await enFile.exists()}');

  if (await enFile.exists()) {
    print('📄 Testing en-US.json...');
    try {
      final content = await enFile.readAsString();
      print('File size: ${content.length} characters');

      // 修复：使用 getParserForFile 方法或直接传入格式名称
      final parser = ParserFactory.getParserForFile('en-US.json') ?? ParserFactory.getParser('json');
      print('Using parser: ${parser.runtimeType}');

      final result = await parser.parseString(content, english);

      print('✅ Successfully parsed ${result.entries.length} entries');
      print('📊 Sample entries:');

      // Show first 10 entries
      for (final entry in result.entries.take(10)) {
        print('  ${entry.key}: ${entry.targetText}');
      }

      if (result.entries.length > 10) {
        print('  ... and ${result.entries.length - 10} more entries');
      }

      print('🌍 Language: ${result.language.name} (${result.language.code})');
      print('');
    } catch (e, stackTrace) {
      print('❌ Error parsing en-US.json: $e');
      print('Stack trace: $stackTrace');
      print('');
    }
  } else {
    print('❌ en-US.json not found');
    print('');
  }

  // Test zh-CN.json
  final zhFile = File('example/zh-CN.json');
  print('Looking for file: ${zhFile.absolute.path}');
  print('File exists: ${await zhFile.exists()}');

  if (await zhFile.exists()) {
    print('📄 Testing zh-CN.json...');
    try {
      final content = await zhFile.readAsString();
      print('File size: ${content.length} characters');

      // 修复：使用 getParserForFile 方法或直接传入格式名称
      final parser = ParserFactory.getParserForFile('zh-CN.json') ?? ParserFactory.getParser('json');
      print('Using parser: ${parser.runtimeType}');

      final result = await parser.parseString(content, chinese);

      print('✅ Successfully parsed ${result.entries.length} entries');
      print('📊 Sample entries:');

      // Show first 10 entries
      for (final entry in result.entries.take(10)) {
        print('  ${entry.key}: ${entry.targetText}');
      }

      if (result.entries.length > 10) {
        print('  ... and ${result.entries.length - 10} more entries');
      }

      print('🌍 Language: ${result.language.name} (${result.language.code})');
      print('');
    } catch (e, stackTrace) {
      print('❌ Error parsing zh-CN.json: $e');
      print('Stack trace: $stackTrace');
      print('');
    }
  } else {
    print('❌ zh-CN.json not found');
    print('');
  }
}

Future<void> runOriginalExamples() async {
  print('🔧 Original Examples:');
  print('-' * 20);

  // 创建语言
  final english = Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
  );

  // 1. JSON Parser Example
  print('1. JSON Parser Example:');
  // 修复：直接传入格式名称而不是文件名
  final jsonParser = ParserFactory.getParser('json');
  print('Parser: ${jsonParser.format}');
  print('Supported extensions: ${jsonParser.supportedExtensions}');

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
  print('Parsed ${jsonResult.entries.length} entries');
  for (final entry in jsonResult.entries.take(3)) {
    print('  ${entry.key}: ${entry.targetText}');
  }
  print('');

  // 2. YAML Parser Example
  print('2. YAML Parser Example:');
  // 修复：直接传入格式名称而不是文件名
  final yamlParser = ParserFactory.getParser('yaml');
  print('Parser: ${yamlParser.format}');

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
  print('Parsed ${yamlResult.entries.length} entries');
  for (final entry in yamlResult.entries.take(3)) {
    print('  ${entry.key}: ${entry.targetText}');
  }
  print('');

  // 3. Supported Formats
  print('3. Supported Formats:');
  for (final format in FileFormats.allFormats) {
    final extension = FileFormats.getFileExtension(format);
    print('  ${FileFormats.getDisplayName(format)}: $extension');
  }
  print('');
}
