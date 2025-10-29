import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_request_model.freezed.dart';
part 'verify_email_request_model.g.dart';

/// 邮箱验证请求模型
@freezed
class VerifyEmailRequestModel with _$VerifyEmailRequestModel {
  const factory VerifyEmailRequestModel({
    /// 验证令牌
    @JsonKey(name: 'token') required String token,
  }) = _VerifyEmailRequestModel;

  factory VerifyEmailRequestModel.fromJson(Map<String, dynamic> json) => _$VerifyEmailRequestModelFromJson(json);
}
