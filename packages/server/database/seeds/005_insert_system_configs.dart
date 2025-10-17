

import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';
import 'base_seed.dart';

/// 种子: 005 - 插入系统配置
/// 创建时间: 2024-12-26
/// 描述: 插入系统默认配置项
class Seed005InsertSystemConfigs extends BaseSeed {
  @override
  String get name => '005_insert_system_configs';

  @override
  String get description => '插入系统配置';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> run() async {
    try {
      LoggerUtils.info('开始插入系统配置数据');

      // 定义系统配置项
      final configs = [
        // ========== 系统基础配置 ==========
        {
          'key': 'system.name',
          'value': 'TTPolyglot',
          'type': 'string',
          'description': '系统名称',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'system.version',
          'value': '1.0.0',
          'type': 'string',
          'description': '系统版本',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'system.description',
          'value': 'TTPolyglot 多语言翻译管理系统',
          'type': 'string',
          'description': '系统描述',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'system.logo_url',
          'value': '/assets/logo.png',
          'type': 'string',
          'description': '系统Logo URL',
          'is_public': true,
          'is_encrypted': false,
        },

        // ========== 用户相关配置 ==========
        {
          'key': 'user.registration_enabled',
          'value': 'true',
          'type': 'boolean',
          'description': '是否允许用户注册',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'user.email_verification_required',
          'value': 'true',
          'type': 'boolean',
          'description': '是否需要邮箱验证',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'user.default_role',
          'value': 'viewer',
          'type': 'string',
          'description': '用户默认角色',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'user.password_min_length',
          'value': '8',
          'type': 'integer',
          'description': '密码最小长度',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'user.password_require_uppercase',
          'value': 'true',
          'type': 'boolean',
          'description': '密码是否需要大写字母',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'user.password_require_number',
          'value': 'true',
          'type': 'boolean',
          'description': '密码是否需要数字',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'user.password_require_special',
          'value': 'false',
          'type': 'boolean',
          'description': '密码是否需要特殊字符',
          'is_public': true,
          'is_encrypted': false,
        },

        // ========== JWT配置 ==========
        {
          'key': 'jwt.access_token_expiry',
          'value': '3600',
          'type': 'integer',
          'description': 'JWT访问令牌过期时间（秒）',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'jwt.refresh_token_expiry',
          'value': '604800',
          'type': 'integer',
          'description': 'JWT刷新令牌过期时间（秒）',
          'is_public': false,
          'is_encrypted': false,
        },

        // ========== 项目相关配置 ==========
        {
          'key': 'project.max_per_user',
          'value': '10',
          'type': 'integer',
          'description': '每个用户最大项目数',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'project.default_source_language',
          'value': 'en-US',
          'type': 'string',
          'description': '项目默认源语言',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'project.allow_public_projects',
          'value': 'false',
          'type': 'boolean',
          'description': '是否允许公开项目',
          'is_public': true,
          'is_encrypted': false,
        },

        // ========== 翻译相关配置 ==========
        {
          'key': 'translation.auto_approve_enabled',
          'value': 'false',
          'type': 'boolean',
          'description': '是否自动批准翻译',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'translation.require_review',
          'value': 'true',
          'type': 'boolean',
          'description': '翻译是否需要审核',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'translation.max_key_length',
          'value': '255',
          'type': 'integer',
          'description': '翻译键最大长度',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'translation.max_value_length',
          'value': '10000',
          'type': 'integer',
          'description': '翻译值最大长度',
          'is_public': true,
          'is_encrypted': false,
        },

        // ========== 文件上传配置 ==========
        {
          'key': 'upload.max_file_size',
          'value': '10485760',
          'type': 'integer',
          'description': '最大文件上传大小（字节）',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'upload.allowed_extensions',
          'value': 'json,po,pot,xliff,yml,yaml,xml,csv',
          'type': 'string',
          'description': '允许上传的文件扩展名',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'upload.storage_path',
          'value': '/app/uploads',
          'type': 'string',
          'description': '文件存储路径',
          'is_public': false,
          'is_encrypted': false,
        },

        // ========== 邮件配置 ==========
        {
          'key': 'email.enabled',
          'value': 'false',
          'type': 'boolean',
          'description': '是否启用邮件服务',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'email.from_address',
          'value': 'noreply@ttpolyglot.com',
          'type': 'string',
          'description': '发件人邮箱地址',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'email.from_name',
          'value': 'TTPolyglot',
          'type': 'string',
          'description': '发件人名称',
          'is_public': false,
          'is_encrypted': false,
        },

        // ========== 缓存配置 ==========
        {
          'key': 'cache.enabled',
          'value': 'true',
          'type': 'boolean',
          'description': '是否启用缓存',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'cache.default_ttl',
          'value': '3600',
          'type': 'integer',
          'description': '缓存默认TTL（秒）',
          'is_public': false,
          'is_encrypted': false,
        },

        // ========== 速率限制配置 ==========
        {
          'key': 'rate_limit.enabled',
          'value': 'true',
          'type': 'boolean',
          'description': '是否启用速率限制',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'rate_limit.max_requests',
          'value': '100',
          'type': 'integer',
          'description': '速率限制最大请求数',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'rate_limit.window_seconds',
          'value': '60',
          'type': 'integer',
          'description': '速率限制时间窗口（秒）',
          'is_public': false,
          'is_encrypted': false,
        },

        // ========== 审计日志配置 ==========
        {
          'key': 'audit.enabled',
          'value': 'true',
          'type': 'boolean',
          'description': '是否启用审计日志',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'audit.retention_days',
          'value': '90',
          'type': 'integer',
          'description': '审计日志保留天数',
          'is_public': false,
          'is_encrypted': false,
        },

        // ========== 翻译服务API配置 ==========
        {
          'key': 'translation_api.google_enabled',
          'value': 'false',
          'type': 'boolean',
          'description': '是否启用Google翻译API',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'translation_api.deepl_enabled',
          'value': 'false',
          'type': 'boolean',
          'description': '是否启用DeepL翻译API',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'translation_api.openai_enabled',
          'value': 'false',
          'type': 'boolean',
          'description': '是否启用OpenAI翻译API',
          'is_public': false,
          'is_encrypted': false,
        },

        // ========== 通知配置 ==========
        {
          'key': 'notification.enabled',
          'value': 'true',
          'type': 'boolean',
          'description': '是否启用通知功能',
          'is_public': false,
          'is_encrypted': false,
        },
        {
          'key': 'notification.retention_days',
          'value': '30',
          'type': 'integer',
          'description': '通知保留天数',
          'is_public': false,
          'is_encrypted': false,
        },

        // ========== 维护模式 ==========
        {
          'key': 'maintenance.enabled',
          'value': 'false',
          'type': 'boolean',
          'description': '是否启用维护模式',
          'is_public': true,
          'is_encrypted': false,
        },
        {
          'key': 'maintenance.message',
          'value': '系统正在维护中，请稍后再试',
          'type': 'string',
          'description': '维护模式提示信息',
          'is_public': true,
          'is_encrypted': false,
        },
      ];

      // 插入系统配置数据
      await insertData('system_configs', configs);

      LoggerUtils.info('系统配置数据插入完成，共 ${configs.length} 项配置');
    } catch (error, stackTrace) {
      LoggerUtils.error('插入系统配置数据失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
