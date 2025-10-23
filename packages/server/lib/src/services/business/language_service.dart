import 'dart:convert';
import 'dart:developer';

import 'package:ttpolyglot_model/model.dart';

import '../base_service.dart';
import '../infrastructure/database_service.dart';
import '../infrastructure/redis_service.dart';

/// 语言服务
class LanguageService extends BaseService {
  final DatabaseService _databaseService;
  final RedisService _redisService;

  static const String _cachePrefix = 'language:';
  static const Duration _cacheDuration = Duration(hours: 1);

  LanguageService({
    required DatabaseService databaseService,
    required RedisService redisService,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        super('LanguageService');

  /// 获取所有激活的语言列表
  Future<List<LanguageModel>> getLanguages({bool includeInactive = false}) async {
    return execute(() async {
      logInfo('获取语言列表', context: {'includeInactive': includeInactive});

      // 尝试从缓存获取
      final cacheKey = '${_cachePrefix}all:${includeInactive ? 'with_inactive' : 'active_only'}';
      final cached = await _redisService.get(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        try {
          final List<dynamic> cachedList = jsonDecode(cached) as List<dynamic>;
          logInfo('从缓存获取语言列表成功', context: {'count': cachedList.length});
          return cachedList.map((item) => LanguageModel.fromJson(item as Map<String, dynamic>)).toList();
        } catch (e) {
          logWarning('缓存数据解析失败', context: {'error': e.toString()});
        }
      }

      // 从数据库查询
      final sql = '''
        SELECT 
          id, code, name, native_name, flag_emoji, 
          is_active, is_rtl, sort_order, 
          created_at, updated_at
        FROM {languages}
        ${includeInactive ? '' : 'WHERE is_active = true'}
        ORDER BY sort_order ASC, id ASC
      ''';

      final result = await _databaseService.query(sql);

      if (result.isEmpty) {
        logWarning('数据库中没有语言数据，返回空列表');
        return [];
      }

      final languages = result.map((row) {
        final data = row.toColumnMap();
        return LanguageModel(
          id: data['id'] as int,
          code: LanguageEnum.fromValue(data['code'] as String),
          name: data['name'] as String,
          nativeName: data['native_name'] as String?,
          flagEmoji: data['flag_emoji'] as String?,
          isActive: data['is_active'] as bool? ?? true,
          isRtl: data['is_rtl'] as bool? ?? false,
          sortOrder: data['sort_order'] as int? ?? 0,
          createdAt: data['created_at'] as DateTime,
          updatedAt: data['updated_at'] as DateTime,
        );
      }).toList();

      // 缓存结果
      await _redisService.set(
        cacheKey,
        jsonEncode(languages.map((lang) => lang.toJson()).toList()),
        _cacheDuration.inSeconds,
      );

      logInfo('获取语言列表成功', context: {'count': languages.length});
      return languages;
    }, operationName: 'getLanguages');
  }

  /// 根据语言代码获取语言
  Future<LanguageModel?> getLanguageByCode(String code) async {
    return execute(() async {
      logInfo('获取语言详情', context: {'code': code});

      // 尝试从缓存获取
      final cacheKey = '$_cachePrefix$code';
      final cached = await _redisService.get(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        try {
          logInfo('从缓存获取语言详情成功', context: {'code': code});
          return LanguageModel.fromJson(jsonDecode(cached) as Map<String, dynamic>);
        } catch (e) {
          logWarning('缓存数据解析失败', context: {'error': e.toString()});
        }
      }

      // 从数据库查询
      const sql = '''
        SELECT 
          id, code, name, native_name, flag_emoji, 
          is_active, is_rtl, sort_order, 
          created_at, updated_at
        FROM {languages}
        WHERE code = @code
      ''';

      final result = await _databaseService.query(sql, {'code': code});

      if (result.isEmpty) {
        logWarning('语言不存在', context: {'code': code});
        return null;
      }

      final data = result.first.toColumnMap();
      final language = LanguageModel(
        id: data['id'] as int,
        code: LanguageEnum.fromValue(data['code'] as String),
        name: data['name'] as String,
        nativeName: data['native_name'] as String?,
        flagEmoji: data['flag_emoji'] as String?,
        isActive: data['is_active'] as bool? ?? true,
        isRtl: data['is_rtl'] as bool? ?? false,
        sortOrder: data['sort_order'] as int? ?? 0,
        createdAt: data['created_at'] as DateTime,
        updatedAt: data['updated_at'] as DateTime,
      );

      // 缓存结果
      await _redisService.set(
        cacheKey,
        jsonEncode(language.toJson()),
        _cacheDuration.inSeconds,
      );

      logInfo('获取语言详情成功', context: {'code': code});
      return language;
    }, operationName: 'getLanguageByCode');
  }

  /// 清除语言缓存
  Future<void> clearCache({String? code}) async {
    try {
      if (code != null) {
        // 清除特定语言的缓存
        await _redisService.delete('$_cachePrefix$code');
        logInfo('清除语言缓存成功', context: {'code': code});
      } else {
        // 清除所有语言相关的缓存
        await _redisService.deletePattern('$_cachePrefix*');
        logInfo('清除所有语言缓存成功');
      }
    } catch (error, stackTrace) {
      log('[clearCache]', error: error, stackTrace: stackTrace, name: 'LanguageService');
    }
  }

  /// 刷新语言缓存
  Future<void> refreshCache() async {
    try {
      logInfo('开始刷新语言缓存');
      await clearCache();
      await getLanguages(includeInactive: false);
      await getLanguages(includeInactive: true);
      logInfo('刷新语言缓存成功');
    } catch (error, stackTrace) {
      log('[refreshCache]', error: error, stackTrace: stackTrace, name: 'LanguageService');
    }
  }
}
