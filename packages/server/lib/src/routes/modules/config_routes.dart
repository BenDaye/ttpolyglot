import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 系统配置路由模块
class ConfigRoutes {
  final DatabaseService databaseService;
  final RedisService redisService;
  final Handler Function(Handler) withAuth;

  ConfigRoutes({
    required this.databaseService,
    required this.redisService,
    required this.withAuth,
  });

  /// 配置系统配置相关路由
  Router configure() {
    final router = Router();
    final configController = ConfigController(
      databaseService: databaseService,
      redisService: redisService,
    );

    // 公开路由（无需认证）
    router.get('/configs/public', configController.getPublicConfigs);

    // 需要认证的路由
    router.get('/configs', withAuth(configController.getConfigs));
    router.get('/configs/<key>', withAuth(configController.getConfig));
    router.put('/configs/<key>', withAuth(configController.updateConfig));
    router.post('/configs', withAuth(configController.createConfig));
    router.delete('/configs/<key>', withAuth(configController.deleteConfig));
    router.get('/configs/categories', withAuth(configController.getConfigCategories));
    router.post('/configs/batch', withAuth(configController.batchUpdateConfigs));
    router.post('/configs/reset/<key>', withAuth(configController.resetConfig));

    return router;
  }
}
