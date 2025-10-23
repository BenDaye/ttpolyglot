import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 通知设置 API
class NotificationSettingsApi {
  /// 获取用户通知设置
  Future<List<NotificationSettingsModel>> getUserNotificationSettings({
    int? projectId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (projectId != null) {
        queryParameters['projectId'] = projectId;
      }

      final response = await HttpClient.get<List<dynamic>>(
        '/notification-settings',
        query: queryParameters,
      );

      final data = response.data as List<dynamic>;
      return data.map((item) => NotificationSettingsModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (error, stackTrace) {
      Logger.error('[getUserNotificationSettings] 获取通知设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目通知设置
  Future<List<NotificationSettingsModel>> getProjectNotificationSettings({
    required int projectId,
  }) async {
    try {
      final response = await HttpClient.get<List<dynamic>>(
        '/projects/$projectId/notification-settings',
      );

      final data = response.data as List<dynamic>;
      return data.map((item) => NotificationSettingsModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (error, stackTrace) {
      Logger.error('[getProjectNotificationSettings] 获取项目通知设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新通知设置
  Future<NotificationSettingsModel> updateNotificationSetting({
    int? projectId,
    required NotificationTypeEnum notificationType,
    required NotificationChannelEnum channel,
    required bool isEnabled,
  }) async {
    try {
      final response = await HttpClient.put<Map<String, dynamic>>(
        '/notification-settings',
        data: {
          if (projectId != null) 'projectId': projectId,
          'notificationType': notificationType.value,
          'channel': channel.value,
          'isEnabled': isEnabled,
        },
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return NotificationSettingsModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('[updateNotificationSetting] 更新通知设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新项目通知设置
  Future<NotificationSettingsModel> updateProjectNotificationSetting({
    required int projectId,
    required NotificationTypeEnum notificationType,
    required NotificationChannelEnum channel,
    required bool isEnabled,
  }) async {
    try {
      final response = await HttpClient.put<Map<String, dynamic>>(
        '/projects/$projectId/notification-settings',
        data: {
          'notificationType': notificationType.value,
          'channel': channel.value,
          'isEnabled': isEnabled,
        },
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return NotificationSettingsModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('[updateProjectNotificationSetting] 更新项目通知设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 批量更新通知设置
  Future<List<NotificationSettingsModel>> batchUpdateNotificationSettings({
    int? projectId,
    required List<NotificationSettingUpdate> updates,
  }) async {
    try {
      final response = await HttpClient.post<List<dynamic>>(
        '/notification-settings/batch',
        data: {
          if (projectId != null) 'projectId': projectId,
          'updates': updates.map((u) => u.toJson()).toList(),
        },
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as List<dynamic>;
      return data.map((item) => NotificationSettingsModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (error, stackTrace) {
      Logger.error('[batchUpdateNotificationSettings] 批量更新通知设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 初始化默认通知设置
  Future<void> initializeDefaultSettings({
    int? projectId,
  }) async {
    try {
      await HttpClient.post(
        '/notification-settings/initialize',
        data: {
          if (projectId != null) 'projectId': projectId,
        },
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: false, // 不显示成功提示
          ).toJson(),
        ),
      );
    } catch (error, stackTrace) {
      Logger.error('[initializeDefaultSettings] 初始化默认设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查通知是否启用
  Future<bool> isNotificationEnabled({
    int? projectId,
    required NotificationTypeEnum notificationType,
    required NotificationChannelEnum channel,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'notificationType': notificationType.value,
        'channel': channel.value,
      };

      if (projectId != null) {
        queryParameters['projectId'] = projectId;
      }

      final response = await HttpClient.get<Map<String, dynamic>>(
        '/notification-settings/check',
        query: queryParameters,
      );

      final data = response.data as Map<String, dynamic>;
      return data['isEnabled'] as bool? ?? true;
    } catch (error, stackTrace) {
      Logger.error('[isNotificationEnabled] 检查通知状态失败', error: error, stackTrace: stackTrace);
      return true; // 默认启用
    }
  }
}
