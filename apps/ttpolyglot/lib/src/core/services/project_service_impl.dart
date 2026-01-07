import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/services/project_service.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 项目服务实现
class ProjectServiceImpl extends GetxService implements ProjectService {
  ProjectServiceImpl();

  /// 从存储提供者创建项目服务
  static Future<ProjectServiceImpl> create() async {
    try {
      return ProjectServiceImpl();
    } catch (error, stackTrace) {
      LoggerUtils.error('创建项目服务失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<ProjectModel> createProject(CreateProjectRequest request) async {
    // 调用 API 创建项目
    final projectApi = Get.find<ProjectApi>();
    final project = await projectApi.createProject(
      name: request.name,
      description: request.description,
      primaryLanguageId: request.primaryLanguageId!,
      slug: request.slug,
      visibility: request.visibility,
    );

    if (project == null) {
      throw Exception('创建项目失败');
    }

    return project;
  }

  @override
  Future<ProjectModel?> getProject(int projectId) async {
    try {
      final projectApi = Get.find<ProjectApi>();
      final project = await projectApi.getProject(projectId);
      return project;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<ProjectModel> updateProject(int projectId, UpdateProjectRequest request) async {
    final existingProject = await getProject(projectId);
    if (existingProject == null) {
      throw Exception('项目不存在: $projectId');
    }

    // 调用 API 更新项目
    final projectApi = Get.find<ProjectApi>();
    final updatedProject = await projectApi.updateProject(
      projectId: projectId,
      name: request.name,
      description: request.description,
      status: request.status,
      visibility: request.visibility,
    );

    if (updatedProject == null) {
      throw Exception('更新项目失败');
    }

    return updatedProject;
  }

  @override
  Future<bool> deleteProject(int projectId) async {
    // 删除项目配置
    final projectApi = Get.find<ProjectApi>();
    final result = await projectApi.deleteProject(projectId);
    if (result == null) {
      throw Exception('删除项目失败');
    }
    return result;
  }

  @override
  Future<ProjectModel> updateProjectStatus(int projectId, {required bool isActive}) async {
    final projectApi = Get.find<ProjectApi>();
    final updatedProject = await projectApi.updateProjectStatus(projectId, isActive: isActive);
    if (updatedProject == null) {
      throw Exception('切换项目状态失败');
    }
    return updatedProject;
  }

  @override
  Future<ProjectStats> getProjectStats(int projectId) async {
    try {
      final projectApi = Get.find<ProjectApi>();
      final stats = await projectApi.getProjectStats(projectId);
      if (stats == null) {
        throw Exception('获取项目统计失败');
      }
      return stats;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目统计失败', error: error, stackTrace: stackTrace);
      return ProjectStats();
    }
  }
}
