import 'dart:developer';

import 'database_service.dart';
import 'redis_service.dart';

/// 权限服务
class PermissionService {
  final DatabaseService _databaseService;
  final RedisService _redisService;

  PermissionService({
    required DatabaseService databaseService,
    required RedisService redisService,
  })  : _databaseService = databaseService,
        _redisService = redisService;

  /// 检查用户是否具有指定权限
  Future<bool> checkUserPermission({
    required String userId,
    required String permission,
    String? projectId,
  }) async {
    try {
      log('检查用户权限: $userId, $permission, 项目: $projectId', name: 'PermissionService');

      // 先检查缓存
      final cacheKey = 'user_permission:$userId:$permission${projectId != null ? ':$projectId' : ''}';
      final cachedResult = await _redisService.get(cacheKey);

      if (cachedResult != null) {
        return cachedResult == 'true';
      }

      // 检查是否为超级管理员
      if (await isSuperAdmin(userId)) {
        await _redisService.setPermissionCache(cacheKey, true);
        return true;
      }

      // 检查项目权限
      if (projectId != null) {
        // 检查项目所有者
        if (await isProjectOwner(userId: userId, projectId: projectId)) {
          await _redisService.setPermissionCache(cacheKey, true);
          return true;
        }

        // 检查项目级权限
        final hasProjectPermission = await _checkProjectPermission(userId, permission, projectId);
        if (hasProjectPermission) {
          await _redisService.setPermissionCache(cacheKey, true);
          return true;
        }
      }

      // 检查全局权限
      final hasGlobalPermission = await _checkGlobalPermission(userId, permission);

      // 缓存结果
      await _redisService.setPermissionCache(cacheKey, hasGlobalPermission);

      return hasGlobalPermission;
    } catch (error, stackTrace) {
      log('权限检查失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      return false;
    }
  }

  /// 批量检查用户权限（性能优化）
  Future<Map<String, bool>> checkUserPermissionsBatch({
    required String userId,
    required List<String> permissions,
    String? projectId,
  }) async {
    try {
      log('批量检查用户权限: $userId, 权限数量: ${permissions.length}, 项目: $projectId', name: 'PermissionService');

      final results = <String, bool>{};
      final uncachedPermissions = <String>[];

      // 批量检查缓存
      for (final permission in permissions) {
        final cacheKey = 'user_permission:$userId:$permission${projectId != null ? ':$projectId' : ''}';
        final cachedResult = await _redisService.get(cacheKey);

        if (cachedResult != null) {
          results[permission] = cachedResult == 'true';
        } else {
          uncachedPermissions.add(permission);
        }
      }

      // 如果有未缓存的权限，批量查询
      if (uncachedPermissions.isNotEmpty) {
        // 检查是否为超级管理员
        final isSuperAdminUser = await isSuperAdmin(userId);
        if (isSuperAdminUser) {
          // 超级管理员拥有所有权限
          for (final permission in uncachedPermissions) {
            results[permission] = true;
            final cacheKey = 'user_permission:$userId:$permission${projectId != null ? ':$projectId' : ''}';
            await _redisService.setPermissionCache(cacheKey, true);
          }
          return results;
        }

        // 批量检查权限
        final batchResults = await _checkPermissionsBatch(userId, uncachedPermissions, projectId);
        results.addAll(batchResults);

        // 批量缓存结果
        for (final permission in uncachedPermissions) {
          final cacheKey = 'user_permission:$userId:$permission${projectId != null ? ':$projectId' : ''}';
          await _redisService.setPermissionCache(cacheKey, results[permission] ?? false);
        }
      }

      return results;
    } catch (error, stackTrace) {
      log('批量权限检查失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      // 返回默认的false结果
      return {for (final permission in permissions) permission: false};
    }
  }

  /// 检查用户是否为超级管理员
  Future<bool> isSuperAdmin(String userId) async {
    try {
      // 先检查缓存
      final cacheKey = 'user_super_admin:$userId';
      final cachedResult = await _redisService.get(cacheKey);

      if (cachedResult != null) {
        return cachedResult == 'true';
      }

      // 查询数据库
      final result = await _databaseService.query('''
        SELECT 1 FROM user_roles ur
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = @user_id 
          AND r.name = 'super_admin'
          AND ur.is_active = true
          AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
        LIMIT 1
      ''', {'user_id': userId});

      final isSuperAdmin = result.isNotEmpty;

      // 缓存结果
      await _redisService.setPermissionCache(cacheKey, isSuperAdmin);

      return isSuperAdmin;
    } catch (error, stackTrace) {
      log('超级管理员检查失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      return false;
    }
  }

  /// 检查用户是否为项目所有者
  Future<bool> isProjectOwner({
    required String userId,
    required String projectId,
  }) async {
    try {
      // 先检查缓存
      final cacheKey = 'project_owner:$userId:$projectId';
      final cachedResult = await _redisService.get(cacheKey);

      if (cachedResult != null) {
        return cachedResult == 'true';
      }

      // 查询数据库
      final result = await _databaseService.query('''
        SELECT 1 FROM projects 
        WHERE id = @project_id AND owner_id = @user_id AND status = 'active'
        LIMIT 1
      ''', {
        'project_id': projectId,
        'user_id': userId,
      });

      final isOwner = result.isNotEmpty;

      // 缓存结果
      await _redisService.setPermissionCache(cacheKey, isOwner);

      return isOwner;
    } catch (error, stackTrace) {
      log('项目所有者检查失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      return false;
    }
  }

  /// 获取用户在项目中的角色
  Future<List<String>> getUserProjectRoles(String userId, String projectId) async {
    try {
      // 先检查缓存
      final cacheKey = 'user_project_roles:$userId:$projectId';
      final cachedResult = await _redisService.get(cacheKey);

      if (cachedResult != null) {
        return cachedResult.split(',');
      }

      // 查询数据库
      final result = await _databaseService.query('''
        SELECT r.name FROM user_roles ur
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = @user_id 
          AND ur.project_id = @project_id
          AND ur.is_active = true
          AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
          AND r.is_active = true
      ''', {
        'user_id': userId,
        'project_id': projectId,
      });

      final roles = result.map((row) => row[0] as String).toList();

      // 缓存结果
      if (roles.isNotEmpty) {
        await _redisService.setPermissionCache(cacheKey, roles.join(','));
      }

      return roles;
    } catch (error, stackTrace) {
      log('获取用户项目角色失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      return [];
    }
  }

  /// 获取用户的全局角色
  Future<List<String>> getUserGlobalRoles(String userId) async {
    try {
      // 先检查缓存
      final cacheKey = 'user_global_roles:$userId';
      final cachedResult = await _redisService.get(cacheKey);

      if (cachedResult != null) {
        return cachedResult.split(',');
      }

      // 查询数据库
      final result = await _databaseService.query('''
        SELECT r.name FROM user_roles ur
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = @user_id 
          AND ur.project_id IS NULL
          AND ur.is_active = true
          AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
          AND r.is_active = true
      ''', {'user_id': userId});

      final roles = result.map((row) => row[0] as String).toList();

      // 缓存结果
      if (roles.isNotEmpty) {
        await _redisService.setPermissionCache(cacheKey, roles.join(','));
      }

      return roles;
    } catch (error, stackTrace) {
      log('获取用户全局角色失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      return [];
    }
  }

  /// 获取用户的所有权限
  Future<List<String>> getUserPermissions(String userId, {String? projectId}) async {
    try {
      // 先检查缓存
      final cacheKey = 'user_permissions:$userId${projectId != null ? ':$projectId' : ''}';
      final cachedResult = await _redisService.get(cacheKey);

      if (cachedResult != null) {
        return cachedResult.split(',');
      }

      final permissions = <String>{};

      // 获取全局权限
      final globalRoles = await getUserGlobalRoles(userId);
      for (final role in globalRoles) {
        final rolePermissions = await _getRolePermissions(role);
        permissions.addAll(rolePermissions);
      }

      // 获取项目权限（如果指定了项目）
      if (projectId != null) {
        final projectRoles = await getUserProjectRoles(userId, projectId);
        for (final role in projectRoles) {
          final rolePermissions = await _getRolePermissions(role);
          permissions.addAll(rolePermissions);
        }
      }

      final permissionList = permissions.toList();

      // 缓存结果
      if (permissionList.isNotEmpty) {
        await _redisService.setPermissionCache(cacheKey, permissionList.join(','));
      }

      return permissionList;
    } catch (error, stackTrace) {
      log('获取用户权限失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      return [];
    }
  }

  /// 预热用户权限缓存（性能优化）
  Future<void> warmupUserPermissionCache(String userId, {String? projectId}) async {
    try {
      log('预热用户权限缓存: $userId, 项目: $projectId', name: 'PermissionService');

      // 并行获取用户角色和权限
      final futures = <Future>[];

      // 获取全局角色
      futures.add(getUserGlobalRoles(userId));

      // 获取项目角色（如果指定了项目）
      if (projectId != null) {
        futures.add(getUserProjectRoles(userId, projectId));
      }

      // 检查是否为超级管理员
      futures.add(isSuperAdmin(userId));

      // 检查是否为项目所有者（如果指定了项目）
      if (projectId != null) {
        futures.add(isProjectOwner(userId: userId, projectId: projectId));
      }

      await Future.wait(futures);

      log('用户权限缓存预热完成: $userId', name: 'PermissionService');
    } catch (error, stackTrace) {
      log('预热用户权限缓存失败: $userId', error: error, stackTrace: stackTrace, name: 'PermissionService');
    }
  }

  /// 清除用户权限缓存
  Future<void> clearUserPermissionCache(String userId, {String? projectId}) async {
    try {
      final patterns = [
        'user_permission:$userId:*',
        'user_super_admin:$userId',
        'user_global_roles:$userId',
        'user_permissions:$userId',
      ];

      if (projectId != null) {
        patterns.addAll([
          'project_owner:$userId:$projectId',
          'user_project_roles:$userId:$projectId',
          'user_permissions:$userId:$projectId',
        ]);
      }

      for (final pattern in patterns) {
        await _redisService.deleteByPattern(pattern);
      }

      log('用户权限缓存已清除: $userId', name: 'PermissionService');
    } catch (error, stackTrace) {
      log('清除用户权限缓存失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
    }
  }

  /// 清除角色权限缓存
  Future<void> clearRolePermissionCache(String roleName) async {
    try {
      await _redisService.deleteByPattern('role_permissions:$roleName');
      log('角色权限缓存已清除: $roleName', name: 'PermissionService');
    } catch (error, stackTrace) {
      log('清除角色权限缓存失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
    }
  }

  // 私有辅助方法

  /// 检查项目级权限
  Future<bool> _checkProjectPermission(String userId, String permission, String projectId) async {
    final result = await _databaseService.query('''
      SELECT 1 FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      JOIN role_permissions rp ON r.id = rp.role_id
      JOIN permissions p ON rp.permission_id = p.id
      WHERE ur.user_id = @user_id 
        AND ur.project_id = @project_id
        AND p.name = @permission
        AND ur.is_active = true
        AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
        AND r.is_active = true
        AND p.is_active = true
        AND rp.is_granted = true
      LIMIT 1
    ''', {
      'user_id': userId,
      'project_id': projectId,
      'permission': permission,
    });

    return result.isNotEmpty;
  }

  /// 检查全局权限
  Future<bool> _checkGlobalPermission(String userId, String permission) async {
    final result = await _databaseService.query('''
      SELECT 1 FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      JOIN role_permissions rp ON r.id = rp.role_id
      JOIN permissions p ON rp.permission_id = p.id
      WHERE ur.user_id = @user_id 
        AND ur.project_id IS NULL
        AND p.name = @permission
        AND ur.is_active = true
        AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
        AND r.is_active = true
        AND p.is_active = true
        AND rp.is_granted = true
      LIMIT 1
    ''', {
      'user_id': userId,
      'permission': permission,
    });

    return result.isNotEmpty;
  }

  /// 获取角色的权限列表
  Future<List<String>> _getRolePermissions(String roleName) async {
    // 先检查缓存
    final cacheKey = 'role_permissions:$roleName';
    final cachedResult = await _redisService.get(cacheKey);

    if (cachedResult != null) {
      return cachedResult.split(',');
    }

    // 查询数据库
    final result = await _databaseService.query('''
      SELECT p.name FROM roles r
      JOIN role_permissions rp ON r.id = rp.role_id
      JOIN permissions p ON rp.permission_id = p.id
      WHERE r.name = @role_name
        AND r.is_active = true
        AND p.is_active = true
        AND rp.is_granted = true
    ''', {'role_name': roleName});

    final permissions = result.map((row) => row[0] as String).toList();

    // 缓存结果
    if (permissions.isNotEmpty) {
      await _redisService.setPermissionCache(cacheKey, permissions.join(','));
    }

    return permissions;
  }

  /// 批量检查权限（性能优化）
  Future<Map<String, bool>> _checkPermissionsBatch(
    String userId,
    List<String> permissions,
    String? projectId,
  ) async {
    try {
      final results = <String, bool>{};

      // 检查项目所有者权限
      bool isProjectOwnerUser = false;
      if (projectId != null) {
        isProjectOwnerUser = await isProjectOwner(userId: userId, projectId: projectId);
        if (isProjectOwnerUser) {
          // 项目所有者拥有所有权限
          for (final permission in permissions) {
            results[permission] = true;
          }
          return results;
        }
      }

      // 批量查询权限
      final permissionPlaceholders = permissions.map((_) => '@permission_${permissions.indexOf(_)}').join(',');
      final parameters = <String, dynamic>{
        'user_id': userId,
        'project_id': projectId,
      };

      for (int i = 0; i < permissions.length; i++) {
        parameters['permission_$i'] = permissions[i];
      }

      final sql = '''
        SELECT p.name FROM user_roles ur
        JOIN roles r ON ur.role_id = r.id
        JOIN role_permissions rp ON r.id = rp.role_id
        JOIN permissions p ON rp.permission_id = p.id
        WHERE ur.user_id = @user_id 
          AND p.name IN ($permissionPlaceholders)
          AND ur.is_active = true
          AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
          AND r.is_active = true
          AND p.is_active = true
          AND rp.is_granted = true
          ${projectId != null ? 'AND ur.project_id = @project_id' : 'AND ur.project_id IS NULL'}
      ''';

      final result = await _databaseService.query(sql, parameters);
      final grantedPermissions = result.map((row) => row[0] as String).toSet();

      // 设置结果
      for (final permission in permissions) {
        results[permission] = grantedPermissions.contains(permission);
      }

      return results;
    } catch (error, stackTrace) {
      log('批量权限检查失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      // 返回默认的false结果
      return {for (final permission in permissions) permission: false};
    }
  }

  /// 获取权限检查统计信息（监控优化）
  Future<Map<String, dynamic>> getPermissionStats() async {
    try {
      final stats = <String, dynamic>{};

      // 获取数据库查询统计
      final dbStats = await _databaseService.query('''
        SELECT 
          COUNT(*) as total_users,
          COUNT(*) FILTER (WHERE is_active = true) as active_users,
          COUNT(DISTINCT ur.user_id) as users_with_roles,
          COUNT(DISTINCT ur.role_id) as active_roles,
          COUNT(DISTINCT rp.permission_id) as active_permissions
        FROM users u
        LEFT JOIN user_roles ur ON u.id = ur.user_id AND ur.is_active = true
        LEFT JOIN roles r ON ur.role_id = r.id AND r.is_active = true
        LEFT JOIN role_permissions rp ON r.id = rp.role_id AND rp.is_granted = true
      ''');

      if (dbStats.isNotEmpty) {
        stats['database'] = dbStats.first.toColumnMap();
      }

      // 添加缓存统计（简化版本）
      stats['cache_info'] = {
        'note': '缓存统计需要Redis服务支持getKeysByPattern方法',
        'timestamp': DateTime.now().toIso8601String(),
      };

      return stats;
    } catch (error, stackTrace) {
      log('获取权限统计信息失败', error: error, stackTrace: stackTrace, name: 'PermissionService');
      return {};
    }
  }
}
