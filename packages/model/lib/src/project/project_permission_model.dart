import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'project_permission_model.freezed.dart';
part 'project_permission_model.g.dart';

/// 项目权限模型
@freezed
class ProjectPermission with _$ProjectPermission {
  const factory ProjectPermission({
    /// 权限ID
    @JsonKey(name: 'id') required int id,

    /// 权限名称
    @JsonKey(name: 'name') required String name,

    /// 权限代码
    @JsonKey(name: 'code') required String code,

    /// 权限描述
    @JsonKey(name: 'description') String? description,

    /// 是否可用
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,
  }) = _ProjectPermission;

  factory ProjectPermission.fromJson(Map<String, dynamic> json) => _$ProjectPermissionFromJson(json);
}
