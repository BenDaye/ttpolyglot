import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// 日志级别
enum LogLevel {
  trace,
  debug,
  info,
  warn,
  error,
  fatal,
}

/// 日志上下文
class LogContext {
  final Map<String, dynamic> _fields = {};

  LogContext();

  /// 添加字段
  LogContext field(String key, dynamic value) {
    _fields[key] = value;
    return this;
  }

  /// 添加用户信息
  LogContext user(String userId, {String? username, String? email}) {
    _fields['user_id'] = userId;
    if (username != null) _fields['username'] = username;
    if (email != null) _fields['email'] = email;
    return this;
  }

  /// 添加请求信息
  LogContext request(String method, String path, {String? requestId, Map<String, String>? headers}) {
    _fields['http_method'] = method;
    _fields['http_path'] = path;
    if (requestId != null) _fields['request_id'] = requestId;
    if (headers != null) _fields['headers'] = headers;
    return this;
  }

  /// 添加响应信息
  LogContext response(int statusCode, {int? responseTime, int? responseSize}) {
    _fields['http_status'] = statusCode;
    if (responseTime != null) _fields['response_time_ms'] = responseTime;
    if (responseSize != null) _fields['response_size_bytes'] = responseSize;
    return this;
  }

  /// 添加数据库信息
  LogContext database(String operation, {String? table, int? rowsAffected, int? queryTime}) {
    _fields['db_operation'] = operation;
    if (table != null) _fields['db_table'] = table;
    if (rowsAffected != null) _fields['db_rows_affected'] = rowsAffected;
    if (queryTime != null) _fields['db_query_time_ms'] = queryTime;
    return this;
  }

  /// 添加缓存信息
  LogContext cache(String operation, {String? key, bool? hit, int? ttl}) {
    _fields['cache_operation'] = operation;
    if (key != null) _fields['cache_key'] = key;
    if (hit != null) _fields['cache_hit'] = hit;
    if (ttl != null) _fields['cache_ttl'] = ttl;
    return this;
  }

  /// 添加错误信息
  LogContext error(dynamic error, {StackTrace? stackTrace, String? errorCode}) {
    _fields['error'] = error.toString();
    if (stackTrace != null) _fields['stack_trace'] = stackTrace.toString();
    if (errorCode != null) _fields['error_code'] = errorCode;
    return this;
  }

  /// 添加性能信息
  LogContext performance(String metric, double value, {String? unit}) {
    _fields['perf_$metric'] = value;
    if (unit != null) _fields['perf_${metric}_unit'] = unit;
    return this;
  }

  /// 添加业务信息
  LogContext business(String operation, {String? entity, String? entityId}) {
    _fields['business_operation'] = operation;
    if (entity != null) _fields['business_entity'] = entity;
    if (entityId != null) _fields['business_entity_id'] = entityId;
    return this;
  }

  /// 获取所有字段
  Map<String, dynamic> get fields => Map.unmodifiable(_fields);

  /// 复制上下文
  LogContext copy() {
    final newContext = LogContext();
    newContext._fields.addAll(_fields);
    return newContext;
  }
}

/// 结构化日志记录器
class StructuredLogger {
  final String name;
  final LogLevel minLevel;
  final bool enableConsole;
  final bool enableJson;
  final String? logFile;

  StructuredLogger({
    required this.name,
    this.minLevel = LogLevel.info,
    this.enableConsole = true,
    this.enableJson = true,
    this.logFile,
  });

  /// 创建子记录器
  StructuredLogger child(String childName) {
    return StructuredLogger(
      name: '$name.$childName',
      minLevel: minLevel,
      enableConsole: enableConsole,
      enableJson: enableJson,
      logFile: logFile,
    );
  }

  /// 记录日志
  void log(LogLevel level, String message, {LogContext? context, dynamic error, StackTrace? stackTrace}) {
    if (level.index < minLevel.index) return;

    final logEntry = _createLogEntry(level, message, context, error, stackTrace);

    if (enableConsole) {
      _logToConsole(logEntry);
    }

    if (enableJson) {
      _logToJson(logEntry);
    }

    if (logFile != null) {
      _logToFile(logEntry);
    }
  }

