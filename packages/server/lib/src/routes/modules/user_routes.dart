import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 用户路由模块
class UserRoutes {
  final UserService userService;
  final UserSettingsService userSettingsService;
  final FileUploadService fileUploadService;
  final Handler Function(Handler) withAuth;

  UserRoutes({
    required this.userService,
    required this.userSettingsService,
    required this.fileUploadService,
    required this.withAuth,
  });

  /// 配置用户相关路由
  Router configure() {
    final router = Router();
    final userController = UserController(
      userService: userService,
      fileUploadService: fileUploadService,
    );

    final userSettingsController = UserSettingsController(
      userSettingsService: userSettingsService,
    );

    // 创建用户子路由器
    // ⚠️ 重要：更具体的路由必须先注册！
    final userRouter = Router();
    userRouter.get('/', userController.getUsers);
    // 先注册 /me 相关路由（更具体）
    userRouter.get('/me', userController.getCurrentUser);
    userRouter.put('/me', userController.updateCurrentUser);
    userRouter.post('/me/avatar', userController.uploadAvatar);
    userRouter.delete('/me/avatar', userController.deleteAvatar);
    userRouter.post('/me/change-password', userController.changePassword);
    // 挂载用户设置路由（在 /me 下）
    userRouter.mount('/me', userSettingsController.router.call);

    // 挂载用户路由并应用认证中间件
    router.mount('/users', withAuth(userRouter.call));

    return router;
  }
}
