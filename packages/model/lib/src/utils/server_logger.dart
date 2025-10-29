import 'dart:developer' as developer;

/// 服务器端日志工具类
///
/// 使用 dart:developer 的 log 函数输出日志，适用于纯 Dart 环境
class ServerLogger {
  ServerLogger._();

  /// 记录调试信息
  static void debug(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    developer.log(
      message.toString(),
      name: name ?? 'DEBUG',
      error: error,
      stackTrace: stackTrace,
      level: 500,
    );
  }

  /// 记录普通信息
  static void info(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    developer.log(
      message.toString(),
      name: name ?? 'INFO',
      error: error,
      stackTrace: stackTrace,
      level: 800,
    );
  }

  /// 记录警告信息
  static void warning(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    developer.log(
      message.toString(),
      name: name ?? 'WARNING',
      error: error,
      stackTrace: stackTrace,
      level: 900,
    );
  }

  /// 记录错误信息
  static void error(
    dynamic message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message.toString(),
      name: name ?? 'ERROR',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  /// 记录严重错误信息
  static void critical(
    dynamic message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message.toString(),
      name: name ?? 'CRITICAL',
      error: error,
      stackTrace: stackTrace,
      level: 1200,
    );
  }

  /// 记录详细日志（verbose）
  static void verbose(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    developer.log(
      message.toString(),
      name: name ?? 'VERBOSE',
      error: error,
      stackTrace: stackTrace,
      level: 300,
    );
  }

  /// 自定义日志
  static void log(
    dynamic message, {
    int logLevel = 800,
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message.toString(),
      name: name ?? 'LOG',
      error: error,
      stackTrace: stackTrace,
      level: logLevel,
    );
  }
}
