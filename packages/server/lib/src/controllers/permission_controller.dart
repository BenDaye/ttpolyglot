import 'package:shelf/shelf.dart';

import '../services/database_service.dart';
import '../services/redis_service.dart';

class PermissionController {
  final DatabaseService databaseService;
  final RedisService redisService;

  PermissionController({
    required this.databaseService,
    required this.redisService,
  });

  Future<Response> getPermissions(Request request) async {
    return Response.ok('{"message": "获取权限列表功能待实现"}', headers: {'Content-Type': 'application/json'});
  }

  Future<Response> getPermission(Request request) async {
    return Response.ok('{"message": "获取权限详情功能待实现"}', headers: {'Content-Type': 'application/json'});
  }
}
