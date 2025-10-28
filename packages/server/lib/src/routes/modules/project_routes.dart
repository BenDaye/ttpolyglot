import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';

/// 项目路由模块
class ProjectRoutes {
  final ProjectService projectService;
  final ProjectMemberService projectMemberService;
  final Handler Function(Handler) withAuth;

  ProjectRoutes({
    required this.projectService,
    required this.projectMemberService,
    required this.withAuth,
  });

  /// 配置项目相关路由
  Router configure() {
    final router = Router();
    final projectController = ProjectController(
      projectService: projectService,
    );
    final projectMemberController = ProjectMemberController(
      projectMemberService: projectMemberService,
    );

    // 项目基本操作
    router.get('/projects', projectController.getProjects);
    router.post('/projects', projectController.createProject);
    // 具体路径必须在通配符路由之前定义
    router.get('/projects/check-name', projectController.checkProjectName);
    router.get('/projects/stats', projectController.stats);
    // 通配符路由
    router.get('/projects/<id>', projectController.getProject);
    router.put('/projects/<id>', projectController.updateProject);
    router.delete('/projects/<id>', projectController.deleteProject);
    router.post('/projects/<id>/archive', projectController.archiveProject);
    router.post('/projects/<id>/restore', projectController.restoreProject);

    // 项目成员管理
    router.get('/projects/<id>/members', projectController.getProjectMembers);
    router.post('/projects/<id>/members', projectController.addProjectMember);
    router.put('/projects/<id>/members/<userId>', projectController.updateMemberRole);
    router.delete('/projects/<id>/members/<userId>', projectController.removeProjectMember);

    // 项目语言管理
    router.get('/projects/<id>/languages', projectController.getProjectLanguages);
    router.post('/projects/<id>/languages', projectController.addProjectLanguage);
    router.put('/projects/<id>/languages/<languageId>', projectController.updateLanguageSettings);
    router.delete('/projects/<id>/languages/<languageId>', projectController.removeProjectLanguage);

    // 项目统计
    router.get('/projects/<id>/statistics', projectController.getProjectStatistics);
    router.get('/projects/<id>/activity', projectController.getProjectActivity);

    // 项目成员上限
    router.patch('/projects/<id>/member-limit', projectController.updateMemberLimit);

    // 挂载项目成员邀请相关路由
    router.mount('/projects', projectMemberController.router.call);

    return router;
  }
}
