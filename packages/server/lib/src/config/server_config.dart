import 'dart:developer';
import 'dart:io';

import 'package:dotenv/dotenv.dart';

/// 服务器配置类
class ServerConfig {
  late final DotEnv _env;

  // 服务器配置
  late final String host;
  late final int port;
  late final String logLevel;
  late final bool isDevelopment;

  // 数据库配置
  late final String databaseUrl;
  late final String dbName;
  late final String dbUser;
  late final String dbPassword;
  late final String dbHost;
  late final int dbPort;
  late final int dbPoolSize;
  late final int dbConnectionTimeout;

  // Redis配置
  late final String redisUrl;
  late final String? redisPassword;
  late final int redisMaxConnections;
  late final int redisConnectionTimeout;
  late final int redisRetryAttempts;
  late final int redisRetryDelay;

  // 缓存TTL配置
  late final int cacheSessionTtl;
  late final int cacheApiResponseTtl;
  late final int cacheConfigTtl;
  late final int cachePermissionTtl;
  late final int cacheTempDataTtl;

  // JWT配置
  late final String jwtSecret;
  late final int jwtExpireHours;
  late final int jwtRefreshExpireDays;

  // 安全配置
  late final int bcryptRounds;
  late final String sessionSecret;
  late final String encryptionKey;
  late final List<String> corsOrigins;
  late final bool corsAllowCredentials;

  // 请求限制
  late final String maxRequestSize;
  late final int rateLimitRequests;
  late final int rateLimitWindowMinutes;

  // 安全配置
  late final int maxLoginAttempts;
  late final int accountLockoutMinutes;

  // 监控配置
  late final bool healthCheckEnabled;
  late final bool metricsEnabled;
  late final int metricsPort;

  // 邮件配置
  late final String? smtpHost;
  late final int? smtpPort;
  late final String? smtpUser;
  late final String? smtpPassword;
  late final String? smtpFromAddress;
  late final String? siteUrl;

  /// 加载配置
  Future<void> load() async {
    try {
      _env = DotEnv(includePlatformEnvironment: true);

      // 尝试加载.env文件
      final envFile = File('.env');
      if (await envFile.exists()) {
        _env.load(['.env']);
        log('已加载.env文件', name: 'ServerConfig');
      } else {
        log('未找到.env文件，使用环境变量', name: 'ServerConfig');
      }

      _loadServerConfig();
      _loadDatabaseConfig();
      _loadRedisConfig();
      _loadCacheConfig();
      _loadJwtConfig();
      _loadSecurityConfig();
      _loadRequestLimitConfig();
      _loadMonitoringConfig();
      _loadEmailConfig();

      log('服务器配置加载完成', name: 'ServerConfig');
    } catch (error, stackTrace) {
      log('配置加载失败', error: error, stackTrace: stackTrace, name: 'ServerConfig');
      rethrow;
    }
  }

  void _loadServerConfig() {
    host = _env['SERVER_HOST'] ?? '0.0.0.0';
    port = int.parse(_env['SERVER_PORT'] ?? '8080');
    logLevel = _env['LOG_LEVEL'] ?? 'info';
    isDevelopment = _env['ENVIRONMENT'] == 'dev';
  }

  void _loadDatabaseConfig() {
    databaseUrl = _env['DATABASE_URL'] ?? 'postgresql://ttpolyglot:password@localhost:5432/ttpolyglot';
    dbName = _env['DB_NAME'] ?? 'ttpolyglot';
    dbUser = _env['DB_USER'] ?? 'ttpolyglot';
    dbPassword = _env['DB_PASSWORD'] ?? 'password';
    dbHost = _env['DB_HOST'] ?? 'localhost';
    dbPort = int.parse(_env['DB_PORT'] ?? '5432');
    dbPoolSize = int.parse(_env['DB_POOL_SIZE'] ?? '20');
    dbConnectionTimeout = int.parse(_env['DB_CONNECTION_TIMEOUT'] ?? '30');
  }

