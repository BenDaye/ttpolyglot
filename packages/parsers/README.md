# TTPolyglot Parsers

TTPolyglot 文件解析器包，提供多种翻译文件格式的解析和生成功能，支持主流的国际化文件格式。

## 📦 功能特性

### 支持的文件格式

| 格式 | 读取 | 写入 | 说明 |
|------|------|------|------|
| **JSON** | ✅ | ✅ | 标准 JSON 格式，支持嵌套结构 |
| **JSON5** | ✅ | ✅ | 支持注释和尾随逗号的 JSON |
| **PO/POT** | ✅ | ✅ | Gettext 格式，广泛用于开源项目 |
| **YAML/YML** | ✅ | ✅ | 人类友好的配置格式 |
| **CSV** | ✅ | ✅ | 表格格式，便于批量编辑 |
| **Dart ARB** | ✅ | ✅ | Flutter 国际化标准格式 |
| **Excel** | 🔜 | 🔜 | 计划支持 |
| **XML** | 🔜 | 🔜 | Android strings.xml 格式 |
| **XLIFF** | 🔜 | 🔜 | 翻译交换格式 |

### 核心特性

- 🔄 **双向转换**: 支持读取和写入，便于导入导出
- 🌳 **嵌套结构**: 支持多层嵌套的翻译键
- 💬 **注释保留**: 部分格式支持保留注释信息
- 🔍 **错误处理**: 详细的解析错误信息和位置定位
- 📊 **统计信息**: 提供翻译条目数量、完成度等统计
- 🎯 **类型安全**: 强类型接口，编译时检查
- ⚡ **性能优化**: 支持大文件的高效解析

## 📥 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  ttpolyglot_parsers:
    path: ../parsers  # 如果是 monorepo
  # 或者
  ttpolyglot_parsers: ^1.0.0  # 如果发布到 pub.dev
```

## 🚀 使用示例

### JSON 格式解析

```dart
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  final jsonParser = JsonParser();

  // 读取 JSON 文件
  final parseResult = await jsonParser.parse('path/to/translations.json');
  
  if (parseResult.success) {
    print('解析成功！');
    print('翻译条目数: ${parseResult.entries.length}');
    
    for (final entry in parseResult.entries) {
      print('${entry.key}: ${entry.value}');
    }
  } else {
    print('解析失败: ${parseResult.error}');
  }

  // 写入 JSON 文件
  final entries = {
    'common.greeting': 'Hello, World!',
    'common.farewell': 'Goodbye!',
    'app.title': 'My Application',
  };

  await jsonParser.write('path/to/output.json', entries);
}
```

### 嵌套 JSON 结构

```dart
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  // 支持嵌套结构的 JSON
  final nestedJson = '''
  {
    "common": {
      "greeting": "Hello",
      "farewell": "Goodbye"
    },
    "errors": {
      "network": {
        "timeout": "Connection timeout",
        "offline": "No internet connection"
      }
    }
  }
  ''';

  final parser = JsonParser();
  final result = await parser.parseFromString(nestedJson);

  // 自动展平为 dot notation
  // common.greeting
  // common.farewell
  // errors.network.timeout
  // errors.network.offline
  
  for (final entry in result.entries) {
    print('${entry.key}: ${entry.value}');
  }
}
```

### PO 格式解析（Gettext）

```dart
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  final poParser = PoParser();

  // 读取 PO 文件
  final parseResult = await poParser.parse('path/to/messages.po');
  
  if (parseResult.success) {
    print('解析成功！');
    
    for (final entry in parseResult.entries) {
      print('msgid: ${entry.key}');
      print('msgstr: ${entry.value}');
      if (entry.context != null) {
        print('msgctxt: ${entry.context}');
      }
      if (entry.comment != null) {
        print('# ${entry.comment}');
      }
      print('---');
    }
  }

  // 写入 PO 文件
  final entries = [
    PoEntry(
      msgid: 'Hello, World!',
      msgstr: '你好，世界！',
      msgctxt: 'greeting',
      translatorComment: '这是一个问候语',
    ),
    PoEntry(
      msgid: 'Goodbye',
      msgstr: '再见',
    ),
  ];

  await poParser.write('path/to/output.po', entries);
}
```

### YAML 格式解析

```dart
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  final yamlParser = YamlParser();

  // YAML 示例内容
  final yamlContent = '''
  common:
    greeting: Hello
    farewell: Goodbye
  
  app:
    title: My Application
    version: 1.0.0
  
  # 注释会被保留
  errors:
    network: Connection failed
  ''';

  final result = await yamlParser.parseFromString(yamlContent);
  
  if (result.success) {
    for (final entry in result.entries) {
      print('${entry.key}: ${entry.value}');
    }
  }

  // 写入 YAML
  final entries = {
    'common.greeting': 'Hello',
    'app.title': 'My App',
  };

  await yamlParser.write('output.yml', entries);
}
```

### CSV 格式解析

```dart
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  final csvParser = CsvParser();

  // CSV 格式: key,en-US,zh-CN,ja-JP
  final csvContent = '''
  key,en-US,zh-CN,ja-JP
  common.greeting,Hello,你好,こんにちは
  common.farewell,Goodbye,再见,さようなら
  app.title,My App,我的应用,私のアプリ
  ''';

  final result = await csvParser.parseFromString(csvContent);
  
  // 返回多语言的翻译条目
  for (final entry in result.entries) {
    print('Key: ${entry.key}');
    for (final lang in entry.translations.entries) {
      print('  ${lang.key}: ${lang.value}');
    }
  }

  // 写入 CSV
  final multiLangEntries = {
    'common.greeting': {
      'en-US': 'Hello',
      'zh-CN': '你好',
      'ja-JP': 'こんにちは',
    },
  };

  await csvParser.write('output.csv', multiLangEntries);
}
```

### Dart ARB 格式（Flutter）

```dart
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  final arbParser = ArbParser();

  // ARB 格式示例
  final arbContent = '''
  {
    "@@locale": "en-US",
    "appTitle": "My Application",
    "@appTitle": {
      "description": "The title of the application"
    },
    "greeting": "Hello, {name}!",
    "@greeting": {
      "description": "A greeting message",
      "placeholders": {
        "name": {
          "type": "String"
        }
      }
    }
  }
  ''';

  final result = await arbParser.parseFromString(arbContent);
  
  if (result.success) {
    print('Locale: ${result.locale}');
    for (final entry in result.entries) {
      print('${entry.key}: ${entry.value}');
      if (entry.metadata != null) {
        print('  Description: ${entry.metadata!.description}');
        if (entry.metadata!.placeholders != null) {
          print('  Placeholders: ${entry.metadata!.placeholders}');
        }
      }
    }
  }

  // 写入 ARB
  await arbParser.write('app_en.arb', entries, locale: 'en-US');
}
```

### 自动格式检测

```dart
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  final parserFactory = ParserFactory();

  // 根据文件扩展名自动选择解析器
  final parser = parserFactory.getParserForFile('translations.json');
  final result = await parser.parse('translations.json');

  // 或者根据文件格式枚举
  final poParser = parserFactory.getParser(FileFormat.po);
  
  // 或者根据内容自动检测格式
  final detectedParser = parserFactory.detectFormat(fileContent);
}
```

### 批量转换格式

```dart
import 'package:ttpolyglot_parsers/parsers.dart';

