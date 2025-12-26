import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// 通知模型
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    /// 通知ID
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 通知标题
    @JsonKey(name: 'title') required String title,

    /// 通知内容
    @JsonKey(name: 'message') required String message,

    /// 通知类型
    @JsonKey(name: 'type') required String type,

    /// 通知优先级
    @JsonKey(name: 'priority') @Default('normal') String priority,

    /// 是否已读
    @JsonKey(name: 'is_read') @Default(false) bool isRead,

    /// 是否为系统通知
    @JsonKey(name: 'is_system') @Default(false) bool isSystem,

    /// 操作URL
    @JsonKey(name: 'action_url') String? actionUrl,

    /// 元数据（JSONB格式）
    @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 阅读时间
    @JsonKey(name: 'read_at') @NullableTimesConverter() DateTime? readAt,
  }) = _NotificationModel;

  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  /// 是否未读
  bool get isUnread => !isRead;
}
