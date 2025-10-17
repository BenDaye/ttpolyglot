import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

class NotificationController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;

  NotificationController({
    required this.databaseService,
    required this.redisService,
  }) : super('NotificationController');

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
}
