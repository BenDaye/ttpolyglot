import 'package:ttpolyglot_server/src/middleware/error_handler_middleware.dart';

import '../utils/structured_logger.dart';

/// 数据验证工具类
class Validator {
  static final StructuredLogger _logger = LoggerFactory.getLogger('Validator');

  /// 验证字符串字段
  static String validateString(
    dynamic value,
    String fieldName, {
    int? minLength,
    int? maxLength,
    bool required = true,
    String? pattern,
  }) {
    final errors = <FieldError>[];

    // 检查是否为空
    if (value == null || (value is String && value.isEmpty)) {
      if (required) {
        errors.add(FieldError(
          field: fieldName,
          message: '$fieldName是必填项',
        ));
      } else {
        return '';
      }
    }

    if (value is! String) {
      errors.add(FieldError(
        field: fieldName,
        message: '$fieldName必须是字符串',
      ));
    } else {
      // 检查长度
      if (minLength != null && value.length < minLength) {
        errors.add(FieldError(
          field: fieldName,
          message: '$fieldName至少需要$minLength个字符',
        ));
      }

      if (maxLength != null && value.length > maxLength) {
        errors.add(FieldError(
          field: fieldName,
          message: '$fieldName不能超过$maxLength个字符',
        ));
      }

      // 检查正则表达式
      if (pattern != null && !RegExp(pattern).hasMatch(value)) {
        errors.add(FieldError(
          field: fieldName,
          message: '$fieldName格式不正确',
        ));
      }
    }

    if (errors.isNotEmpty) {
      throw ValidationException(
        message: '输入验证失败',
        errors: errors,
      );
    }

    return value as String;
  }

  /// 验证邮箱地址
  static String validateEmail(dynamic value, String fieldName) {
    final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    try {
      return validateString(
        value,
        fieldName,
        pattern: emailPattern,
        minLength: 5,
        maxLength: 255,
      );
    } catch (e) {
      if (e is ValidationException) {
        throw ValidationException(
          message: '输入验证失败',
          errors: e.errors,
        );
      }
      rethrow;
    }
  }

  /// 验证整数字段
  static int validateInt(
    dynamic value,
    String fieldName, {
    int? min,
    int? max,
    bool required = true,
  }) {
    final errors = <FieldError>[];

    if (value == null) {
      if (required) {
        errors.add(FieldError(
          field: fieldName,
          message: '$fieldName是必填项',
        ));
        throw ValidationException(
          message: '输入验证失败',
          errors: errors,
        );
      } else {
        return 0;
      }
    }

    int? intValue;

    if (value is int) {
      intValue = value;
    } else if (value is String) {
      intValue = int.tryParse(value);
    } else if (value is double) {
      intValue = value.toInt();
    }

    if (intValue == null) {
      errors.add(FieldError(
        field: fieldName,
        message: '$fieldName必须是整数',
      ));
    } else {
      // 检查范围
      if (min != null && intValue < min) {
        errors.add(FieldError(
          field: fieldName,
          message: '$fieldName不能小于$min',
        ));
      }

      if (max != null && intValue > max) {
        errors.add(FieldError(
          field: fieldName,
          message: '$fieldName不能大于$max',
        ));
      }
    }

    if (errors.isNotEmpty) {
      throw ValidationException(
        message: '输入验证失败',
        errors: errors,
      );
    }

    return intValue!;
  }

