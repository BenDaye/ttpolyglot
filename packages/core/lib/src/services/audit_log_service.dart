import 'package:ttpolyglot_model/model.dart';

/// 审计日志服务接口
abstract class AuditLogService {
  /// 创建审计日志
  Future<AuditLogModel> createAuditLog(AuditLogModel auditLog);

  /// 获取审计日志
  Future<AuditLogModel?> getAuditLog(int logId);

  /// 获取用户的审计日志
  Future<List<AuditLogModel>> getUserAuditLogs(
    String userId, {
    String? action,
    String? resourceType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// 获取资源的审计日志
  Future<List<AuditLogModel>> getResourceAuditLogs(
    String resourceType,
    int resourceId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// 根据操作类型获取审计日志
  Future<List<AuditLogModel>> getAuditLogsByAction(
    String action, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// 搜索审计日志
  Future<List<AuditLogModel>> searchAuditLogs({
    String? userId,
    String? action,
    String? resourceType,
    int? resourceId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// 删除审计日志（通常用于数据清理）
  Future<void> deleteAuditLog(int logId);

  /// 批量删除审计日志
  Future<int> deleteAuditLogsByDateRange(DateTime startDate, DateTime endDate);
}
