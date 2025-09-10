import 'dart:developer';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

void main() {
  group('Demo文件导入测试', () {
    testWidgets('测试JSON格式demo文件解析', (WidgetTester tester) async {
      // 创建测试用的JSON内容
      const jsonContent = '{"hello": "你好", "welcome": "欢迎", "goodbye": "再见", "thank_you": "谢谢"}';

      // 获取JSON解析器
      final parser = ParserFactory.getParser('json');

      // 创建中文语言对象
      final language = Language(
        code: 'zh-CN',
        name: 'Chinese (Simplified)',
        nativeName: '中文（简体）',
      );

      try {
        // 解析JSON内容
        final result = await parser.parseString(jsonContent, language);

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.entries.length, 4);
        expect(result.language.code, 'zh-CN');

        // 验证具体的翻译条目
        final helloEntry = result.entries.firstWhere((e) => e.key == 'hello');
        expect(helloEntry.targetText, '你好');

        log('✅ JSON格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印解析结果
        for (final entry in result.entries) {
          log('  ${entry.key}: ${entry.targetText}');
        }
      } catch (error, stackTrace) {
        log('❌ JSON格式demo文件解析失败', error: error, stackTrace: stackTrace);
        fail('JSON解析失败: $error');
      }
    });

    testWidgets('测试CSV格式demo文件解析', (WidgetTester tester) async {
      // 创建测试用的CSV内容
      const csvContent = '''key,value
hello,你好
welcome,欢迎
goodbye,再见
thank_you,谢谢''';

      // 获取CSV解析器
      final parser = ParserFactory.getParser('csv');

      // 创建中文语言对象
      final language = Language(
        code: 'zh-CN',
        name: 'Chinese (Simplified)',
        nativeName: '中文（简体）',
      );

      try {
        // 解析CSV内容
        final result = await parser.parseString(csvContent, language);

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.entries.length, 4);
        expect(result.language.code, 'zh-CN');

        // 验证具体的翻译条目
        final welcomeEntry = result.entries.firstWhere((e) => e.key == 'welcome');
        expect(welcomeEntry.targetText, '欢迎');

        log('✅ CSV格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印解析结果
        for (final entry in result.entries) {
          log('  ${entry.key}: ${entry.targetText}');
        }
      } catch (error, stackTrace) {
        log('❌ CSV格式demo文件解析失败', error: error, stackTrace: stackTrace);
        fail('CSV解析失败: $error');
      }
    });

    testWidgets('测试ARB格式demo文件解析', (WidgetTester tester) async {
      // 创建测试用的ARB内容
      const arbContent = '{"@@locale":"zh","hello":"你好","welcome":"欢迎","goodbye":"再见","thank_you":"谢谢"}';

      // 获取ARB解析器
      final parser = ParserFactory.getParser('arb');

      // 创建中文语言对象
      final language = Language(
        code: 'zh-CN',
        name: 'Chinese (Simplified)',
        nativeName: '中文（简体）',
      );

      try {
        // 解析ARB内容
        final result = await parser.parseString(arbContent, language);

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.entries.length, 4); // @@locale不应该被解析为翻译条目
        expect(result.language.code, 'zh-CN');

        // 验证具体的翻译条目
        final goodbyeEntry = result.entries.firstWhere((e) => e.key == 'goodbye');
        expect(goodbyeEntry.targetText, '再见');

        log('✅ ARB格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印解析结果
        for (final entry in result.entries) {
          log('  ${entry.key}: ${entry.targetText}');
        }
      } catch (error, stackTrace) {
        log('❌ ARB格式demo文件解析失败', error: error, stackTrace: stackTrace);
        fail('ARB解析失败: $error');
      }
    });

    testWidgets('测试PO格式demo文件解析', (WidgetTester tester) async {
      // 创建测试用的PO内容
      const poContent = '''# Translation file for zh_CN
msgid "hello"
msgstr "你好"

msgid "welcome"
msgstr "欢迎"

msgid "goodbye"
msgstr "再见"

msgid "thank_you"
msgstr "谢谢"''';

      // 获取PO解析器
      final parser = ParserFactory.getParser('po');

      // 创建中文语言对象
      final language = Language(
        code: 'zh-CN',
        name: 'Chinese (Simplified)',
        nativeName: '中文（简体）',
      );

      try {
        // 解析PO内容
        final result = await parser.parseString(poContent, language);

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.entries.length, 4);
        expect(result.language.code, 'zh-CN');

        // 验证具体的翻译条目
        final thankYouEntry = result.entries.firstWhere((e) => e.key == 'thank_you');
        expect(thankYouEntry.targetText, '谢谢');

        log('✅ PO格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印解析结果
        for (final entry in result.entries) {
          log('  ${entry.key}: ${entry.targetText}');
        }
      } catch (error, stackTrace) {
        log('❌ PO格式demo文件解析失败', error: error, stackTrace: stackTrace);
        fail('PO解析失败: $error');
      }
    });

    testWidgets('测试复杂JSON demo文件解析', (WidgetTester tester) async {
      // 读取实际的demo文件
      final demoFile = File('/Users/mac888/Desktop/www/ttpolyglot/demo_zh_CN.json');

      if (!await demoFile.exists()) {
        log('⚠️ demo文件不存在，跳过测试');
        return;
      }

      final content = await demoFile.readAsString();

      // 获取JSON解析器
      final parser = ParserFactory.getParser('json');

      // 创建中文语言对象
      final language = Language(
        code: 'zh-CN',
        name: 'Chinese (Simplified)',
        nativeName: '中文（简体）',
      );

      try {
        // 解析JSON内容
        final result = await parser.parseString(content, language);

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.language.code, 'zh-CN');

        log('✅ 复杂JSON格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印前几个解析结果
        final firstFewEntries = result.entries.take(5);
        for (final entry in firstFewEntries) {
          log('  ${entry.key}: ${entry.targetText}');
        }
        if (result.entries.length > 5) {
          log('  ... 还有 ${result.entries.length - 5} 个条目');
        }
      } catch (error, stackTrace) {
        log('❌ 复杂JSON格式demo文件解析失败', error: error, stackTrace: stackTrace);
        fail('复杂JSON解析失败: $error');
      }
    });

    testWidgets('测试支持的文件格式', (WidgetTester tester) async {
      final supportedFormats = ParserFactory.getSupportedFormats();

      log('📋 支持的文件格式:');
      for (final format in supportedFormats) {
        final parser = ParserFactory.getParser(format);
        log('  - $format (${parser.displayName}): ${parser.supportedExtensions.join(', ')}');
      }

      // 验证必要的格式都被支持
      expect(supportedFormats.contains('json'), true);
      expect(supportedFormats.contains('csv'), true);
      expect(supportedFormats.contains('arb'), true);
      expect(supportedFormats.contains('po'), true);

      log('✅ 所有期望的文件格式都被支持！');
    });
  });
}
