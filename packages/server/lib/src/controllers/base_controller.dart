import 'dart:developer' as developer;

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';

import '../exceptions/exceptions.dart';
import '../utils/http/response_utils.dart';
import '../utils/logging/logger_utils.dart';

/// 控制器基类
/// 提供统一的请求处理、错误处理和日志记录机制
abstract class BaseController {
  final String controllerName;

  BaseController(this.controllerName);

  /// 获取当前用户ID
  String? getCurrentUserId(Request request) {
    return request.context['user_id'] as String?;
  }

  /// 获取认证令牌
  String? getAuthToken(Request request) {
    final authHeader = request.headers['authorization'];
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      return authHeader.substring(7);
    }
    return null;
  }

  /// 获取客户端IP地址
  String? getClientIp(Request request) {
    // 尝试从X-Forwarded-For头获取真实IP
    final forwardedFor = request.headers['x-forwarded-for'];
    if (forwardedFor != null && forwardedFor.isNotEmpty) {
      return forwardedFor.split(',').first.trim();
    }

    // 尝试从X-Real-IP头获取
    final realIp = request.headers['x-real-ip'];
    if (realIp != null && realIp.isNotEmpty) {
      return realIp;
    }

    // 从连接信息获取
    final connectionInfo = request.context['shelf.io.connection_info'];
    if (connectionInfo != null) {
      return connectionInfo.toString();
    }

    return null;
  }

  /// 包装异步操作，提供统一的错误处理和日志记录
  Future<Response> execute(
    Future<Response> Function() operation, {
    String? operationName,
    Map<String, dynamic>? context,
  }) async {
    final opName = operationName ?? 'operation';

    try {
      developer.log(
        '开始执行',
        name: controllerName,
        error: {'operation': opName, ...?context},
      );

      final result = await operation();

      developer.log(
        '执行成功',
        name: controllerName,
        error: {'operation': opName, ...?context},
      );

      return result;
    } on ValidationException catch (error, stackTrace) {
      developer.log(
        '验证错误',
        error: error,
        stackTrace: stackTrace,
        name: controllerName,
      );

      return ResponseUtils.error(
        code: ApiResponseCode.validationError,
        message: error.message,
      );
    } on NotFoundException catch (error, stackTrace) {
      developer.log(
        '资源不存在',
        error: error,
        stackTrace: stackTrace,
        name: controllerName,
      );

      return ResponseUtils.error(
        code: ApiResponseCode.notFound,
        message: error.message,
      );
    } on BusinessException catch (error, stackTrace) {
      developer.log(
        '业务错误',
        error: error,
        stackTrace: stackTrace,
        name: controllerName,
      );

      return ResponseUtils.error(
        code: error.code,
        message: error.message,
      );
    } on AuthenticationException catch (error, stackTrace) {
      developer.log(
        '认证失败',
        error: error,
        stackTrace: stackTrace,
        name: controllerName,
      );

      return ResponseUtils.error(
        code: ApiResponseCode.unauthorized,
        message: error.message,
      );
    } on AuthorizationException catch (error, stackTrace) {
      developer.log(
        '授权失败',
        error: error,
        stackTrace: stackTrace,
        name: controllerName,
      );

      return ResponseUtils.error(
        code: ApiResponseCode.forbidden,
        message: error.message,
      );
    } catch (error, stackTrace) {
      developer.log(
        '执行失败: $opName',
        error: error,
        stackTrace: stackTrace,
        name: controllerName,
      );

      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '操作失败，请稍后重试',
      );
    }
  }

  /// 记录信息日志
  void logInfo(String message, {Map<String, dynamic>? context}) {
    LoggerUtils.info(message, context: LogContext({'controller': controllerName, ...?context}));
  }

  /// 记录警告日志
  void logWarn(String message, {Map<String, dynamic>? context}) {
    LoggerUtils.warn(message, context: LogContext({'controller': controllerName, ...?context}));
  }

  /// 记录错误日志
  void logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    LoggerUtils.error(
      message,
      error: error,
      stackTrace: stackTrace,
      context: LogContext({'controller': controllerName, ...?context}),
    );
  }

  /// 记录调试日志
  void logDebug(String message, {Map<String, dynamic>? context}) {
    LoggerUtils.debug(message, context: LogContext({'controller': controllerName, ...?context}));
  }
}
