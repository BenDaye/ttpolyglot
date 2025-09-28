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
}