  /// 验证布尔字段
  static bool validateBool(
    dynamic value,
    String fieldName, {
    bool required = true,
    bool defaultValue = false,
  }) {
    if (value == null) {
      if (required) {
        throw ValidationException(message: '输入验证失败', errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName是必填项',
          ),
        ]);
      } else {
        return defaultValue;
      }
    }

    if (value is bool) {
      return value;
    }

    if (value is String) {
      final lowerValue = value.toLowerCase();
      if (lowerValue == 'true' || lowerValue == '1' || lowerValue == 'yes') {
        return true;
      } else if (lowerValue == 'false' || lowerValue == '0' || lowerValue == 'no') {
        return false;
      }
    }

    if (value is int) {
      return value != 0;
    }

    throw ValidationException(
      message: '输入验证失败',
      errors: [
        FieldError(
          field: fieldName,
          message: '$fieldName必须是布尔值',
        ),
      ],
    );
  }

  /// 验证枚举值
  static String validateEnum(
    dynamic value,
    String fieldName,
    List<String> allowedValues, {
    bool required = true,
  }) {
    if (value == null) {
      if (required) {
        throw ValidationException(message: '输入验证失败', errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName是必填项',
          ),
        ]);
      } else {
        return allowedValues.first;
      }
    }

    if (value is! String) {
      throw ValidationException(
        message: '输入验证失败',
        errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName必须是字符串',
          ),
        ],
      );
    }

    if (!allowedValues.contains(value)) {
      throw ValidationException(
        message: '输入验证失败',
        errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName必须是以下值之一: ${allowedValues.join(', ')}',
          ),
        ],
      );
    }

    return value;
  }

  /// 验证UUID格式
  static String validateUuid(dynamic value, String fieldName, {bool required = true}) {
    final uuidPattern = r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$';

    try {
      return validateString(
        value,
        fieldName,
        pattern: uuidPattern,
        required: required,
      );
    } catch (e) {
      if (e is ValidationException) {
        throw ValidationException(
          message: '输入验证失败',
          errors: e.errors,
        );
      }
      rethrow;
    }
  }

  /// 验证日期时间字符串
  static DateTime validateDateTime(
    dynamic value,
    String fieldName, {
    bool required = true,
  }) {
    if (value == null) {
      if (required) {
        throw ValidationException(message: '输入验证失败', errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName是必填项',
          ),
        ]);
      } else {
        return DateTime.now();
      }
    }

    if (value is DateTime) {
      return value;
    }

    if (value is! String) {
      throw ValidationException(
        message: '输入验证失败',
        errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName必须是日期时间字符串',
          ),
        ],
      );
    }

    try {
      return DateTime.parse(value);
    } catch (e) {
      throw ValidationException(
        message: '输入验证失败',
        errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName必须是有效的日期时间格式',
          ),
        ],
      );
    }
  }

  /// 验证URL格式
  static String validateUrl(dynamic value, String fieldName, {bool required = true}) {
    final urlPattern =
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';

    try {
      return validateString(
        value,
        fieldName,
        pattern: urlPattern,
        required: required,
      );
    } catch (e) {
      if (e is ValidationException) {
        throw ValidationException(
          message: '输入验证失败',
          errors: e.errors,
        );
      }
      rethrow;
    }
  }

  /// 验证JSON对象
  static Map<String, dynamic> validateJson(
    dynamic value,
    String fieldName, {
    bool required = true,
  }) {
    if (value == null) {
      if (required) {
        throw ValidationException(message: '输入验证失败', errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName是必填项',
          ),
        ]);
      } else {
        return <String, dynamic>{};
      }
    }

    if (value is Map<String, dynamic>) {
      return value;
    }

    throw ValidationException(
      message: '输入验证失败',
      errors: [
        FieldError(
          field: fieldName,
          message: '$fieldName必须是JSON对象',
        ),
      ],
    );
  }

  /// 验证数组
  static List<T> validateList<T>(
    dynamic value,
    String fieldName, {
    bool required = true,
    int? minLength,
    int? maxLength,
  }) {
    if (value == null) {
      if (required) {
        throw ValidationException(message: '输入验证失败', errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName是必填项',
          ),
        ]);
      } else {
        return <T>[];
      }
    }

    if (value is! List) {
      throw ValidationException(
        message: '输入验证失败',
        errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName必须是数组',
          ),
        ],
      );
    }

    final list = value;
    final errors = <FieldError>[];

    // 检查长度
    if (minLength != null && list.length < minLength) {
      errors.add(FieldError(
        field: fieldName,
        message: '$fieldName至少需要$minLength个元素',
      ));
    }

    if (maxLength != null && list.length > maxLength) {
      errors.add(FieldError(
        field: fieldName,
        message: '$fieldName不能超过$maxLength个元素',
      ));
    }

    if (errors.isNotEmpty) {
      throw ValidationException(
        message: '输入验证失败',
        errors: errors,
      );
    }

    try {
      return list.cast<T>();
    } catch (e) {
      throw ValidationException(
        message: '输入验证失败',
        errors: [
          FieldError(
            field: fieldName,
            message: '$fieldName数组元素类型不正确',
          ),
        ],
      );
    }
  }

  /// 批量验证（收集所有错误）
  static void validateBatch(List<Function> validations) {
    final allErrors = <FieldError>[];

    for (final validation in validations) {
      try {
        validation();
      } catch (error, stackTrace) {
        if (error is ValidationException) {
          allErrors.addAll(error.errors);
        } else {
          _logger.error('验证过程中出现未知错误', error: error, stackTrace: stackTrace);
        }
      }
    }

    if (allErrors.isNotEmpty) {
      throw ValidationException(
        message: '输入验证失败',
        errors: allErrors,
      );
    }
  }
}
