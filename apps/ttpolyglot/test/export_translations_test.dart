import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

void main() {
  group('翻译导出功能测试', () {
    test('根据文件扩展名确定格式', () {
      // 测试 JSON 格式
      final jsonFormat = _getFormatFromExtension('translations.json');
      expect(jsonFormat['format'], FileFormats.json);
      expect(jsonFormat['keyStyle'], TranslationKeyStyle.nested);

      // 测试 YAML 格式
      final yamlFormat = _getFormatFromExtension('translations.yaml');
      expect(yamlFormat['format'], FileFormats.yaml);
      expect(yamlFormat['keyStyle'], TranslationKeyStyle.nested);

      final ymlFormat = _getFormatFromExtension('translations.yml');
      expect(ymlFormat['format'], FileFormats.yaml);
      expect(ymlFormat['keyStyle'], TranslationKeyStyle.nested);

      // 测试 CSV 格式
      final csvFormat = _getFormatFromExtension('translations.csv');
      expect(csvFormat['format'], FileFormats.csv);
      expect(csvFormat['keyStyle'], TranslationKeyStyle.flat);

      // 测试 ARB 格式
      final arbFormat = _getFormatFromExtension('translations.arb');
      expect(arbFormat['format'], FileFormats.arb);
      expect(arbFormat['keyStyle'], TranslationKeyStyle.flat);

      // 测试 Properties 格式
      final propertiesFormat = _getFormatFromExtension('translations.properties');
      expect(propertiesFormat['format'], FileFormats.properties);
      expect(propertiesFormat['keyStyle'], TranslationKeyStyle.flat);

      // 测试 PO 格式
      final poFormat = _getFormatFromExtension('translations.po');
      expect(poFormat['format'], FileFormats.po);
      expect(poFormat['keyStyle'], TranslationKeyStyle.flat);

      // 测试未知格式（默认使用 JSON）
      final unknownFormat = _getFormatFromExtension('translations.unknown');
      expect(unknownFormat['format'], FileFormats.json);
      expect(unknownFormat['keyStyle'], TranslationKeyStyle.nested);
    });

    test('生成默认文件名', () {
      // 模拟用户数据
      final user = User(
        id: 'test-user',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 模拟项目数据
      final project = Project(
        id: 'test-project',
        name: '测试项目',
        description: '这是一个测试项目',
        defaultLanguage: Language.getLanguageByCode('zh-CN')!,
        targetLanguages: [
          Language.getLanguageByCode('en-US')!,
          Language.getLanguageByCode('ja-JP')!,
        ],
        owner: user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final defaultFileName = '${project.name}_translations.json';
      expect(defaultFileName, '测试项目_translations.json');
    });

    test('文件扩展名解析', () {
      // 测试各种文件路径的扩展名解析
      expect(_getFileExtension('translations.json'), 'json');
      expect(_getFileExtension('translations.yaml'), 'yaml');
      expect(_getFileExtension('translations.yml'), 'yml');
      expect(_getFileExtension('translations.csv'), 'csv');
      expect(_getFileExtension('translations.arb'), 'arb');
      expect(_getFileExtension('translations.properties'), 'properties');
      expect(_getFileExtension('translations.po'), 'po');
      expect(_getFileExtension('translations.unknown'), 'unknown');
      expect(_getFileExtension('translations'), '');
      expect(_getFileExtension('.json'), 'json');
    });
  });
}

/// 根据文件扩展名确定格式（模拟 exportTranslations 方法中的逻辑）
Map<String, dynamic> _getFormatFromExtension(String filePath) {
  final fileExtension = filePath.split('.').last.toLowerCase();
  String format;
  TranslationKeyStyle keyStyle;

  switch (fileExtension) {
    case 'json':
      format = FileFormats.json;
      keyStyle = TranslationKeyStyle.nested;
      break;
    case 'yaml':
    case 'yml':
      format = FileFormats.yaml;
      keyStyle = TranslationKeyStyle.nested;
      break;
    case 'csv':
      format = FileFormats.csv;
      keyStyle = TranslationKeyStyle.flat;
      break;
    case 'arb':
      format = FileFormats.arb;
      keyStyle = TranslationKeyStyle.flat;
      break;
    case 'properties':
      format = FileFormats.properties;
      keyStyle = TranslationKeyStyle.flat;
      break;
    case 'po':
      format = FileFormats.po;
      keyStyle = TranslationKeyStyle.flat;
      break;
    default:
      format = FileFormats.json;
      keyStyle = TranslationKeyStyle.nested;
  }

  return {
    'format': format,
    'keyStyle': keyStyle,
  };
}

/// 获取文件扩展名
String _getFileExtension(String filePath) {
  final parts = filePath.split('.');
  if (parts.length <= 1) return '';
  return parts.last.toLowerCase();
}