void main() async {
  final converter = FormatConverter();

  // JSON 转 PO
  await converter.convert(
    sourcePath: 'translations.json',
    sourceFormat: FileFormat.json,
    targetPath: 'translations.po',
    targetFormat: FileFormat.po,
  );

  // YAML 转 ARB
  await converter.convert(
    sourcePath: 'translations.yml',
    sourceFormat: FileFormat.yaml,
    targetPath: 'app_en.arb',
    targetFormat: FileFormat.arb,
    options: ConvertOptions(
      locale: 'en-US',
      preserveComments: true,
    ),
  );

  // 批量转换
  await converter.convertBatch(
    sourceFiles: ['en.json', 'zh.json', 'ja.json'],
    sourceFormat: FileFormat.json,
    targetFormat: FileFormat.arb,
    outputDir: 'lib/l10n/',
  );
}
```

## 📚 API 文档

### 解析器接口

所有解析器都实现了 `TranslationFileParser` 接口：

```dart
abstract class TranslationFileParser {
  /// 从文件解析翻译条目
  Future<ParseResult> parse(String filePath);
  
  /// 从字符串解析翻译条目
  Future<ParseResult> parseFromString(String content);
  
  /// 写入翻译条目到文件
  Future<void> write(String filePath, Map<String, dynamic> entries);
  
  /// 写入翻译条目为字符串
  Future<String> writeToString(Map<String, dynamic> entries);
  
  /// 获取支持的文件格式
  FileFormat get format;
}
```

### 解析结果

```dart
class ParseResult {
  final bool success;                    // 是否成功
  final List<TranslationEntry> entries;  // 翻译条目列表
  final String? error;                   // 错误信息
  final int? errorLine;                  // 错误行号
  final int? errorColumn;                // 错误列号
  final Map<String, dynamic>? metadata;  // 元数据
  
