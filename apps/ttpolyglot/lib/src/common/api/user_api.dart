import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 用户 API
class UserApi {
  /// 搜索用户
  Future<List<UserSearchResultModel>?> searchUsers({
    required String query,
    int limit = 10,
  }) async {
    try {
      final response = await HttpClient.get<List<dynamic>>(
        '/users/search',
        query: {
          'q': query,
          'limit': limit,
        },
      );

      final result = ModelUtils.toModelArray<UserSearchResultModel>(
        response.data,
        (json) => UserSearchResultModel.fromJson(json),
      );
      return result;
    } catch (error, stackTrace) {
      LoggerUtils.error('[searchUsers] 搜索用户失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
