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

        Logger.info('✅ JSON格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印解析结果
        for (final entry in result.entries) {
          Logger.info('  ${entry.key}: ${entry.targetText}');
        }
      } catch (error, stackTrace) {
        Logger.error('❌ JSON格式demo文件解析失败', error: error, stackTrace: stackTrace);
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

        // 调试输出
        Logger.info('CSV解析结果: ${result.entries.length} 个条目');
        if (result.warnings.isNotEmpty) {
          Logger.info('CSV解析警告: ${result.warnings.join(', ')}');
        }

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.entries.length, 4);
        expect(result.language.code, 'zh-CN');

        // 验证具体的翻译条目
        final welcomeEntry = result.entries.firstWhere((e) => e.key == 'welcome');
        expect(welcomeEntry.targetText, '欢迎');

        Logger.info('✅ CSV格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印解析结果
        for (final entry in result.entries) {
          Logger.info('  ${entry.key}: ${entry.targetText}');
        }
      } catch (error, stackTrace) {
        Logger.error('❌ CSV格式demo文件解析失败', error: error, stackTrace: stackTrace);
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

        Logger.info('✅ ARB格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印解析结果
        for (final entry in result.entries) {
          Logger.info('  ${entry.key}: ${entry.targetText}');
        }
      } catch (error, stackTrace) {
        Logger.error('❌ ARB格式demo文件解析失败', error: error, stackTrace: stackTrace);
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

        // 调试输出
        Logger.info('PO解析结果: ${result.entries.length} 个条目');
        if (result.warnings.isNotEmpty) {
          Logger.info('PO解析警告: ${result.warnings.join(', ')}');
        }

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.entries.length, 4);
        expect(result.language.code, 'zh-CN');

        // 验证具体的翻译条目
        final thankYouEntry = result.entries.firstWhere((e) => e.key == 'thank_you');
        expect(thankYouEntry.targetText, '谢谢');

        Logger.info('✅ PO格式demo文件解析成功！解析了 ${result.entries.length} 个翻译条目');

        // 打印解析结果
        for (final entry in result.entries) {
          Logger.info('  ${entry.key}: ${entry.targetText}');
        }
      } catch (error, stackTrace) {
        Logger.error('❌ PO格式demo文件解析失败', error: error, stackTrace: stackTrace);
        fail('PO解析失败: $error');
      }
    });

    testWidgets('测试支持的文件格式', (WidgetTester tester) async {
      final supportedFormats = ParserFactory.getSupportedFormats();

      Logger.info('📋 支持的文件格式:');
      for (final format in supportedFormats) {
        final parser = ParserFactory.getParser(format);
        Logger.info('  - $format (${parser.displayName}): ${parser.supportedExtensions.join(', ')}');
      }

      // 验证必要的格式都被支持
      expect(supportedFormats.contains('json'), true);
      expect(supportedFormats.contains('csv'), true);
      expect(supportedFormats.contains('arb'), true);
      expect(supportedFormats.contains('po'), true);

      Logger.info('✅ 所有期望的文件格式都被支持！');
    });
  });
}
