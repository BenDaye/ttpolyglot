
import '../base_service.dart';
import '../../config/server_config.dart';
import '../infrastructure/database_service.dart';
import '../infrastructure/redis_service.dart';
import '../../utils/string_utils.dart';

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
  Future<Map<String, dynamic>> getProjects({
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
        conditions.add('(p.name ILIKE @search OR p.description ILIKE @search)');
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
             SELECT 1 FROM user_roles ur 
             WHERE ur.user_id = @user_id 
               AND ur.project_id = p.id 
               AND ur.is_active = true
           ))
        ''');
        parameters['user_id'] = userId;
      }

      // 计算总数
      final countSql = '''
        SELECT COUNT(*) FROM projects p
        ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
      ''';

      final countResult = await _databaseService.query(countSql, parameters);
      final total = countResult.first[0] as int;

      // 获取分页数据
      final offset = (page - 1) * limit;
      parameters['limit'] = limit;
      parameters['offset'] = offset;

      final projectsSql = '''
        SELECT 
          p.id, p.name, p.slug, p.description, p.status, p.visibility,
          p.primary_language_code, p.total_keys, p.translated_keys, 
          p.languages_count, p.members_count, p.settings,
          p.last_activity_at, p.created_at, p.updated_at,
          u.username as owner_username,
          u.display_name as owner_display_name,
          l.name as primary_language_name,
          CASE 
            WHEN p.total_keys > 0 
            THEN ROUND((p.translated_keys::float / p.total_keys * 100), 2)
            ELSE 0 
          END as completion_percentage
        FROM projects p
        LEFT JOIN users u ON p.owner_id = u.id
        LEFT JOIN languages l ON p.primary_language_code = l.code
        ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
        ORDER BY p.last_activity_at DESC
        LIMIT @limit OFFSET @offset
      ''';

      final projectsResult = await _databaseService.query(projectsSql, parameters);

      final projects = projectsResult.map((row) {
        final projectData = row.toColumnMap();

        // 解析设置信息
        final settingsJson = projectData['settings'] as String?;
        projectData['settings'] = settingsJson != null && settingsJson.isNotEmpty ? settingsJson : <String, dynamic>{};

        return projectData;
      }).toList();

      return {
        'projects': projects,
        'pagination': {
          'page': page,
          'limit': limit,
          'total': total,
          'pages': (total / limit).ceil(),
        },
      };
    } catch (error, stackTrace) {
      logError('获取项目列表失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 根据ID获取项目详情
  Future<Map<String, dynamic>?> getProjectById(String projectId, {String? userId}) async {
    try {
      logInfo('获取项目详情: $projectId');

      // 先检查缓存
      final cacheKey = 'project:details:$projectId';
      final cachedProject = await _redisService.getJson(cacheKey);
      if (cachedProject != null) {
        return cachedProject;
      }

      final sql = '''
        SELECT 
          p.id, p.name, p.slug, p.description, p.status, p.visibility,
          p.primary_language_code, p.total_keys, p.translated_keys, 
          p.languages_count, p.members_count, p.settings,
          p.last_activity_at, p.created_at, p.updated_at,
          u.id as owner_id, u.username as owner_username,
          u.display_name as owner_display_name, u.avatar_url as owner_avatar,
          l.name as primary_language_name, l.native_name as primary_language_native_name,
          CASE 
            WHEN p.total_keys > 0 
            THEN ROUND((p.translated_keys::float / p.total_keys * 100), 2)
            ELSE 0 
          END as completion_percentage,
          COALESCE(
            json_agg(
              json_build_object(
                'language_code', pl.language_code,
                'language_name', lang.name,
                'language_native_name', lang.native_name,
                'is_primary', pl.is_primary,
                'completion_percentage', pl.completion_percentage,
                'is_enabled', pl.is_enabled
              )
            ) FILTER (WHERE pl.language_code IS NOT NULL), 
            '[]'
          ) as languages
        FROM projects p
        LEFT JOIN users u ON p.owner_id = u.id
        LEFT JOIN languages l ON p.primary_language_code = l.code
        LEFT JOIN project_languages pl ON p.id = pl.project_id AND pl.is_enabled = true
        LEFT JOIN languages lang ON pl.language_code = lang.code
        WHERE p.id = @project_id
        GROUP BY p.id, u.id, l.code
      ''';

      final result = await _databaseService.query(sql, {'project_id': projectId});

      if (result.isEmpty) {
        return null;
      }

      final projectData = result.first.toColumnMap();

      // 解析设置和语言信息
      final settingsJson = projectData['settings'] as String?;
      projectData['settings'] = settingsJson != null && settingsJson.isNotEmpty ? settingsJson : <String, dynamic>{};

      final languagesJson = projectData['languages'] as String;
      projectData['languages'] = languagesJson.isNotEmpty ? languagesJson : [];

      // 如果指定了用户ID，检查用户权限
      if (userId != null) {
        projectData['user_role'] = await _getUserRoleInProject(userId, projectId);
        projectData['is_owner'] = projectData['owner_id'] == userId;
      }

      // 缓存项目信息
      await _redisService.setJson(cacheKey, projectData, ServerConfig.cacheApiResponseTtl);

      return projectData;
    } catch (error, stackTrace) {
      logError('获取项目详情失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 创建项目
  Future<Map<String, dynamic>> createProject({
    required String name,
    required String ownerId,
    required String primaryLanguageCode,
    String? description,
    String? slug,
    String visibility = 'private',
    Map<String, dynamic>? settings,
  }) async {
    try {
      logInfo('创建项目: $name, owner: $ownerId');

      // 验证主语言是否存在
      final languageExists = await _isLanguageExists(primaryLanguageCode);
      if (!languageExists) {
        throwBusiness('指定的主语言不存在');
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
          INSERT INTO projects (
            name, slug, description, owner_id, primary_language_code,
            visibility, settings, status
          ) VALUES (
            @name, @slug, @description, @owner_id, @primary_language_code,
            @visibility, @settings, 'active'
          ) RETURNING id
        ''', {
          'name': name,
          'slug': finalSlug,
          'description': description,
          'owner_id': ownerId,
          'primary_language_code': primaryLanguageCode,
          'visibility': visibility,
          'settings': settings != null ? settings.toString() : '{}',
        });

        projectId = projectResult.first[0] as String;

        // 添加主语言到项目语言列表
        await _databaseService.query('''
          INSERT INTO project_languages (
            project_id, language_code, is_enabled, is_primary
          ) VALUES (
            @project_id, @language_code, true, true
          )
        ''', {
          'project_id': projectId,
          'language_code': primaryLanguageCode,
        });

        // 给项目所有者分配project_owner角色
        await _assignProjectOwnerRole(projectId, ownerId);
      });

      // 清除相关缓存
      await _clearProjectCache(projectId);

      // 获取创建的项目信息
      final project = await getProjectById(projectId);

      logInfo('项目创建成功: $projectId');

      return project!;
    } catch (error, stackTrace) {
      logError('创建项目失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新项目信息
  Future<Map<String, dynamic>> updateProject(String projectId, Map<String, dynamic> updateData,
      {String? updatedBy}) async {
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
          UPDATE projects 
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
      final updatedProject = await getProjectById(projectId);

      logInfo('项目信息更新成功: $projectId');

      return updatedProject!;
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
            .query('DELETE FROM translation_entries WHERE project_id = @project_id', {'project_id': projectId});

        // 删除项目语言关联
        await _databaseService
            .query('DELETE FROM project_languages WHERE project_id = @project_id', {'project_id': projectId});

        // 删除项目角色关联
        await _databaseService
            .query('DELETE FROM user_roles WHERE project_id = @project_id', {'project_id': projectId});

        // 删除项目
        await _databaseService.query('DELETE FROM projects WHERE id = @project_id', {'project_id': projectId});
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
  Future<List<Map<String, dynamic>>> getProjectMembers(String projectId) async {
    try {
      logInfo('获取项目成员: $projectId');

      final sql = '''
        SELECT 
          u.id, u.username, u.display_name, u.avatar_url,
          ur.granted_at, ur.expires_at,
          r.name as role_name, r.display_name as role_display_name,
          p.owner_id = u.id as is_owner
        FROM user_roles ur
        JOIN users u ON ur.user_id = u.id
        JOIN roles r ON ur.role_id = r.id
        JOIN projects p ON ur.project_id = p.id
        WHERE ur.project_id = @project_id 
          AND ur.is_active = true 
          AND u.is_active = true
          AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
        ORDER BY is_owner DESC, ur.granted_at ASC
      ''';

      final result = await _databaseService.query(sql, {'project_id': projectId});

      return result.map((row) => row.toColumnMap()).toList();
    } catch (error, stackTrace) {
      logError('获取项目成员失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 添加项目成员
  Future<void> addProjectMember({
    required String projectId,
    required String userId,
    required String roleId,
    required String grantedBy,
    DateTime? expiresAt,
  }) async {
    try {
      logInfo('添加项目成员: $projectId, user: $userId, role: $roleId');

      // 检查用户是否已经是项目成员
      final existingRole = await _getUserRoleInProject(userId, projectId);
      if (existingRole != null) {
        throwBusiness('用户已经是项目成员');
      }

      // 添加角色关联
      await _databaseService.query('''
        INSERT INTO user_roles (
          user_id, role_id, project_id, granted_by, expires_at
        ) VALUES (
          @user_id, @role_id, @project_id, @granted_by, @expires_at
        )
      ''', {
        'user_id': userId,
        'role_id': roleId,
        'project_id': projectId,
        'granted_by': grantedBy,
        'expires_at': expiresAt?.toIso8601String(),
      });

      // 更新项目成员数量
      await _updateProjectMemberCount(projectId);

      logInfo('项目成员添加成功: $projectId, user: $userId');
    } catch (error, stackTrace) {
      logError('添加项目成员失败: $projectId, user: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 移除项目成员
  Future<void> removeProjectMember(String projectId, String userId) async {
    try {
      logInfo('移除项目成员: $projectId, user: $userId');

      // 移除角色关联
      await _databaseService.query('''
        UPDATE user_roles 
        SET is_active = false 
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
  Future<Map<String, dynamic>> getProjectStats() async {
    try {
      logInfo('获取项目统计信息');

      // 检查缓存
      const cacheKey = 'project:stats';
      final cachedStats = await _redisService.getJson(cacheKey);
      if (cachedStats != null) {
        return cachedStats;
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
      final stats = result.first.toColumnMap();

      // 缓存统计信息
      await _redisService.setJson(cacheKey, stats, 3600); // 1小时缓存

      return stats;
    } catch (error, stackTrace) {
      logError('获取项目统计信息失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  // 私有辅助方法

  Future<bool> _isLanguageExists(String languageCode) async {
    final result = await _databaseService
        .query('SELECT 1 FROM languages WHERE code = @code AND is_active = true LIMIT 1', {'code': languageCode});
    return result.isNotEmpty;
  }

  Future<bool> _isSlugExists(String slug, [String? excludeProjectId]) async {
    var sql = 'SELECT 1 FROM projects WHERE slug = @slug';
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

  Future<void> _assignProjectOwnerRole(String projectId, String ownerId) async {
    // 查找project_owner角色ID
    final roleResult =
        await _databaseService.query('SELECT id FROM roles WHERE name = @name LIMIT 1', {'name': 'project_owner'});

    if (roleResult.isEmpty) {
      throwBusiness('项目所有者角色不存在');
    }

    final roleId = roleResult.first[0] as String;

    // 分配角色
    await _databaseService.query('''
      INSERT INTO user_roles (
        user_id, role_id, project_id, granted_by
      ) VALUES (
        @user_id, @role_id, @project_id, @user_id
      )
    ''', {
      'user_id': ownerId,
      'role_id': roleId,
      'project_id': projectId,
    });
  }

  Future<Map<String, dynamic>?> _getUserRoleInProject(String userId, String projectId) async {
    final result = await _databaseService.query('''
      SELECT r.name, r.display_name
      FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = @user_id 
        AND ur.project_id = @project_id 
        AND ur.is_active = true
        AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
      LIMIT 1
    ''', {
      'user_id': userId,
      'project_id': projectId,
    });

    return result.isNotEmpty ? result.first.toColumnMap() : null;
  }

  Future<void> _updateProjectMemberCount(String projectId) async {
    await _databaseService.query('''
      UPDATE projects 
      SET members_count = (
        SELECT COUNT(DISTINCT ur.user_id)
        FROM user_roles ur
        WHERE ur.project_id = @project_id 
          AND ur.is_active = true
          AND (ur.expires_at IS NULL OR ur.expires_at > CURRENT_TIMESTAMP)
      )
      WHERE id = @project_id
    ''', {'project_id': projectId});
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
  Future<void> updateProjectMemberRole(String projectId, String userId, String roleId) async {
    try {
      logInfo('更新项目成员角色: project=$projectId, user=$userId, role=$roleId');

      await _databaseService.query('''
        UPDATE project_members
        SET role_id = @role_id, updated_at = CURRENT_TIMESTAMP
        WHERE project_id = @project_id AND user_id = @user_id
      ''', {
        'project_id': projectId,
        'user_id': userId,
        'role_id': roleId,
      });

      await _clearProjectCache(projectId);

      logInfo('项目成员角色更新成功');
    } catch (error, stackTrace) {
      logError('更新项目成员角色失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目语言
  Future<List<Map<String, dynamic>>> getProjectLanguages(String projectId) async {
    try {
      logInfo('获取项目语言: $projectId');

      final result = await _databaseService.query('''
        SELECT pl.*, l.name, l.native_name, l.direction, l.is_rtl
        FROM project_languages pl
        JOIN languages l ON pl.language_code = l.code
        WHERE pl.project_id = @project_id AND pl.is_enabled = true
        ORDER BY l.sort_index, l.name
      ''', {'project_id': projectId});

      return result.map((row) => row.toColumnMap()).toList();
    } catch (error, stackTrace) {
      logError('获取项目语言失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 添加项目语言
  Future<void> addProjectLanguage(String projectId, String languageCode) async {
    try {
      logInfo('添加项目语言: project=$projectId, language=$languageCode');

      // 检查语言是否存在
      if (!await _isLanguageExists(languageCode)) {
        throwBusiness('语言不存在');
      }

      // 检查是否已存在
      final existing = await _databaseService.query('''
        SELECT 1 FROM project_languages
        WHERE project_id = @project_id AND language_code = @language_code
      ''', {'project_id': projectId, 'language_code': languageCode});

      if (existing.isNotEmpty) {
        throwBusiness('语言已存在于项目中');
      }

      await _databaseService.query('''
        INSERT INTO project_languages (project_id, language_code, is_enabled)
        VALUES (@project_id, @language_code, true)
      ''', {
        'project_id': projectId,
        'language_code': languageCode,
      });

      await _clearProjectCache(projectId);

      logInfo('项目语言添加成功');
    } catch (error, stackTrace) {
      logError('添加项目语言失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 移除项目语言
  Future<void> removeProjectLanguage(String projectId, String languageCode) async {
    try {
      logInfo('移除项目语言: project=$projectId, language=$languageCode');

      await _databaseService.query('''
        DELETE FROM project_languages
        WHERE project_id = @project_id AND language_code = @language_code
      ''', {
        'project_id': projectId,
        'language_code': languageCode,
      });

      await _clearProjectCache(projectId);

      logInfo('项目语言移除成功');
    } catch (error, stackTrace) {
      logError('移除项目语言失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新语言设置
  Future<void> updateLanguageSettings(String projectId, String languageCode, Map<String, dynamic> settings) async {
    try {
      logInfo('更新语言设置: project=$projectId, language=$languageCode');

      await _databaseService.query('''
        UPDATE project_languages
        SET settings = @settings, updated_at = CURRENT_TIMESTAMP
        WHERE project_id = @project_id AND language_code = @language_code
      ''', {
        'project_id': projectId,
        'language_code': languageCode,
        'settings': settings.toString(),
      });

      await _clearProjectCache(projectId);

      logInfo('语言设置更新成功');
    } catch (error, stackTrace) {
      logError('更新语言设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目统计信息
  Future<Map<String, dynamic>> getProjectStatistics(String projectId) async {
    try {
      logInfo('获取项目统计信息: $projectId');

      // 获取基本统计信息
      final basicStats = await _databaseService.query('''
        SELECT
          COUNT(DISTINCT pl.language_code) as language_count,
          COUNT(DISTINCT pm.user_id) as member_count,
          COUNT(te.id) as total_entries,
          COUNT(te.id) FILTER (WHERE te.status = 'completed') as completed_entries,
          COUNT(te.id) FILTER (WHERE te.status = 'reviewing') as reviewing_entries,
          COUNT(te.id) FILTER (WHERE te.status = 'approved') as approved_entries,
          COALESCE(AVG(te.quality_score), 0) as avg_quality_score
        FROM projects p
        LEFT JOIN project_languages pl ON p.id = pl.project_id AND pl.is_enabled = true
        LEFT JOIN project_members pm ON p.id = pm.project_id AND pm.status = 'active'
        LEFT JOIN translation_entries te ON p.id = te.project_id
        WHERE p.id = @project_id
        GROUP BY p.id
      ''', {'project_id': projectId});

      return basicStats.isNotEmpty ? basicStats.first.toColumnMap() : {};
    } catch (error, stackTrace) {
      logError('获取项目统计信息失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取项目活动日志
  Future<List<Map<String, dynamic>>> getProjectActivity(String projectId, {int page = 1, int limit = 20}) async {
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
        FROM translation_entries te
        JOIN users u ON te.translator_id = u.id OR te.reviewer_id = u.id
        WHERE te.project_id = @project_id
        ORDER BY te.updated_at DESC
        LIMIT @limit OFFSET @offset
      ''', {
        'project_id': projectId,
        'limit': limit,
        'offset': offset,
      });

      return activities.map((row) => row.toColumnMap()).toList();
    } catch (error, stackTrace) {
      logError('获取项目活动失败: $projectId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
