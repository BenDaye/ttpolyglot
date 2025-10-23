import 'package:freezed_annotation/freezed_annotation.dart';

/// 通知类型枚举
enum NotificationTypeEnum {
  projectCreated('project.created', '项目创建', '当创建新项目时通知您', '📁'),
  projectUpdated('project.updated', '项目更新', '当项目信息更新时通知您', '✏️'),
  projectArchived('project.archived', '项目归档', '当项目被归档时通知您', '📦'),
  memberInvited('member.invited', '成员邀请', '当您被邀请加入项目时通知您', '📨'),
  memberJoined('member.joined', '成员加入', '当新成员加入项目时通知您', '👋'),
  memberRemoved('member.removed', '成员移除', '当成员被移除时通知您', '👋'),
  memberRoleChanged('member.role_changed', '成员角色变更', '当成员角色变更时通知您', '🔄'),
  translationCreated('translation.created', '翻译创建', '当创建新翻译时通知您', '🌐'),
  translationUpdated('translation.updated', '翻译更新', '当翻译内容更新时通知您', '🌐'),
  translationDeleted('translation.deleted', '翻译删除', '当翻译被删除时通知您', '🗑️'),
  commentMentioned('comment.mentioned', '评论提及', '当有人在评论中提及您时通知您', '💬'),
  commentReplied('comment.replied', '评论回复', '当有人回复您的评论时通知您', '💬');

  const NotificationTypeEnum(this.value, this.displayName, this.description, this.icon);

  final String value;
  final String displayName;
  final String description;
  final String icon;

  /// 根据值获取对应的枚举
  static NotificationTypeEnum fromValue(String value) {
    return NotificationTypeEnum.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationTypeEnum.projectCreated,
    );
  }
}

/// NotificationTypeEnum 的 JSON 转换器
class NotificationTypeEnumConverter implements JsonConverter<NotificationTypeEnum, String> {
  const NotificationTypeEnumConverter();

  @override
  NotificationTypeEnum fromJson(String json) {
    return NotificationTypeEnum.fromValue(json);
  }

  @override
  String toJson(NotificationTypeEnum object) => object.value;
}
