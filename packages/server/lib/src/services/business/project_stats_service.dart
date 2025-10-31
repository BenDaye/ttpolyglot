import 'dart:developer';

import '../base_service.dart';
import '../infrastructure/database_service.dart';

/// 项目统计缓存服务
///
/// 管理项目翻译统计数据的缓存，提供高性能的统计查询
class ProjectStatsService extends BaseService {
  final DatabaseService _databaseService;

  ProjectStatsService({
    required DatabaseService databaseService,
  })  : _databaseService = databaseService,
        super('ProjectStatsService');

  /// 获取项目统计信息（从缓存表读取）
  ///
  /// 如果缓存不存在或过期（超过5分钟），则刷新缓存
  Future<Map<String, dynamic>> getProjectStats(int projectId) async {
    return execute(
      () async {
        logInfo('获取项目统计', context: {'project_id': projectId});

        // 先从缓存表读取
        final cached = await _databaseService.query('''
          SELECT * FROM {project_translation_stats}
          WHERE project_id = @project_id
        ''', {'project_id': projectId});

        if (cached.isNotEmpty) {
          final stats = cached.first.toColumnMap();
          final lastUpdate = stats['last_updated_at'] as DateTime?;

          // 检查是否过期（超过5分钟）
          if (lastUpdate != null) {
            final age = DateTime.now().difference(lastUpdate);
            if (age.inMinutes < 5) {
              logInfo('使用缓存的统计数据', context: {
                'project_id': projectId,
                'age_seconds': age.inSeconds,
              });
              return stats;
            }
          }
        }

        // 缓存不存在或过期，重新计算
        logInfo('缓存过期或不存在，刷新统计', context: {'project_id': projectId});
        return await refreshProjectStats(projectId);
      },
      operationName: 'getProjectStats',
    );
  }

  /// 刷新项目统计信息
  ///
  /// 重新计算并更新统计缓存
  Future<Map<String, dynamic>> refreshProjectStats(int projectId) async {
    return execute(
      () async {
        logInfo('刷新项目统计', context: {'project_id': projectId});

        // 计算统计数据
        final sql = '''
          INSERT INTO {project_translation_stats} (
            project_id, total_entries, pending_count, completed_count,
            reviewing_count, approved_count, total_source_chars, total_target_chars,
            completion_rate, last_updated_at
          )
          SELECT 
            @project_id as project_id,
            COUNT(*) as total_entries,
            SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_count,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_count,
            SUM(CASE WHEN status = 'reviewing' THEN 1 ELSE 0 END) as reviewing_count,
            SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved_count,
            COALESCE(SUM(source_char_count), 0) as total_source_chars,
            COALESCE(SUM(target_char_count), 0) as total_target_chars,
            CASE 
              WHEN COUNT(*) > 0 
              THEN ROUND((SUM(CASE WHEN status IN ('completed', 'approved') THEN 1 ELSE 0 END)::DECIMAL / COUNT(*)) * 100, 2)
              ELSE 0 
            END as completion_rate,
            CURRENT_TIMESTAMP as last_updated_at
          FROM {translation_entries}
          WHERE project_id = @project_id AND is_deleted = false
          ON CONFLICT (project_id) 
          DO UPDATE SET
            total_entries = EXCLUDED.total_entries,
            pending_count = EXCLUDED.pending_count,
            completed_count = EXCLUDED.completed_count,
            reviewing_count = EXCLUDED.reviewing_count,
            approved_count = EXCLUDED.approved_count,
            total_source_chars = EXCLUDED.total_source_chars,
            total_target_chars = EXCLUDED.total_target_chars,
            completion_rate = EXCLUDED.completion_rate,
            last_updated_at = EXCLUDED.last_updated_at
          RETURNING *
        ''';

        final result = await _databaseService.query(sql, {'project_id': projectId});

        if (result.isEmpty) {
          // 如果没有数据，返回空统计
          return {
            'project_id': projectId,
            'total_entries': 0,
            'pending_count': 0,
            'completed_count': 0,
            'reviewing_count': 0,
            'approved_count': 0,
            'total_source_chars': 0,
            'total_target_chars': 0,
            'completion_rate': 0.0,
            'last_updated_at': DateTime.now().toIso8601String(),
          };
        }

        final stats = result.first.toColumnMap();
        logInfo('统计刷新完成', context: {
          'project_id': projectId,
          'total_entries': stats['total_entries'],
          'completion_rate': stats['completion_rate'],
        });

        return stats;
      },
      operationName: 'refreshProjectStats',
    );
  }

