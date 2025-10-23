import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目缓存服务
/// 负责项目列表的本地缓存管理（读取/写入缓存）
class ProjectCacheService {
  static const String _cacheKey = 'projects_cache';
  static const String _cacheTimestampKey = 'projects_cache_timestamp';
  static const Duration _cacheExpiration = Duration(minutes: 30); // 缓存有效期

  final SharedPreferences _prefs;

  ProjectCacheService(this._prefs);

  /// 获取缓存的项目列表
  Future<List<ProjectModel>?> getCachedProjects() async {
    try {
      final cachedData = _prefs.getString(_cacheKey);
      if (cachedData == null) {
        log('[getCachedProjects] 缓存为空', name: 'ProjectCacheService');
        return null;
      }

      // 检查缓存是否过期
      if (_isCacheExpired()) {
        log('[getCachedProjects] 缓存已过期', name: 'ProjectCacheService');
        await clearCache();
        return null;
      }

      final jsonList = jsonDecode(cachedData) as List<dynamic>;
      final projects = jsonList.map((json) => ProjectModel.fromJson(json as Map<String, dynamic>)).toList();

      log('[getCachedProjects] 从缓存读取 ${projects.length} 个项目', name: 'ProjectCacheService');
      return projects;
    } catch (error, stackTrace) {
      log('[getCachedProjects]', error: error, stackTrace: stackTrace, name: 'ProjectCacheService');
      return null;
    }
  }

  /// 缓存项目列表
  Future<void> cacheProjects(List<ProjectModel> projects) async {
    try {
      final jsonList = projects.map((project) => project.toJson()).toList();
      final cachedData = jsonEncode(jsonList);

      await _prefs.setString(_cacheKey, cachedData);
      await _prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);

      log('[cacheProjects] 已缓存 ${projects.length} 个项目', name: 'ProjectCacheService');
    } catch (error, stackTrace) {
      log('[cacheProjects]', error: error, stackTrace: stackTrace, name: 'ProjectCacheService');
    }
  }

  /// 更新单个项目缓存
  Future<void> updateCachedProject(ProjectModel project) async {
    try {
      final cachedProjects = await getCachedProjects();
      if (cachedProjects == null) {
        // 如果没有缓存，创建新缓存
        await cacheProjects([project]);
        return;
      }

      // 查找并更新项目
      final index = cachedProjects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        cachedProjects[index] = project;
        await cacheProjects(cachedProjects);
        log('[updateCachedProject] 已更新项目: ${project.name}', name: 'ProjectCacheService');
      } else {
        // 如果项目不存在，添加到缓存
        cachedProjects.add(project);
        await cacheProjects(cachedProjects);
        log('[updateCachedProject] 已添加项目到缓存: ${project.name}', name: 'ProjectCacheService');
      }
    } catch (error, stackTrace) {
      log('[updateCachedProject]', error: error, stackTrace: stackTrace, name: 'ProjectCacheService');
    }
  }

  /// 从缓存中删除项目
  Future<void> removeCachedProject(int projectId) async {
    try {
      final cachedProjects = await getCachedProjects();
      if (cachedProjects == null) return;

      cachedProjects.removeWhere((p) => p.id == projectId);
      await cacheProjects(cachedProjects);

      log('[removeCachedProject] 已从缓存删除项目: $projectId', name: 'ProjectCacheService');
    } catch (error, stackTrace) {
      log('[removeCachedProject]', error: error, stackTrace: stackTrace, name: 'ProjectCacheService');
    }
  }

  /// 清除缓存
  Future<void> clearCache() async {
    try {
      await _prefs.remove(_cacheKey);
      await _prefs.remove(_cacheTimestampKey);
      log('[clearCache] 缓存已清除', name: 'ProjectCacheService');
    } catch (error, stackTrace) {
      log('[clearCache]', error: error, stackTrace: stackTrace, name: 'ProjectCacheService');
    }
  }

  /// 检查缓存是否过期
  bool _isCacheExpired() {
    final timestamp = _prefs.getInt(_cacheTimestampKey);
    if (timestamp == null) return true;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);

    return difference > _cacheExpiration;
  }

  /// 获取缓存时间
  DateTime? getCacheTime() {
    final timestamp = _prefs.getInt(_cacheTimestampKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// 检查是否有缓存
  bool hasCache() {
    return _prefs.containsKey(_cacheKey);
  }
}
