import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

class PermissionController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;

  PermissionController({
    required this.databaseService,
    required this.redisService,
  }) : super('PermissionController');

  Future<Response> getPermissions(Request request) async {
    return ResponseUtils.success(message: '获取权限列表功能待实现');
  }

  Future<Response> getPermission(Request request) async {
    return ResponseUtils.success(message: '获取权限详情功能待实现');
  }
}
