import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_model.freezed.dart';
part 'register_request_model.g.dart';

/// 注册请求模型
@freezed
class RegisterRequestModel with _$RegisterRequestModel {
  const factory RegisterRequestModel({
    /// 用户名
    @JsonKey(name: 'username') required String username,

    /// 邮箱
    @JsonKey(name: 'email') required String email,

    /// 密码
    @JsonKey(name: 'password') required String password,

    /// 显示名称（可选）
    @JsonKey(name: 'display_name') String? displayName,

    /// 语言代码（可选）
    @JsonKey(name: 'language_code') String? languageCode,
  }) = _RegisterRequestModel;

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => _$RegisterRequestModelFromJson(json);
}
