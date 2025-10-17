import 'package:flutter_test/flutter_test.dart';
import 'package:ttpolyglot_model/model.dart';

void main() {
  test('model package exports are available', () {
    // 验证认证模型可以导入
    expect(LoginRequestModel, isNotNull);
    expect(LoginResponseModel, isNotNull);
    expect(TokenInfoModel, isNotNull);
    expect(UserInfoModel, isNotNull);

    // 验证网络模型可以导入
    expect(ApiResponseModel, isNotNull);
    expect(RequestExtraModel, isNotNull);

    // 验证枚举可以导入
    expect(ApiResponseCode, isNotNull);

    // 验证项目模型可以导入
    expect(ImportRecordModel, isNotNull);
  });
}
