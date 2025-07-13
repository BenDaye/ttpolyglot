/// TTPolyglot 文件解析器包
///
/// 提供多种翻译文件格式的解析和生成功能
library;

// 常量
export 'src/constants/file_formats.dart';
// 异常类
export 'src/exceptions/parser_exception.dart';
export 'src/parser_factory.dart';
// 核心接口
export 'src/parser_interface.dart';
export 'src/parser_result.dart';
export 'src/parsers/arb_parser.dart';
export 'src/parsers/csv_parser.dart';
// 具体解析器实现
export 'src/parsers/json_parser.dart';
export 'src/parsers/po_parser.dart';
export 'src/parsers/properties_parser.dart';
export 'src/parsers/yaml_parser.dart';
export 'src/utils/encoding_utils.dart';
// 工具类
export 'src/utils/file_utils.dart';
