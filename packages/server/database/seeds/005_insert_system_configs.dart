import 'dart:developer';

/// 种子数据: 005 - 插入系统配置
/// 创建时间: 2024-12-26
/// 描述: 插入系统默认配置
class Seed005InsertSystemConfigs {
  static const String name = '005_insert_system_configs';
  static const String description = '插入系统默认配置';
  static const String createdAt = '2024-12-26';

  /// 执行种子数据插入
  static Future<void> up() async {
    try {
      log('开始执行种子数据: $name', name: 'Seed005InsertSystemConfigs');

      // 插入系统配置
      await _insertSystemConfigs();

      log('种子数据完成: $name', name: 'Seed005InsertSystemConfigs');
    } catch (error, stackTrace) {
      log('种子数据失败: $name', error: error, stackTrace: stackTrace, name: 'Seed005InsertSystemConfigs');
      rethrow;
    }
  }

  /// 回滚种子数据
  static Future<void> down() async {
    try {
      log('开始回滚种子数据: $name', name: 'Seed005InsertSystemConfigs');

      // 删除系统配置
      await _deleteSystemConfigs();

      log('回滚完成: $name', name: 'Seed005InsertSystemConfigs');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Seed005InsertSystemConfigs');
      rethrow;
    }
  }

  /// 插入系统配置
  static Future<void> _insertSystemConfigs() async {
    final configs = [
      // 系统配置
      {
        'config_key': 'system.site_title',
        'config_value': 'TTPolyglot',
        'value_type': 'string',
        'category': 'system',
        'display_name': '网站标题',
        'description': '系统显示的标题',
        'is_public': true,
        'sort_order': 1,
      },
      {
        'config_key': 'system.site_description',
        'config_value': 'Multi-language translation management system',
        'value_type': 'string',
        'category': 'system',
        'display_name': '网站描述',
        'description': '系统描述信息',
        'is_public': true,
        'sort_order': 2,
      },
      {
        'config_key': 'system.max_upload_size',
        'config_value': '10485760',
        'value_type': 'number',
        'category': 'system',
        'display_name': '最大上传文件大小',
        'description': '单位：字节 (10MB)',
        'is_public': false,
        'sort_order': 3,
      },
      {
        'config_key': 'system.session_timeout',
        'config_value': '1440',
        'value_type': 'number',
        'category': 'system',
        'display_name': '会话超时时间',
        'description': '单位：分钟 (24小时)',
        'is_public': false,
        'sort_order': 4,
      },
      {
        'config_key': 'system.maintenance_mode',
        'config_value': 'false',
        'value_type': 'boolean',
        'category': 'system',
        'display_name': '维护模式',
        'description': '是否启用维护模式',
        'is_public': false,
        'sort_order': 5,
      },
      // 安全配置
      {
        'config_key': 'security.password_min_length',
        'config_value': '8',
        'value_type': 'number',
        'category': 'security',
        'display_name': '密码最小长度',
        'description': '用户密码最小长度要求',
        'is_public': false,
        'sort_order': 1,
      },
      {
        'config_key': 'security.password_require_special',
        'config_value': 'true',
        'value_type': 'boolean',
        'category': 'security',
        'display_name': '密码需要特殊字符',
        'description': '是否要求密码包含特殊字符',
        'is_public': false,
        'sort_order': 2,
      },
      {
        'config_key': 'security.password_require_number',
        'config_value': 'true',
        'value_type': 'boolean',
        'category': 'security',
        'display_name': '密码需要数字',
        'description': '是否要求密码包含数字',
        'is_public': false,
        'sort_order': 3,
      },
      {
        'config_key': 'security.password_require_uppercase',
        'config_value': 'true',
        'value_type': 'boolean',
        'category': 'security',
        'display_name': '密码需要大写字母',
        'description': '是否要求密码包含大写字母',
        'is_public': false,
        'sort_order': 4,
      },
      {
        'config_key': 'security.login_max_attempts',
        'config_value': '5',
        'value_type': 'number',
        'category': 'security',
        'display_name': '登录最大尝试次数',
        'description': '账户锁定前的最大登录尝试次数',
        'is_public': false,
        'sort_order': 5,
      },
      {
        'config_key': 'security.account_lock_duration',
        'config_value': '30',
        'value_type': 'number',
        'category': 'security',
        'display_name': '账户锁定时长',
        'description': '单位：分钟',
        'is_public': false,
        'sort_order': 6,
      },
      {
        'config_key': 'security.jwt_expire_hours',
        'config_value': '24',
        'value_type': 'number',
        'category': 'security',
        'display_name': 'JWT过期时间',
        'description': '单位：小时',
        'is_public': false,
        'sort_order': 7,
      },
      {
        'config_key': 'security.jwt_refresh_expire_days',
        'config_value': '7',
        'value_type': 'number',
        'category': 'security',
        'display_name': 'JWT刷新过期时间',
        'description': '单位：天',
        'is_public': false,
        'sort_order': 8,
      },
      {
        'config_key': 'security.two_factor_enabled',
        'config_value': 'false',
        'value_type': 'boolean',
        'category': 'security',
        'display_name': '启用双因子认证',
        'description': '是否启用双因子认证功能',
        'is_public': false,
        'sort_order': 9,
      },
      // 翻译配置
      {
        'config_key': 'translation.max_text_length',
        'config_value': '5000',
        'value_type': 'number',
        'category': 'translation',
        'display_name': '单次翻译最大字符数',
        'description': '每次翻译请求的最大字符数限制',
        'is_public': false,
        'sort_order': 1,
      },
      {
        'config_key': 'translation.auto_save_interval',
        'config_value': '30',
        'value_type': 'number',
        'category': 'translation',
        'display_name': '自动保存间隔',
        'description': '单位：秒',
        'is_public': true,
        'sort_order': 2,
      },
      {
        'config_key': 'translation.batch_size_limit',
        'config_value': '100',
        'value_type': 'number',
        'category': 'translation',
        'display_name': '批量翻译数量限制',
        'description': '批量操作的最大条目数',
        'is_public': false,
        'sort_order': 3,
      },
      {
        'config_key': 'translation.auto_translate_enabled',
        'config_value': 'true',
        'value_type': 'boolean',
        'category': 'translation',
        'display_name': '启用自动翻译',
        'description': '是否启用AI自动翻译功能',
        'is_public': true,
        'sort_order': 4,
      },
      {
        'config_key': 'translation.quality_threshold',
        'config_value': '0.8',
        'value_type': 'number',
        'category': 'translation',
        'display_name': '翻译质量阈值',
        'description': '自动批准翻译的最低质量分数',
        'is_public': false,
        'sort_order': 5,
      },
      {
        'config_key': 'translation.review_required',
        'config_value': 'true',
        'value_type': 'boolean',
        'category': 'translation',
        'display_name': '需要审核',
        'description': '翻译是否需要审核才能发布',
        'is_public': false,
        'sort_order': 6,
      },
      // 通知配置
      {
        'config_key': 'notification.email_enabled',
        'config_value': 'false',
        'value_type': 'boolean',
        'category': 'notification',
        'display_name': '邮件通知开关',
        'description': '是否启用邮件通知',
        'is_public': false,
        'sort_order': 1,
      },
      {
        'config_key': 'notification.email_smtp_host',
        'config_value': '',
        'value_type': 'string',
        'category': 'notification',
        'display_name': 'SMTP服务器地址',
        'description': 'SMTP服务器地址',
        'is_public': false,
        'sort_order': 2,
      },
      {
        'config_key': 'notification.email_smtp_port',
        'config_value': '587',
        'value_type': 'number',
        'category': 'notification',
        'display_name': 'SMTP端口',
        'description': 'SMTP服务器端口',
        'is_public': false,
        'sort_order': 3,
      },
      {
        'config_key': 'notification.email_from_address',
        'config_value': 'noreply@ttpolyglot.com',
        'value_type': 'string',
        'category': 'notification',
        'display_name': '发件人邮箱',
        'description': '系统发件人邮箱地址',
        'is_public': false,
        'sort_order': 4,
      },
      {
        'config_key': 'notification.push_enabled',
        'config_value': 'true',
        'value_type': 'boolean',
        'category': 'notification',
        'display_name': '推送通知开关',
        'description': '是否启用推送通知',
        'is_public': true,
        'sort_order': 5,
      },
      {
        'config_key': 'notification.retention_days',
        'config_value': '30',
        'value_type': 'number',
        'category': 'notification',
        'display_name': '通知保留天数',
        'description': '通知的保留天数',
        'is_public': false,
        'sort_order': 6,
      },
      // UI配置
      {
        'config_key': 'ui.default_language',
        'config_value': 'en',
        'value_type': 'string',
        'category': 'ui',
        'display_name': '默认语言',
        'description': '系统默认显示语言',
        'is_public': true,
        'sort_order': 1,
      },
      {
        'config_key': 'ui.theme',
        'config_value': 'light',
        'value_type': 'string',
        'category': 'ui',
        'display_name': '默认主题',
        'description': '系统默认主题',
        'is_public': true,
        'sort_order': 2,
      },
      {
        'config_key': 'ui.items_per_page',
        'config_value': '20',
        'value_type': 'number',
        'category': 'ui',
        'display_name': '每页显示数量',
        'description': '列表页面每页显示的项目数量',
        'is_public': true,
        'sort_order': 3,
      },
      {
        'config_key': 'ui.date_format',
        'config_value': 'YYYY-MM-DD',
        'value_type': 'string',
        'category': 'ui',
        'display_name': '日期格式',
        'description': '系统显示的日期格式',
        'is_public': true,
        'sort_order': 4,
      },
      {
        'config_key': 'ui.time_format',
        'config_value': 'HH:mm:ss',
        'value_type': 'string',
        'category': 'ui',
        'display_name': '时间格式',
        'description': '系统显示的时间格式',
        'is_public': true,
        'sort_order': 5,
      },
      {
        'config_key': 'ui.timezone',
        'config_value': 'UTC',
        'value_type': 'string',
        'category': 'ui',
        'display_name': '默认时区',
        'description': '系统默认时区',
        'is_public': true,
        'sort_order': 6,
      },
      // API配置
      {
        'config_key': 'api.rate_limit_requests',
        'config_value': '1000',
        'value_type': 'number',
        'category': 'api',
        'display_name': 'API速率限制',
        'description': '每15分钟最大请求数',
        'is_public': false,
        'sort_order': 1,
      },
      {
        'config_key': 'api.rate_limit_window',
        'config_value': '15',
        'value_type': 'number',
        'category': 'api',
        'display_name': '速率限制窗口',
        'description': '速率限制时间窗口（分钟）',
        'is_public': false,
        'sort_order': 2,
      },
      {
        'config_key': 'api.request_timeout',
        'config_value': '30',
        'value_type': 'number',
        'category': 'api',
        'display_name': '请求超时时间',
        'description': 'API请求超时时间（秒）',
        'is_public': false,
        'sort_order': 3,
      },
      {
        'config_key': 'api.cors_enabled',
        'config_value': 'true',
        'value_type': 'boolean',
        'category': 'api',
        'display_name': '启用CORS',
        'description': '是否启用跨域资源共享',
        'is_public': false,
        'sort_order': 4,
      },
      {
        'config_key': 'api.documentation_enabled',
        'config_value': 'true',
        'value_type': 'boolean',
        'category': 'api',
        'display_name': '启用API文档',
        'description': '是否启用API文档页面',
        'is_public': true,
        'sort_order': 5,
      },
      {
        'config_key': 'api.version',
        'config_value': 'v1',
        'value_type': 'string',
        'category': 'api',
        'display_name': 'API版本',
        'description': '当前API版本',
        'is_public': true,
        'sort_order': 6,
      },
    ];

    for (final config in configs) {
      log('插入系统配置: ${config['config_key']}', name: 'Seed005InsertSystemConfigs');
    }
  }