  void _loadRedisConfig() {
    redisUrl = _env['REDIS_URL'] ?? 'redis://localhost:6379';
    redisPassword = _env['REDIS_PASSWORD'];
    redisMaxConnections = int.parse(_env['REDIS_MAX_CONNECTIONS'] ?? '10');
    redisConnectionTimeout = int.parse(_env['REDIS_CONNECTION_TIMEOUT'] ?? '5');
    redisRetryAttempts = int.parse(_env['REDIS_RETRY_ATTEMPTS'] ?? '3');
    redisRetryDelay = int.parse(_env['REDIS_RETRY_DELAY'] ?? '1000');
  }

  void _loadCacheConfig() {
    cacheSessionTtl = int.parse(_env['CACHE_SESSION_TTL'] ?? '86400');
    cacheApiResponseTtl = int.parse(_env['CACHE_API_RESPONSE_TTL'] ?? '3600');
    cacheConfigTtl = int.parse(_env['CACHE_CONFIG_TTL'] ?? '21600');
    cachePermissionTtl = int.parse(_env['CACHE_PERMISSION_TTL'] ?? '7200');
    cacheTempDataTtl = int.parse(_env['CACHE_TEMP_DATA_TTL'] ?? '300');
  }

  void _loadJwtConfig() {
    jwtSecret = _env['JWT_SECRET'] ?? 'your-super-secret-jwt-key';
    jwtExpireHours = int.parse(_env['JWT_EXPIRE_HOURS'] ?? '24');
    jwtRefreshExpireDays = int.parse(_env['JWT_REFRESH_EXPIRE_DAYS'] ?? '7');
  }

  void _loadSecurityConfig() {
    bcryptRounds = int.parse(_env['BCRYPT_ROUNDS'] ?? '12');
    sessionSecret = _env['SESSION_SECRET'] ?? 'your-session-secret';
    encryptionKey = _env['ENCRYPTION_KEY'] ?? 'your-encryption-key-32-chars';

    final originsString = _env['CORS_ORIGINS'] ?? 'http://localhost:3000';
    corsOrigins = originsString.split(',').map((e) => e.trim()).toList();
    corsAllowCredentials = _env['CORS_ALLOW_CREDENTIALS']?.toLowerCase() == 'true';

    // 安全配置
    maxLoginAttempts = int.parse(_env['MAX_LOGIN_ATTEMPTS'] ?? '5');
    accountLockoutMinutes = int.parse(_env['ACCOUNT_LOCKOUT_MINUTES'] ?? '30');
  }

  void _loadRequestLimitConfig() {
    maxRequestSize = _env['MAX_REQUEST_SIZE'] ?? '10MB';
    rateLimitRequests = int.parse(_env['RATE_LIMIT_REQUESTS'] ?? '1000');
    rateLimitWindowMinutes = int.parse(_env['RATE_LIMIT_WINDOW_MINUTES'] ?? '15');
  }

  void _loadMonitoringConfig() {
    healthCheckEnabled = _env['HEALTH_CHECK_ENABLED']?.toLowerCase() != 'false';
    metricsEnabled = _env['METRICS_ENABLED']?.toLowerCase() == 'true';
    metricsPort = int.parse(_env['METRICS_PORT'] ?? '9090');
  }

  void _loadEmailConfig() {
    smtpHost = _env['SMTP_HOST'];
    smtpPort = int.tryParse(_env['SMTP_PORT'] ?? '');
    smtpUser = _env['SMTP_USER'];
    smtpPassword = _env['SMTP_PASSWORD'];
    smtpFromAddress = _env['SMTP_FROM_ADDRESS'];
    siteUrl = _env['SITE_URL'];
  }

  /// 获取环境变量值
  String? getEnv(String key) => _env[key];

  /// 验证配置
  void validate() {
    if (jwtSecret == 'your-super-secret-jwt-key' && !isDevelopment) {
      throw Exception('生产环境必须设置JWT_SECRET');
    }

    if (sessionSecret == 'your-session-secret' && !isDevelopment) {
      throw Exception('生产环境必须设置SESSION_SECRET');
    }

    if (dbPassword == 'password' && !isDevelopment) {
      throw Exception('生产环境必须设置数据库密码');
    }
  }
}
