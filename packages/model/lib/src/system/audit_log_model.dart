import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'audit_log_model.freezed.dart';
part 'audit_log_model.g.dart';

/// 审计日志模型
@freezed
class AuditLogModel with _$AuditLogModel {
  const factory AuditLogModel({
    /// 日志ID
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 用户ID
    @JsonKey(name: 'user_id') String? userId,

    /// 操作类型
    @JsonKey(name: 'action') required String action,

    /// 资源类型
    @JsonKey(name: 'resource_type') required String resourceType,

    /// 资源ID
    @JsonKey(name: 'resource_id') @FlexibleIntConverter() int? resourceId,

    /// 旧值（JSONB格式）
    @JsonKey(name: 'old_values') Map<String, dynamic>? oldValues,

    /// 新值（JSONB格式）
    @JsonKey(name: 'new_values') Map<String, dynamic>? newValues,

    /// IP地址
    @JsonKey(name: 'ip_address') String? ipAddress,

    /// 用户代理
    @JsonKey(name: 'user_agent') String? userAgent,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,
  }) = _AuditLogModel;

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => _$AuditLogModelFromJson(json);
}
