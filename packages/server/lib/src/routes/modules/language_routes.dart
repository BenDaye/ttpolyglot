import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 语言路由模块
class LanguageRoutes {
  final DatabaseService databaseService;
  final RedisService redisService;
  final Handler Function(Handler) withAuth;

  LanguageRoutes({
    required this.databaseService,
    required this.redisService,
    required this.withAuth,
  });

  /// 配置语言相关路由
  Router configure() {
    final router = Router();
    final languageController = LanguageController(
      databaseService: databaseService,
      redisService: redisService,
    );

    router.get('/languages', languageController.getLanguages);
    router.post('/languages', languageController.createLanguage);
    router.get('/languages/<code>', languageController.getLanguage);
    router.put('/languages/<code>', languageController.updateLanguage);
    router.delete('/languages/<code>', languageController.deleteLanguage);

    return router;
  }
}