  /// 按语言获取项目统计
  Future<Map<String, dynamic>> getProjectStatsByLanguage(int projectId) async {
    return execute(
      () async {
        logInfo('获取项目按语言统计', context: {'project_id': projectId});

        final sql = '''
          SELECT 
            target_language_id,
            COUNT(*) as total_entries,
            SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_count,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_count,
            SUM(CASE WHEN status = 'reviewing' THEN 1 ELSE 0 END) as reviewing_count,
            SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved_count,
            COALESCE(SUM(source_char_count), 0) as total_source_chars,
            COALESCE(SUM(target_char_count), 0) as total_target_chars,
            CASE 
              WHEN COUNT(*) > 0 
              THEN ROUND((SUM(CASE WHEN status IN ('completed', 'approved') THEN 1 ELSE 0 END)::DECIMAL / COUNT(*)) * 100, 2)
              ELSE 0 
            END as completion_rate
          FROM {translation_entries}
          WHERE project_id = @project_id AND is_deleted = false
          GROUP BY target_language_id
          ORDER BY target_language_id
        ''';

        final result = await _databaseService.query(sql, {'project_id': projectId});
        final statsByLanguage = result.map((row) => row.toColumnMap()).toList();

        return {
          'project_id': projectId,
          'languages': statsByLanguage,
        };
      },
      operationName: 'getProjectStatsByLanguage',
    );
  }

  /// 批量刷新多个项目的统计
  Future<void> batchRefreshProjectStats(List<int> projectIds) async {
    return execute(
      () async {
        logInfo('批量刷新项目统计', context: {'project_count': projectIds.length});

        for (final projectId in projectIds) {
          try {
            await refreshProjectStats(projectId);
          } catch (error, stackTrace) {
            log('[ProjectStatsService.batchRefreshProjectStats]',
                error: error, stackTrace: stackTrace, name: 'ProjectStatsService');
            // 继续处理其他项目
          }
        }

        logInfo('批量刷新完成', context: {'project_count': projectIds.length});
      },
      operationName: 'batchRefreshProjectStats',
    );
  }

  /// 获取所有需要刷新的项目（统计数据过期）
  Future<List<int>> getStaleProjects({int minutesOld = 10}) async {
    return execute(
      () async {
        logInfo('查找过期的项目统计', context: {'minutes_old': minutesOld});

        final cutoffTime = DateTime.now().subtract(Duration(minutes: minutesOld));

        final sql = '''
          SELECT DISTINCT project_id
          FROM {project_translation_stats}
          WHERE last_updated_at < @cutoff_time
        ''';

        final result = await _databaseService.query(sql, {'cutoff_time': cutoffTime});
        final projectIds = result.map((row) => row.toColumnMap()['project_id'] as int).toList();

        logInfo('找到过期项目', context: {'count': projectIds.length});
        return projectIds;
      },
      operationName: 'getStaleProjects',
    );
  }

  /// 清理指定项目的统计缓存
  Future<void> clearProjectStats(int projectId) async {
    return execute(
      () async {
        logInfo('清理项目统计缓存', context: {'project_id': projectId});

        await _databaseService.query('''
          DELETE FROM {project_translation_stats}
          WHERE project_id = @project_id
        ''', {'project_id': projectId});

        logInfo('统计缓存已清理', context: {'project_id': projectId});
      },
      operationName: 'clearProjectStats',
    );
  }
}
