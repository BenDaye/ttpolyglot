import 'package:freezed_annotation/freezed_annotation.dart';

/// 项目角色枚举
enum ProjectRoleEnum {
  owner('owner', '所有者'),
  admin('admin', '管理员'),
  member('member', '成员'),
  viewer('viewer', '查看者');

  const ProjectRoleEnum(this.value, this.displayName);

  final String value;
  final String displayName;

  /// 根据值获取对应的枚举
  static ProjectRoleEnum fromValue(String value) {
    return ProjectRoleEnum.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ProjectRoleEnum.member,
    );
  }
}

/// ProjectRoleEnum 的 JSON 转换器
class ProjectRoleEnumConverter implements JsonConverter<ProjectRoleEnum, String> {
  const ProjectRoleEnumConverter();

  @override
  ProjectRoleEnum fromJson(String json) {
    return ProjectRoleEnum.fromValue(json);
  }

  @override
  String toJson(ProjectRoleEnum object) => object.value;
}
