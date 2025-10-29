import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// TTPolyglot 统一日志管理类
///
/// 基于 Talker 实现的日志系统，提供：
/// - 统一的日志记录接口
/// - Dio 网络请求日志
/// - 路由导航日志
/// - 可视化日志查看器
class LoggerUtils {
  // 提供一个全局访问点
  static LoggerUtils? _instance;
  factory LoggerUtils() => _instance ??= LoggerUtils._();

  late final Talker _talker;
  static Talker get talker => LoggerUtils()._talker;

  // 私有构造函数，初始化 Talker
  LoggerUtils._() {
    _talker = TalkerFlutter.init(
      settings: TalkerSettings(
        colors: {
          // 可以在这里自定义日志颜色
          // TalkerLogType.verbose.key: AnsiPen()..yellow(),
        },
        enabled: true,
      ),
    );
  }

  // ========== 常用日志方法 ==========

  /// 记录调试信息
  static void debug(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    talker.debug('${name != null && name.isNotEmpty ? '$name: ' : ''}$message', error, stackTrace);
  }

  /// 记录普通信息
  static void info(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    talker.info('${name != null && name.isNotEmpty ? '$name: ' : ''}$message', error, stackTrace);
  }

  /// 记录警告信息
  static void warning(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    talker.warning('${name != null && name.isNotEmpty ? '$name: ' : ''}$message', error, stackTrace);
  }

  /// 记录错误信息
  static void error(
    dynamic message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    talker.error('${name != null && name.isNotEmpty ? '$name: ' : ''}$message', error, stackTrace);
  }

  /// 记录严重错误信息
  static void critical(
    dynamic message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    talker.critical('${name != null && name.isNotEmpty ? '$name: ' : ''}$message', error, stackTrace);
  }

  /// 记录详细日志（verbose）
  static void verbose(dynamic message, {String? name, Object? error, StackTrace? stackTrace}) {
    talker.verbose('${name != null && name.isNotEmpty ? '$name: ' : ''}$message', error, stackTrace);
  }

  /// 自定义日志
  static void log(
    dynamic message, {
    LogLevel logLevel = LogLevel.info,
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    talker.log('${name != null && name.isNotEmpty ? '$name: ' : ''}$message',
        logLevel: logLevel, exception: error, stackTrace: stackTrace);
  }

  // ========== UI 相关 ==========

  /// 日志查看器页面
  static TalkerScreen get talkerScreen => TalkerScreen(
        talker: talker,
      );

  // ========== 路由监听 ==========

  /// 路由监听器，用于 MaterialApp 的 navigatorObservers
  static TalkerRouteObserver talkerRouteObserver() => TalkerRouteObserver(
        talker,
      );

  // ========== Dio 拦截器配置 ==========

  /// Dio 日志拦截器
  static TalkerDioLogger get talkerDioLogger => TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printRequestData: true,
          printResponseHeaders: false,
          printResponseData: false,
        ),
      );

  // ========== 工具方法 ==========

  /// 清空所有日志
  static void clean() {
    talker.cleanHistory();
  }

  /// 禁用日志
  static void disable() {
    talker.disable();
  }

  /// 启用日志
  static void enable() {
    talker.enable();
  }

  /// 获取日志历史
  static List<TalkerData> get history => talker.history;
}
