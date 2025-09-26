/// API错误模型
class ApiError {
  final String code;
  final String message;
  final String? details;
  final List<FieldError>? fieldErrors;
  final Map<String, dynamic>? metadata;

  const ApiError({
    required this.code,
    required this.message,
    this.details,
    this.fieldErrors,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'error': {
        'code': code,
        'message': message,
        if (details != null) 'details': details,
        if (fieldErrors != null && fieldErrors!.isNotEmpty)
          'field_errors': fieldErrors!.map((e) => e.toJson()).toList(),
        if (metadata != null) 'metadata': metadata,
      },
    };
  }
}

/// 字段验证错误
class FieldError {
  final String field;
  final String code;
  final String message;

  const FieldError({
    required this.field,
    required this.code,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'code': code,
      'message': message,
    };
  }
}

/// 验证异常
class ValidationException implements Exception {
  final String code;
  final String message;
  final List<FieldError> fieldErrors;

  ValidationException({
    required this.code,
    required this.message,
    required this.fieldErrors,
  });

  @override
  String toString() => 'ValidationException: $code - $message';
}

/// 业务逻辑异常
class BusinessException implements Exception {
  final String code;
  final String message;
  final String? details;

  const BusinessException(this.code, this.message, {this.details});

  @override
  String toString() => 'BusinessException: $code - $message';
}

/// 认证异常
class AuthenticationException implements Exception {
  final String code;
  final String message;

  const AuthenticationException(this.code, this.message);

  @override
  String toString() => 'AuthenticationException: $code - $message';
}

/// 授权异常
class AuthorizationException implements Exception {
  final String code;
  final String message;

  const AuthorizationException(this.code, this.message);

  @override
  String toString() => 'AuthorizationException: $code - $message';
}

/// 资源未找到异常
class NotFoundException implements Exception {
  final String message;

  const NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// 资源冲突异常
class ConflictException implements Exception {
  final String message;

  const ConflictException(this.message);

  @override
  String toString() => 'ConflictException: $message';
}

/// 系统异常
class SystemException implements Exception {
  final String code;
  final String message;

  const SystemException(this.code, this.message);

  @override
  String toString() => 'SystemException: $code - $message';
}
