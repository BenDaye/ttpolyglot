import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

void main() {
  group('简单解析器测试', () {
    test('测试CSV格式解析', () async {
      // 创建测试用的CSV内容
      final csvContent = ['key,value', 'hello,你好', 'welcome,欢迎', 'goodbye,再见', 'thank_you,谢谢'].join('\n');

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
        // log('开始解析CSV内容...');
        final result = await parser.parseString(csvContent, language);

        // 调试输出
        Logger.info('CSV解析结果: ${result.entries.length} 个条目');
        if (result.warnings.isNotEmpty) {
          Logger.info('CSV解析警告: ${result.warnings.join(', ')}');
        }

        // 打印解析结果
        for (final entry in result.entries) {
          Logger.info('  ${entry.key}: ${entry.targetText}');
        }

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.entries.length, 4);
        expect(result.language.code, 'zh-CN');

        // 验证具体的翻译条目
        final welcomeEntry = result.entries.firstWhere((e) => e.key == 'welcome');
        expect(welcomeEntry.targetText, '欢迎');

        Logger.info('✅ CSV格式解析成功！');
      } catch (error, stackTrace) {
        Logger.error('❌ CSV解析失败', error: error, stackTrace: stackTrace);
        rethrow;
      }
    });

    test('测试PO格式解析', () async {
      // 创建测试用的PO内容
      final poContent = [
        '# Translation file for zh_CN',
        'msgid "hello"',
        'msgstr "你好"',
        '',
        'msgid "welcome"',
        'msgstr "欢迎"',
        '',
        'msgid "goodbye"',
        'msgstr "再见"',
        '',
        'msgid "thank_you"',
        'msgstr "谢谢"'
      ].join('\n');

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
        Logger.info('开始解析PO内容...');
        final result = await parser.parseString(poContent, language);

        // 调试输出
        Logger.info('PO解析结果: ${result.entries.length} 个条目');
        if (result.warnings.isNotEmpty) {
          Logger.info('PO解析警告: ${result.warnings.join(', ')}');
        }

        // 打印解析结果
        for (final entry in result.entries) {
          Logger.info('  ${entry.key}: ${entry.targetText}');
        }

        // 验证解析结果
        expect(result.entries.isNotEmpty, true);
        expect(result.entries.length, 4);
        expect(result.language.code, 'zh-CN');

        // 验证具体的翻译条目
        final thankYouEntry = result.entries.firstWhere((e) => e.key == 'thank_you');
        expect(thankYouEntry.targetText, '谢谢');

        Logger.info('✅ PO格式解析成功！');
      } catch (error, stackTrace) {
        Logger.error('❌ PO解析失败', error: error, stackTrace: stackTrace);
        rethrow;
      }
    });

    test('测试支持的格式', () {
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