  /// 删除系统配置
  static Future<void> _deleteSystemConfigs() async {
    final configKeys = [
      'system.site_title',
      'system.site_description',
      'system.max_upload_size',
      'system.session_timeout',
      'system.maintenance_mode',
      'security.password_min_length',
      'security.password_require_special',
      'security.password_require_number',
      'security.password_require_uppercase',
      'security.login_max_attempts',
      'security.account_lock_duration',
      'security.jwt_expire_hours',
      'security.jwt_refresh_expire_days',
      'security.two_factor_enabled',
      'translation.max_text_length',
      'translation.auto_save_interval',
      'translation.batch_size_limit',
      'translation.auto_translate_enabled',
      'translation.quality_threshold',
      'translation.review_required',
      'notification.email_enabled',
      'notification.email_smtp_host',
      'notification.email_smtp_port',
      'notification.email_from_address',
      'notification.push_enabled',
      'notification.retention_days',
      'ui.default_language',
      'ui.theme',
      'ui.items_per_page',
      'ui.date_format',
      'ui.time_format',
      'ui.timezone',
      'api.rate_limit_requests',
      'api.rate_limit_window',
      'api.request_timeout',
      'api.cors_enabled',
      'api.documentation_enabled',
      'api.version',
    ];

    for (final configKey in configKeys) {
      log('删除系统配置: $configKey', name: 'Seed005InsertSystemConfigs');
    }
  }
}
