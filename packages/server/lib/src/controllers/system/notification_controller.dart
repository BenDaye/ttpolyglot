import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

class NotificationController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;
  late final NotificationSettingsService _notificationSettingsService;

  NotificationController({
    required this.databaseService,
    required this.redisService,
  }) : super('NotificationController') {
    _notificationSettingsService = NotificationSettingsService(
      databaseService: databaseService,
      redisService: redisService,
    );
  }

  Future<Response> getNotifications(Request request) async {
    return ResponseUtils.success(message: '获取通知列表功能待实现');
  }

  Future<Response> getNotification(Request request) async {
    return ResponseUtils.success(message: '获取通知详情功能待实现');
  }

  Future<Response> markAsRead(Request request) async {
    return ResponseUtils.success(message: '标记为已读功能待实现');
  }

  Future<Response> markAllAsRead(Request request) async {
    return ResponseUtils.success(message: '标记全部为已读功能待实现');
  }

  Future<Response> deleteNotification(Request request) async {
    return ResponseUtils.success(message: '删除通知功能待实现');
  }

  // 通知设置相关方法
  Future<Response> getNotificationSettings(Request request) async {
    try {
      // 获取当前用户
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '未授权访问');
      }

      // 获取查询参数中的 projectId（可选）
      final projectIdStr = request.url.queryParameters['projectId'];
      final projectId = projectIdStr != null ? int.tryParse(projectIdStr) : null;

      ServerLogger.info('[getNotificationSettings] userId=$userId, projectId=$projectId');

      // 获取用户的通知设置
      final settings = await _notificationSettingsService.getUserNotificationSettings(
        userId: userId,
        projectId: projectId,
      );

      // 如果没有设置，初始化默认设置
      if (settings.isEmpty) {
        await _notificationSettingsService.initializeDefaultSettings(
          userId: userId,
          projectId: projectId,
        );
        final newSettings = await _notificationSettingsService.getUserNotificationSettings(
          userId: userId,
          projectId: projectId,
        );
        return ResponseUtils.success(data: newSettings.map((s) => s.toJson()).toList());
      }

      return ResponseUtils.success(data: settings.map((s) => s.toJson()).toList());
    } catch (error, stackTrace) {
      ServerLogger.error('[getNotificationSettings]', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: error is ServerException ? error.message : '获取通知设置失败');
    }
  }

  Future<Response> updateNotificationSettings(Request request) async {
    try {
      // 获取当前用户
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '未授权访问');
      }

      // 解析请求体
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final projectId = body['projectId'] as int?;
      final notificationType = body['notificationType'] as String?;
      final channel = body['channel'] as String?;
      final isEnabled = body['isEnabled'] as bool?;

      if (notificationType == null || channel == null || isEnabled == null) {
        return ResponseUtils.error(message: '缺少必要参数');
      }

      ServerLogger.info(
          '[updateNotificationSettings] userId=$userId, projectId=$projectId, type=$notificationType, channel=$channel, enabled=$isEnabled');

      // 更新通知设置
      final updatedSetting = await _notificationSettingsService.updateNotificationSetting(
        userId: userId,
        projectId: projectId,
        notificationType: notificationType,
        channel: channel,
        isEnabled: isEnabled,
      );

      return ResponseUtils.success(
        data: updatedSetting.toJson(),
        message: '通知设置更新成功',
      );
    } catch (error, stackTrace) {
      ServerLogger.error('[updateNotificationSettings]', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: error is ServerException ? error.message : '更新通知设置失败');
    }
  }

  Future<Response> batchUpdateNotificationSettings(Request request) async {
    try {
      // 获取当前用户
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '未授权访问');
      }

      // 解析请求体
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final projectId = body['projectId'] as int?;
      final updatesJson = body['updates'] as List<dynamic>?;

      if (updatesJson == null || updatesJson.isEmpty) {
        return ResponseUtils.error(message: '更新列表不能为空');
      }

      ServerLogger.info(
          '[batchUpdateNotificationSettings] userId=$userId, projectId=$projectId, updates count=${updatesJson.length}');

      // 将 JSON 转换为 NotificationSettingUpdate 对象
      final updates =
          updatesJson.map((json) => NotificationSettingUpdate.fromJson(json as Map<String, dynamic>)).toList();

      // 批量更新通知设置
      final updatedSettings = await _notificationSettingsService.batchUpdateNotificationSettings(
        userId: userId,
        projectId: projectId,
        updates: updates,
      );

      return ResponseUtils.success(
        data: updatedSettings.map((s) => s.toJson()).toList(),
        message: '批量更新通知设置成功',
      );
    } catch (error, stackTrace) {
      ServerLogger.error('[batchUpdateNotificationSettings]', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: error is ServerException ? error.message : '批量更新通知设置失败');
    }
  }

  Future<Response> getProjectNotificationSettings(Request request, String id) async {
    try {
      // 获取当前用户
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '未授权访问');
      }

      // 解析项目ID
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '无效的项目ID');
      }

      ServerLogger.info('[getProjectNotificationSettings] userId=$userId, projectId=$projectId');

      // 获取用户的项目通知设置
      final settings = await _notificationSettingsService.getUserNotificationSettings(
        userId: userId,
        projectId: projectId,
      );

      // 如果没有设置，初始化默认设置
      if (settings.isEmpty) {
        await _notificationSettingsService.initializeDefaultSettings(
          userId: userId,
          projectId: projectId,
        );
        final newSettings = await _notificationSettingsService.getUserNotificationSettings(
          userId: userId,
          projectId: projectId,
        );
        return ResponseUtils.success(data: newSettings.map((s) => s.toJson()).toList());
      }

      return ResponseUtils.success(data: settings.map((s) => s.toJson()).toList());
    } catch (error, stackTrace) {
      ServerLogger.error('[getProjectNotificationSettings]', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: error is ServerException ? error.message : '获取项目通知设置失败');
    }
  }

  Future<Response> updateProjectNotificationSettings(Request request, String id) async {
    try {
      // 获取当前用户
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '未授权访问');
      }

      // 解析项目ID
      final projectId = int.tryParse(id);
      if (projectId == null) {
        return ResponseUtils.error(message: '无效的项目ID');
      }

      // 解析请求体
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final notificationType = body['notificationType'] as String?;
      final channel = body['channel'] as String?;
      final isEnabled = body['isEnabled'] as bool?;

      if (notificationType == null || channel == null || isEnabled == null) {
        return ResponseUtils.error(message: '缺少必要参数');
      }

      ServerLogger.info(
          '[updateProjectNotificationSettings] userId=$userId, projectId=$projectId, type=$notificationType, channel=$channel, enabled=$isEnabled');

      // 更新通知设置
      final updatedSetting = await _notificationSettingsService.updateNotificationSetting(
        userId: userId,
        projectId: projectId,
        notificationType: notificationType,
        channel: channel,
        isEnabled: isEnabled,
      );

      return ResponseUtils.success(
        data: updatedSetting.toJson(),
        message: '通知设置更新成功',
      );
    } catch (error, stackTrace) {
      ServerLogger.error('[updateProjectNotificationSettings]', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(message: error is ServerException ? error.message : '更新项目通知设置失败');
    }
  }
}
