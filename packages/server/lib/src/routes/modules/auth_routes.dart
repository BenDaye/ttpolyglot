import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 认证路由模块
class AuthRoutes {
  final AuthService authService;
  final Handler Function(Handler) withAuth;

  AuthRoutes({
    required this.authService,
    required this.withAuth,
  });

  /// 配置认证相关路由
  Router configure() {
    final router = Router();
    final authController = AuthController(
      authService: authService,
    );

    // 公开路由（无需认证）
    router.post('/auth/login', authController.login);
    router.post('/auth/refresh', authController.refresh);
    router.post('/auth/register', authController.register);
    router.post('/auth/forgot-password', authController.forgotPassword);
    router.post('/auth/reset-password', authController.resetPassword);
    router.get('/auth/verify-email', authController.verifyEmail);
    router.post('/auth/resend-verification', authController.resendVerification);

    // 需要认证的路由
    router.post('/auth/logout', withAuth(authController.logout));

    return router;
  }
}
