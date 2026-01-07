import 'package:ttpolyglot_model/model.dart';

/// 项目服务抽象接口
abstract class ProjectService {
  /// 创建项目
  Future<ProjectModel> createProject(CreateProjectRequest request);

  /// 获取项目
  Future<ProjectModel?> getProject(int projectId);

  /// 更新项目
  Future<ProjectModel> updateProject(int projectId, UpdateProjectRequest request);

  /// 删除项目
  Future<void> deleteProject(int projectId);

  /// 切换项目状态（激活/停用）
  Future<ProjectModel> updateProjectStatus(int projectId, {required bool isActive});

  /// 获取项目统计信息
  Future<ProjectStats> getProjectStats(int projectId);
}
