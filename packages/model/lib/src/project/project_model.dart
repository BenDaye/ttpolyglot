import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

/// 项目模型
@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'slug') required String slug,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'visibility') required String visibility,
    @JsonKey(name: 'primary_language_code') String? primaryLanguageCode,
    @JsonKey(name: 'total_keys') @Default(0) int totalKeys,
    @JsonKey(name: 'translated_keys') @Default(0) int translatedKeys,
    @JsonKey(name: 'languages_count') @Default(0) int languagesCount,
    @JsonKey(name: 'members_count') @Default(1) int membersCount,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'settings') Map<String, dynamic>? settings,
    @JsonKey(name: 'last_activity_at') DateTime? lastActivityAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // 扩展字段（从联表查询）
    @JsonKey(name: 'owner_username') String? ownerUsername,
    @JsonKey(name: 'owner_display_name') String? ownerDisplayName,
    @JsonKey(name: 'owner_avatar') String? ownerAvatar,
    @JsonKey(name: 'primary_language_name') String? primaryLanguageName,
    @JsonKey(name: 'primary_language_native_name') String? primaryLanguageNativeName,
    @JsonKey(name: 'completion_percentage') @Default(0.0) double completionPercentage,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);
}

/// 创建项目请求模型
@freezed
class CreateProjectRequest with _$CreateProjectRequest {
  const factory CreateProjectRequest({
    required String name,
    required String slug,
    String? description,
    @Default('active') String status,
    @Default('private') String visibility,
    String? primaryLanguageCode,
    Map<String, dynamic>? settings,
  }) = _CreateProjectRequest;

  factory CreateProjectRequest.fromJson(Map<String, dynamic> json) => _$CreateProjectRequestFromJson(json);
}

/// 更新项目请求模型
@freezed
class UpdateProjectRequest with _$UpdateProjectRequest {
  const factory UpdateProjectRequest({
    String? name,
    String? slug,
    String? description,
    String? status,
    String? visibility,
    String? primaryLanguageCode,
    Map<String, dynamic>? settings,
  }) = _UpdateProjectRequest;

  factory UpdateProjectRequest.fromJson(Map<String, dynamic> json) => _$UpdateProjectRequestFromJson(json);
}

/// 项目详情模型（包含更多关联信息）
@freezed
class ProjectDetailModel with _$ProjectDetailModel {
  const factory ProjectDetailModel({
    required ProjectModel project,
    List<ProjectLanguageInfo>? languages,
    List<ProjectMemberInfo>? members,
  }) = _ProjectDetailModel;

  factory ProjectDetailModel.fromJson(Map<String, dynamic> json) => _$ProjectDetailModelFromJson(json);
}

/// 项目语言信息
@freezed
class ProjectLanguageInfo with _$ProjectLanguageInfo {
  const factory ProjectLanguageInfo({
    @JsonKey(name: 'language_code') required String languageCode,
    @JsonKey(name: 'language_name') required String languageName,
    @JsonKey(name: 'native_name') String? nativeName,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    @JsonKey(name: 'translated_keys') @Default(0) int translatedKeys,
    @JsonKey(name: 'total_keys') @Default(0) int totalKeys,
    @JsonKey(name: 'completion_percentage') @Default(0.0) double completionPercentage,
  }) = _ProjectLanguageInfo;

  factory ProjectLanguageInfo.fromJson(Map<String, dynamic> json) => _$ProjectLanguageInfoFromJson(json);
}

/// 项目成员信息（简化版）
@freezed
class ProjectMemberInfo with _$ProjectMemberInfo {
  const factory ProjectMemberInfo({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'role') required String role,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
  }) = _ProjectMemberInfo;

  factory ProjectMemberInfo.fromJson(Map<String, dynamic> json) => _$ProjectMemberInfoFromJson(json);
}
