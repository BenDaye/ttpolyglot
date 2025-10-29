import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_request_model.freezed.dart';
part 'reset_password_request_model.g.dart';

/// 重置密码请求模型
@freezed
class ResetPasswordRequestModel with _$ResetPasswordRequestModel {
  const factory ResetPasswordRequestModel({
    /// 重置令牌
    @JsonKey(name: 'token') required String token,

    /// 新密码
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _ResetPasswordRequestModel;

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestModelFromJson(json);
}
