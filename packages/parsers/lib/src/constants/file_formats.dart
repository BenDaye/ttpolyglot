/// 支持的文件格式常量
class FileFormats {
  FileFormats._();

  /// JSON 格式
  static const String json = 'json';

  /// YAML 格式
  static const String yaml = 'yaml';

  /// CSV 格式
  static const String csv = 'csv';

  /// ARB 格式 (Application Resource Bundle)
  static const String arb = 'arb';

  /// Properties 格式
  static const String properties = 'properties';

  /// PO 格式 (Portable Object)
  static const String po = 'po';

  /// 所有支持的格式
  static const List<String> allFormats = [
    json,
    yaml,
    csv,
    arb,
    properties,
    po,
  ];

  /// 获取格式的显示名称
  static String getDisplayName(String format) {
    switch (format) {
      case json:
        return 'JSON';
      case yaml:
        return 'YAML';
      case csv:
        return 'CSV';
      case arb:
        return 'ARB';
      case properties:
        return 'Properties';
      case po:
        return 'PO';
      default:
        return format.toUpperCase();
    }
  }

  /// 获取格式的文件扩展名
  static String getFileExtension(String format) {
    switch (format) {
      case json:
        return '.json';
      case yaml:
        return '.yaml';
      case csv:
        return '.csv';
      case arb:
        return '.arb';
      case properties:
        return '.properties';
      case po:
        return '.po';
      default:
        return '.$format';
    }
  }

  /// 从文件路径推断格式
  static String? inferFromPath(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;

    switch (extension) {
      case 'json':
        return json;
      case 'yaml':
      case 'yml':
        return yaml;
      case 'csv':
        return csv;
      case 'arb':
        return arb;
      case 'properties':
        return properties;
      case 'po':
        return po;
      default:
        return null;
    }
  }

  /// 检查格式是否受支持
  static bool isSupported(String format) {
    return allFormats.contains(format.toLowerCase());
  }
}