  /// 创建日志条目
  Map<String, dynamic> _createLogEntry(
    LogLevel level,
    String message,
    LogContext? context,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    final entry = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'level': level.name.toUpperCase(),
      'logger': name,
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

  /// 输出到控制台
  void _logToConsole(Map<String, dynamic> entry) {
    final level = entry['level'] as String;
    final message = entry['message'] as String;
    final logger = entry['logger'] as String;

    // 构建控制台输出
    final consoleMessage = '[$level] $logger: $message';

    // 添加关键字段
    final keyFields = <String, dynamic>{};
    for (final key in ['request_id', 'user_id', 'http_method', 'http_path', 'http_status', 'error']) {
      if (entry.containsKey(key)) {
        keyFields[key] = entry[key];
      }
    }

    if (keyFields.isNotEmpty) {
      final fieldsStr = keyFields.entries.map((e) => '${e.key}=${e.value}').join(', ');
      log('$consoleMessage ($fieldsStr)', name: logger);
    } else {
      log(consoleMessage, name: logger);
    }
  }

  /// 输出JSON格式
  void _logToJson(Map<String, dynamic> entry) {
    final jsonStr = jsonEncode(entry);
    log(jsonStr, name: name);
  }

  /// 输出到文件
  void _logToFile(Map<String, dynamic> entry) {
    if (logFile == null) return;

    try {
      final file = File(logFile!);
      final jsonStr = jsonEncode(entry);
      file.writeAsStringSync('$jsonStr\n', mode: FileMode.append);
    } catch (e) {
      // 忽略文件写入错误
    }
  }

  /// 便捷方法
  void trace(String message, {LogContext? context}) => log(LogLevel.trace, message, context: context);
  void debug(String message, {LogContext? context}) => log(LogLevel.debug, message, context: context);
  void info(String message, {LogContext? context}) => log(LogLevel.info, message, context: context);
  void warn(String message, {LogContext? context, dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.warn, message, context: context, error: error, stackTrace: stackTrace);
  void error(String message, {LogContext? context, dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.error, message, context: context, error: error, stackTrace: stackTrace);
  void fatal(String message, {LogContext? context, dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.fatal, message, context: context, error: error, stackTrace: stackTrace);
}

/// 全局日志记录器工厂
class LoggerFactory {
  static final Map<String, StructuredLogger> _loggers = {};
  static LogLevel _globalMinLevel = LogLevel.info;
  static bool _enableConsole = true;
  static bool _enableJson = true;
  static String? _globalLogFile;

  /// 配置全局日志设置
  static void configure({
    LogLevel minLevel = LogLevel.info,
    bool enableConsole = true,
    bool enableJson = true,
    String? logFile,
  }) {
    _globalMinLevel = minLevel;
    _enableConsole = enableConsole;
    _enableJson = enableJson;
    _globalLogFile = logFile;
  }

  /// 获取日志记录器
  static StructuredLogger getLogger(String name) {
    if (!_loggers.containsKey(name)) {
      _loggers[name] = StructuredLogger(
        name: name,
        minLevel: _globalMinLevel,
        enableConsole: _enableConsole,
        enableJson: _enableJson,
        logFile: _globalLogFile,
      );
    }
    return _loggers[name]!;
  }

  /// 获取所有日志记录器
  static List<StructuredLogger> getAllLoggers() => _loggers.values.toList();

  /// 清理所有日志记录器
  static void clear() => _loggers.clear();
}

/// 便捷的全局日志记录器
final StructuredLogger logger = LoggerFactory.getLogger('TTPolyglotServer');

/// 日志中间件
class StructuredLoggingMiddleware {
  final StructuredLogger _logger;

  StructuredLoggingMiddleware({StructuredLogger? logger})
      : _logger = logger ?? LoggerFactory.getLogger('StructuredLogging');

  /// 创建结构化日志中间件
  Middleware call() {
    return (Handler handler) {
      return (Request request) async {
        final startTime = DateTime.now();
        final requestId = request.context['request_id'] as String?;

        // 记录请求开始
        _logger.info(
          '请求开始',
          context: LogContext()
              .request(request.method, request.url.path, requestId: requestId)
              .field('user_agent', request.headers['user-agent'] ?? 'unknown')
              .field('remote_addr', request.headers['x-forwarded-for'] ?? 'unknown'),
        );

        try {
          final response = await handler(request);
          final duration = DateTime.now().difference(startTime);

          // 记录请求完成
          _logger.info(
            '请求完成',
            context: LogContext()
                .request(request.method, request.url.path, requestId: requestId)
                .response(response.statusCode, responseTime: duration.inMilliseconds)
                .field('response_size', response.headers['content-length'] ?? 'unknown'),
          );

          return response;
        } catch (error, stackTrace) {
          final duration = DateTime.now().difference(startTime);

          // 记录请求错误
          _logger.error(
            '请求失败',
            context: LogContext()
                .request(request.method, request.url.path, requestId: requestId)
                .response(500, responseTime: duration.inMilliseconds)
                .error(error, stackTrace: stackTrace),
          );

          rethrow;
        }
      };
    };
  }
}

/// 创建结构化日志中间件
Middleware structuredLoggingMiddleware({StructuredLogger? logger}) {
  return StructuredLoggingMiddleware(logger: logger).call();
}
