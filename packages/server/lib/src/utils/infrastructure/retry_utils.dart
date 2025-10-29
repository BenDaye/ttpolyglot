import 'dart:async';
import 'dart:math';

import 'package:ttpolyglot_utils/utils.dart';

/// 重试策略
enum RetryStrategy {
  fixed, // 固定间隔
  exponential, // 指数退避
  linear, // 线性增长
}

/// 重试配置
class RetryConfig {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final RetryStrategy strategy;
  final double backoffMultiplier;
  final double jitter;
  final bool Function(dynamic error)? retryIf;

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.strategy = RetryStrategy.exponential,
    this.backoffMultiplier = 2.0,
    this.jitter = 0.1,
    this.retryIf,
  });

  /// 默认数据库重试配置
  static const database = RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 5),
    strategy: RetryStrategy.exponential,
  );

  /// 默认Redis重试配置
  static const redis = RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(milliseconds: 200),
    maxDelay: Duration(seconds: 2),
    strategy: RetryStrategy.exponential,
  );

  /// 默认HTTP重试配置
  static const http = RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 10),
    strategy: RetryStrategy.exponential,
  );

  /// 默认外部API重试配置
  static const externalApi = RetryConfig(
    maxAttempts: 5,
    initialDelay: Duration(seconds: 2),
    maxDelay: Duration(seconds: 30),
    strategy: RetryStrategy.exponential,
    backoffMultiplier: 1.5,
    jitter: 0.2,
  );
}

/// 重试结果
class RetryResult<T> {
  final T? result;
  final dynamic lastError;
  final int attempts;
  final Duration totalDuration;
  final bool succeeded;

  RetryResult({
    this.result,
    this.lastError,
    required this.attempts,
    required this.totalDuration,
    required this.succeeded,
  });
}

/// 重试工具类
class RetryUtils {
  static final Random _random = Random();

