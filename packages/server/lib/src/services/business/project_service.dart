import 'dart:convert';

import 'package:ttpolyglot_model/model.dart';

import '../../config/server_config.dart';
import '../../utils/data/string_utils.dart';
import '../base_service.dart';
import '../infrastructure/database_service.dart';
import '../infrastructure/redis_service.dart';

/// 项目服务
class ProjectService extends BaseService {
  final DatabaseService _databaseService;
  final RedisService _redisService;

  ProjectService({
    required DatabaseService databaseService,
    required RedisService redisService,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        super('ProjectService');

  /// 获取项目列表
  Future<PagerModel<ProjectModel>> getProjects({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? userId,
  }) async {
    try {
      logInfo('获取项目列表: page=$page, limit=$limit, userId=$userId');

      // 构建查询条件
      final conditions = <String>[];
      final parameters = <String, dynamic>{};

      if (search != null && search.isNotEmpty) {
        conditions.add('(p.name ILIKE @search OR COALESCE(p.description, \'\') ILIKE @search)');
        parameters['search'] = '%$search%';
      }

      if (status != null && status.isNotEmpty && status != 'all') {
        conditions.add('p.status = @status');
        parameters['status'] = status;
      }

      // 如果指定了用户ID，只返回该用户参与的项目
      if (userId != null) {
        conditions.add('''
          (p.owner_id = @user_id OR 
          EXISTS (
            SELECT 1 FROM {project_members} pm 
            WHERE pm.user_id = @user_id 
              AND pm.project_id = p.id 
              AND pm.is_active = true
          ))
        ''');
        parameters['user_id'] = userId;
      }

      // 计算总数
      final countSql = '''
        SELECT COUNT(*) FROM {projects} p
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

      final projectsSql = '''
        SELECT 
          p.id, p.name, p.slug, p.description, p.status, p.visibility,
          p.owner_id,
          p.primary_language_id, p.total_keys, p.translated_keys, 
          p.languages_count, p.members_count, p.member_limit, p.settings,
          p.last_activity_at, p.created_at, p.updated_at,
          u.username as owner_username,
          u.email as owner_email,
          u.display_name as owner_display_name,
          CASE 
            WHEN p.total_keys > 0 
            THEN ROUND((p.translated_keys::numeric / p.total_keys * 100), 2)
            ELSE 0 
          END as completion_percentage
        FROM {projects} p
        LEFT JOIN {users} u ON p.owner_id = u.id
        ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
        ORDER BY p.last_activity_at DESC
        LIMIT @limit OFFSET @offset
      ''';

      final projectsResult = await _databaseService.query(projectsSql, parameters);

      final projects = projectsResult.map((row) {
        final projectData = row.toColumnMap();

        // 解析设置信息 - JSONB 字段已自动解析为 Map
        if (projectData['settings'] == null || projectData['settings'] is! Map) {
          projectData['settings'] = <String, dynamic>{};
        }

        return projectData;
      }).toList();

      return PagerModel<ProjectModel>(
        page: page,
        pageSize: limit,
        totalSize: total,
        totalPage: (total / limit).ceil(),
        items: projects.map((project) => ProjectModel.fromJson(project)).toList(),
      );
    } catch (error, stackTrace) {
      logError('获取项目列表失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 根据ID获取项目详情
  Future<ProjectDetailModel?> getProjectById(String projectId, {String? userId}) async {
    try {
      logInfo('获取项目详情: $projectId');

      // 先检查缓存
      final cacheKey = 'project:details:$projectId';
      final cachedProjectDetail = await _redisService.getJson(cacheKey);
      if (cachedProjectDetail != null) {
        try {
          // 验证缓存数据结构
          if (cachedProjectDetail['project'] != null) {
            return ProjectDetailModel.fromJson(cachedProjectDetail);
          } else {
            // 缓存数据结构无效，删除缓存
            logInfo('缓存数据结构无效，删除缓存: $cacheKey');
            await _redisService.delete(cacheKey);
          }
        } catch (cacheError, cacheStackTrace) {
          // 缓存数据解析失败，删除缓存并继续查询数据库
          logError('缓存数据解析失败', error: cacheError, stackTrace: cacheStackTrace);
          await _redisService.delete(cacheKey);
        }
      }

      final sql = '''
        SELECT 
          p.id, p.name, p.slug, p.description, p.status, p.visibility,
          p.primary_language_id, p.total_keys, p.translated_keys, 
          p.languages_count, p.members_count, p.member_limit, p.settings,
          p.last_activity_at, p.created_at, p.updated_at,
          u.id as owner_id, u.username as owner_username,
          u.email as owner_email,
          u.display_name as owner_display_name, u.avatar_url as owner_avatar,
          CASE 
            WHEN p.total_keys > 0 
            THEN ROUND((p.translated_keys::numeric / p.total_keys * 100), 2)
            ELSE 0 
          END as completion_percentage
        FROM {projects} p
        LEFT JOIN {users} u ON p.owner_id = u.id
        WHERE p.id = @project_id
      ''';

      final result = await _databaseService.query(sql, {'project_id': projectId});

      if (result.isEmpty) {
        return null;
      }

      final projectData = result.first.toColumnMap();

      // 解析设置信息 - JSONB 字段已自动解析为 Map
      if (projectData['settings'] == null || projectData['settings'] is! Map) {
        projectData['settings'] = <String, dynamic>{};
      }

      // 如果指定了用户ID，检查用户权限
      if (userId != null) {
        projectData['user_role'] = await _getUserRoleInProject(userId, projectId);
        projectData['is_owner'] = projectData['owner_id'] == userId;
      }

      // 构建项目模型
      final project = ProjectModel.fromJson(projectData);

      // 获取项目语言列表
      final languages = await getProjectLanguages(projectId);

      // 获取项目成员列表
      final members = await getProjectMembers(projectId);

      // 组装项目详情模型
      final projectDetail = ProjectDetailModel(
        project: project,
        languages: languages.isNotEmpty ? languages : null,
        members: members,
      );

      // 缓存项目详情
      await _redisService.setJson(cacheKey, projectDetail.toJson(), ServerConfig.cacheApiResponseTtl);

      return projectDetail;
    } catch (error, stackTrace) {
      logError('获取项目详情失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查项目名称是否可用
  Future<bool> checkProjectNameAvailable(String name, {int? excludeProjectId}) async {
    try {
      logInfo('检查项目名称: $name, excludeProjectId: $excludeProjectId');

      final conditions = <String>['LOWER(name) = LOWER(@name)'];
      final parameters = <String, dynamic>{'name': name};

      if (excludeProjectId != null) {
        conditions.add('id != @exclude_id');
        parameters['exclude_id'] = excludeProjectId;
      }

      final sql = '''
        SELECT COUNT(*) as count FROM {projects}
        WHERE ${conditions.join(' AND ')}
      ''';

      final result = await _databaseService.query(sql, parameters);
      // COUNT(*) 返回的可能是 int 或 bigint，需要安全转换
      final countRaw = result.first[0];
      final count = (countRaw is int) ? countRaw : int.parse(countRaw.toString());

      return count == 0;
    } catch (error, stackTrace) {
      logError('检查项目名称失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 序列化 settings，处理 DateTime 等特殊类型
  String _serializeSettings(Map<String, dynamic>? settings) {
    if (settings == null) return '{}';

    return jsonEncode(settings, toEncodable: (dynamic value) {
      if (value is DateTime) {
        return value.toIso8601String();
      }
      return value;
    });
  }

  /// 创建项目
  Future<ProjectModel> createProject({
    required String name,
    required String ownerId,
    required int primaryLanguageId,
    String? description,
    String? slug,
    String visibility = 'private',
    Map<String, dynamic>? settings,
    List<int>? targetLanguageIds,
  }) async {
    try {
      logInfo(
          '创建项目: name: $name, owner: $ownerId, primaryLanguageId: $primaryLanguageId, targetLanguages: $targetLanguageIds,  description: $description');

      // 验证主语言是否存在
      final languageExists = await _isLanguageExistsById(primaryLanguageId);
      if (!languageExists) {
        throwBusiness('指定的主语言不存在');
      }

      // 验证目标语言是否存在
      if (targetLanguageIds != null && targetLanguageIds.isNotEmpty) {
        for (final langId in targetLanguageIds) {
          final exists = await _isLanguageExistsById(langId);
          if (!exists) {
            throwBusiness('目标语言 ID $langId 不存在');
          }
        }
      }

      // 生成或验证slug
      String finalSlug = slug ?? StringUtils.generateSlug(name);

      // 确保slug唯一性
      if (await _isSlugExists(finalSlug)) {
        finalSlug = await _generateUniqueSlug(finalSlug);
      }

      // 在事务中创建项目
      late String projectId;

      await _databaseService.transaction(() async {
        // 创建项目
        final projectResult = await _databaseService.query('''
          INSERT INTO {projects} (
            name, slug, description, owner_id, primary_language_id,
            visibility, settings, status, members_count
          ) VALUES (
            @name, @slug, @description, @owner_id, @primary_language_id,
            @visibility, @settings, 'active', @members_count
          ) RETURNING id
        ''', {
          'name': name,
          'slug': finalSlug,
          'description': description,
          'owner_id': ownerId,
          'primary_language_id': primaryLanguageId,
          'visibility': visibility,
          'settings': _serializeSettings(settings),
          'members_count': 1,
        });

        // 数据库返回的 id 可能是 int 或其他数值类型，统一转换为字符串
        final rawId = projectResult.first[0];
        projectId = rawId.toString();

        // 添加主语言到项目语言列表
        await _databaseService.query('''
          INSERT INTO {project_languages} (
            project_id, language_id, is_primary, is_active
          ) VALUES (
            @project_id, @language_id, true, true
          )
        ''', {
          'project_id': projectId,
          'language_id': primaryLanguageId,
        });

        // 添加目标语言到项目语言列表
        if (targetLanguageIds != null && targetLanguageIds.isNotEmpty) {
          for (final langId in targetLanguageIds) {
            // 避免重复添加主语言
            if (langId != primaryLanguageId) {
              await _databaseService.query('''
                INSERT INTO {project_languages} (
                  project_id, language_id, is_primary, is_active
                ) VALUES (
                  @project_id, @language_id, false, true
                )
              ''', {
                'project_id': projectId,
                'language_id': langId,
              });
            }
          }
        }

        // 创建项目所有者成员记录
        await _databaseService.query('''
          INSERT INTO {project_members} (
            project_id, user_id, role, status, joined_at
          ) VALUES (
            @project_id, @user_id, 'owner', 'active', CURRENT_TIMESTAMP
          )
        ''', {
          'project_id': projectId,
          'user_id': ownerId,
        });
      });

      // 清除相关缓存
      await _clearProjectCache(projectId);

      // 获取创建的项目信息
      final projectDetail = await getProjectById(projectId);

      logInfo('项目创建成功: $projectId');

      return projectDetail!.project;
    } catch (error, stackTrace) {
      logError('创建项目失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新项目信息
  Future<ProjectModel> updateProject(String projectId, Map<String, dynamic> updateData, {String? updatedBy}) async {
    try {
      logInfo('更新项目信息: $projectId');

      // 验证项目是否存在
      final existingProject = await getProjectById(projectId);
      if (existingProject == null) {
        throwNotFound('项目不存在');
      }

      // 构建更新字段
      final updates = <String>[];
      final parameters = <String, dynamic>{'project_id': projectId};

      // 允许更新的字段
      final allowedFields = {
        'name': 'name',
        'description': 'description',
        'status': 'status',
        'visibility': 'visibility',
        'settings': 'settings',
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

      // 检查slug唯一性
      if (updateData.containsKey('slug')) {
        final newSlug = updateData['slug'] as String;
        if (await _isSlugExists(newSlug, projectId)) {
          throwBusiness('项目标识已存在');
        }
        updates.add('slug = @slug');
        parameters['slug'] = newSlug;
      }

      // 在事务中更新项目
      await _databaseService.transaction(() async {
        final sql = '''
          UPDATE {projects} 
          SET ${updates.join(', ')}, 
              updated_at = CURRENT_TIMESTAMP,
              last_activity_at = CURRENT_TIMESTAMP
          WHERE id = @project_id
        ''';

        await _databaseService.query(sql, parameters);
      });

      // 清除缓存
      await _clearProjectCache(projectId);

      // 获取更新后的项目信息
      final updatedProjectDetail = await getProjectById(projectId);

      logInfo('项目信息更新成功: $projectId');

      return updatedProjectDetail!.project;
    } catch (error, stackTrace) {
      logError('更新项目信息失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除项目
  Future<void> deleteProject(String projectId, {String? deletedBy}) async {
    try {
      logInfo('删除项目: $projectId');

      // 检查项目是否存在
      final project = await getProjectById(projectId);
      if (project == null) {
        throwNotFound('项目不存在');
      }

      // 在事务中删除项目相关数据
      await _databaseService.transaction(() async {
        // 删除翻译条目
        await _databaseService
            .query('DELETE FROM {translation_entries} WHERE project_id = @project_id', {'project_id': projectId});

        // 删除项目语言关联
        await _databaseService
            .query('DELETE FROM {project_languages} WHERE project_id = @project_id', {'project_id': projectId});

        // 删除项目成员关联
        await _databaseService
            .query('DELETE FROM {project_members} WHERE project_id = @project_id', {'project_id': projectId});

        // 删除项目
        await _databaseService.query('DELETE FROM {projects} WHERE id = @project_id', {'project_id': projectId});
      });

      // 清除缓存
      await _clearProjectCache(projectId);

      logInfo('项目删除成功: $projectId');
    } catch (error, stackTrace) {
      logError('删除项目失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目成员列表
  Future<List<ProjectMemberModel>?> getProjectMembers(String projectId) async {
    try {
      logInfo('获取项目成员: $projectId');

      final sql = '''
        SELECT 
          pm.id,
          pm.project_id,
          pm.role,
          pm.invited_by,
          pm.invited_at,
          pm.joined_at,
          pm.status,
          pm.is_active,
          pm.created_at,
          pm.updated_at,
          u.username,
          u.display_name,
          u.avatar_url,
          u.email,
          inviter.username as inviter_username,
          inviter.display_name as inviter_display_name
        FROM {project_members} pm
        JOIN {users} u ON pm.user_id = u.id
        JOIN {projects} p ON pm.project_id = p.id
        LEFT JOIN {users} inviter ON pm.invited_by = inviter.id
        WHERE pm.project_id = @project_id 
          AND pm.is_active = true 
          AND u.is_active = true
        ORDER BY (p.owner_id = u.id) DESC, pm.joined_at ASC
      ''';

      final result = await _databaseService.query(sql, {'project_id': projectId});

      return result.isNotEmpty ? result.map((row) => ProjectMemberModel.fromJson(row.toColumnMap())).toList() : null;
    } catch (error, stackTrace) {
      logError('获取项目成员失败: $projectId', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 添加项目成员
  Future<void> addProjectMember({
    required String projectId,
    required String userId,
    required String role,
    required String invitedBy,
  }) async {
    try {
      logInfo('添加项目成员: $projectId, user: $userId, role: $role');

      // 检查用户是否已经是项目成员
      final existingRole = await _getUserRoleInProject(userId, projectId);
      if (existingRole != null) {
        throwBusiness('用户已经是项目成员');
      }

      // 添加项目成员
      await _databaseService.query('''
        INSERT INTO {project_members} (
          project_id, user_id, role, invited_by, joined_at, status
        ) VALUES (
          @project_id, @user_id, @role, @invited_by, CURRENT_TIMESTAMP, 'active'
        )
      ''', {
        'project_id': projectId,
        'user_id': userId,
        'role': role,
        'invited_by': invitedBy,
      });

      // 更新项目成员数量
      await _updateProjectMemberCount(projectId);

      logInfo('项目成员添加成功: $projectId, user: $userId');
    } catch (error) {
      logError('添加项目成员失败: $projectId, user: $userId', error: error);
      rethrow;
    }
  }

  /// 移除项目成员
  Future<void> removeProjectMember(String projectId, String userId) async {
    try {
      logInfo('移除项目成员: $projectId, user: $userId');

      // 移除项目成员
      await _databaseService.query('''
        UPDATE {project_members} 
        SET is_active = false, status = 'inactive'
        WHERE project_id = @project_id AND user_id = @user_id
      ''', {
        'project_id': projectId,
        'user_id': userId,
      });

      // 更新项目成员数量
      await _updateProjectMemberCount(projectId);

      logInfo('项目成员移除成功: $projectId, user: $userId');
    } catch (error, stackTrace) {
      logError('移除项目成员失败: $projectId, user: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目统计信息
  Future<ProjectStatisticsModel> getProjectStats() async {
    try {
      logInfo('获取项目统计信息');

      // 检查缓存
      const cacheKey = 'project:stats';
      final cachedStats = await _redisService.getJson(cacheKey);
      if (cachedStats != null) {
        try {
          return ProjectStatisticsModel.fromJson(cachedStats);
        } catch (cacheError, cacheStackTrace) {
          // 缓存数据解析失败，删除缓存并继续查询数据库
          logError('缓存数据解析失败', error: cacheError, stackTrace: cacheStackTrace);
          await _redisService.delete(cacheKey);
        }
      }

      final sql = '''
        SELECT 
          COUNT(*) as total_projects,
          COUNT(*) FILTER (WHERE status = 'active') as active_projects,
          COUNT(*) FILTER (WHERE status = 'archived') as archived_projects,
          COUNT(*) FILTER (WHERE visibility = 'public') as public_projects,
          COUNT(*) FILTER (WHERE visibility = 'private') as private_projects,
          COUNT(*) FILTER (WHERE created_at > CURRENT_TIMESTAMP - INTERVAL '30 days') as new_last_month,
          COALESCE(AVG(total_keys), 0) as avg_keys_per_project,
          COALESCE(AVG(CASE WHEN total_keys > 0 THEN translated_keys::float / total_keys * 100 ELSE 0 END), 0) as avg_completion_percentage
        FROM projects
      ''';

      final result = await _databaseService.query(sql);
      final stats = ProjectStatisticsModel.fromJson(result.first.toColumnMap());

      // 缓存统计信息
      await _redisService.setJson(cacheKey, stats.toJson(), 3600); // 1小时缓存

      return stats;
    } catch (error, stackTrace) {
      logError('获取项目统计信息失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  // 私有辅助方法
  Future<bool> _isLanguageExistsById(int languageId) async {
    final result = await _databaseService
        .query('SELECT 1 FROM {languages} WHERE id = @id AND is_active = true LIMIT 1', {'id': languageId});
    return result.isNotEmpty;
  }

  Future<bool> _isSlugExists(String slug, [String? excludeProjectId]) async {
    var sql = 'SELECT 1 FROM {projects} WHERE slug = @slug';
    final parameters = <String, dynamic>{'slug': slug};

    if (excludeProjectId != null) {
      sql += ' AND id != @exclude_id';
      parameters['exclude_id'] = excludeProjectId;
    }

    final result = await _databaseService.query(sql, parameters);
    return result.isNotEmpty;
  }

  Future<String> _generateUniqueSlug(String baseSlug) async {
    String slug = baseSlug;
    int counter = 1;

    while (await _isSlugExists(slug)) {
      slug = '$baseSlug-$counter';
      counter++;
    }

    return slug;
  }

  Future<Map<String, dynamic>?> _getUserRoleInProject(String userId, String projectId) async {
    final result = await _databaseService.query('''
      SELECT pm.role as name, pm.role as display_name
      FROM {project_members} pm
      WHERE pm.user_id = @user_id 
        AND pm.project_id = @project_id 
        AND pm.is_active = true
        AND pm.status = 'active'
      LIMIT 1
    ''', {
      'user_id': userId,
      'project_id': projectId,
    });

    return result.isNotEmpty ? result.first.toColumnMap() : null;
  }

  Future<void> _updateProjectMemberCount(String projectId) async {
    try {
      await _databaseService.query('''
      UPDATE {projects} 
      SET members_count = (
        SELECT COUNT(DISTINCT pm.user_id)
        FROM {project_members} pm
        WHERE pm.project_id = @project_id 
          AND pm.is_active = true
          AND pm.status = 'active'
      )
      WHERE id = @project_id
    ''', {'project_id': projectId});

      await _clearProjectCache(projectId);
    } catch (error, stackTrace) {
      logError('更新项目成员数量失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> _clearProjectCache(String projectId) async {
    await _redisService.delete('project:details:$projectId');
    await _redisService.delete('project:stats');
  }

  /// 归档项目
  Future<void> archiveProject(String projectId) async {
    try {
      logInfo('归档项目: $projectId');

      await _databaseService.query('''
        UPDATE projects
        SET status = 'archived', archived_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP
        WHERE id = @project_id
      ''', {'project_id': projectId});

      await _clearProjectCache(projectId);

      logInfo('项目归档成功: $projectId');
    } catch (error, stackTrace) {
      logError('归档项目失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 恢复项目
  Future<void> restoreProject(String projectId) async {
    try {
      logInfo('恢复项目: $projectId');

      await _databaseService.query('''
        UPDATE projects
        SET status = 'active', archived_at = NULL, updated_at = CURRENT_TIMESTAMP
        WHERE id = @project_id
      ''', {'project_id': projectId});

      await _clearProjectCache(projectId);

      logInfo('项目恢复成功: $projectId');
    } catch (error, stackTrace) {
      logError('恢复项目失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新项目成员角色
  Future<void> updateProjectMemberRole(String projectId, String userId, String role) async {
    try {
      logInfo('更新项目成员角色: project=$projectId, user=$userId, role=$role');

      await _databaseService.query('''
        UPDATE {project_members}
        SET role = @role, updated_at = CURRENT_TIMESTAMP
        WHERE project_id = @project_id AND user_id = @user_id
      ''', {
        'project_id': projectId,
        'user_id': userId,
        'role': role,
      });

      await _clearProjectCache(projectId);

      logInfo('项目成员角色更新成功');
    } catch (error, stackTrace) {
      logError('更新项目成员角色失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 转移项目所有权
  Future<void> transferProjectOwnership(String projectId, String newOwnerId, {String? currentOwnerId}) async {
    try {
      logInfo('转移项目所有权: project=$projectId, newOwner=$newOwnerId');

      // 检查项目是否存在
      final project = await getProjectById(projectId);
      if (project == null) {
        throwNotFound('项目不存在');
      }

      // 检查新所有者是否是项目成员
      final members = await getProjectMembers(projectId);
      if (members == null || members.isEmpty) {
        throwBusiness('无法获取项目成员列表');
      }

      final newOwnerMember = members.where((member) => member.userId == newOwnerId).firstOrNull;
      if (newOwnerMember == null) {
        throwBusiness('新所有者不是项目成员');
      }

      // 在事务中执行转移
      await _databaseService.transaction(() async {
        // 将原所有者降为管理员
        await _databaseService.query('''
          UPDATE {project_members}
          SET role = @role, updated_at = CURRENT_TIMESTAMP
          WHERE project_id = @project_id AND role = 'owner'
        ''', {
          'project_id': projectId,
          'role': 'admin',
        });

        // 将新成员提升为所有者
        await _databaseService.query('''
          UPDATE {project_members}
          SET role = @role, updated_at = CURRENT_TIMESTAMP
          WHERE project_id = @project_id AND user_id = @user_id
        ''', {
          'project_id': projectId,
          'user_id': newOwnerId,
          'role': 'owner',
        });

        // 更新项目表中的 owner_id 字段
        await _databaseService.query('''
          UPDATE {projects}
          SET owner_id = @owner_id, updated_at = CURRENT_TIMESTAMP
          WHERE id = @project_id
        ''', {
          'project_id': projectId,
          'owner_id': newOwnerId,
        });
      });

      // 清除缓存
      await _clearProjectCache(projectId);

      logInfo('项目所有权转移成功');
    } catch (error, stackTrace) {
      logError('转移项目所有权失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目语言
  Future<List<LanguageModel>> getProjectLanguages(String projectId) async {
    try {
      logInfo('获取项目语言: $projectId');

      final result = await _databaseService.query('''
        SELECT l.id, l.code, l.name, l.native_name, l.flag_emoji, l.is_active, l.is_rtl, 
               l.sort_order, l.created_at, l.updated_at, pl.is_primary
        FROM {project_languages} pl
        JOIN {languages} l ON pl.language_id = l.id
        WHERE pl.project_id = @project_id AND pl.is_active = true
        ORDER BY pl.is_primary DESC, l.sort_order, l.name
      ''', {'project_id': projectId});

      return result.map((row) => LanguageModel.fromJson(row.toColumnMap())).toList();
    } catch (error, stackTrace) {
      logError('获取项目语言失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 添加项目语言
  Future<void> addProjectLanguage(String projectId, int languageId) async {
    try {
      logInfo('添加项目语言: project=$projectId, language=$languageId');

      // 检查语言是否存在
      if (!await _isLanguageExistsById(languageId)) {
        throwBusiness('语言不存在');
      }

      // 检查是否已存在
      final existing = await _databaseService.query('''
        SELECT 1 FROM {project_languages}
        WHERE project_id = @project_id AND language_id = @language_id
      ''', {'project_id': projectId, 'language_id': languageId});

      if (existing.isNotEmpty) {
        throwBusiness('语言已存在于项目中');
      }

      await _databaseService.query('''
        INSERT INTO {project_languages} (project_id, language_id, is_active)
        VALUES (@project_id, @language_id, true)
      ''', {
        'project_id': projectId,
        'language_id': languageId,
      });

      await _clearProjectCache(projectId);

      logInfo('项目语言添加成功');
    } catch (error, stackTrace) {
      logError('添加项目语言失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 移除项目语言
  Future<void> removeProjectLanguage(String projectId, int languageId) async {
    try {
      logInfo('移除项目语言: project=$projectId, language=$languageId');

      await _databaseService.query('''
        DELETE FROM {project_languages}
        WHERE project_id = @project_id AND language_id = @language_id
      ''', {
        'project_id': projectId,
        'language_id': languageId,
      });

      await _clearProjectCache(projectId);

      logInfo('项目语言移除成功');
    } catch (error, stackTrace) {
      logError('移除项目语言失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新语言设置
  Future<void> updateLanguageSettings(String projectId, int languageId, Map<String, dynamic> settings) async {
    try {
      logInfo('更新语言设置: project=$projectId, language=$languageId');

      await _databaseService.query('''
        UPDATE {project_languages}
        SET settings = @settings, updated_at = CURRENT_TIMESTAMP
        WHERE project_id = @project_id AND language_id = @language_id
      ''', {
        'project_id': projectId,
        'language_id': languageId,
        'settings': _serializeSettings(settings),
      });

      await _clearProjectCache(projectId);

      logInfo('语言设置更新成功');
    } catch (error, stackTrace) {
      logError('更新语言设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目统计信息
  Future<ProjectStatisticsModel?> getProjectStatistics(String projectId) async {
    try {
      logInfo('获取项目统计信息: $projectId');

      // 获取基本统计信息
      final basicStats = await _databaseService.query('''
        SELECT
          COUNT(DISTINCT pl.language_id) as language_count,
          COUNT(DISTINCT pm.user_id) as member_count,
          COUNT(te.id) as total_entries,
          COUNT(te.id) FILTER (WHERE te.status = 'completed') as completed_entries,
          COUNT(te.id) FILTER (WHERE te.status = 'reviewing') as reviewing_entries,
          COUNT(te.id) FILTER (WHERE te.status = 'approved') as approved_entries,
          COALESCE(AVG(te.quality_score), 0) as avg_quality_score
        FROM {projects} p
        LEFT JOIN {project_languages} pl ON p.id = pl.project_id AND pl.is_active = true
        LEFT JOIN {project_members} pm ON p.id = pm.project_id AND pm.status = 'active'
        LEFT JOIN {translation_entries} te ON p.id = te.project_id
        WHERE p.id = @project_id
        GROUP BY p.id
      ''', {'project_id': projectId});

      return basicStats.isNotEmpty
          ? ProjectStatisticsModel.fromJson(basicStats.first.toColumnMap())
          : ProjectStatisticsModel();
    } catch (error, stackTrace) {
      logError('获取项目统计信息失败: $projectId', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 获取项目活动日志
  Future<PagerModel<TranslationEntryModel>> getProjectActivity(String projectId, {int page = 1, int limit = 20}) async {
    try {
      logInfo('获取项目活动: $projectId, page=$page, limit=$limit');

      final offset = (page - 1) * limit;

      final activities = await _databaseService.query('''
        SELECT
          'translation_updated' as activity_type,
          te.entry_key,
          te.language_code,
          u.username as user_name,
          te.status,
          te.updated_at as activity_at
        FROM {translation_entries} te
        JOIN {users} u ON te.translator_id = u.id OR te.reviewer_id = u.id
        WHERE te.project_id = @project_id
        ORDER BY te.updated_at DESC
        LIMIT @limit OFFSET @offset
      ''', {
        'project_id': projectId,
        'limit': limit,
        'offset': offset,
      });

      return PagerModel<TranslationEntryModel>(
        page: page,
        pageSize: limit,
        totalSize: activities.length,
        totalPage: (activities.length / limit).ceil(),
        items: activities.map((row) => TranslationEntryModel.fromJson(row.toColumnMap())).toList(),
      );
    } catch (error, stackTrace) {
      logError('获取项目活动失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新项目成员上限（仅 Owner）
  Future<ProjectModel> updateMemberLimit({
    required String projectId,
    required String userId,
    required int newLimit,
  }) async {
    try {
      logInfo('更新项目成员上限: project=$projectId, newLimit=$newLimit');

      // 验证新上限范围
      if (newLimit < 1 || newLimit > 1000) {
        throwBusiness('成员上限必须在 1 到 1000 之间');
      }

      // 检查项目是否存在
      final project = await getProjectById(projectId);
      if (project == null) {
        throwNotFound('项目不存在');
      }

      // 验证用户是否为项目 Owner
      final isOwner = await _isUserProjectOwner(projectId, userId);
      if (!isOwner) {
        throwBusiness('只有项目所有者可以修改成员上限');
      }

      // 获取当前成员数
      final currentMemberCount = project.project.membersCount;

      // 验证新上限不能小于当前成员数
      if (newLimit < currentMemberCount) {
        throwBusiness('新上限不能小于当前成员数 ($currentMemberCount)');
      }

      // 更新成员上限
      await _databaseService.query('''
        UPDATE {projects}
        SET member_limit = @new_limit, updated_at = CURRENT_TIMESTAMP
        WHERE id = @project_id
      ''', {
        'project_id': projectId,
        'new_limit': newLimit,
      });

      // 清除缓存
      await _clearProjectCache(projectId);

      // 获取更新后的项目信息
      final updatedProject = await getProjectById(projectId);

      logInfo('项目成员上限更新成功: $projectId -> $newLimit');

      return updatedProject!.project;
    } catch (error, stackTrace) {
      logError('更新项目成员上限失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查用户是否为项目 Owner
  Future<bool> _isUserProjectOwner(String projectId, String userId) async {
    final result = await _databaseService.query('''
      SELECT 1 FROM {projects}
      WHERE id = @project_id AND owner_id = @user_id
    ''', {
      'project_id': projectId,
      'user_id': userId,
    });

    return result.isNotEmpty;
  }
}
