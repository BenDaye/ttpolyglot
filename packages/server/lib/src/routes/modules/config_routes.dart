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

    router.get('/configs/public', configController.getPublicConfigs);
    router.get('/configs', configController.getConfigs);
    router.get('/configs/<key>', configController.getConfig);
    router.put('/configs/<key>', configController.updateConfig);
    router.post('/configs', configController.createConfig);
    router.delete('/configs/<key>', configController.deleteConfig);
    router.get('/configs/categories', configController.getConfigCategories);
    router.post('/configs/batch', configController.batchUpdateConfigs);
    router.post('/configs/reset/<key>', configController.resetConfig);

    return router;
  }
}
