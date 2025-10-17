import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 角色权限路由模块
class RolePermissionRoutes {
  final DatabaseService databaseService;
  final RedisService redisService;
  final Handler Function(Handler) withAuth;

  RolePermissionRoutes({
    required this.databaseService,
    required this.redisService,
    required this.withAuth,
  });

  /// 配置角色权限相关路由
  Router configure() {
    final router = Router();
    final roleController = RoleController(
      databaseService: databaseService,
      redisService: redisService,
    );

    final permissionController = PermissionController(
      databaseService: databaseService,
      redisService: redisService,
    );

    // 角色管理
    router.get('/roles', roleController.getRoles);
    router.post('/roles', roleController.createRole);
    router.get('/roles/<id>', roleController.getRole);
    router.put('/roles/<id>', roleController.updateRole);
    router.delete('/roles/<id>', roleController.deleteRole);

    // 权限管理
    router.get('/permissions', permissionController.getPermissions);
    router.get('/permissions/<id>', permissionController.getPermission);

    // 角色权限关联
    router.get('/roles/<id>/permissions', roleController.getRolePermissions);
    router.post('/roles/<id>/permissions', roleController.assignPermissions);
    router.delete('/roles/<id>/permissions/<permissionId>', roleController.revokePermission);

    // 用户角色管理
    router.get('/users/<userId>/roles', roleController.getUserRoles);
    router.post('/users/<userId>/roles', roleController.assignUserRole);
    router.delete('/users/<userId>/roles/<roleId>', roleController.revokeUserRole);

    return router;
  }
}
