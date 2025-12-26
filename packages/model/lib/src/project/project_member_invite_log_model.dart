import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'project_member_invite_log_model.freezed.dart';
part 'project_member_invite_log_model.g.dart';

/// 项目成员邀请日志模型
@freezed
class ProjectMemberInviteLogModel with _$ProjectMemberInviteLogModel {
  const factory ProjectMemberInviteLogModel({
    /// 日志ID
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 成员ID（邀请链接ID）
    @JsonKey(name: 'member_id') @FlexibleIntConverter() required int memberId,

    /// 用户ID（使用邀请的用户ID）
    @JsonKey(name: 'user_id') required String userId,

    /// 是否接受邀请
    @JsonKey(name: 'accepted') @Default(false) bool accepted,

    /// 接受时间
    @JsonKey(name: 'accepted_at') @NullableTimesConverter() DateTime? acceptedAt,

    /// IP地址
    @JsonKey(name: 'ip_address') String? ipAddress,

    /// 用户代理
    @JsonKey(name: 'user_agent') String? userAgent,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,
  }) = _ProjectMemberInviteLogModel;

  factory ProjectMemberInviteLogModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberInviteLogModelFromJson(json);
}
