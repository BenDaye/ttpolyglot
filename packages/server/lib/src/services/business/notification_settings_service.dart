import 'dart:developer';

import 'package:ttpolyglot_model/model.dart';

import '../base_service.dart';
import '../infrastructure/database_service.dart';
import '../infrastructure/redis_service.dart';

/// 通知设置服务
class NotificationSettingsService extends BaseService {
  final DatabaseService _databaseService;
  final RedisService _redisService;

  NotificationSettingsService({
    required DatabaseService databaseService,
    required RedisService redisService,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        super('NotificationSettingsService');

  /// 获取用户的通知设置
  Future<List<NotificationSettingsModel>> getUserNotificationSettings({
    required String userId,
    int? projectId,
  }) async {
    try {
      log('[getUserNotificationSettings] userId=$userId, projectId=$projectId', name: 'NotificationSettingsService');

      // 构建查询条件
      final conditions = <String>['user_id = @user_id'];
      final parameters = <String, dynamic>{'user_id': userId};

      if (projectId != null) {
        conditions.add('project_id = @project_id');
        parameters['project_id'] = projectId;
      }

      final sql = '''
        SELECT * FROM {notification_settings}
        WHERE ${conditions.join(' AND ')}
        ORDER BY notification_type, channel
      ''';

      final result = await _databaseService.query(sql, parameters);

      return result.map((row) => NotificationSettingsModel.fromJson(row.toColumnMap())).toList();
    } catch (error, stackTrace) {
      log('[getUserNotificationSettings]', error: error, stackTrace: stackTrace, name: 'NotificationSettingsService');
      rethrow;
    }
  }

  /// 更新通知设置
  Future<NotificationSettingsModel> updateNotificationSetting({
    required String userId,
    int? projectId,
    required String notificationType,
    required String channel,
    required bool isEnabled,
  }) async {
    try {
      log('[updateNotificationSetting] userId=$userId, type=$notificationType, channel=$channel, enabled=$isEnabled',
          name: 'NotificationSettingsService');

      // 检查是否已存在
      final existing = await _getNotificationSetting(
        userId: userId,
        projectId: projectId,
        notificationType: notificationType,
        channel: channel,
      );

      late int settingId;

      if (existing != null) {
        // 更新现有设置
        await _databaseService.query('''
          UPDATE {notification_settings}
          SET is_enabled = @is_enabled,
              updated_at = CURRENT_TIMESTAMP
          WHERE user_id = @user_id
            AND ${projectId != null ? 'project_id = @project_id' : 'project_id IS NULL'}
            AND notification_type = @notification_type
            AND channel = @channel
        ''', {
          'user_id': userId,
          if (projectId != null) 'project_id': projectId,
          'notification_type': notificationType,
          'channel': channel,
          'is_enabled': isEnabled,
        });

        settingId = existing.id;
      } else {
        // 创建新设置
        final result = await _databaseService.query('''
          INSERT INTO {notification_settings} (
            user_id, project_id, notification_type, channel, is_enabled
          ) VALUES (
            @user_id, @project_id, @notification_type, @channel, @is_enabled
          ) RETURNING id
        ''', {
          'user_id': userId,
          'project_id': projectId,
          'notification_type': notificationType,
          'channel': channel,
          'is_enabled': isEnabled,
        });

        // notification_settings.id 是 SERIAL 类型（INTEGER），需要安全转换
        final rawSettingId = result.first[0];
        settingId = (rawSettingId is int) ? rawSettingId : int.parse(rawSettingId.toString());
      }

      // 清除缓存
      await _clearNotificationSettingsCache(userId, projectId);

      // 获取更新后的设置
      final setting = await _getNotificationSettingById(settingId);

      log('[updateNotificationSetting] 通知设置更新成功', name: 'NotificationSettingsService');

      return setting!;
    } catch (error, stackTrace) {
      log('[updateNotificationSetting]', error: error, stackTrace: stackTrace, name: 'NotificationSettingsService');
      rethrow;
    }
  }

  /// 批量更新通知设置
  Future<List<NotificationSettingsModel>> batchUpdateNotificationSettings({
    required String userId,
    int? projectId,
    required List<NotificationSettingUpdate> updates,
  }) async {
    try {
      log('[batchUpdateNotificationSettings] userId=$userId, updates count=${updates.length}',
          name: 'NotificationSettingsService');

      final updatedSettings = <NotificationSettingsModel>[];

      await _databaseService.transaction(() async {
        for (final update in updates) {
          final setting = await updateNotificationSetting(
            userId: userId,
            projectId: projectId,
            notificationType: update.notificationType.value,
            channel: update.channel.value,
            isEnabled: update.isEnabled,
          );
          updatedSettings.add(setting);
        }
      });

      log('[batchUpdateNotificationSettings] 批量更新完成', name: 'NotificationSettingsService');

      return updatedSettings;
    } catch (error, stackTrace) {
      log('[batchUpdateNotificationSettings]',
          error: error, stackTrace: stackTrace, name: 'NotificationSettingsService');
      rethrow;
    }
  }

  /// 初始化用户的默认通知设置
  Future<void> initializeDefaultSettings({
    required String userId,
    int? projectId,
  }) async {
    try {
      log('[initializeDefaultSettings] userId=$userId, projectId=$projectId', name: 'NotificationSettingsService');

      // 默认通知设置
      final defaultSettings = [
        // 邮件通知 - 重要事件
        {
          'type': NotificationTypeEnum.memberInvited.value,
          'channel': NotificationChannelEnum.email.value,
          'enabled': true
        },
        {
          'type': NotificationTypeEnum.projectCreated.value,
          'channel': NotificationChannelEnum.email.value,
          'enabled': true
        },
        {
          'type': NotificationTypeEnum.memberRoleChanged.value,
          'channel': NotificationChannelEnum.email.value,
          'enabled': true
        },

        // 站内通知 - 所有事件
        {
          'type': NotificationTypeEnum.memberInvited.value,
          'channel': NotificationChannelEnum.inApp.value,
          'enabled': true
        },
        {
          'type': NotificationTypeEnum.memberJoined.value,
          'channel': NotificationChannelEnum.inApp.value,
          'enabled': true
        },
        {
          'type': NotificationTypeEnum.memberRemoved.value,
          'channel': NotificationChannelEnum.inApp.value,
          'enabled': true
        },
        {
          'type': NotificationTypeEnum.memberRoleChanged.value,
          'channel': NotificationChannelEnum.inApp.value,
          'enabled': true
        },
        {
          'type': NotificationTypeEnum.projectCreated.value,
          'channel': NotificationChannelEnum.inApp.value,
          'enabled': true
        },
        {
          'type': NotificationTypeEnum.projectUpdated.value,
          'channel': NotificationChannelEnum.inApp.value,
          'enabled': true
        },
        {
          'type': NotificationTypeEnum.commentMentioned.value,
          'channel': NotificationChannelEnum.inApp.value,
          'enabled': true
        },
      ];

      await _databaseService.transaction(() async {
        for (final setting in defaultSettings) {
          // 检查是否已存在
          final existing = await _getNotificationSetting(
            userId: userId,
            projectId: projectId,
            notificationType: setting['type'] as String,
            channel: setting['channel'] as String,
          );

          if (existing == null) {
            await _databaseService.query('''
              INSERT INTO {notification_settings} (
                user_id, project_id, notification_type, channel, is_enabled
              ) VALUES (
                @user_id, @project_id, @notification_type, @channel, @is_enabled
              )
            ''', {
              'user_id': userId,
              'project_id': projectId,
              'notification_type': setting['type'],
              'channel': setting['channel'],
              'is_enabled': setting['enabled'],
            });
          }
        }
      });

      log('[initializeDefaultSettings] 默认设置初始化完成', name: 'NotificationSettingsService');
    } catch (error, stackTrace) {
      log('[initializeDefaultSettings]', error: error, stackTrace: stackTrace, name: 'NotificationSettingsService');
      rethrow;
    }
  }

  /// 检查是否启用了某个通知
  Future<bool> isNotificationEnabled({
    required String userId,
    int? projectId,
    required String notificationType,
    required String channel,
  }) async {
    try {
      // 先检查缓存
      final cacheKey = _getNotificationCacheKey(userId, projectId, notificationType, channel);
      final cached = await _redisService.get(cacheKey);

      if (cached != null) {
        return cached == 'true';
      }

      // 从数据库查询
      final setting = await _getNotificationSetting(
        userId: userId,
        projectId: projectId,
        notificationType: notificationType,
        channel: channel,
      );

      // 如果没有设置，返回默认值（true）
      final enabled = setting?.isEnabled ?? true;

      // 缓存结果
      await _redisService.set(cacheKey, enabled ? 'true' : 'false', 3600);

      return enabled;
    } catch (error, stackTrace) {
      log('[isNotificationEnabled]', error: error, stackTrace: stackTrace, name: 'NotificationSettingsService');
      // 发生错误时返回默认值
      return true;
    }
  }

  /// 发送通知（根据用户设置）
  Future<void> sendNotificationIfEnabled({
    required String userId,
    int? projectId,
    required String notificationType,
    required String channel,
    required Map<String, dynamic> notificationData,
  }) async {
    try {
      final enabled = await isNotificationEnabled(
        userId: userId,
        projectId: projectId,
        notificationType: notificationType,
        channel: channel,
      );

      if (!enabled) {
        log('[sendNotificationIfEnabled] 通知已被用户禁用', name: 'NotificationSettingsService');
        return;
      }

      // TODO: 实际发送通知的逻辑
      // 这里应该调用通知服务来发送通知
      log('[sendNotificationIfEnabled] 发送通知: type=$notificationType, channel=$channel',
          name: 'NotificationSettingsService');
    } catch (error, stackTrace) {
      log('[sendNotificationIfEnabled]', error: error, stackTrace: stackTrace, name: 'NotificationSettingsService');
    }
  }

  // ========== 辅助方法 ==========

  /// 获取通知设置
  Future<NotificationSettingsModel?> _getNotificationSetting({
    required String userId,
    int? projectId,
    required String notificationType,
    required String channel,
  }) async {
    final result = await _databaseService.query('''
      SELECT * FROM {notification_settings}
      WHERE user_id = @user_id
        AND ${projectId != null ? 'project_id = @project_id' : 'project_id IS NULL'}
        AND notification_type = @notification_type
        AND channel = @channel
    ''', {
      'user_id': userId,
      if (projectId != null) 'project_id': projectId,
      'notification_type': notificationType,
      'channel': channel,
    });

    if (result.isEmpty) {
      return null;
    }

    return NotificationSettingsModel.fromJson(result.first.toColumnMap());
  }

  /// 根据ID获取通知设置
  Future<NotificationSettingsModel?> _getNotificationSettingById(int id) async {
    final result = await _databaseService.query('''
      SELECT * FROM {notification_settings}
      WHERE id = @id
    ''', {'id': id});

    if (result.isEmpty) {
      return null;
    }

    return NotificationSettingsModel.fromJson(result.first.toColumnMap());
  }

  /// 生成缓存键
  String _getNotificationCacheKey(String userId, int? projectId, String notificationType, String channel) {
    return 'notification_setting:$userId:${projectId ?? 'global'}:$notificationType:$channel';
  }

  /// 清除通知设置缓存
  Future<void> _clearNotificationSettingsCache(String userId, int? projectId) async {
    await _redisService.deleteByPattern('notification_setting:$userId:${projectId ?? 'global'}:*');
  }
}
