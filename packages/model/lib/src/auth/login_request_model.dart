import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

/// 登录请求模型
@freezed
class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    /// 邮箱或用户名
    @JsonKey(name: 'email_or_username') required String emailOrUsername,

    /// 密码
    @JsonKey(name: 'password') required String password,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => _$LoginRequestModelFromJson(json);
}
