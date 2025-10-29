import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 认证服务
class AuthService extends BaseService {
  final DatabaseService _databaseService;
  final RedisService _redisService;
  final UserService _userService;
  late final JwtUtils _jwtUtils;
  late final CryptoUtils _cryptoUtils;
  late final EmailService _emailService;

  AuthService({
    required DatabaseService databaseService,
    required RedisService redisService,
    required EmailService emailService,
    required UserService userService,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        _emailService = emailService,
        _userService = userService,
        super('AuthService') {
    _jwtUtils = JwtUtils();
    _cryptoUtils = CryptoUtils();
  }

  /// 用户注册
  Future<UserInfoModel?> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
    String? timezone,
    String? locale,
  }) async {
    try {
      LoggerUtils.info('用户注册: $username, $email');

      // 验证输入
      _validateRegistrationInput(username, email, password);

      // 检查用户名是否已存在
      if (await _isUsernameExists(username)) {
        throwBusiness('用户名已存在');
      }

      // 检查邮箱是否已存在
      if (await _isEmailExists(email)) {
        throwBusiness('邮箱已被使用');
      }

      // 验证密码强度
      final passwordStrength = _cryptoUtils.checkPasswordStrength(password);
      if (!passwordStrength.isAcceptable) {
        throwValidation('密码强度不足：${passwordStrength.checks.join(', ')}');
      }

      // 加密密码
      final passwordHash = _cryptoUtils.hashPassword(password);

      // 在事务中创建用户
      final userId = await _databaseService.transaction(() async {
        // 插入用户
        final result = await _databaseService.query('''
          INSERT INTO {users} (
            username, email, password_hash, display_name, 
            timezone, locale, is_active, is_email_verified
          ) VALUES (
            @username, @email, @password_hash, @display_name,
            @timezone, @locale, true, false
          ) RETURNING id
        ''', {
          'username': username,
          'email': email,
          'password_hash': passwordHash,
          'display_name': displayName ?? username,
          'timezone': timezone ?? 'UTC',
          'locale': locale ?? 'en-US',
        });

        // users.id 是 UUID 类型，需要安全转换为字符串
        final rawUserId = result.first[0];
        return rawUserId.toString();
      });

      LoggerUtils.info('用户注册成功: $userId');

      // 生成邮箱验证令牌
      final verificationToken = _jwtUtils.generateEmailVerificationToken(userId, email);

      // 存储验证令牌到Redis
      await _redisService.setTempData('email_verification:$userId', verificationToken);

      final userInfo = await _userService.getUserById(userId);

      return userInfo!;
    } catch (error, stackTrace) {
      LoggerUtils.error('用户注册失败', error: error, stackTrace: stackTrace);

      if (error is ServerException) {
        return null;
      }

      return null;
    }
  }

