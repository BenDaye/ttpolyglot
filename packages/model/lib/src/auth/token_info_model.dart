import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_info_model.freezed.dart';
part 'token_info_model.g.dart';

/// Token 信息模型
@freezed
class TokenInfoModel with _$TokenInfoModel {
  const factory TokenInfoModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'expires_in') required int expiresIn,
  }) = _TokenInfoModel;

  factory TokenInfoModel.fromJson(Map<String, dynamic> json) => _$TokenInfoModelFromJson(json);
}
