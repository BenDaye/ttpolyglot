import 'package:freezed_annotation/freezed_annotation.dart';

/// 成员状态枚举
enum MemberStatusEnum {
  pending('pending', '待加入'),
  active('active', '活跃'),
  inactive('inactive', '已停用');

  const MemberStatusEnum(this.value, this.displayName);

  final String value;
  final String displayName;

  /// 根据值获取对应的枚举
  static MemberStatusEnum fromValue(String value) {
    return MemberStatusEnum.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MemberStatusEnum.pending,
    );
  }
}

/// MemberStatusEnum 的 JSON 转换器
class MemberStatusEnumConverter implements JsonConverter<MemberStatusEnum, String> {
  const MemberStatusEnumConverter();

  @override
  MemberStatusEnum fromJson(String json) {
    return MemberStatusEnum.fromValue(json);
  }

  @override
  String toJson(MemberStatusEnum object) => object.value;
}
