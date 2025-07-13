import 'constants/file_formats.dart';
import 'exceptions/parser_exception.dart';
import 'parser_interface.dart';
import 'parsers/arb_parser.dart';
import 'parsers/csv_parser.dart';
import 'parsers/json_parser.dart';
import 'parsers/po_parser.dart';
import 'parsers/properties_parser.dart';
import 'parsers/yaml_parser.dart';

/// 解析器工厂类
class ParserFactory {
  ParserFactory._();

  static final Map<String, TranslationParser> _parsers = {
    FileFormats.json: JsonParser(),
    FileFormats.yaml: YamlParser(),
    FileFormats.csv: CsvParser(),
    FileFormats.arb: ArbParser(),
    FileFormats.properties: PropertiesParser(),
    FileFormats.po: PoParser(),
  };

  /// 根据格式获取解析器
  static TranslationParser getParser(String format) {
    final parser = _parsers[format.toLowerCase()];
    if (parser == null) {
      throw UnsupportedFormatException(format);
    }
    return parser;
  }

  /// 根据文件路径获取解析器
  static TranslationParser? getParserForFile(String filePath) {
    final format = FileFormats.inferFromPath(filePath);
    if (format == null) {
      return null;
    }
    return getParser(format);
  }

  /// 获取所有支持的格式
  static List<String> getSupportedFormats() {
    return _parsers.keys.toList();
  }

  /// 获取所有解析器
  static List<TranslationParser> getAllParsers() {
    return _parsers.values.toList();
  }

  /// 注册自定义解析器
  static void registerParser(String format, TranslationParser parser) {
    _parsers[format.toLowerCase()] = parser;
  }

  /// 检查格式是否受支持
  static bool isFormatSupported(String format) {
    return _parsers.containsKey(format.toLowerCase());
  }

  /// 获取格式的解析器信息
  static Map<String, dynamic> getParserInfo(String format) {
    final parser = _parsers[format.toLowerCase()];
    if (parser == null) {
      throw UnsupportedFormatException(format);
    }

    return {
      'format': parser.format,
      'displayName': parser.displayName,
      'supportedExtensions': parser.supportedExtensions,
      'options': parser.getOptionsDescription(),
    };
  }
}
