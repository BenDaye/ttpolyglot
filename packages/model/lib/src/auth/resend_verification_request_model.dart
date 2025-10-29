import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_verification_request_model.freezed.dart';
part 'resend_verification_request_model.g.dart';

/// 重发验证邮件请求模型
@freezed
class ResendVerificationRequestModel with _$ResendVerificationRequestModel {
  const factory ResendVerificationRequestModel({
    /// 邮箱
    @JsonKey(name: 'email') required String email,
  }) = _ResendVerificationRequestModel;

  factory ResendVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ResendVerificationRequestModelFromJson(json);
}
