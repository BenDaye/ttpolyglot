import 'package:ttpolyglot_model/model.dart';

import '../config/server_config.dart';
import '../middleware/error_handler_middleware.dart';
import '../utils/crypto_utils.dart';
import '../utils/structured_logger.dart';
import 'database_service.dart';
import 'redis_service.dart';

/// 用户服务
class UserService {
  final DatabaseService _databaseService;
  final RedisService _redisService;
  late final CryptoUtils _cryptoUtils;
  static final _logger = LoggerFactory.getLogger('UserService');

  UserService({
    required DatabaseService databaseService,
    required RedisService redisService,
  })  : _databaseService = databaseService,
        _redisService = redisService {
    _cryptoUtils = CryptoUtils();
  }

  /// 获取用户列表
  Future<Map<String, dynamic>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? role,
  }) async {
    try {
      _logger.info('获取用户列表: page=$page, limit=$limit');

      // 构建查询条件
      final conditions = <String>[];
      final parameters = <String, dynamic>{};

      if (search != null && search.isNotEmpty) {
        conditions.add('(u.username ILIKE @search OR u.email ILIKE @search OR u.display_name ILIKE @search)');
        parameters['search'] = '%$search%';
      }

      if (status != null && status.isNotEmpty) {
        if (status == 'active') {
          conditions.add('u.is_active = true');
        } else if (status == 'inactive') {
          conditions.add('u.is_active = false');
        }
      }

      // 计算总数
      final countSql = '''
        SELECT COUNT(*) FROM users u
        ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
      ''';

      final countResult = await _databaseService.query(countSql, parameters);
      final total = countResult.first[0] as int;

      // 获取分页数据
      final offset = (page - 1) * limit;
      parameters['limit'] = limit;
      parameters['offset'] = offset;

      final usersSql = '''
        SELECT 
          u.id, u.username, u.email, u.display_name, u.avatar_url,
          u.timezone, u.locale, u.is_active, u.is_email_verified,
          u.last_login_at, u.created_at, u.updated_at,
          COALESCE(
            json_agg(
              json_build_object(
                'role_name', r.name,
                'role_display_name', r.display_name,
                'project_id', ur.project_id,
                'is_global', ur.project_id IS NULL
              )
            ) FILTER (WHERE r.id IS NOT NULL), 
            '[]'
          ) as roles
        FROM users u
        LEFT JOIN user_roles ur ON u.id = ur.user_id AND ur.is_active = true
        LEFT JOIN roles r ON ur.role_id = r.id AND r.is_active = true
        ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
        GROUP BY u.id
        ORDER BY u.created_at DESC
        LIMIT @limit OFFSET @offset
      ''';

      final usersResult = await _databaseService.query(usersSql, parameters);

      final users = usersResult.map((row) {
        final userData = row.toColumnMap();

        // 解析角色信息
        final rolesJson = userData['roles'] as String;
        userData['roles'] = rolesJson.isNotEmpty ? rolesJson : [];

        // 移除敏感信息
        userData.remove('password_hash');

        return userData;
      }).toList();

      return {
        'users': users,
        'pagination': {
          'page': page,
          'limit': limit,
          'total': total,
          'pages': (total / limit).ceil(),
        },
      };
    } catch (error, stackTrace) {
      _logger.error('获取用户列表失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 根据ID获取用户详情
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      _logger.info('获取用户详情: $userId');

      // 先检查缓存
      final cacheKey = 'user:details:$userId';
      final cachedUser = await _redisService.getJson(cacheKey);
      if (cachedUser != null) {
        return cachedUser;
      }

      final sql = '''
        SELECT 
          u.id, u.username, u.email, u.display_name, u.avatar_url,
          u.phone, u.timezone, u.locale, u.two_factor_enabled,
          u.is_active, u.is_email_verified, u.email_verified_at,
          u.last_login_at, u.last_login_ip, u.created_at, u.updated_at,
          COALESCE(
            json_agg(
              json_build_object(
                'role_id', r.id,
                'role_name', r.name,
                'role_display_name', r.display_name,
                'project_id', ur.project_id,
                'is_global', ur.project_id IS NULL,
                'granted_at', ur.granted_at,
                'expires_at', ur.expires_at
              )
            ) FILTER (WHERE r.id IS NOT NULL), 
            '[]'
          ) as roles
        FROM users u
        LEFT JOIN user_roles ur ON u.id = ur.user_id 
          AND ur.is_active = true 
          AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
        LEFT JOIN roles r ON ur.role_id = r.id AND r.is_active = true
        WHERE u.id = @user_id
        GROUP BY u.id
      ''';

      final result = await _databaseService.query(sql, {'user_id': userId});

      if (result.isEmpty) {
        return null;
      }

      final userData = result.first.toColumnMap();

      // 解析角色信息
      final rolesJson = userData['roles'] as String;
      userData['roles'] = rolesJson.isNotEmpty ? rolesJson : [];

      // 移除敏感信息
      userData.remove('password_hash');

      // 缓存用户信息
      await _redisService.setJson(cacheKey, userData, ServerConfig.cacheApiResponseTtl);

      return userData;
    } catch (error, stackTrace) {
      _logger.error('获取用户详情失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新用户信息
  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> updateData, {String? updatedBy}) async {
    try {
      _logger.info('更新用户信息: $userId');

      // 验证用户是否存在
      final existingUser = await getUserById(userId);
      if (existingUser == null) {
        throw const NotFoundException('用户不存在');
      }

      // 构建更新字段
      final updates = <String>[];
      final parameters = <String, dynamic>{'user_id': userId};

      // 允许更新的字段
      final allowedFields = {
        'display_name': 'display_name',
        'phone': 'phone',
        'timezone': 'timezone',
        'locale': 'locale',
        'avatar_url': 'avatar_url',
        'is_active': 'is_active',
      };

      for (final entry in allowedFields.entries) {
        if (updateData.containsKey(entry.key)) {
          updates.add('${entry.value} = @${entry.key}');
          parameters[entry.key] = updateData[entry.key];
        }
      }

      if (updates.isEmpty) {
        throw const BusinessException(ApiResponseCode.validationError, '没有可更新的字段');
      }

      // 检查用户名和邮箱唯一性
      if (updateData.containsKey('username')) {
        final usernameExists = await _isUsernameExists(updateData['username'], userId);
        if (usernameExists) {
          throw const BusinessException(ApiResponseCode.validationError, '用户名已存在');
        }
        updates.add('username = @username');
        parameters['username'] = updateData['username'];
      }

      if (updateData.containsKey('email')) {
        final emailExists = await _isEmailExists(updateData['email'], userId);
        if (emailExists) {
          throw const BusinessException(ApiResponseCode.validationError, '邮箱已被使用');
        }
        updates.add('email = @email');
        updates.add('is_email_verified = false'); // 更改邮箱后需要重新验证
        parameters['email'] = updateData['email'];
      }

      // 在事务中更新用户
      await _databaseService.transaction(() async {
        final sql = '''
          UPDATE users 
          SET ${updates.join(', ')}, updated_at = CURRENT_TIMESTAMP
          WHERE id = @user_id
        ''';

        await _databaseService.query(sql, parameters);
      });

      // 清除缓存
      await _clearUserCache(userId);

      // 获取更新后的用户信息
      final updatedUser = await getUserById(userId);

      _logger.info('用户信息更新成功: $userId');

      return updatedUser!;
    } catch (error, stackTrace) {
      _logger.error('更新用户信息失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更改用户密码
  Future<void> changePassword(String userId, String currentPassword, String newPassword) async {
    try {
      _logger.info('更改用户密码: $userId');

      // 获取当前密码哈希
      final sql = 'SELECT password_hash FROM users WHERE id = @user_id AND is_active = true';
      final result = await _databaseService.query(sql, {'user_id': userId});

      if (result.isEmpty) {
        throw const NotFoundException('用户不存在');
      }

      final currentPasswordHash = result.first[0] as String;

      // 验证当前密码
      if (!_cryptoUtils.verifyPassword(currentPassword, currentPasswordHash)) {
        throw const BusinessException(ApiResponseCode.validationError, '当前密码不正确');
      }

      // 验证新密码强度
      final passwordStrength = _cryptoUtils.checkPasswordStrength(newPassword);
      if (!passwordStrength.isAcceptable) {
        throw BusinessException(ApiResponseCode.validationError, '新密码强度不足：${passwordStrength.checks.join(', ')}');
      }

      // 生成新密码哈希
      final newPasswordHash = _cryptoUtils.hashPassword(newPassword);

      // 更新密码
      await _databaseService.query('''
        UPDATE users 
        SET password_hash = @password_hash, 
            password_changed_at = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = @user_id
      ''', {
        'user_id': userId,
        'password_hash': newPasswordHash,
      });

      // 清除用户的所有会话（强制重新登录）
      await _revokeAllUserSessions(userId);

      _logger.info('用户密码更改成功: $userId');
    } catch (error, stackTrace) {
      _logger.error('更改用户密码失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 禁用/启用用户
  Future<void> toggleUserStatus(String userId, bool isActive, {String? reason}) async {
    try {
      _logger.info('切换用户状态: $userId -> $isActive');

      await _databaseService.query('''
        UPDATE users 
        SET is_active = @is_active, updated_at = CURRENT_TIMESTAMP
        WHERE id = @user_id
      ''', {
        'user_id': userId,
        'is_active': isActive,
      });

      // 如果禁用用户，清除所有会话
      if (!isActive) {
        await _revokeAllUserSessions(userId);
      }

      // 清除缓存
      await _clearUserCache(userId);

      _logger.info('用户状态切换成功: $userId');
    } catch (error, stackTrace) {
      _logger.error('切换用户状态失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除用户
  Future<void> deleteUser(String userId, {String? deletedBy}) async {
    try {
      _logger.info('删除用户: $userId');

      // 检查用户是否存在
      final user = await getUserById(userId);
      if (user == null) {
        throw const NotFoundException('用户不存在');
      }

      // 在事务中删除用户相关数据
      await _databaseService.transaction(() async {
        // 删除用户会话
        await _databaseService.query('DELETE FROM user_sessions WHERE user_id = @user_id', {'user_id': userId});

        // 删除用户角色关联
        await _databaseService.query('DELETE FROM user_roles WHERE user_id = @user_id', {'user_id': userId});

        // 删除用户
        await _databaseService.query('DELETE FROM users WHERE id = @user_id', {'user_id': userId});
      });

      // 清除缓存
      await _clearUserCache(userId);

      _logger.info('用户删除成功: $userId');
    } catch (error, stackTrace) {
      _logger.error('删除用户失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取用户统计信息
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      _logger.info('获取用户统计信息');

      // 检查缓存
      const cacheKey = 'user:stats';
      final cachedStats = await _redisService.getJson(cacheKey);
      if (cachedStats != null) {
        return cachedStats;
      }

      final sql = '''
        SELECT 
          COUNT(*) as total_users,
          COUNT(*) FILTER (WHERE is_active = true) as active_users,
          COUNT(*) FILTER (WHERE is_active = false) as inactive_users,
          COUNT(*) FILTER (WHERE is_email_verified = true) as verified_users,
          COUNT(*) FILTER (WHERE last_login_at > CURRENT_TIMESTAMP - INTERVAL '30 days') as active_last_month,
          COUNT(*) FILTER (WHERE created_at > CURRENT_TIMESTAMP - INTERVAL '30 days') as new_last_month
        FROM users
      ''';

      final result = await _databaseService.query(sql);
      final stats = result.first.toColumnMap();

      // 缓存统计信息
      await _redisService.setJson(cacheKey, stats, 3600); // 1小时缓存

      return stats;
    } catch (error, stackTrace) {
      _logger.error('获取用户统计信息失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  // 私有辅助方法

  Future<bool> _isUsernameExists(String username, [String? excludeUserId]) async {
    var sql = 'SELECT 1 FROM users WHERE username = @username';
    final parameters = <String, dynamic>{'username': username};

    if (excludeUserId != null) {
      sql += ' AND id != @exclude_id';
      parameters['exclude_id'] = excludeUserId;
    }

    final result = await _databaseService.query(sql, parameters);
    return result.isNotEmpty;
  }

  Future<bool> _isEmailExists(String email, [String? excludeUserId]) async {
    var sql = 'SELECT 1 FROM users WHERE email = @email';
    final parameters = <String, dynamic>{'email': email};

    if (excludeUserId != null) {
      sql += ' AND id != @exclude_id';
      parameters['exclude_id'] = excludeUserId;
    }

    final result = await _databaseService.query(sql, parameters);
    return result.isNotEmpty;
  }

  Future<void> _revokeAllUserSessions(String userId) async {
    await _databaseService
        .query('UPDATE user_sessions SET is_active = false WHERE user_id = @user_id', {'user_id': userId});

    // 清除Redis中的会话缓存
    await _redisService.deleteUserSession(userId);
  }

  /// 获取用户会话列表
  Future<List<Map<String, dynamic>>> getUserSessions(String userId) async {
    try {
      _logger.info('获取用户会话: $userId');

      final result = await _databaseService.query('''
        SELECT
          id, device_name, device_type, ip_address,
          user_agent, location_info, last_activity_at,
          created_at, expires_at, is_active
        FROM user_sessions
        WHERE user_id = @user_id AND is_active = true
        ORDER BY last_activity_at DESC
      ''', {'user_id': userId});

      return result.map((row) => row.toColumnMap()).toList();
    } catch (error, stackTrace) {
      _logger.error('获取用户会话失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除用户会话
  Future<void> deleteUserSession(String userId, String sessionId) async {
    try {
      _logger.info('删除用户会话: user=$userId, session=$sessionId');

      await _databaseService.query('''
        UPDATE user_sessions
        SET is_active = false, updated_at = CURRENT_TIMESTAMP
        WHERE id = @session_id AND user_id = @user_id
      ''', {'session_id': sessionId, 'user_id': userId});

      await _redisService.deleteUserSession(userId);

      _logger.info('用户会话删除成功');
    } catch (error, stackTrace) {
      _logger.error('删除用户会话失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> _clearUserCache(String userId) async {
    await _redisService.delete('user:details:$userId');
    await _redisService.delete('user:stats');
  }
}
