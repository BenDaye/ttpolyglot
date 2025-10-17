import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 文件路由模块
class FileRoutes {
  final DatabaseService databaseService;
  final RedisService redisService;
  final Handler Function(Handler) withAuth;

  FileRoutes({
    required this.databaseService,
    required this.redisService,
    required this.withAuth,
  });

  /// 配置文件相关路由
  Router configure() {
    final router = Router();
    final fileController = FileController(
      databaseService: databaseService,
      redisService: redisService,
    );

    router.post('/files/upload', fileController.uploadFile);
    router.get('/files/<id>', fileController.getFile);
    router.get('/files/<id>/download', fileController.downloadFile);
    router.delete('/files/<id>', fileController.deleteFile);

    // 项目文件导入导出
    router.post('/projects/<id>/import', fileController.importTranslations);
    router.post('/projects/<id>/export', fileController.exportTranslations);
    router.get('/projects/<id>/export/<taskId>', fileController.getExportStatus);

    return router;
  }
}
