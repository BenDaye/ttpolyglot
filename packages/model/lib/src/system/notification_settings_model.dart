import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings_model.freezed.dart';
part 'notification_settings_model.g.dart';

/// 通知设置模型
@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const factory NotificationSettingsModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'project_id') int? projectId,
    @JsonKey(name: 'notification_type') required String notificationType,
    @JsonKey(name: 'channel') required String channel,
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) => _$NotificationSettingsModelFromJson(json);
}

/// 更新通知设置请求模型
@freezed
class UpdateNotificationSettingsRequest with _$UpdateNotificationSettingsRequest {
  const factory UpdateNotificationSettingsRequest({
    required String userId,
    int? projectId,
    required String notificationType,
    required String channel,
    required bool isEnabled,
  }) = _UpdateNotificationSettingsRequest;

  factory UpdateNotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNotificationSettingsRequestFromJson(json);
}

/// 批量更新通知设置请求模型
@freezed
class BatchUpdateNotificationSettingsRequest with _$BatchUpdateNotificationSettingsRequest {
  const factory BatchUpdateNotificationSettingsRequest({
    required String userId,
    int? projectId,
    required List<NotificationSettingUpdate> updates,
  }) = _BatchUpdateNotificationSettingsRequest;

  factory BatchUpdateNotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchUpdateNotificationSettingsRequestFromJson(json);
}

/// 通知设置更新项
@freezed
class NotificationSettingUpdate with _$NotificationSettingUpdate {
  const factory NotificationSettingUpdate({
    required String notificationType,
    required String channel,
    required bool isEnabled,
  }) = _NotificationSettingUpdate;

  factory NotificationSettingUpdate.fromJson(Map<String, dynamic> json) => _$NotificationSettingUpdateFromJson(json);
}

/// 通知类型枚举
class NotificationType {
  // 项目相关
  static const String projectCreated = 'project.created';
  static const String projectUpdated = 'project.updated';
  static const String projectArchived = 'project.archived';

  // 成员相关
  static const String memberInvited = 'member.invited';
  static const String memberJoined = 'member.joined';
  static const String memberRemoved = 'member.removed';
  static const String memberRoleChanged = 'member.role_changed';

  // 翻译相关
  static const String translationCreated = 'translation.created';
  static const String translationUpdated = 'translation.updated';
  static const String translationDeleted = 'translation.deleted';

  // 评论相关
  static const String commentMentioned = 'comment.mentioned';
  static const String commentReplied = 'comment.replied';

  static const List<String> all = [
    projectCreated,
    projectUpdated,
    projectArchived,
    memberInvited,
    memberJoined,
    memberRemoved,
    memberRoleChanged,
    translationCreated,
    translationUpdated,
    translationDeleted,
    commentMentioned,
    commentReplied,
  ];

  static bool isValid(String type) => all.contains(type);

  static String getDisplayName(String type) {
    switch (type) {
      case projectCreated:
        return '项目创建';
      case projectUpdated:
        return '项目更新';
      case projectArchived:
        return '项目归档';
      case memberInvited:
        return '成员邀请';
      case memberJoined:
        return '成员加入';
      case memberRemoved:
        return '成员移除';
      case memberRoleChanged:
        return '成员角色变更';
      case translationCreated:
        return '翻译创建';
      case translationUpdated:
        return '翻译更新';
      case translationDeleted:
        return '翻译删除';
      case commentMentioned:
        return '评论提及';
      case commentReplied:
        return '评论回复';
      default:
        return type;
    }
  }

  static String getDescription(String type) {
    switch (type) {
      case projectCreated:
        return '当新项目创建时通知';
      case projectUpdated:
        return '当项目信息更新时通知';
      case projectArchived:
        return '当项目被归档时通知';
      case memberInvited:
        return '当您被邀请加入项目时通知';
      case memberJoined:
        return '当新成员加入项目时通知';
      case memberRemoved:
        return '当成员被移除时通知';
      case memberRoleChanged:
        return '当成员角色变更时通知';
      case translationCreated:
        return '当新翻译创建时通知';
      case translationUpdated:
        return '当翻译更新时通知';
      case translationDeleted:
        return '当翻译删除时通知';
      case commentMentioned:
        return '当有人在评论中@您时通知';
      case commentReplied:
        return '当有人回复您的评论时通知';
      default:
        return type;
    }
  }
}

/// 通知渠道枚举
class NotificationChannel {
  static const String email = 'email';
  static const String inApp = 'in_app';

  static const List<String> all = [email, inApp];

  static bool isValid(String channel) => all.contains(channel);

  static String getDisplayName(String channel) {
    switch (channel) {
      case email:
        return '邮件';
      case inApp:
        return '站内信';
      default:
        return channel;
    }
  }
}
