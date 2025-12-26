import 'package:ttpolyglot_model/model.dart';

/// 项目成员邀请日志服务接口
abstract class ProjectMemberInviteLogService {
  /// 创建邀请日志
  Future<ProjectMemberInviteLogModel> createInviteLog(ProjectMemberInviteLogModel log);

  /// 获取邀请日志
  Future<ProjectMemberInviteLogModel?> getInviteLog(int logId);

  /// 获取成员的所有邀请日志
  Future<List<ProjectMemberInviteLogModel>> getMemberInviteLogs(
    int memberId, {
    bool? accepted,
    int? limit,
    int? offset,
  });

  /// 获取用户的所有邀请日志
  Future<List<ProjectMemberInviteLogModel>> getUserInviteLogs(
    String userId, {
    int? limit,
    int? offset,
  });

  /// 获取项目的所有邀请日志
  Future<List<ProjectMemberInviteLogModel>> getProjectInviteLogs(
    int projectId, {
    bool? accepted,
    int? limit,
    int? offset,
  });

  /// 删除邀请日志
  Future<void> deleteInviteLog(int logId);

  /// 清理旧的邀请日志
  Future<int> cleanupOldInviteLogs({int keepDays = 90});
}
