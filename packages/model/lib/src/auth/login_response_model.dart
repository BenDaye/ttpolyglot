import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// 登录响应模型
@freezed
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    /// 用户信息
    @JsonKey(name: 'user') required UserInfoModel user,

    /// 令牌信息
    @JsonKey(name: 'tokens') required TokenInfoModel tokens,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);
}
