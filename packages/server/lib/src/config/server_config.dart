import 'package:dotenv/dotenv.dart';

/// 服务器配置类
class ServerConfig {
  static final DotEnv _env = DotEnv(includePlatformEnvironment: true);

  // 服务器配置
  static String get host => _env['HOST'] ?? '0.0.0.0';
  static int get port => int.tryParse(_env['PORT'] ?? '8080') ?? 8080;
  static String get logLevel => _env['LOG_LEVEL'] ?? 'info';
  static bool get isDevelopment => _env['ENVIRONMENT'] == 'dev';

  // 数据库配置
  static String get databaseUrl => _env['DATABASE_URL'] ?? '';
  static String get dbName => _env['DB_NAME'] ?? '';
  static String get dbUser => _env['DB_USER'] ?? '';
  static String get dbPassword => _env['DB_PASSWORD'] ?? '';
  static String get dbHost => _env['DB_HOST'] ?? '';
  static int get dbPort => int.tryParse(_env['DB_PORT'] ?? '5432') ?? 5432;
  static int get dbPoolSize => int.tryParse(_env['DB_POOL_SIZE'] ?? '20') ?? 20;
  static int get dbConnectionTimeout => int.tryParse(_env['DB_CONNECTION_TIMEOUT'] ?? '30') ?? 30;
  static String get tablePrefix => _env['DB_TABLE_PREFIX'] ?? '';

  // Redis配置
  static String get redisUrl => _env['REDIS_URL'] ?? '';
  static String get redisPassword => _env['REDIS_PASSWORD'] ?? '';
  static int get redisMaxConnections => int.tryParse(_env['REDIS_MAX_CONNECTIONS'] ?? '10') ?? 10;
  static int get redisConnectionTimeout => int.tryParse(_env['REDIS_CONNECTION_TIMEOUT'] ?? '5') ?? 5;
  static int get redisRetryAttempts => int.tryParse(_env['REDIS_RETRY_ATTEMPTS'] ?? '3') ?? 3;
  static int get redisRetryDelay => int.tryParse(_env['REDIS_RETRY_DELAY'] ?? '1000') ?? 1000;

  // 缓存TTL配置
  static int get cacheSessionTtl => int.tryParse(_env['CACHE_SESSION_TTL'] ?? '86400') ?? 86400;
  static int get cacheApiResponseTtl => int.tryParse(_env['CACHE_API_RESPONSE_TTL'] ?? '3600') ?? 3600;
  static int get cacheConfigTtl => int.tryParse(_env['CACHE_CONFIG_TTL'] ?? '21600') ?? 21600;
  static int get cachePermissionTtl => int.tryParse(_env['CACHE_PERMISSION_TTL'] ?? '7200') ?? 7200;
  static int get cacheTempDataTtl => int.tryParse(_env['CACHE_TEMP_DATA_TTL'] ?? '300') ?? 300;

  // JWT配置
  static String get jwtSecret => _env['JWT_SECRET'] ?? '';
  static int get jwtExpireHours => int.tryParse(_env['JWT_EXPIRE_HOURS'] ?? '24') ?? 24;
  static int get jwtRefreshExpireDays => int.tryParse(_env['JWT_REFRESH_EXPIRE_DAYS'] ?? '7') ?? 7;

  // 安全配置
  static int get bcryptRounds => int.tryParse(_env['BCRYPT_ROUNDS'] ?? '12') ?? 12;
  static String get sessionSecret => _env['SESSION_SECRET'] ?? '';
  static String get encryptionKey => _env['ENCRYPTION_KEY'] ?? '';
  static List<String> get corsOrigins => _env['CORS_ORIGINS']?.split(',') ?? [];
  static bool get corsAllowCredentials => _env['CORS_ALLOW_CREDENTIALS'] == 'true';

  // 请求限制
  static String get maxRequestSize => _env['MAX_REQUEST_SIZE'] ?? '';
  static int get rateLimitRequests => int.tryParse(_env['RATE_LIMIT_REQUESTS'] ?? '1000') ?? 1000;
  static int get rateLimitWindowMinutes => int.tryParse(_env['RATE_LIMIT_WINDOW_MINUTES'] ?? '15') ?? 15;

  // 安全配置
  static int get maxLoginAttempts => int.tryParse(_env['MAX_LOGIN_ATTEMPTS'] ?? '5') ?? 5;
  static int get accountLockoutMinutes => int.tryParse(_env['ACCOUNT_LOCKOUT_MINUTES'] ?? '30') ?? 30;

  // 监控配置
  static bool get healthCheckEnabled => _env['HEALTH_CHECK_ENABLED'] == 'true';
  static bool get metricsEnabled => _env['METRICS_ENABLED'] == 'true';
  static int get metricsPort => int.tryParse(_env['METRICS_PORT'] ?? '9090') ?? 9090;

  // 邮件配置
  static String get smtpHost => _env['SMTP_HOST'] ?? '';
  static int get smtpPort => int.tryParse(_env['SMTP_PORT'] ?? '587') ?? 587;
  static String get smtpUser => _env['SMTP_USER'] ?? '';
  static String get smtpPassword => _env['SMTP_PASSWORD'] ?? '';
  static String get smtpFromAddress => _env['SMTP_FROM_ADDRESS'] ?? '';
  static String get siteUrl => _env['SITE_URL'] ?? '';
}
