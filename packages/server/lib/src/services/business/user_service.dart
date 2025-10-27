import 'package:ttpolyglot_model/model.dart';

import '../../config/server_config.dart';
import '../../utils/security/crypto_utils.dart';
import '../base_service.dart';
import '../feature/ip_location_service.dart';
import '../infrastructure/database_service.dart';
import '../infrastructure/redis_service.dart';

/// 用户服务
class UserService extends BaseService {
  final DatabaseService _databaseService;
  final RedisService _redisService;
  final IpLocationService _ipLocationService;
  late final CryptoUtils _cryptoUtils;

  UserService({
    required DatabaseService databaseService,
    required RedisService redisService,
    required IpLocationService ipLocationService,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        _ipLocationService = ipLocationService,
        super('UserService') {
    _cryptoUtils = CryptoUtils();
  }

  /// 获取用户列表
  Future<PagerModel<UserInfoModel>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? role,
  }) async {
    return execute(() async {
      logInfo('获取用户列表', context: {'page': page, 'limit': limit});

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
        SELECT COUNT(*) FROM {users} u
        ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
      ''';

      final countResult = await _databaseService.query(countSql, parameters);
      // COUNT(*) 返回的可能是 int 或 bigint，需要安全转换
      final totalRaw = countResult.first[0];
      final total = (totalRaw is int) ? totalRaw : int.parse(totalRaw.toString());

      // 获取分页数据
      final offset = (page - 1) * limit;
      parameters['limit'] = limit;
      parameters['offset'] = offset;

      final usersSql = '''
        SELECT 
          u.id, u.username, u.email, u.display_name, u.avatar_url,
          u.phone, u.timezone, u.locale,
          u.is_active, u.is_email_verified,
          u.last_login_at, 
          COALESCE(HOST(u.last_login_ip)::text, '') as last_login_ip,
          u.created_at, u.updated_at,
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
        FROM {users} u
        LEFT JOIN {user_roles} ur ON u.id = ur.user_id AND ur.is_active = true
        LEFT JOIN {roles} r ON ur.role_id = r.id AND r.is_active = true
        ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
        GROUP BY u.id
        ORDER BY u.created_at DESC
        LIMIT @limit OFFSET @offset
      ''';

      final usersResult = await _databaseService.query(usersSql, parameters);

      final usersData = usersResult.map((row) {
        final userData = row.toColumnMap();

        // 解析角色信息
        final rolesJson = userData['roles'] as String;
        userData['roles'] = rolesJson.isNotEmpty ? rolesJson : [];

        // 移除敏感信息
        userData.remove('password_hash');
        userData.remove('id'); // 隐藏用户ID

        return userData;
      }).toList();

      // 批量查询IP地理位置信息
      // 收集所有唯一的IP地址
      final uniqueIps = <String>{};
      for (final user in usersData) {
        final ip = user['last_login_ip']?.toString();
        if (ip != null && ip != '' && ip.isNotEmpty) {
          uniqueIps.add(ip);
        }
      }

      // 批量查询位置信息
      final locationMap = <String, LocationModel>{};
      if (uniqueIps.isNotEmpty) {
        try {
          // 为了避免API限流，这里限制批量查询数量
          final ipsToQuery = uniqueIps.take(10).toList();
          for (final ip in ipsToQuery) {
            locationMap[ip] = await _ipLocationService.getLocation(ip);
            // 添加延迟以避免API限流
            if (ipsToQuery.length > 1) {
              await Future.delayed(const Duration(milliseconds: 1500));
            }
          }
        } catch (e) {
          logWarning('批量查询IP地理位置失败: $e');
        }
      }

      // 为每个用户添加位置信息并转换为 UserInfoModel
      final users = usersData.map((user) {
        final ip = user['last_login_ip']?.toString();
        if (ip != null && locationMap.containsKey(ip)) {
          final location = locationMap[ip]!;
          user['last_login_location'] = location.toJson();
        } else {
          user['last_login_location'] = const LocationModel().toJson();
        }
        return UserInfoModel.fromJson(user);
      }).toList();

      return PagerModel<UserInfoModel>(
        page: page,
        pageSize: limit,
        totalSize: total,
        totalPage: (total / limit).ceil(),
        items: users,
      );
    }, operationName: 'getUsers');
  }

  /// 根据ID获取用户详情
  Future<UserInfoModel?> getUserById(String userId) async {
    try {
      logInfo('获取用户详情: $userId');

      // 先检查缓存
      final cacheKey = 'user:details:$userId';
      final cachedUser = await _redisService.getJson(cacheKey);
      if (cachedUser != null) {
        try {
          logInfo('从缓存获取用户详情');
          return UserInfoModel.fromJson(cachedUser);
        } catch (cacheError, cacheStackTrace) {
          // 缓存数据解析失败，删除缓存并继续查询数据库
          logError('缓存数据解析失败', error: cacheError, stackTrace: cacheStackTrace);
          await _redisService.delete(cacheKey);
        }
      }

      final sql = '''
        SELECT 
          u.id, u.username, u.email, u.display_name, u.avatar_url,
          u.phone, u.timezone, u.locale,
          u.is_active, u.is_email_verified, u.email_verified_at,
          u.last_login_at, 
          COALESCE(HOST(u.last_login_ip)::text, '') as last_login_ip,
          u.login_attempts, u.locked_until, u.password_changed_at,
          u.created_at, u.updated_at,
          COALESCE(
            json_agg(
              json_build_object(
                'role_id', r.id,
                'role_name', r.name,
                'role_display_name', r.display_name,
                'is_system_role', r.is_system_role,
                'assigned_at', ur.assigned_at,
                'expires_at', ur.expires_at
              )
            ) FILTER (WHERE r.id IS NOT NULL), 
            '[]'
          ) as roles
        FROM {users} u
        LEFT JOIN {user_roles} ur ON u.id = ur.user_id 
          AND ur.is_active = true 
          AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
        LEFT JOIN {roles} r ON ur.role_id = r.id AND r.is_active = true
        WHERE u.id = @user_id
        GROUP BY u.id
      ''';

      final result = await _databaseService.query(sql, {'user_id': userId});

      if (result.isEmpty) {
        return null;
      }

      final userData = result.first.toColumnMap();

      // 解析角色信息
      // PostgreSQL的json_agg返回的可能是List或String，需要处理两种情况
      final roles = userData['roles'];
      if (roles is String) {
        userData['roles'] = roles.isNotEmpty ? roles : [];
      } else if (roles is! List) {
        userData['roles'] = [];
      }

      // 移除敏感信息
      userData.remove('password_hash');
      userData.remove('id'); // 隐藏用户ID

      // 转换特殊类型对象为可序列化格式
      final serializedData = <String, dynamic>{};
      String? lastLoginIp;

      userData.forEach((key, value) {
        if (value == null) {
          serializedData[key] = null;
        } else if (value is List || value is Map || value is String || value is num || value is bool) {
          // 基本类型直接使用
          serializedData[key] = value;
          // 同时保存IP地址字符串
          if (key == 'last_login_ip' && value is String) {
            lastLoginIp = value;
          }
        } else {
          // 其他类型转换为字符串
          serializedData[key] = value.toString();
        }
      });

      // 添加IP地理位置信息
      if (lastLoginIp != null && lastLoginIp != '') {
        try {
          final location = await _ipLocationService.getLocation(lastLoginIp!);
          serializedData['last_login_location'] = location.toJson();
        } catch (e) {
          // IP地理位置查询失败时使用默认值
          serializedData['last_login_location'] = const LocationModel().toJson();
        }
      } else {
        serializedData['last_login_location'] = const LocationModel().toJson();
      }

      // 缓存用户信息
      await _redisService.setJson(cacheKey, serializedData, ServerConfig.cacheApiResponseTtl);

      return UserInfoModel.fromJson(serializedData);
    } catch (error, stackTrace) {
      logError('获取用户详情失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新用户信息
  Future<UserInfoModel> updateUser(String userId, Map<String, dynamic> updateData, {String? updatedBy}) async {
    try {
      logInfo('更新用户信息: $userId');

      // 验证用户是否存在
      final existingUser = await getUserById(userId);
      if (existingUser == null) {
        throwNotFound('用户不存在');
      }

      // 构建更新字段
      final updates = <String>[];
      final parameters = <String, dynamic>{'user_id': userId};

      // 允许更新的字段
      final allowedFields = {
        'display_name': 'display_name',
        'phone': 'phone',
        'avatar_url': 'avatar_url',
        'timezone': 'timezone',
        'locale': 'locale',
        'is_active': 'is_active',
      };

      for (final entry in allowedFields.entries) {
        if (updateData.containsKey(entry.key)) {
          updates.add('${entry.value} = @${entry.key}');
          parameters[entry.key] = updateData[entry.key];
        }
      }

      if (updates.isEmpty) {
        throwBusiness('没有可更新的字段');
      }

      // 检查用户名和邮箱唯一性
      if (updateData.containsKey('username')) {
        final usernameExists = await _isUsernameExists(updateData['username'], userId);
        if (usernameExists) {
          throwBusiness('用户名已存在');
        }
        updates.add('username = @username');
        parameters['username'] = updateData['username'];
      }

      if (updateData.containsKey('email')) {
        final emailExists = await _isEmailExists(updateData['email'], userId);
        if (emailExists) {
          throwBusiness('邮箱已被使用');
        }
        updates.add('email = @email');
        updates.add('is_email_verified = false'); // 更改邮箱后需要重新验证
        updates.add('email_verified_at = NULL');
        parameters['email'] = updateData['email'];
      }

      // 在事务中更新用户
      await _databaseService.transaction(() async {
        final sql = '''
          UPDATE {users} 
          SET ${updates.join(', ')}, updated_at = CURRENT_TIMESTAMP
          WHERE id = @user_id
        ''';

        await _databaseService.query(sql, parameters);
      });

      // 清除缓存
      await _clearUserCache(userId);

      // 获取更新后的用户信息
      final updatedUser = await getUserById(userId);

      logInfo('用户信息更新成功: $userId');

      return updatedUser!;
    } catch (error, stackTrace) {
      logError('更新用户信息失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更改用户密码
  Future<void> changePassword(String userId, String currentPassword, String newPassword) async {
    try {
      logInfo('更改用户密码: $userId');

      // 获取当前密码哈希
      final sql = 'SELECT password_hash FROM {users} WHERE id = @user_id AND is_active = true';
      final result = await _databaseService.query(sql, {'user_id': userId});

      if (result.isEmpty) {
        throwNotFound('用户不存在');
      }

      // password_hash 是 CHAR(60) 类型，应该返回 String，但为了安全起见使用 toString()
      final rawPasswordHash = result.first[0];
      final currentPasswordHash = rawPasswordHash.toString();

      // 验证当前密码
      if (!_cryptoUtils.verifyPassword(currentPassword, currentPasswordHash)) {
        throwBusiness('当前密码不正确');
      }

      // 验证新密码强度
      final passwordStrength = _cryptoUtils.checkPasswordStrength(newPassword);
      if (!passwordStrength.isAcceptable) {
        throwValidation('新密码强度不足：${passwordStrength.checks.join(', ')}');
      }

      // 生成新密码哈希
      final newPasswordHash = _cryptoUtils.hashPassword(newPassword);

      // 更新密码
      await _databaseService.query('''
        UPDATE {users} 
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

      logInfo('用户密码更改成功: $userId');
    } catch (error, stackTrace) {
      logError('更改用户密码失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 禁用/启用用户
  Future<void> toggleUserStatus(String userId, bool isActive, {String? reason}) async {
    try {
      logInfo('切换用户状态: $userId -> $isActive');

      await _databaseService.query('''
        UPDATE {users} 
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

      logInfo('用户状态切换成功: $userId');
    } catch (error, stackTrace) {
      logError('切换用户状态失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除用户
  Future<void> deleteUser(String userId, {String? deletedBy}) async {
    try {
      logInfo('删除用户: $userId');

      // 检查用户是否存在
      final user = await getUserById(userId);
      if (user == null) {
        throwNotFound('用户不存在');
      }

      // 在事务中删除用户相关数据
      await _databaseService.transaction(() async {
        // 删除用户会话
        await _databaseService.query('DELETE FROM {user_sessions} WHERE user_id = @user_id', {'user_id': userId});

        // 删除用户角色关联
        await _databaseService.query('DELETE FROM {user_roles} WHERE user_id = @user_id', {'user_id': userId});

        // 删除用户
        await _databaseService.query('DELETE FROM {users} WHERE id = @user_id', {'user_id': userId});
      });

      // 清除缓存
      await _clearUserCache(userId);

      logInfo('用户删除成功: $userId');
    } catch (error, stackTrace) {
      logError('删除用户失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  // 私有辅助方法
  Future<bool> _isUsernameExists(String username, [String? excludeUserId]) async {
    var sql = 'SELECT 1 FROM {users} WHERE username = @username';
    final parameters = <String, dynamic>{'username': username};

    if (excludeUserId != null) {
      sql += ' AND id != @exclude_id';
      parameters['exclude_id'] = excludeUserId;
    }

    final result = await _databaseService.query(sql, parameters);
    return result.isNotEmpty;
  }

  Future<bool> _isEmailExists(String email, [String? excludeUserId]) async {
    var sql = 'SELECT 1 FROM {users} WHERE email = @email';
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
        .query('UPDATE {user_sessions} SET is_active = false WHERE user_id = @user_id', {'user_id': userId});

    // 清除Redis中的会话缓存
    await _redisService.deleteUserSession(userId);
  }

  /// 删除用户会话
  Future<void> deleteUserSession(String userId, String sessionId) async {
    try {
      logInfo('删除用户会话: user=$userId, session=$sessionId');

      await _databaseService.query('''
        UPDATE {user_sessions}
        SET is_active = false, updated_at = CURRENT_TIMESTAMP
        WHERE id = @session_id AND user_id = @user_id
      ''', {'session_id': sessionId, 'user_id': userId});

      await _redisService.deleteUserSession(userId);

      logInfo('用户会话删除成功');
    } catch (error, stackTrace) {
      logError('删除用户会话失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> _clearUserCache(String userId) async {
    await _redisService.delete('user:details:$userId');
    await _redisService.delete('user:stats');
  }
}
