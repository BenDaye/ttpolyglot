/// 解析器异常基类
class ParserException implements Exception {
  const ParserException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'ParserException: $message';
}

/// 文件格式不支持异常
class UnsupportedFormatException extends ParserException {
  const UnsupportedFormatException(String format) : super('Unsupported file format: $format');
}

/// 文件解析异常
class FileParseException extends ParserException {
  const FileParseException(super.message, {super.cause});
}

/// 文件写入异常
class FileWriteException extends ParserException {
  const FileWriteException(super.message, {super.cause});
}

/// 文件读取异常
class FileReadException extends ParserException {
  const FileReadException(super.message, {super.cause});
}

/// 数据验证异常
class ValidationException extends ParserException {
  const ValidationException(super.message, {this.errors = const []});

  final List<String> errors;

  @override
  String toString() {
    if (errors.isEmpty) {
      return super.toString();
    }
    return 'ValidationException: $message\nErrors:\n${errors.map((e) => '  - $e').join('\n')}';
  }
}

/// 编码异常
class EncodingException extends ParserException {
  const EncodingException(super.message, {super.cause});
}
