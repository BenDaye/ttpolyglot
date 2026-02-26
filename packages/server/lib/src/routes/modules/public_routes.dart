import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 公开访问路由模块
///
/// 提供无需认证的公开 API 端点
class PublicRoutes {
  final DatabaseService databaseService;

  PublicRoutes({
    required this.databaseService,
  });

  /// 配置公开路由
  Router configure() {
    final router = Router();
    final publicAccessController = PublicAccessController(
      databaseService: databaseService,
    );

    // 公开获取项目翻译数据
    // GET /public/projects/<slug>/translations?page=1&limit=1000
    router.get('/public/projects/<slug>/translations', publicAccessController.getTranslations);

    return router;
  }
}
