import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 翻译路由模块
class TranslationRoutes {
  final DatabaseService databaseService;
  final RedisService redisService;
  final Handler Function(Handler) withAuth;

  TranslationRoutes({
    required this.databaseService,
    required this.redisService,
    required this.withAuth,
  });

  /// 配置翻译相关路由
  Router configure() {
    final router = Router();
    final translationController = TranslationController(
      databaseService: databaseService,
      redisService: redisService,
    );

    // 翻译条目 CRUD
    router.get('/projects/<projectId>/translations', translationController.getTranslations);
    router.post('/projects/<projectId>/translations', translationController.createTranslation);
    router.get('/projects/<projectId>/translations/<entryId>', translationController.getTranslation);
    router.put('/projects/<projectId>/translations/<entryId>', translationController.updateTranslation);
    router.patch('/projects/<projectId>/translations/<entryId>', translationController.patchTranslation);
    router.delete('/projects/<projectId>/translations/<entryId>', translationController.deleteTranslation);

    // 批量操作
    router.post('/projects/<projectId>/translations/batch', translationController.batchOperations);
    router.delete('/projects/<projectId>/translations/batch', translationController.batchDelete);
    router.post('/projects/<projectId>/translations/batch/translate', translationController.batchTranslate);
    router.post('/projects/<projectId>/translations/batch/approve', translationController.batchApprove);

    // 翻译历史和版本
    router.get('/projects/<projectId>/translations/<entryId>/history', translationController.getTranslationHistory);
    router.get('/projects/<projectId>/translations/<entryId>/versions', translationController.getTranslationVersions);
    router.post('/projects/<projectId>/translations/<entryId>/revert', translationController.revertTranslation);

    // 翻译状态管理
    router.post('/projects/<projectId>/translations/<entryId>/assign', translationController.assignTranslator);
    router.post('/projects/<projectId>/translations/<entryId>/submit', translationController.submitTranslation);
    router.post('/projects/<projectId>/translations/<entryId>/review', translationController.reviewTranslation);
    router.post('/projects/<projectId>/translations/<entryId>/approve', translationController.approveTranslation);
    router.post('/projects/<projectId>/translations/<entryId>/reject', translationController.rejectTranslation);

    // 翻译搜索和过滤
    router.get('/projects/<projectId>/translations/search', translationController.searchTranslations);
    router.get('/projects/<projectId>/translations/filter', translationController.filterTranslations);

    return router;
  }
}
