import 'package:ttpolyglot_model/model.dart';

/// 通知服务接口
abstract class NotificationService {
  /// 创建通知
  Future<NotificationModel> createNotification(NotificationModel notification);

  /// 批量创建通知
  Future<List<NotificationModel>> batchCreateNotifications(
    List<NotificationModel> notifications,
  );

  /// 获取通知
  Future<NotificationModel?> getNotification(int notificationId);

  /// 获取用户的通知列表
  Future<List<NotificationModel>> getUserNotifications(
    String userId, {
    bool? isRead,
    String? type,
    String? priority,
    int? limit,
    int? offset,
  });

  /// 获取未读通知数量
  Future<int> getUnreadCount(String userId);

  /// 标记通知为已读
  Future<NotificationModel> markAsRead(int notificationId);

  /// 批量标记为已读
  Future<int> batchMarkAsRead(List<int> notificationIds);

  /// 标记所有通知为已读
  Future<int> markAllAsRead(String userId);

  /// 删除通知
  Future<void> deleteNotification(int notificationId);

  /// 批量删除通知
  Future<int> batchDeleteNotifications(List<int> notificationIds);

  /// 删除用户的所有通知
  Future<int> deleteAllUserNotifications(String userId);

  /// 删除已读通知（清理功能）
  Future<int> deleteReadNotifications(String userId, {DateTime? beforeDate});
}
