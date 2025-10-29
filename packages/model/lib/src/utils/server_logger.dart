import 'package:talker/talker.dart';

/// 服务器端日志工具类
///
/// 使用talker 的 log 函数输出日志，适用于纯 Dart 环境
class ServerLogger {
  // 提供一个全局访问点
  static ServerLogger? _instance;
  factory ServerLogger() => _instance ??= ServerLogger._();

  late final Talker _talker;
  static Talker get talker => ServerLogger()._talker;

  // 私有构造函数，初始化 Talker
  ServerLogger._() {
    _talker = Talker(
      settings: TalkerSettings(
        colors: {
          // 可以在这里自定义日志颜色
          // TalkerLogType.verbose.key: AnsiPen()..yellow(),
        },
        enabled: true,
        timeFormat: TimeFormat.yearMonthDayAndTime,
      ),
    );
  }

  /// 记录调试信息
  static void debug(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    talker.debug(
      '${name != null && name.isNotEmpty ? '$name: ' : ''}$message',
      error,
      stackTrace,
    );
  }

  /// 记录普通信息
  static void info(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    talker.info(
      '${name != null && name.isNotEmpty ? '$name: ' : ''}$message',
      error,
      stackTrace,
    );
  }

  /// 记录警告信息
  static void warning(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    talker.warning(
      '${name != null && name.isNotEmpty ? '$name: ' : ''}$message',
      error,
      stackTrace,
    );
  }

  /// 记录错误信息
  static void error(
    dynamic message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    talker.error(
      '${name != null && name.isNotEmpty ? '$name: ' : ''}$message',
      error,
      stackTrace,
    );
  }

  /// 记录严重错误信息
  static void critical(
    dynamic message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    talker.critical(
      '${name != null && name.isNotEmpty ? '$name: ' : ''}$message',
      error,
      stackTrace,
    );
  }

  /// 记录详细日志（verbose）
  static void verbose(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    talker.verbose(
      '${name != null && name.isNotEmpty ? '$name: ' : ''}$message',
      error,
      stackTrace,
    );
  }

  /// 自定义日志
  static void log(
    dynamic message, {
    LogLevel logLevel = LogLevel.info,
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    talker.log(
      '${name != null && name.isNotEmpty ? '$name: ' : ''}$message',
      logLevel: logLevel,
      exception: error,
      stackTrace: stackTrace,
    );
  }
}
