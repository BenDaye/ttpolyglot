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

  /// 配置需认证的项目路由
  Router configure() {
    final router = Router();
    final projectController = ProjectController(
      projectService: projectService,
    );
    final projectMemberController = ProjectMemberController(
      projectMemberService: projectMemberService,
      projectService: projectService,
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
    router.get('/projects/<id>/stats', projectController.getProjectStatistics);
    router.get('/projects/<id>/statistics', projectController.getProjectStatistics);
    router.get('/projects/<id>/activity', projectController.getProjectActivity);

    // 项目成员上限
    router.patch('/projects/<id>/member-limit', projectController.updateMemberLimit);

    // 所有权转移
    router.post('/projects/<id>/transfer-ownership', projectController.transferOwnership);

    // 邀请链接管理（需认证）
    router.post('/projects/<projectId>/invites', projectMemberController.generateInvite);
    router.get('/projects/<projectId>/invites', projectMemberController.getProjectInvites);
    router.delete('/projects/<projectId>/invites/<inviteId>', projectMemberController.revokeInvite);

    // 接受邀请（需认证）
    router.post('/projects/invites/<inviteCode>/accept', projectMemberController.acceptInvite);

    return router;
  }

  /// 配置公开路由（无需认证）
  Router publicRouter() {
    final router = Router();
    final projectMemberController = ProjectMemberController(
      projectMemberService: projectMemberService,
      projectService: projectService,
    );

    // 获取邀请信息（公开，无需认证）
    router.get('/projects/invites/<inviteCode>/info', projectMemberController.getInviteInfo);

    return router;
  }
}
