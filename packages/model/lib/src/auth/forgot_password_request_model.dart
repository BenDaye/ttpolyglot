import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_request_model.freezed.dart';
part 'forgot_password_request_model.g.dart';

/// 忘记密码请求模型
@freezed
class ForgotPasswordRequestModel with _$ForgotPasswordRequestModel {
  const factory ForgotPasswordRequestModel({
    /// 邮箱
    @JsonKey(name: 'email') required String email,
  }) = _ForgotPasswordRequestModel;

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestModelFromJson(json);
}
