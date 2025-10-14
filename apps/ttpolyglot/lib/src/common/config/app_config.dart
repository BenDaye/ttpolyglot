/// 应用配置类
class AppConfig {
  // 私有构造函数，防止实例化
  AppConfig._();

  /// API 配置
  /// 从 .env 文件读取 API_BASE_URL
  /// 开发环境：.env.development.local
  /// 生产环境：.env.production.local
  static String get apiBaseUrl => String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3000/api/v1',
      );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Token 配置
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userInfoKey = 'user_info';

  /// 请求配置
  static const int requestTimeThreshold = 1000; // 最小请求时间（毫秒）
  static const int pageSize = 20; // 分页大小

  /// HTTP 状态码
  static const int httpStatusOk = 200;
  static const int httpStatusCreated = 201;
  static const int httpStatusNoContent = 204;
  static const int httpStatusBadRequest = 400;
  static const int httpStatusUnauthorized = 401;
  static const int httpStatusForbidden = 403;
  static const int httpStatusNotFound = 404;
  static const int httpStatusUnprocessableEntity = 422;
  static const int httpStatusInternalServerError = 500;
  static const int httpStatusServiceUnavailable = 503;

  /// 业务状态码
  static const int codeSuccess = 200;
  static const int codeUnauthorized = 401;
  static const int codeValidationFailed = 422;
  static const int codeServerError = 500;
}