  /// 执行带重试的操作
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    RetryConfig config = const RetryConfig(),
    String? operationName,
  }) async {
    final startTime = DateTime.now();
    dynamic lastError;

    for (int attempt = 1; attempt <= config.maxAttempts; attempt++) {
      try {
        final result = await operation();

        if (attempt > 1) {
          final duration = DateTime.now().difference(startTime);
          LoggerUtils.info('重试成功: ${operationName ?? 'operation'} (第${attempt}次尝试, 耗时: ${duration.inMilliseconds}ms)');
        }

        return result;
      } catch (error, stackTrace) {
        lastError = error;

        // 检查是否应该重试
        if (config.retryIf != null && !config.retryIf!(error)) {
          LoggerUtils.warning('错误不可重试: ${operationName ?? 'operation'} - $error', error: error, stackTrace: stackTrace);
          rethrow;
        }

        // 如果是最后一次尝试，抛出错误
        if (attempt == config.maxAttempts) {
          final duration = DateTime.now().difference(startTime);
          LoggerUtils.error('重试失败: ${operationName ?? 'operation'} (${attempt}次尝试, 耗时: ${duration.inMilliseconds}ms)',
              error: error, stackTrace: stackTrace);
          rethrow;
        }

        // 计算延迟时间
        final delay = _calculateDelay(config, attempt);

        LoggerUtils.debug(
            '重试中: ${operationName ?? 'operation'} (第${attempt}次失败, ${delay.inMilliseconds}ms后重试) - $error');

        // 等待后重试
        await Future.delayed(delay);
      }
    }

    // 这里不应该到达，但为了类型安全
    throw lastError ?? Exception('重试失败');
  }

  /// 执行带重试的操作（返回详细结果）
  static Future<RetryResult<T>> retryWithResult<T>(
    Future<T> Function() operation, {
    RetryConfig config = const RetryConfig(),
    String? operationName,
  }) async {
    final startTime = DateTime.now();
    dynamic lastError;

    for (int attempt = 1; attempt <= config.maxAttempts; attempt++) {
      try {
        final result = await operation();
        final totalDuration = DateTime.now().difference(startTime);

        return RetryResult<T>(
          result: result,
          attempts: attempt,
          totalDuration: totalDuration,
          succeeded: true,
        );
      } catch (error) {
        lastError = error;

        // 检查是否应该重试
        if (config.retryIf != null && !config.retryIf!(error)) {
          final totalDuration = DateTime.now().difference(startTime);
          return RetryResult<T>(
            lastError: error,
            attempts: attempt,
            totalDuration: totalDuration,
            succeeded: false,
          );
        }

        // 如果是最后一次尝试
        if (attempt == config.maxAttempts) {
          final totalDuration = DateTime.now().difference(startTime);
          return RetryResult<T>(
            lastError: error,
            attempts: attempt,
            totalDuration: totalDuration,
            succeeded: false,
          );
        }

        // 计算延迟时间并等待
        final delay = _calculateDelay(config, attempt);
        await Future.delayed(delay);
      }
    }

    // 这里不应该到达
    final totalDuration = DateTime.now().difference(startTime);
    return RetryResult<T>(
      lastError: lastError,
      attempts: config.maxAttempts,
      totalDuration: totalDuration,
      succeeded: false,
    );
  }

  /// 计算延迟时间
  static Duration _calculateDelay(RetryConfig config, int attempt) {
    Duration delay;

    switch (config.strategy) {
      case RetryStrategy.fixed:
        delay = config.initialDelay;
        break;

      case RetryStrategy.exponential:
        final exponentialDelay = config.initialDelay.inMilliseconds * pow(config.backoffMultiplier, attempt - 1);
        delay = Duration(milliseconds: exponentialDelay.round());
        break;

      case RetryStrategy.linear:
        final linearDelay = config.initialDelay.inMilliseconds * attempt;
        delay = Duration(milliseconds: linearDelay);
        break;
    }

    // 应用最大延迟限制
    if (delay > config.maxDelay) {
      delay = config.maxDelay;
    }

    // 添加抖动
    if (config.jitter > 0) {
      final jitterAmount = delay.inMilliseconds * config.jitter;
      final jitterOffset = (_random.nextDouble() - 0.5) * 2 * jitterAmount;
      final jitteredDelay = delay.inMilliseconds + jitterOffset.round();
      delay = Duration(milliseconds: max(0, jitteredDelay));
    }

    return delay;
  }

  /// 数据库操作重试
  static Future<T> retryDatabase<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    return retry(
      operation,
      config: RetryConfig.database.copyWith(
        retryIf: (error) => _isDatabaseRetryableError(error),
      ),
      operationName: operationName ?? 'database_operation',
    );
  }

  /// Redis操作重试
  static Future<T> retryRedis<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    return retry(
      operation,
      config: RetryConfig.redis.copyWith(
        retryIf: (error) => _isRedisRetryableError(error),
      ),
      operationName: operationName ?? 'redis_operation',
    );
  }

  /// HTTP请求重试
  static Future<T> retryHttp<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    return retry(
      operation,
      config: RetryConfig.http.copyWith(
        retryIf: (error) => _isHttpRetryableError(error),
      ),
      operationName: operationName ?? 'http_request',
    );
  }

  /// 外部API调用重试
  static Future<T> retryExternalApi<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    return retry(
      operation,
      config: RetryConfig.externalApi.copyWith(
        retryIf: (error) => _isExternalApiRetryableError(error),
      ),
      operationName: operationName ?? 'external_api',
    );
  }

  /// 判断数据库错误是否可重试
  static bool _isDatabaseRetryableError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // 连接相关错误
    if (errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('network') ||
        errorString.contains('socket')) {
      return true;
    }

    // 临时性错误
    if (errorString.contains('temporary') || errorString.contains('busy') || errorString.contains('lock')) {
      return true;
    }

    return false;
  }

  /// 判断Redis错误是否可重试
  static bool _isRedisRetryableError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // 连接相关错误
    if (errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('network') ||
        errorString.contains('socket')) {
      return true;
    }

    return false;
  }

  /// 判断HTTP错误是否可重试
  static bool _isHttpRetryableError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // 网络相关错误
    if (errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('network') ||
        errorString.contains('socket')) {
      return true;
    }

    // HTTP状态码相关（需要根据实际情况调整）
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504')) {
      return true;
    }

    return false;
  }

  /// 判断外部API错误是否可重试
  static bool _isExternalApiRetryableError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // 网络相关错误
    if (errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('network') ||
        errorString.contains('socket')) {
      return true;
    }

    // 速率限制
    if (errorString.contains('rate limit') || errorString.contains('429')) {
      return true;
    }

    // 服务器错误
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504')) {
      return true;
    }

    return false;
  }
}

/// RetryConfig扩展方法
extension RetryConfigExtension on RetryConfig {
  RetryConfig copyWith({
    int? maxAttempts,
    Duration? initialDelay,
    Duration? maxDelay,
    RetryStrategy? strategy,
    double? backoffMultiplier,
    double? jitter,
    bool Function(dynamic error)? retryIf,
  }) {
    return RetryConfig(
      maxAttempts: maxAttempts ?? this.maxAttempts,
      initialDelay: initialDelay ?? this.initialDelay,
      maxDelay: maxDelay ?? this.maxDelay,
      strategy: strategy ?? this.strategy,
      backoffMultiplier: backoffMultiplier ?? this.backoffMultiplier,
      jitter: jitter ?? this.jitter,
      retryIf: retryIf ?? this.retryIf,
    );
  }
}
