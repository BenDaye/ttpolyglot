import 'dart:developer' as developer;

import 'package:ttpolyglot_model/model.dart';

import '../exceptions/exceptions.dart';
import '../utils/logging/logger_utils.dart';

/// 服务基类
/// 提供统一的日志记录和错误处理机制
abstract class BaseService {
  final String serviceName;

  BaseService(this.serviceName);

  /// 包装异步操作，提供统一的错误处理
  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? operationName,
    Map<String, dynamic>? context,
    T Function(dynamic error, StackTrace stackTrace)? onError,
  }) async {
    final opName = operationName ?? 'operation';

    try {
      LoggerUtils.debug('开始执行: $opName', context: _buildContext(context));
      final result = await operation();
      LoggerUtils.debug('执行成功: $opName', context: _buildContext(context));
      return result;
    } on ServerException catch (error, stackTrace) {
      // 服务器异常直接重新抛出
      LoggerUtils.error(
        '执行失败: $opName - ${error.message}',
        error: error,
        stackTrace: stackTrace,
        context: _buildContext(context),
      );
      rethrow;
    } catch (error, stackTrace) {
      // 未知异常，记录日志并根据情况处理
      LoggerUtils.error(
        '执行出现未知错误: $opName',
        error: error,
        stackTrace: stackTrace,
        context: _buildContext(context),
      );

      // 如果提供了错误处理函数，使用它
      if (onError != null) {
        return onError(error, stackTrace);
      }

      // 否则包装为服务器异常
      throw BusinessException(
        message: '操作失败: $opName',
        details: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  /// 包装同步操作，提供统一的错误处理
  T executeSync<T>(
    T Function() operation, {
    String? operationName,
    Map<String, dynamic>? context,
    T Function(dynamic error, StackTrace stackTrace)? onError,
  }) {
    final opName = operationName ?? 'operation';

    try {
      LoggerUtils.debug('开始执行: $opName', context: _buildContext(context));
      final result = operation();
      LoggerUtils.debug('执行成功: $opName', context: _buildContext(context));
      return result;
    } on ServerException catch (error, stackTrace) {
      LoggerUtils.error(
        '执行失败: $opName - ${error.message}',
        error: error,
        stackTrace: stackTrace,
        context: _buildContext(context),
      );
      rethrow;
    } catch (error, stackTrace) {
      LoggerUtils.error(
        '执行出现未知错误: $opName',
        error: error,
        stackTrace: stackTrace,
        context: _buildContext(context),
      );

      if (onError != null) {
        return onError(error, stackTrace);
      }

      throw BusinessException(
        message: '操作失败: $opName',
        details: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  /// 验证参数非空
  void requireNonNull(dynamic value, String paramName) {
    if (value == null) {
      throw ValidationException(
        message: '参数不能为空',
        fieldErrors: [
          FieldError(field: paramName, message: '该字段不能为空'),
        ],
      );
    }
  }

  /// 验证字符串非空
  void requireNonEmpty(String? value, String paramName) {
    if (value == null || value.isEmpty) {
      throw ValidationException(
        message: '参数不能为空',
        fieldErrors: [
          FieldError(field: paramName, message: '该字段不能为空'),
        ],
      );
    }
  }

  /// 验证条件
  void require(bool condition, String message, {DataCodeEnum? code}) {
    if (!condition) {
      throw BusinessException(
        message: message,
      );
    }
  }

  /// 抛出未找到异常
  Never throwNotFound(String message, {dynamic details}) {
    throw NotFoundException(
      message: message,
      details: details,
    );
  }

  /// 抛出验证异常
  Never throwValidation(
    String message, {
    List<FieldError>? fieldErrors,
    dynamic details,
  }) {
    throw ValidationException(
      message: message,
      fieldErrors: fieldErrors ?? [],
      details: details,
    );
  }

  /// 抛出业务异常
  Never throwBusiness(
    String message, {
    dynamic details,
  }) {
    throw BusinessException(
      message: message,
      details: details,
    );
  }

  /// 抛出认证异常
  Never throwAuthentication(String message, {dynamic details}) {
    throw AuthenticationException(
      message: message,
      details: details,
    );
  }

  /// 抛出授权异常
  Never throwAuthorization(String message, {dynamic details}) {
    throw AuthorizationException(
      message: message,
      details: details,
    );
  }

  /// 抛出冲突异常
  Never throwConflict(String message, {dynamic details}) {
    throw ConflictException(
      message: message,
      details: details,
    );
  }

  /// 抛出数据库异常
  Never throwDatabase(String message, {dynamic details}) {
    throw DatabaseException(
      message: message,
      details: details,
    );
  }

  /// 构建日志上下文
  LogContext _buildContext(Map<String, dynamic>? context) {
    final logContext = LogContext();
    if (context != null) {
      for (final entry in context.entries) {
        logContext.field(entry.key, entry.value);
      }
    }
    return logContext;
  }

  /// 记录信息日志
  void logInfo(String message, {Map<String, dynamic>? context}) {
    LoggerUtils.info(message, context: _buildContext(context));
  }

  /// 记录调试日志
  void logDebug(String message, {Map<String, dynamic>? context}) {
    LoggerUtils.debug(message, context: _buildContext(context));
  }

  /// 记录警告日志
  void logWarning(String message, {Map<String, dynamic>? context}) {
    LoggerUtils.warn(message, context: _buildContext(context));
  }

  /// 记录错误日志
  void logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    developer.log(
      message,
      error: error,
      stackTrace: stackTrace,
      name: serviceName,
    );
  }
}
