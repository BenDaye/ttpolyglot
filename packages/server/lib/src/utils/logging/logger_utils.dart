import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

/// 日志级别
enum LogLevel {
  trace,
  debug,
  info,
  warn,
  error,
  fatal,
}

/// 静态日志记录器
class LoggerUtils {
  LoggerUtils._();

  static String _loggerName = 'TTPolyglotServer';
  static LogLevel _minLevel = LogLevel.info;
  static bool _enableConsole = true;
  static bool _enableJson = false;
  static String? _logFile;

  /// 配置日志
  static void configure({
    String? loggerName,
    LogLevel minLevel = LogLevel.info,
    bool enableConsole = true,
    bool enableJson = false,
    String? logFile,
  }) {
    if (loggerName != null) _loggerName = loggerName;
    _minLevel = minLevel;
    _enableConsole = enableConsole;
    _enableJson = enableJson;
    _logFile = logFile;
  }

  /// 记录日志
  static void _log(
    LogLevel level,
    String message, {
    LogContext? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) return;

    final logEntry = _createLogEntry(level, message, context, error, stackTrace);

    if (_enableConsole) {
      _logToConsole(logEntry);
    }

    if (_enableJson) {
      _logToJson(logEntry);
    }

    if (_logFile != null) {
      _logToFile(logEntry);
    }
  }

  /// 创建日志条目
  static Map<String, dynamic> _createLogEntry(
    LogLevel level,
    String message,
    LogContext? context,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    final entry = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'level': level.name.toUpperCase(),
      'logger': _loggerName,
      'message': message,
    };

    // 添加上下文字段
    if (context != null) {
      entry.addAll(context.fields);
    }

    // 添加错误信息
    if (error != null) {
      entry['error'] = error.toString();
    }

    if (stackTrace != null) {
      entry['stack_trace'] = stackTrace.toString();
    }

    return entry;
  }

  /// 获取日志级别的颜色代码
  static String _getLogLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'TRACE':
        return '\x1B[37m'; // 白色
      case 'DEBUG':
        return '\x1B[36m'; // 青色
      case 'INFO':
        return '\x1B[32m'; // 绿色
      case 'WARN':
        return '\x1B[33m'; // 黄色
      case 'ERROR':
        return '\x1B[31m'; // 红色
      case 'FATAL':
        return '\x1B[35m'; // 紫色
      default:
        return '\x1B[0m'; // 默认颜色
    }
  }

  /// 重置颜色代码
  static const String _resetColor = '\x1B[0m';

  /// 输出到控制台
  static void _logToConsole(Map<String, dynamic> entry) {
    final level = entry['level'] as String;
    final message = entry['message'] as String;
    final logger = entry['logger'] as String;
    final stackTrace = entry['stack_trace'] as String?;

    // 获取颜色代码
    final colorCode = _getLogLevelColor(level);

    // 构建带颜色的控制台输出
    final coloredLevel = '$colorCode[$level]$_resetColor';
    final consoleMessage = '$coloredLevel $logger: $message';

    // 添加关键字段
    final keyFields = <String, dynamic>{};
    for (final key in ['request_id', 'http_method', 'http_path', 'http_status', 'error']) {
      if (entry.containsKey(key)) {
        keyFields[key] = entry[key];
      }
    }

    // 使用 stdout/stderr 输出，这样在 AOT 编译后也能看到日志
    final timestamp = entry['timestamp'] as String;
    if (keyFields.isNotEmpty) {
      final fieldsStr = keyFields.entries.map((e) => '${e.key}=${e.value}').join(', ');
      final output = '$timestamp $consoleMessage ($fieldsStr)';
      if (level == 'ERROR' || level == 'FATAL') {
        stderr.writeln(output);
        if (stackTrace != null) stderr.writeln(stackTrace);
      } else {
        stdout.writeln(output);
      }
    } else {
      final output = '$timestamp $consoleMessage';
      if (level == 'ERROR' || level == 'FATAL') {
        stderr.writeln(output);
        if (stackTrace != null) stderr.writeln(stackTrace);
      } else {
        stdout.writeln(output);
      }
    }
  }

  /// 输出JSON格式
  static void _logToJson(Map<String, dynamic> entry) {
    final jsonStr = jsonEncode(entry);
    final level = entry['level'] as String;
    // 使用 stdout/stderr 输出，这样在 AOT 编译后也能看到日志
    if (level == 'ERROR' || level == 'FATAL') {
      stderr.writeln(jsonStr);
    } else {
      stdout.writeln(jsonStr);
    }
  }

  /// 输出到文件
  static void _logToFile(Map<String, dynamic> entry) {
    if (_logFile == null) return;

    try {
      final file = File(_logFile!);
      final jsonStr = jsonEncode(entry);
      file.writeAsStringSync('$jsonStr\n', mode: FileMode.append);
    } catch (e) {
      // 忽略文件写入错误
    }
  }

  /// 便捷方法
  static void trace(String message, {LogContext? context}) {
    _log(LogLevel.trace, message, context: context);
  }

  static void debug(String message, {LogContext? context}) {
    _log(LogLevel.debug, message, context: context);
  }

  static void info(String message, {LogContext? context}) {
    _log(LogLevel.info, message, context: context);
  }

  static void warn(
    String message, {
    LogContext? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.warn, message, context: context, error: error, stackTrace: stackTrace);
  }

  static void error(
    String message, {
    LogContext? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, context: context, error: error, stackTrace: stackTrace);
  }

  static void fatal(
    String message, {
    LogContext? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.fatal, message, context: context, error: error, stackTrace: stackTrace);
  }
}

/// 日志上下文，用于携带额外的结构化字段
class LogContext {
  final Map<String, dynamic> fields;

  LogContext([Map<String, dynamic>? fields]) : fields = fields ?? {};

  /// 添加字段
  void field(String key, dynamic value) {
    fields[key] = value;
  }

  /// 从 Request 创建上下文
  factory LogContext.fromRequest(Request request, {Map<String, dynamic>? extra}) {
    final fields = <String, dynamic>{
      'http_method': request.method,
      'http_path': request.url.path,
    };

    if (extra != null) {
      fields.addAll(extra);
    }

    return LogContext(fields);
  }

  /// 创建简单的上下文
  factory LogContext.simple(Map<String, dynamic> fields) {
    return LogContext(fields);
  }
}
