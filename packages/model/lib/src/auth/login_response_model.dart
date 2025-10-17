import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/auth/token_info_model.dart';
import 'package:ttpolyglot_model/src/auth/user_info_model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// 登录响应模型
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required UserInfo user,
    required TokenInfo tokens,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}
