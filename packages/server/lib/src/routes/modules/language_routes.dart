import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/language/language_controller.dart';
import '../../services/business/language_service.dart';
import '../../services/infrastructure/database_service.dart';
import '../../services/infrastructure/redis_service.dart';

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
    final languageService = LanguageService(
      databaseService: databaseService,
      redisService: redisService,
    );

    final languageController = LanguageController(
      languageService: languageService,
    );

    return languageController.router;
  }
}
