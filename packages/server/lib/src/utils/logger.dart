import 'dart:developer' as dev;

/// 自定义日志工具类
class Logger {
  static const String name = 'TTPolyglotServer';

  /// 记录信息日志
  static void info(String message, {String? name}) {
    dev.log(message, name: name ?? Logger.name, level: 800);
  }

  /// 记录警告日志
  static void warning(String message, {String? name}) {
    dev.log(message, name: name ?? Logger.name, level: 900);
  }

  /// 记录错误日志
  static void error(String message, {Object? error, StackTrace? stackTrace, String? name}) {
    dev.log(message, name: name ?? Logger.name, level: 1000, error: error, stackTrace: stackTrace);
  }

  /// 记录调试日志
  static void debug(String message, {String? name}) {
    dev.log(message, name: name ?? Logger.name, level: 500);
  }

  /// 记录详细日志
  static void verbose(String message, {String? name}) {
    dev.log(message, name: name ?? Logger.name, level: 400);
  }

  /// 记录严重错误日志
  static void severe(String message, {Object? error, StackTrace? stackTrace, String? name}) {
    dev.log(message, name: name ?? Logger.name, level: 1200, error: error, stackTrace: stackTrace);
  }
}

/// 便捷的全局日志函数
void log(String message, {Object? error, StackTrace? stackTrace, String? name}) {
  if (error != null || stackTrace != null) {
    Logger.error(message, error: error, stackTrace: stackTrace, name: name);
  } else {
    Logger.info(message, name: name);
  }
}

/// 记录错误信息的便捷函数
void logError(String message, {Object? error, StackTrace? stackTrace, String? name}) {
  Logger.error(message, error: error, stackTrace: stackTrace, name: name);
}

/// 记录警告信息的便捷函数
void logWarning(String message, {String? name}) {
  Logger.warning(message, name: name);
}

/// 记录调试信息的便捷函数
void logDebug(String message, {String? name}) {
  Logger.debug(message, name: name);
}
