import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

/// 项目模型
@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();

  const factory ProjectModel({
    /// 项目ID
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 项目UUID
    @JsonKey(name: 'uuid') required String uuid,

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

    /// 项目成员上限
    @JsonKey(name: 'member_limit') @FlexibleIntConverter() @Default(10) int memberLimit,

    /// 是否激活
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// 项目最后活动时间
    @JsonKey(name: 'last_activity_at') @NullableTimesConverter() DateTime? lastActivityAt,

    /// 项目创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 项目更新时间
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,

    /// 项目语言
    @JsonKey(name: 'languages') required List<LanguageModel> languages,

    /// 项目成员
    @JsonKey(name: 'members') required List<ProjectMemberModel> members,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);

  /// 项目所有者（如果找不到匹配的成员，返回第一个成员；如果成员列表为空，返回 null）
  ProjectMemberModel? get owner {
    if (members.isEmpty) return null;
    return members.cast<ProjectMemberModel?>().firstWhere(
              (member) => member!.userId == ownerId,
              orElse: () => null,
            ) ??
        members.first;
  }

  /// 主语言（如果找不到匹配的语言，返回第一个语言）
  LanguageModel get primaryLanguage =>
      languages.cast<LanguageModel?>().firstWhere(
            (language) => language!.id == primaryLanguageId,
            orElse: () => null,
          ) ??
      languages.first;
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
