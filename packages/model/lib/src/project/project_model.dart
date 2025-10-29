import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

/// 项目模型
@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    /// 项目ID
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 项目名称
    @JsonKey(name: 'name') required String name,

    /// 项目slug
    @JsonKey(name: 'slug') required String slug,

    /// 项目描述
    @JsonKey(name: 'description') String? description,

    /// 项目所有者ID
    @JsonKey(name: 'owner_id') required String ownerId,

    /// 项目状态
    @JsonKey(name: 'status') required String status,

    /// 项目可见性
    @JsonKey(name: 'visibility') required String visibility,

    /// 项目主语言ID
    @JsonKey(name: 'primary_language_id') @FlexibleIntConverter() required int primaryLanguageId,

    /// 项目总键数
    @JsonKey(name: 'total_keys') @FlexibleIntConverter() @Default(0) int totalKeys,

    /// 项目已翻译键数
    @JsonKey(name: 'translated_keys') @FlexibleIntConverter() @Default(0) int translatedKeys,

    /// 项目语言数
    @JsonKey(name: 'languages_count') @FlexibleIntConverter() @Default(0) int languagesCount,

    /// 项目成员数
    @JsonKey(name: 'members_count') @FlexibleIntConverter() @Default(1) int membersCount,

    /// 项目成员上限
    @JsonKey(name: 'member_limit') @FlexibleIntConverter() @Default(10) int memberLimit,

    /// 项目是否公开
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,

    /// 项目是否活跃
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// 项目设置
    @JsonKey(name: 'settings') Map<String, dynamic>? settings,

    /// 项目最后活动时间
    @JsonKey(name: 'last_activity_at') @NullableTimesConverter() DateTime? lastActivityAt,

    /// 项目创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 项目更新时间
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,

    /// 项目所有者用户名
    @JsonKey(name: 'owner_username') String? ownerUsername,

    /// 项目所有者邮箱
    @JsonKey(name: 'owner_email') String? ownerEmail,

    /// 项目所有者显示名称
    @JsonKey(name: 'owner_display_name') String? ownerDisplayName,

    /// 项目所有者头像
    @JsonKey(name: 'owner_avatar') String? ownerAvatar,

    /// 项目完成百分比
    @JsonKey(name: 'completion_percentage') @FlexibleDoubleConverter() @Default(0.0) double completionPercentage,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);
}

/// 创建项目请求模型
@freezed
class CreateProjectRequest with _$CreateProjectRequest {
  const factory CreateProjectRequest({
    /// 项目名称
    @JsonKey(name: 'name') required String name,

    /// 项目slug
    @JsonKey(name: 'slug') required String slug,

    /// 项目描述
    @JsonKey(name: 'description') String? description,

    /// 项目状态
    @JsonKey(name: 'status') @Default('active') String status,

    /// 项目可见性
    @JsonKey(name: 'visibility') @Default('private') String visibility,

    /// 项目主语言ID
    @JsonKey(name: 'primary_language_id') @FlexibleIntConverter() int? primaryLanguageId,

    /// 项目设置
    @JsonKey(name: 'settings') Map<String, dynamic>? settings,
  }) = _CreateProjectRequest;

  factory CreateProjectRequest.fromJson(Map<String, dynamic> json) => _$CreateProjectRequestFromJson(json);
}

/// 更新项目请求模型
@freezed
class UpdateProjectRequest with _$UpdateProjectRequest {
  const factory UpdateProjectRequest({
    /// 项目名称
    @JsonKey(name: 'name') String? name,

    /// 项目slug
    @JsonKey(name: 'slug') String? slug,

    /// 项目描述
    @JsonKey(name: 'description') String? description,

    /// 项目状态
    @JsonKey(name: 'status') String? status,

    /// 项目可见性
    @JsonKey(name: 'visibility') String? visibility,

    /// 项目主语言ID
    @JsonKey(name: 'primary_language_id') @FlexibleIntConverter() int? primaryLanguageId,

    /// 项目设置
    @JsonKey(name: 'settings') Map<String, dynamic>? settings,
  }) = _UpdateProjectRequest;

  factory UpdateProjectRequest.fromJson(Map<String, dynamic> json) => _$UpdateProjectRequestFromJson(json);
}

/// 更新项目成员上限请求模型
@freezed
class UpdateMemberLimitRequest with _$UpdateMemberLimitRequest {
  const factory UpdateMemberLimitRequest({
    /// 新的成员上限
    @JsonKey(name: 'member_limit') required int memberLimit,
  }) = _UpdateMemberLimitRequest;

  factory UpdateMemberLimitRequest.fromJson(Map<String, dynamic> json) => _$UpdateMemberLimitRequestFromJson(json);
}

/// 项目详情模型（包含更多关联信息）
@freezed
class ProjectDetailModel with _$ProjectDetailModel {
  const factory ProjectDetailModel({
    /// 项目
    @JsonKey(name: 'project') required ProjectModel project,

    /// 项目语言
    @JsonKey(name: 'languages') List<LanguageModel>? languages,

    /// 项目成员
    @JsonKey(name: 'members') List<ProjectMemberModel>? members,
  }) = _ProjectDetailModel;

  factory ProjectDetailModel.fromJson(Map<String, dynamic> json) => _$ProjectDetailModelFromJson(json);
}
