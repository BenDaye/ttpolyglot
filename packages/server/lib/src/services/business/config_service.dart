import 'package:ttpolyglot_model/model.dart';

import '../../config/server_config.dart';
import '../../utils/infrastructure/cache_utils.dart';
import '../base_service.dart';
import '../infrastructure/database_service.dart';
import '../infrastructure/redis_service.dart';

/// 系统配置服务
class ConfigService extends BaseService {
  final DatabaseService _databaseService;
  final RedisService _redisService;

  ConfigService({
    required DatabaseService databaseService,
    required RedisService redisService,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        super('ConfigService');

  /// 获取配置值
  Future<String?> getConfigValue(String key) async {
    try {
      // 先检查缓存
      final cacheKey = CacheUtils.systemConfigKey(key);
      final cachedValue = await _redisService.get(cacheKey);

      if (cachedValue != null) {
        return cachedValue;
      }

      // 从数据库查询
      final result = await _databaseService.query('''
        SELECT config_value FROM system_configs
        WHERE config_key = @key AND is_active = true
      ''', {'key': key});

      if (result.isEmpty) {
        return null;
      }

      final value = result.first[0] as String?;

      // 缓存配置值
      if (value != null) {
        await _redisService.set(cacheKey, value, ServerConfig.cacheConfigTtl);
      }

      return value;
    } catch (error, stackTrace) {
      logError('获取配置值失败', error: error, stackTrace: stackTrace, context: {'config_key': key});
      rethrow;
    }
  }

  /// 获取解析后的配置值
  Future<dynamic> getParsedConfigValue(String key) async {
    final value = await getConfigValue(key);
    if (value == null) return null;

    // 根据配置键确定值类型
    final config = await getConfigByKey(key);
    if (config == null) return value;

    return config.getParsedValue();
  }

  /// 根据键获取配置项
  Future<SystemConfigModel?> getConfigByKey(String key) async {
    try {
      final result = await _databaseService.query('''
        SELECT * FROM system_configs
        WHERE config_key = @key AND is_active = true
      ''', {'key': key});

      if (result.isEmpty) {
        return null;
      }

      return SystemConfigModel.fromJson(result.first.toColumnMap());
    } catch (error, stackTrace) {
      logError('获取配置项失败', error: error, stackTrace: stackTrace, context: {'config_key': key});
      rethrow;
    }
  }

  /// 获取配置列表
  Future<List<SystemConfigModel>> getConfigs({
    String? category,
    bool? isPublic,
    bool? isEditable,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final conditions = <String>[];
      final parameters = <String, dynamic>{};

      if (category != null && category.isNotEmpty) {
        conditions.add('category = @category');
        parameters['category'] = category;
      }

      if (isPublic != null) {
        conditions.add('is_public = @is_public');
        parameters['is_public'] = isPublic;
      }

      if (isEditable != null) {
        conditions.add('is_editable = @is_editable');
        parameters['is_editable'] = isEditable;
      }

      final offset = (page - 1) * limit;
      parameters['limit'] = limit;
      parameters['offset'] = offset;

      final sql = '''
        SELECT * FROM system_configs
        WHERE is_active = true
        ${conditions.isNotEmpty ? 'AND ${conditions.join(' AND ')}' : ''}
        ORDER BY category, sort_order, display_name
        LIMIT @limit OFFSET @offset
      ''';

      final result = await _databaseService.query(sql, parameters);

      return result.map((row) => SystemConfigModel.fromJson(row.toColumnMap())).toList();
    } catch (error, stackTrace) {
      logError('获取配置列表失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取公开配置
  Future<Map<String, dynamic>> getPublicConfigs() async {
    try {
      const cacheKey = 'config:public';
      final cached = await _redisService.getJson(cacheKey);

      if (cached != null) {
        return cached;
      }

      final configs = await getConfigs(isPublic: true);
      final publicConfigs = <String, dynamic>{};

      for (final config in configs) {
        final key = config.configKey;
        final value = config.getParsedValue();
        if (value != null) {
          publicConfigs[key] = value;
        }
      }

      // 缓存公开配置
      await _redisService.setJson(cacheKey, publicConfigs, ServerConfig.cacheConfigTtl);

      return publicConfigs;
    } catch (error, stackTrace) {
      logError('获取公开配置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新配置值
  Future<SystemConfigModel> updateConfig({
    required String key,
    required String value,
    String? updatedBy,
    String? reason,
  }) async {
    return execute<SystemConfigModel>(
      () async {
        // 获取当前配置
        final currentConfig = await getConfigByKey(key);
        if (currentConfig == null) {
          throwNotFound('配置项不存在');
        }

        if (!currentConfig.isEditable) {
          throwBusiness('配置项不可编辑');
        }

        // 验证值
        if (!currentConfig.validateValue(value)) {
          throwValidation('配置值无效');
        }

        // 更新数据库
        await _databaseService.query('''
        UPDATE system_configs
        SET config_value = @value,
            updated_by = @updated_by,
            change_reason = @reason,
            updated_at = CURRENT_TIMESTAMP
        WHERE config_key = @key
      ''', {
          'key': key,
          'value': value,
          'updated_by': updatedBy,
          'reason': reason,
        });

        // 清除缓存
        await _clearConfigCache(key);

        // 获取更新后的配置
        final updatedConfig = await getConfigByKey(key);

        logInfo('配置更新成功', context: {'config_key': key, 'value': value});

        return updatedConfig!;
      },
      operationName: 'updateConfig',
    );
  }

  /// 批量更新配置
  Future<List<SystemConfigModel>> updateConfigs({
    required Map<String, String> updates,
    String? updatedBy,
    String? reason,
  }) async {
    return execute<List<SystemConfigModel>>(
      () async {
        final updatedConfigs = <SystemConfigModel>[];

        await _databaseService.transaction(() async {
          for (final entry in updates.entries) {
            final key = entry.key;
            final value = entry.value;

            final currentConfig = await getConfigByKey(key);
            if (currentConfig == null) {
              logDebug('配置项不存在，跳过', context: {'config_key': key});
              continue;
            }

            if (!currentConfig.isEditable) {
              logDebug('配置项不可编辑，跳过', context: {'config_key': key});
              continue;
            }

            if (!currentConfig.validateValue(value)) {
              logDebug('配置值无效，跳过', context: {'config_key': key});
              continue;
            }

            await _databaseService.query('''
            UPDATE system_configs
            SET config_value = @value,
                updated_by = @updated_by,
                change_reason = @reason,
                updated_at = CURRENT_TIMESTAMP
            WHERE config_key = @key
          ''', {
              'key': key,
              'value': value,
              'updated_by': updatedBy,
              'reason': reason,
            });

            updatedConfigs.add(currentConfig.copyWith(configValue: value));
          }
        });

        // 清除所有相关缓存
        await _clearAllConfigCache();

        logInfo('批量配置更新完成', context: {'count': updatedConfigs.length});

        return updatedConfigs;
      },
      operationName: 'updateConfigs',
    );
  }

  /// 重置配置为默认值
  Future<SystemConfigModel> resetConfigToDefault(String key, {String? updatedBy}) async {
    return execute<SystemConfigModel>(
      () async {
        final config = await getConfigByKey(key);
        if (config == null) {
          throwNotFound('配置项不存在');
        }

        if (config.defaultValue == null) {
          throwBusiness('配置项没有默认值');
        }

        return await updateConfig(
          key: key,
          value: config.defaultValue!,
          updatedBy: updatedBy,
          reason: '重置为默认值',
        );
      },
      operationName: 'resetConfigToDefault',
    );
  }

  /// 获取配置分类列表
  Future<List<String>> getConfigCategories() async {
    try {
      const cacheKey = 'config:categories';
      final cached = await _redisService.getJson(cacheKey);

      if (cached != null) {
        return List<String>.from(cached['categories'] ?? []);
      }

      final result = await _databaseService.query('''
        SELECT DISTINCT category
        FROM system_configs
        WHERE is_active = true
        ORDER BY category
      ''');

      final categories = result.map((row) => row[0] as String).toList();

      // 缓存分类列表
      await _redisService.setJson(cacheKey, {'categories': categories}, ServerConfig.cacheConfigTtl);

      return categories;
    } catch (error, stackTrace) {
      logError('获取配置分类失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 清除配置缓存
  Future<void> _clearConfigCache(String key) async {
    final cacheKey = CacheUtils.systemConfigKey(key);
    await _redisService.delete(cacheKey);

    // 如果是公开配置，也清除公开配置缓存
    final config = await getConfigByKey(key);
    if (config != null && config.isPublic) {
      await _redisService.delete('config:public');
    }
  }

  /// 清除所有配置缓存
  Future<void> _clearAllConfigCache() async {
    await _redisService.deleteByPattern('config:*');
  }

  /// 获取常用配置值的方法

  /// 获取站点标题
  Future<String> getSiteTitle() async {
    return await getParsedConfigValue('system.site_title') ?? 'TTPolyglot';
  }

  /// 获取站点描述
  Future<String> getSiteDescription() async {
    return await getParsedConfigValue('system.site_description') ?? '';
  }

  /// 获取最大上传文件大小
  Future<int> getMaxUploadSize() async {
    return await getParsedConfigValue('system.max_upload_size') ?? 10485760; // 10MB
  }

  /// 获取会话超时时间
  Future<int> getSessionTimeout() async {
    return await getParsedConfigValue('system.session_timeout') ?? 1440; // 24小时（分钟）
  }

  /// 检查是否启用维护模式
  Future<bool> isMaintenanceMode() async {
    return await getParsedConfigValue('system.maintenance_mode') ?? false;
  }

  /// 获取密码最小长度
  Future<int> getPasswordMinLength() async {
    return await getParsedConfigValue('security.password_min_length') ?? 8;
  }

  /// 检查密码是否需要特殊字符
  Future<bool> isPasswordRequireSpecial() async {
    return await getParsedConfigValue('security.password_require_special') ?? true;
  }

  /// 获取登录最大尝试次数
  Future<int> getLoginMaxAttempts() async {
    return await getParsedConfigValue('security.login_max_attempts') ?? 5;
  }

  /// 获取JWT过期时间（小时）
  Future<int> getJwtExpireHours() async {
    return await getParsedConfigValue('security.jwt_expire_hours') ?? 24;
  }

  /// 获取默认翻译提供商
  Future<String?> getDefaultTranslationProvider() async {
    return await getParsedConfigValue('translation.default_provider');
  }

  /// 获取单次翻译最大字符数
  Future<int> getMaxTextLength() async {
    return await getParsedConfigValue('translation.max_text_length') ?? 5000;
  }

  /// 检查是否启用邮件通知
  Future<bool> isEmailNotificationEnabled() async {
    return await getParsedConfigValue('notification.email_enabled') ?? false;
  }

  /// 获取SMTP主机
  Future<String?> getSmtpHost() async {
    return await getParsedConfigValue('notification.email_smtp_host');
  }

  /// 获取SMTP端口
  Future<int?> getSmtpPort() async {
    return await getParsedConfigValue('notification.email_smtp_port');
  }
}