  int get entryCount => entries.length;
  bool get hasError => !success;
}
```

### 翻译条目

```dart
class TranslationEntry {
  final String key;           // 翻译键
  final String value;         // 翻译值
  final String? context;      // 上下文
  final String? comment;      // 注释
  final Map<String, dynamic>? metadata;  // 元数据
}
```

## 🏗️ 项目结构

```
lib/
├── parsers.dart                # 主导出文件
└── src/
    ├── base/
    │   ├── parser_interface.dart       # 解析器接口
    │   └── parse_result.dart           # 解析结果
    ├── parsers/
    │   ├── json_parser.dart            # JSON 解析器
    │   ├── json5_parser.dart           # JSON5 解析器
    │   ├── po_parser.dart              # PO 解析器
    │   ├── yaml_parser.dart            # YAML 解析器
    │   ├── csv_parser.dart             # CSV 解析器
    │   └── arb_parser.dart             # ARB 解析器
    ├── models/
    │   ├── translation_entry.dart      # 翻译条目模型
    │   └── file_format.dart            # 文件格式枚举
    └── utils/
        ├── parser_factory.dart         # 解析器工厂
        ├── format_converter.dart       # 格式转换器
        └── format_detector.dart        # 格式检测器
```

## 🔧 开发指南

### 添加新的解析器

1. 创建解析器类：

```dart
// lib/src/parsers/my_format_parser.dart
import 'package:ttpolyglot_parsers/src/base/parser_interface.dart';

class MyFormatParser implements TranslationFileParser {
  @override
  FileFormat get format => FileFormat.myFormat;

  @override
  Future<ParseResult> parse(String filePath) async {
    final content = await File(filePath).readAsString();
    return parseFromString(content);
  }

  @override
  Future<ParseResult> parseFromString(String content) async {
    try {
      // 实现解析逻辑
      final entries = <TranslationEntry>[];
      // ...
      return ParseResult.success(entries: entries);
    } catch (e) {
      return ParseResult.error(error: e.toString());
    }
  }

  @override
  Future<void> write(String filePath, Map<String, dynamic> entries) async {
    final content = await writeToString(entries);
    await File(filePath).writeAsString(content);
  }

  @override
  Future<String> writeToString(Map<String, dynamic> entries) async {
    // 实现写入逻辑
    return '';
  }
}
```

2. 在 `parsers.dart` 中导出：

```dart
export 'src/parsers/my_format_parser.dart';
```

3. 添加到解析器工厂：

```dart
// lib/src/utils/parser_factory.dart
case FileFormat.myFormat:
  return MyFormatParser();
```

### 运行测试

```bash
# 运行所有测试
dart test

# 运行特定解析器的测试
dart test test/parsers/json_parser_test.dart

# 生成测试覆盖率
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

## 📦 依赖

```yaml
dependencies:
  # JSON 解析
  json5: ^2.0.0
  
  # YAML 解析
  yaml: ^3.1.2
  
  # CSV 解析
  csv: ^6.0.0
  
  # PO 文件解析
  gettext_parser: ^0.2.0
  
  # 文件操作
  path: ^1.8.3
  
  # 核心依赖
  ttpolyglot_core: ^1.0.0
  ttpolyglot_model: ^1.0.0
```

## 🎯 使用场景

### 场景 1: 导入现有翻译文件

```dart
// 从现有的 i18n 文件导入翻译
final parser = JsonParser();
final result = await parser.parse('assets/i18n/en.json');

if (result.success) {
  // 将翻译条目导入到 TTPolyglot
  await translationService.importEntries(result.entries);
}
```

### 场景 2: 导出为多种格式

```dart
// 从 TTPolyglot 导出翻译到不同格式
final entries = await translationService.getEntries(projectId: 'project-1');

// 导出为 JSON
await JsonParser().write('output/en.json', entries);

// 导出为 PO
await PoParser().write('output/messages.po', entries);

// 导出为 YAML
await YamlParser().write('output/en.yml', entries);
```

### 场景 3: 格式转换

```dart
// 将项目从 JSON 迁移到 ARB (Flutter)
final converter = FormatConverter();
await converter.convert(
  sourcePath: 'assets/i18n/en.json',
  sourceFormat: FileFormat.json,
  targetPath: 'lib/l10n/app_en.arb',
  targetFormat: FileFormat.arb,
  options: ConvertOptions(locale: 'en-US'),
);
```

## 🔗 相关链接

- [项目主文档](../../README.md)
- [Gettext PO 格式规范](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html)
- [Flutter ARB 格式](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [JSON5 规范](https://json5.org/)

## 📄 许可证

Apache License 2.0 - 详见 [LICENSE](../../LICENSE)

## 🤝 贡献

欢迎贡献！请查看主项目的 [贡献指南](../../README.md#-贡献指南)。

## ✨ 未来计划

- [ ] 支持 Excel (XLSX) 格式
- [ ] 支持 Android XML strings.xml 格式  
- [ ] 支持 iOS Localizable.strings 格式
- [ ] 支持 XLIFF 翻译交换格式
- [ ] 支持 Properties 文件格式
- [ ] 增强错误恢复能力
- [ ] 支持流式解析大文件
- [ ] 提供 CLI 工具进行格式转换
