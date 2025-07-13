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
  const FileParseException(String message, {Object? cause}) : super(message, cause: cause);
}

/// 文件写入异常
class FileWriteException extends ParserException {
  const FileWriteException(String message, {Object? cause}) : super(message, cause: cause);
}

/// 文件读取异常
class FileReadException extends ParserException {
  const FileReadException(String message, {Object? cause}) : super(message, cause: cause);
}

/// 数据验证异常
class ValidationException extends ParserException {
  const ValidationException(String message, {this.errors = const []}) : super(message);

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
  const EncodingException(String message, {Object? cause}) : super(message, cause: cause);
}