  /// 用户登录
  Future<LoginResponseModel?> login({
    required String emailOrUsername,
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
    String? userAgent,
  }) async {
    try {
      LoggerUtils.info('用户登录尝试: $emailOrUsername');

      // 查找用户
      final user = await _findUserByEmailOrUsername(emailOrUsername);
      if (user == null) {
        throwBusiness('用户名或密码错误');
      }

      // 检查账户状态
      if (!user['is_active']) {
        throwBusiness('账户已被禁用');
      }

      // 检查账户锁定
      if (user['locked_until'] != null) {
        final lockedUntil = DateTime.parse(user['locked_until']);
        if (lockedUntil.isAfter(DateTime.now())) {
          throwBusiness('账户已被锁定，请稍后重试');
        }
      }

      // 验证密码
      final passwordHash = user['password_hash'] as String;
      if (!_cryptoUtils.verifyPassword(password, passwordHash)) {
        // 增加登录失败次数
        await _incrementLoginAttempts(user['id']);
        throwBusiness('用户名或密码错误');
      }

      // 重置登录失败次数
      await _resetLoginAttempts(user['id']);

      // 生成令牌
      final userId = user['id'] as String;
      final tokenPayload = {
        'user_id': userId,
        'username': user['username'],
        'email': user['email'],
      };

      final accessToken = _jwtUtils.generateAccessToken(tokenPayload);
      final refreshToken = _jwtUtils.generateRefreshToken(tokenPayload);

      // 生成令牌哈希
      final accessTokenHash = _jwtUtils.generateTokenHash(accessToken);
      final refreshTokenHash = _jwtUtils.generateTokenHash(refreshToken);

      // 失效该设备的旧会话（防止重复登录冲突）
      await _invalidateDeviceSessions(
        userId: userId,
        deviceId: deviceId,
      );

      // 创建会话记录
      await _createUserSession(
        userId: userId,
        accessTokenHash: accessTokenHash,
        refreshTokenHash: refreshTokenHash,
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType ?? 'web',
        ipAddress: ipAddress,
        userAgent: userAgent,
      );

      // 缓存用户会话到Redis
      await _redisService.setUserSession(userId, {
        'user_id': userId,
        'username': user['username'],
        'email': user['email'],
        'display_name': user['display_name'],
        'access_token_hash': accessTokenHash,
        'login_at': DateTime.now().toIso8601String(),
      });

      // 更新最后登录时间
      await _updateLastLogin(userId, ipAddress);

      // 获取完整的用户信息（包括角色、地理位置等）
      final fullUserInfo = await _userService.getUserById(userId);
      if (fullUserInfo == null) {
        throwBusiness('获取用户信息失败');
      }

      LoggerUtils.info('用户登录成功: $userId');

      return LoginResponseModel(
        user: fullUserInfo,
        tokens: TokenInfoModel(
          accessToken: accessToken,
          refreshToken: refreshToken,
          tokenType: 'Bearer',
          expiresIn: ServerConfig.jwtExpireHours * 3600,
        ),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('用户登录失败: $emailOrUsername', error: error, stackTrace: stackTrace);

      if (error is ServerException) {
        return null;
      }

      return null;
    }
  }

  /// 刷新令牌
  Future<TokenInfoModel?> refreshToken(String refreshToken) async {
    try {
      // final logger = LoggerFactory.getLogger('AuthService');
      LoggerUtils.info('刷新令牌');

      // 验证刷新令牌
      final payload = _jwtUtils.verifyToken(refreshToken);
      if (payload == null || !_jwtUtils.isRefreshToken(refreshToken)) {
        throwBusiness('无效的刷新令牌');
      }

      final userId = payload['user_id'] as String;

      // 检查会话是否存在
      final refreshTokenHash = _jwtUtils.generateTokenHash(refreshToken);
      final sessionExists = await _isSessionExists(userId, refreshTokenHash);
      if (!sessionExists) {
        throwBusiness('会话不存在或已过期');
      }

      // 获取最新用户信息
      final user = await _findUserById(userId);
      if (user == null || !user['is_active']) {
        throwBusiness('用户不存在或已被禁用');
      }

      // 生成新的访问令牌
      final tokenPayload = {
        'user_id': userId,
        'username': user['username'],
        'email': user['email'],
      };

      final newAccessToken = _jwtUtils.generateAccessToken(tokenPayload);
      final newAccessTokenHash = _jwtUtils.generateTokenHash(newAccessToken);

      // 更新会话中的访问令牌哈希
      await _updateSessionAccessToken(userId, refreshTokenHash, newAccessTokenHash);

      // 更新Redis缓存
      await _redisService.setUserSession(userId, {
        'user_id': userId,
        'username': user['username'],
        'email': user['email'],
        'display_name': user['display_name'],
        'access_token_hash': newAccessTokenHash,
        'refreshed_at': DateTime.now().toIso8601String(),
      });

      LoggerUtils.info('令牌刷新成功: $userId');

      return TokenInfoModel(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
        tokenType: 'Bearer',
        expiresIn: ServerConfig.jwtExpireHours * 3600,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('令牌刷新失败', error: error, stackTrace: stackTrace);

      if (error is ServerException) {
        return null;
      }

      return null;
    }
  }

  /// 用户登出
  Future<bool?> logout(String accessToken) async {
    try {
      LoggerUtils.info('用户登出');

      // 验证访问令牌
      final payload = _jwtUtils.verifyToken(accessToken);
      if (payload == null) {
        throwBusiness('无效的访问令牌');
      }

      final userId = payload['user_id'] as String;
      final accessTokenHash = _jwtUtils.generateTokenHash(accessToken);

      // 删除会话
      await _deleteUserSession(userId, accessTokenHash);

      // 删除Redis缓存
      await _redisService.deleteUserSession(userId);

      LoggerUtils.info('用户登出成功: $userId');

      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('用户登出失败', error: error, stackTrace: stackTrace);

      if (error is ServerException) {
        return null;
      }

      return null;
    }
  }

  /// 验证访问令牌
  Future<Map<String, dynamic>?> verifyAccessToken(String accessToken) async {
    try {
      // 验证JWT令牌
      final payload = _jwtUtils.verifyToken(accessToken);
      if (payload == null || !_jwtUtils.isAccessToken(accessToken)) {
        return null;
      }

      final userId = payload['user_id'] as String;

      // 检查Redis缓存中的会话
      final session = await _redisService.getUserSession(userId);
      if (session == null) {
        LoggerUtils.warning('用户会话不存在: $userId');
        return null;
      }

      // 验证令牌哈希
      final accessTokenHash = _jwtUtils.generateTokenHash(accessToken);
      if (session['access_token_hash'] != accessTokenHash) {
        LoggerUtils.warning('访问令牌哈希不匹配: $userId');
        return null;
      }

      return payload;
    } catch (error, stackTrace) {
      LoggerUtils.error('访问令牌验证失败', error: error, stackTrace: stackTrace);

      if (error is ServerException) {
        return null;
      }

      return null;
    }
  }

  /// 邮箱验证
  Future<bool?> verifyEmail(String token) async {
    try {
      LoggerUtils.info('邮箱验证');

      // 验证邮箱验证令牌
      final payload = _jwtUtils.verifyEmailVerificationToken(token);
      if (payload == null) {
        throwBusiness('无效的验证令牌');
      }

      final userId = payload['user_id'] as String;
      final email = payload['email'] as String;

      // 检查Redis中的验证令牌
      final storedToken = await _redisService.getTempData('email_verification:$userId');
      if (storedToken != token) {
        throwBusiness('验证令牌不匹配');
      }

      // 更新用户邮箱验证状态
      await _databaseService.query('''
        UPDATE {users} 
        SET is_email_verified = true, email_verified_at = CURRENT_TIMESTAMP
        WHERE id = @user_id AND email = @email
      ''', {
        'user_id': userId,
        'email': email,
      });

      // 删除验证令牌
      await _redisService.delete('temp:email_verification:$userId');

      LoggerUtils.info('邮箱验证成功: $userId');

      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('邮箱验证失败', error: error, stackTrace: stackTrace);

      if (error is ServerException) {
        return null;
      }

      return null;
    }
  }

  /// 忘记密码
  Future<bool?> forgotPassword(String email) async {
    try {
      LoggerUtils.info('忘记密码请求: $email');

      if (!_cryptoUtils.isValidEmail(email)) {
        return false;
      }

      // 查找用户
      final userResult = await _databaseService.query(
        'SELECT id, username, email, display_name FROM {users} WHERE email = @email AND is_active = true',
        {'email': email},
      );

      if (userResult.isEmpty) {
        // 为了安全，即使用户不存在也返回成功消息
        return true;
      }

      final user = userResult.first.toColumnMap();
      final userId = user['id'] as String;
      final username = user['username'] as String;

      // 生成密码重置令牌
      final token = _jwtUtils.generatePasswordResetToken(userId, email);
      final tokenHash = _cryptoUtils.hashToken(token);

      // 存储重置令牌到Redis（1小时过期）
      await _redisService.setTempData('password_reset:$userId', tokenHash);

      // 发送重置密码邮件
      final emailSent = await _emailService.sendForgotPassword(
        to: email,
        username: username,
        token: tokenHash,
      );

      if (emailSent) {
        LoggerUtils.info('密码重置邮件发送成功: $email');
      } else {
        LoggerUtils.warning('密码重置邮件发送失败: $email');
      }

      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('忘记密码失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 重置密码
  Future<bool?> resetPassword(String token, String newPassword) async {
    try {
      LoggerUtils.info('重置密码');

      // 验证密码重置令牌
      final payload = _jwtUtils.verifyPasswordResetToken(token);
      if (payload == null) {
        throwBusiness('无效的重置令牌');
      }

      final userId = payload['user_id'] as String;
      final email = payload['email'] as String;

      // 检查Redis中的重置令牌
      final storedToken = await _redisService.getTempData('password_reset:$userId');
      if (storedToken != token) {
        throwBusiness('重置令牌不匹配或已过期');
      }

      // 验证新密码强度
      final passwordStrength = _cryptoUtils.checkPasswordStrength(newPassword);
      if (!passwordStrength.isAcceptable) {
        throwValidation('密码强度不足：${passwordStrength.checks.join(', ')}');
      }

      // 加密新密码
      final passwordHash = _cryptoUtils.hashPassword(newPassword);

      // 更新密码
      await _databaseService.query('''
        UPDATE {users} 
        SET password_hash = @password_hash, 
            updated_at = CURRENT_TIMESTAMP
        WHERE id = @user_id AND email = @email
      ''', {
        'user_id': userId,
        'email': email,
        'password_hash': passwordHash,
      });

      // 删除重置令牌
      await _redisService.delete('temp:password_reset:$userId');

      // 删除所有用户会话（强制重新登录）
      await _deleteAllUserSessions(userId);

      LoggerUtils.info('密码重置成功: $userId');

      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('重置密码失败', error: error, stackTrace: stackTrace);

      if (error is ServerException) {
        return null;
      }

      return null;
    }
  }

  /// 重发邮箱验证邮件
  Future<bool?> resendVerification(String email) async {
    try {
      if (!_cryptoUtils.isValidEmail(email)) {
        return false;
      }

      // 查找用户
      final userResult = await _databaseService.query(
        'SELECT id, username, is_email_verified FROM {users} WHERE email = @email',
        {'email': email},
      );

      if (userResult.isEmpty) {
        return false;
      }

      final user = userResult.first.toColumnMap();
      if (user['is_email_verified'] as bool) {
        return false;
      }

      // 生成新的验证令牌
      final token = _jwtUtils.generateEmailVerificationToken(user['id'] as String, email);
      final tokenHash = _cryptoUtils.hashToken(token);

      // 存储验证令牌到Redis
      await _redisService.setTempData('email_verification:${user['id']}', tokenHash);

      // 发送验证邮件
      final emailSent = await _emailService.sendEmailVerification(
        to: email,
        username: user['username'] as String,
        token: tokenHash,
      );

      if (emailSent) {
        LoggerUtils.info('验证邮件发送成功: $email');
      } else {
        LoggerUtils.warning('验证邮件发送失败: $email');
      }

      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('重发验证邮件失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  // 私有辅助方法
  void _validateRegistrationInput(String username, String email, String password) {
    if (username.isEmpty || username.length < 3) {
      throwBusiness('用户名至少3个字符');
    }

    if (!_cryptoUtils.isValidEmail(email)) {
      throwBusiness('邮箱格式不正确');
    }

    if (password.isEmpty || password.length < 8) {
      throwBusiness('密码至少8个字符');
    }
  }

  Future<bool> _isUsernameExists(String username) async {
    final result = await _databaseService
        .query('SELECT 1 FROM {users} WHERE username = @username LIMIT 1', {'username': username});
    return result.isNotEmpty;
  }

  Future<bool> _isEmailExists(String email) async {
    final result = await _databaseService.query('SELECT 1 FROM {users} WHERE email = @email LIMIT 1', {'email': email});
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>?> _findUserByEmailOrUsername(String emailOrUsername) async {
    final result = await _databaseService.query('''
      SELECT id, username, email, password_hash, display_name, avatar_url,
             timezone, locale, is_active, is_email_verified, locked_until
      FROM {users} 
      WHERE (email = @identifier OR username = @identifier) AND is_active = true
      LIMIT 1
    ''', {'identifier': emailOrUsername});

    return result.isNotEmpty ? result.first.toColumnMap() : null;
  }

  Future<Map<String, dynamic>?> _findUserById(String userId) async {
    final result = await _databaseService.query('''
      SELECT id, username, email, display_name, avatar_url,
             timezone, locale, is_active, is_email_verified
      FROM {users} 
      WHERE id = @user_id AND is_active = true
      LIMIT 1
    ''', {'user_id': userId});

    return result.isNotEmpty ? result.first.toColumnMap() : null;
  }

  /// 根据ID获取用户信息（公开方法）
  /// 委托给 UserService 处理，避免重复代码
  Future<UserInfoModel?> getUserById(String userId) async {
    return await _userService.getUserById(userId);
  }

  Future<void> _incrementLoginAttempts(String userId) async {
    await _databaseService.query('''
      UPDATE {users} 
      SET login_attempts = login_attempts + 1,
          locked_until = CASE 
            WHEN login_attempts + 1 >= @max_attempts 
            THEN CURRENT_TIMESTAMP + INTERVAL '@lockout_minutes minutes'
            ELSE locked_until
          END
      WHERE id = @user_id
    ''', {
      'user_id': userId,
      'max_attempts': ServerConfig.maxLoginAttempts,
      'lockout_minutes': ServerConfig.accountLockoutMinutes,
    });
  }

  Future<void> _resetLoginAttempts(String userId) async {
    await _databaseService.query('''
      UPDATE {users} 
      SET login_attempts = 0, locked_until = NULL
      WHERE id = @user_id
    ''', {'user_id': userId});
  }

  Future<void> _updateLastLogin(String userId, String? ipAddress) async {
    await _databaseService.query('''
      UPDATE {users} 
      SET last_login_at = CURRENT_TIMESTAMP, last_login_ip = @ip_address
      WHERE id = @user_id
    ''', {
      'user_id': userId,
      'ip_address': ipAddress,
    });
  }

  /// 失效用户在特定设备上的旧会话
  Future<void> _invalidateDeviceSessions({
    required String userId,
    String? deviceId,
  }) async {
    try {
      if (deviceId != null && deviceId.isNotEmpty) {
        // 失效该设备的所有旧会话
        await _databaseService.query('''
          UPDATE {user_sessions} 
          SET is_active = false
          WHERE user_id = @user_id 
            AND device_id = @device_id
            AND is_active = true
        ''', {
          'user_id': userId,
          'device_id': deviceId,
        });
        LoggerUtils.info('已失效用户 $userId 在设备 $deviceId 上的旧会话');
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('失效设备会话失败', error: error, stackTrace: stackTrace);
      // 不抛出异常，继续登录流程
    }
  }

  Future<void> _createUserSession({
    required String userId,
    required String accessTokenHash,
    required String refreshTokenHash,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
    String? userAgent,
  }) async {
    await _databaseService.query('''
      INSERT INTO {user_sessions} (
        user_id, token_hash, refresh_token_hash, device_id, device_name,
        device_type, ip_address, user_agent, expires_at
      ) VALUES (
        @user_id, @token_hash, @refresh_token_hash, @device_id, @device_name,
        @device_type, @ip_address, @user_agent, @expires_at
      )
    ''', {
      'user_id': userId,
      'token_hash': accessTokenHash,
      'refresh_token_hash': refreshTokenHash,
      'device_id': deviceId,
      'device_name': deviceName,
      'device_type': deviceType,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'expires_at': DateTime.now().add(Duration(days: ServerConfig.jwtRefreshExpireDays)).toIso8601String(),
    });
  }

  Future<bool> _isSessionExists(String userId, String refreshTokenHash) async {
    final result = await _databaseService.query('''
      SELECT 1 FROM {user_sessions} 
      WHERE user_id = @user_id 
        AND refresh_token_hash = @refresh_token_hash 
        AND is_active = true 
        AND expires_at > CURRENT_TIMESTAMP
      LIMIT 1
    ''', {
      'user_id': userId,
      'refresh_token_hash': refreshTokenHash,
    });

    return result.isNotEmpty;
  }

  Future<void> _updateSessionAccessToken(String userId, String refreshTokenHash, String newAccessTokenHash) async {
    await _databaseService.query('''
      UPDATE {user_sessions} 
      SET token_hash = @new_token_hash, last_activity_at = CURRENT_TIMESTAMP
      WHERE user_id = @user_id AND refresh_token_hash = @refresh_token_hash
    ''', {
      'user_id': userId,
      'refresh_token_hash': refreshTokenHash,
      'new_token_hash': newAccessTokenHash,
    });
  }

  Future<void> _deleteUserSession(String userId, String accessTokenHash) async {
    await _databaseService.query('''
      UPDATE {user_sessions} 
      SET is_active = false
      WHERE user_id = @user_id AND token_hash = @token_hash
    ''', {
      'user_id': userId,
      'token_hash': accessTokenHash,
    });
  }

  Future<void> _deleteAllUserSessions(String userId) async {
    await _databaseService.query('''
      UPDATE {user_sessions} 
      SET is_active = false
      WHERE user_id = @user_id
    ''', {
      'user_id': userId,
    });
  }
}
