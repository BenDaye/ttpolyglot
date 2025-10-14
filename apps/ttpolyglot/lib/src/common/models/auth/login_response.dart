import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot/src/common/models/auth/token_info.dart';
import 'package:ttpolyglot/src/common/models/auth/user_info.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// 登录响应模型
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required UserInfo user,
    required TokenInfo tokens,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}
