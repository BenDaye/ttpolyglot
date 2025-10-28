import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/converter/converters.dart';

import '../enums/notification_channel_enum.dart';
import '../enums/notification_type_enum.dart';

part 'notification_settings_model.freezed.dart';
part 'notification_settings_model.g.dart';

/// 通知设置模型
@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const factory NotificationSettingsModel({
    /// 通知设置ID
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 项目ID
    @JsonKey(name: 'project_id') @FlexibleIntConverter() int? projectId,

    /// 通知类型
    @JsonKey(name: 'notification_type') @NotificationTypeEnumConverter() required NotificationTypeEnum notificationType,

    /// 通知渠道
    @JsonKey(name: 'channel') @NotificationChannelEnumConverter() required NotificationChannelEnum channel,

    /// 是否启用
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) => _$NotificationSettingsModelFromJson(json);
}

/// 更新通知设置请求模型
@freezed
class UpdateNotificationSettingsRequest with _$UpdateNotificationSettingsRequest {
  const factory UpdateNotificationSettingsRequest({
    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 项目ID
    @JsonKey(name: 'project_id') @FlexibleIntConverter() int? projectId,

    /// 通知类型
    @JsonKey(name: 'notification_type') @NotificationTypeEnumConverter() required NotificationTypeEnum notificationType,

    /// 通知渠道
    @JsonKey(name: 'channel') @NotificationChannelEnumConverter() required NotificationChannelEnum channel,

    /// 是否启用
    @JsonKey(name: 'is_enabled') required bool isEnabled,
  }) = _UpdateNotificationSettingsRequest;

  factory UpdateNotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNotificationSettingsRequestFromJson(json);
}

/// 批量更新通知设置请求模型
@freezed
class BatchUpdateNotificationSettingsRequest with _$BatchUpdateNotificationSettingsRequest {
  const factory BatchUpdateNotificationSettingsRequest({
    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 项目ID
    @JsonKey(name: 'project_id') @FlexibleIntConverter() int? projectId,

    /// 通知设置更新项
    @JsonKey(name: 'updates') required List<NotificationSettingUpdate> updates,
  }) = _BatchUpdateNotificationSettingsRequest;

  factory BatchUpdateNotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchUpdateNotificationSettingsRequestFromJson(json);
}

/// 通知设置更新项
@freezed
class NotificationSettingUpdate with _$NotificationSettingUpdate {
  const factory NotificationSettingUpdate({
    /// 通知类型
    @JsonKey(name: 'notification_type') @NotificationTypeEnumConverter() required NotificationTypeEnum notificationType,

    /// 通知渠道
    @JsonKey(name: 'channel') @NotificationChannelEnumConverter() required NotificationChannelEnum channel,

    /// 是否启用
    @JsonKey(name: 'is_enabled') required bool isEnabled,
  }) = _NotificationSettingUpdate;

  factory NotificationSettingUpdate.fromJson(Map<String, dynamic> json) => _$NotificationSettingUpdateFromJson(json);
}
