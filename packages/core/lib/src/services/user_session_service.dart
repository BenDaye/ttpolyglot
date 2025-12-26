import 'package:ttpolyglot_model/model.dart';

/// 用户会话服务接口
abstract class UserSessionService {
  /// 创建用户会话
  Future<UserSessionModel> createSession(UserSessionModel session);

  /// 获取会话
  Future<UserSessionModel?> getSession(int sessionId);

  /// 根据token哈希获取会话
  Future<UserSessionModel?> getSessionByTokenHash(String tokenHash);

  /// 根据刷新token哈希获取会话
  Future<UserSessionModel?> getSessionByRefreshTokenHash(String refreshTokenHash);

  /// 获取用户的所有会话
  Future<List<UserSessionModel>> getUserSessions(
    String userId, {
    bool? isActive,
    int? limit,
    int? offset,
  });

  /// 更新会话最后活动时间
  Future<UserSessionModel> updateLastActivity(int sessionId);

  /// 激活/停用会话
  Future<UserSessionModel> updateSessionStatus(int sessionId, bool isActive);

  /// 删除会话
  Future<void> deleteSession(int sessionId);

  /// 删除用户的所有会话
  Future<int> deleteUserSessions(String userId);

  /// 删除过期的会话
  Future<int> deleteExpiredSessions();

  /// 删除用户的其他会话（保留当前会话）
  Future<int> deleteOtherSessions(String userId, int currentSessionId);
}
