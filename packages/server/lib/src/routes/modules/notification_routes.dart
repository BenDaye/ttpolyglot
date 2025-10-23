import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 通知路由模块
class NotificationRoutes {
  final DatabaseService databaseService;
  final RedisService redisService;
  final Handler Function(Handler) withAuth;

  NotificationRoutes({
    required this.databaseService,
    required this.redisService,
    required this.withAuth,
  });

  /// 配置通知相关路由
  Router configure() {
    final router = Router();
    final notificationController = NotificationController(
      databaseService: databaseService,
      redisService: redisService,
    );

    // 通知基本操作
    router.get('/notifications', notificationController.getNotifications);
    router.get('/notifications/<id>', notificationController.getNotification);
    router.put('/notifications/<id>/read', notificationController.markAsRead);
    router.post('/notifications/mark-all-read', notificationController.markAllAsRead);
    router.delete('/notifications/<id>', notificationController.deleteNotification);

    // 通知设置
    router.get('/notification-settings', notificationController.getNotificationSettings);
    router.put('/notification-settings', notificationController.updateNotificationSettings);
    router.post('/notification-settings/batch', notificationController.batchUpdateNotificationSettings);

    // 项目通知设置
    router.get('/projects/<id>/notification-settings', notificationController.getProjectNotificationSettings);
    router.put('/projects/<id>/notification-settings', notificationController.updateProjectNotificationSettings);

    return router;
  }
}
