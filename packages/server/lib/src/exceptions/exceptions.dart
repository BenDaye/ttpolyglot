import 'dart:developer' as developer;

import 'package:ttpolyglot_model/model.dart';

/// 服务器异常基类
abstract class ServerException implements Exception {
  final ApiResponseCode code;
  final String message;
  final dynamic details;
  final StackTrace? stackTrace;

  const ServerException({
    required this.code,
    required this.message,
    this.details,
    this.stackTrace,
  });

  /// 获取 HTTP 状态码
  int get httpStatusCode => code.value > 0 ? code.value : 500;

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'code': code.value,
      'message': message,
      if (details != null) 'details': details,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  /// 记录日志
  void log(String className) {
    developer.log(
      message,
      error: this,
      stackTrace: stackTrace,
      name: className,
    );
  }

  @override
  String toString() => '$runtimeType: $message (code: ${code.value})';
}

/// 验证异常
class ValidationException extends ServerException {
  final List<FieldError> fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors = const [],
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.unprocessableEntity);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    if (fieldErrors.isNotEmpty) {
      map['field_errors'] = fieldErrors.map((e) => e.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() =>
      'ValidationException: $message\nErrors:\n${fieldErrors.map((e) => '  - ${e.field}: ${e.message}').join('\n')}';
}

/// 认证异常
class AuthenticationException extends ServerException {
  const AuthenticationException({
    required super.message,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.unauthorized);
}

/// 授权异常
class AuthorizationException extends ServerException {
  const AuthorizationException({
    required super.message,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.forbidden);
}

/// 资源未找到异常
class NotFoundException extends ServerException {
  const NotFoundException({
    required super.message,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.notFound);
}

/// 业务逻辑异常
class BusinessException extends ServerException {
  const BusinessException({
    required super.code,
    required super.message,
    super.details,
    super.stackTrace,
  });
}

/// 数据库异常
class DatabaseException extends ServerException {
  const DatabaseException({
    required super.message,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.internalServerError);
}

/// 缓存异常
class CacheException extends ServerException {
  const CacheException({
    required super.message,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.internalServerError);
}

/// 外部服务异常
class ExternalServiceException extends ServerException {
  final String serviceName;

  const ExternalServiceException({
    required this.serviceName,
    required super.message,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.badGateway);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['service'] = serviceName;
    return map;
  }

  @override
  String toString() => 'ExternalServiceException($serviceName): $message';
}

/// 速率限制异常
class RateLimitException extends ServerException {
  final int retryAfterSeconds;

  const RateLimitException({
    required super.message,
    this.retryAfterSeconds = 60,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.tooManyRequests);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['retry_after_seconds'] = retryAfterSeconds;
    return map;
  }
}

/// 冲突异常（如资源已存在）
class ConflictException extends ServerException {
  const ConflictException({
    required super.message,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.conflict);
}

/// 文件上传异常
class FileUploadException extends ServerException {
  final String? fileName;
  final int? fileSize;

  const FileUploadException({
    required super.message,
    this.fileName,
    this.fileSize,
    super.details,
    super.stackTrace,
  }) : super(code: ApiResponseCode.badRequest);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    if (fileName != null) map['file_name'] = fileName;
    if (fileSize != null) map['file_size'] = fileSize;
    return map;
  }
}

/// 字段验证错误
class FieldError {
  final String field;
  final String message;
  final dynamic value;

  const FieldError({
    required this.field,
    required this.message,
    this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'message': message,
      if (value != null) 'value': value,
    };
  }
}
