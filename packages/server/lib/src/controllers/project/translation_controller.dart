import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 翻译控制器
class TranslationController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;
  final TranslationService _translationService;

  TranslationController({
    required this.databaseService,
    required this.redisService,
  })  : _translationService = TranslationService(databaseService: databaseService),
        super('TranslationController');

  Future<Response> getTranslations(Request request, String projectId) async {
    return execute(
      () async {
        final projectIdInt = int.tryParse(projectId);
        if (projectIdInt == null) {
          throw ValidationException(message: '项目ID格式无效');
        }

        final params = request.url.queryParameters;
        final page = int.tryParse(params['page'] ?? '1') ?? 1;
        final limit = int.tryParse(params['limit'] ?? '50') ?? 50;
        final languageCode = params['language_code'];
        final status = params['status'];
        final translatorId = params['translator_id'];
        final reviewerId = params['reviewer_id'];
        final search = params['search'];

        if (page < 1 || limit < 1 || limit > 1000) {
          throw ValidationException(message: '分页参数无效');
        }

        final result = await _translationService.getTranslationEntries(
          projectId: projectIdInt,
          languageCode: languageCode,
          status: status,
          translatorId: translatorId,
          reviewerId: reviewerId,
          page: page,
          limit: limit,
          search: search,
        );

        return ResponseUtils.success<PagerModel<TranslationEntryModel>>(
          message: '获取翻译列表成功',
          data: result,
        );
      },
      operationName: 'getTranslations',
    );
  }

  Future<Response> createTranslation(Request request, String projectId) async {
    return execute(
      () async {
        final projectIdInt = int.tryParse(projectId);
        if (projectIdInt == null) {
          throw ValidationException(message: '项目ID格式无效');
        }

        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final entryKey = ValidatorUtils.validateString(data['entry_key'] ?? data['key'], 'entry_key');
        final languageCode = ValidatorUtils.validateString(
          data['language_code'] ?? data['target_language'] ?? data['lang'],
          'language_code',
        );
        final sourceText = data['source_text']?.toString();
        final targetText = data['target_text']?.toString();
        final translatorId = data['translator_id']?.toString();
        final contextInfo = data['context_info']?.toString() ?? data['context']?.toString();

        final entry = await _translationService.createTranslationEntry(
          projectId: projectIdInt,
          entryKey: entryKey,
          languageCode: languageCode,
          sourceText: sourceText,
          targetText: targetText,
          translatorId: translatorId,
          contextInfo: contextInfo,
        );

        return ResponseUtils.success(
          message: '创建翻译成功',
          data: entry,
        );
      },
      operationName: 'createTranslation',
    );
  }

  Future<Response> getTranslation(Request request, String projectId, String entryId) async {
    return execute(
      () async {
        final projectIdInt = int.tryParse(projectId);
        if (projectIdInt == null) {
          throw ValidationException(message: '项目ID格式无效');
        }

        final entry = await _translationService.getTranslationEntryById(entryId);
        if (entry == null) {
          throw NotFoundException(message: '翻译条目不存在');
        }

        if (entry.projectId != projectIdInt) {
          throw NotFoundException(message: '翻译条目不存在');
        }

        return ResponseUtils.success(
          message: '获取翻译详情成功',
          data: entry,
        );
      },
      operationName: 'getTranslation',
    );
  }

  Future<Response> updateTranslation(Request request, String projectId, String entryId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final targetText = data['target_text']?.toString();
        final targetLanguage = data['target_language']?.toString();
        final translatorId = data['translator_id']?.toString();
        final reviewerId = data['reviewer_id']?.toString();
        final contextInfo = data['context_info']?.toString() ?? data['context']?.toString();
        final sourceText = data['source_text']?.toString();
        final sortIndex = data['sort_index'] != null ? int.tryParse(data['sort_index'].toString()) : null;
        final updatedBy = getCurrentUserId(request);

        final entry = await _translationService.updateTranslationEntry(
          entryId: entryId,
          targetText: targetText,
          targetLanguage: targetLanguage,
          translatorId: translatorId,
          reviewerId: reviewerId,
          contextInfo: contextInfo,
          sourceText: sourceText,
          sortIndex: sortIndex,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '更新翻译成功',
          data: entry,
        );
      },
      operationName: 'updateTranslation',
    );
  }

  Future<Response> patchTranslation(Request request, String projectId, String entryId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final targetText = data['target_text']?.toString();
        final targetLanguage = data['target_language']?.toString();
        final translatorId = data['translator_id']?.toString();
        final reviewerId = data['reviewer_id']?.toString();
        final contextInfo = data['context_info']?.toString() ?? data['context']?.toString();
        final sourceText = data['source_text']?.toString();
        final sortIndex = data['sort_index'] != null ? int.tryParse(data['sort_index'].toString()) : null;
        final updatedBy = getCurrentUserId(request);

        final entry = await _translationService.updateTranslationEntry(
          entryId: entryId,
          targetText: targetText,
          targetLanguage: targetLanguage,
          translatorId: translatorId,
          reviewerId: reviewerId,
          contextInfo: contextInfo,
          sourceText: sourceText,
          sortIndex: sortIndex,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '部分更新翻译成功',
          data: entry,
        );
      },
      operationName: 'patchTranslation',
    );
  }

  Future<Response> deleteTranslation(Request request, String projectId, String entryId) async {
    return execute(
      () async {
        final deletedBy = getCurrentUserId(request);
        await _translationService.deleteTranslationEntry(entryId, deletedBy: deletedBy);

        return ResponseUtils.success(
          message: '删除翻译成功',
        );
      },
      operationName: 'deleteTranslation',
    );
  }

  Future<Response> batchOperations(Request request) async {
    return ResponseUtils.success(message: '批量操作功能待实现');
  }

  /// POST /api/v1/projects/{projectId}/translations/batch
  Future<Response> _batchCreateTranslations(Request request, String projectId) async {
    try {
      final projectIdInt = int.tryParse(projectId);
      if (projectIdInt == null) {
        return ResponseUtils.error(message: '项目ID格式无效');
      }

      final body = await request.readAsString();
      final decoded = jsonDecode(body);
      List<dynamic>? rawItems;
      if (decoded is Map<String, dynamic>) {
        rawItems = decoded['items'] as List<dynamic>?;
      } else if (decoded is List) {
        rawItems = decoded;
      }

      if (rawItems == null || rawItems.isEmpty) {
        return ResponseUtils.error(message: 'items 不能为空');
      }

      // 规范化为 Map<String, dynamic>
      final items = rawItems
          .map((e) => e is Map ? e.map((k, v) => MapEntry(k.toString(), v)) : <String, dynamic>{})
          .cast<Map<String, dynamic>>()
          .toList();

      // 基本校验：entry_key 与 language_code
      for (final item in items) {
        final entryKey = item['entry_key'] ?? item['key'];
        final languageCode = item['language_code'] ?? item['target_language'] ?? item['lang'];
        if (entryKey == null || entryKey.toString().trim().isEmpty) {
          return ResponseUtils.error(message: 'entry_key 不能为空');
        }
        if (languageCode == null || languageCode.toString().trim().isEmpty) {
          return ResponseUtils.error(message: 'language_code 不能为空');
        }
      }

      final created = await _translationService.batchCreateTranslations(
        projectId: projectIdInt,
        items: items,
      );

      return ResponseUtils.success<List<TranslationEntryModel>>(
        message: '批量创建翻译成功',
        data: created,
      );
    } catch (error, stackTrace) {
      ServerLogger.error(
        'batchCreateTranslations',
        error: error,
        stackTrace: stackTrace,
      );
      return ResponseUtils.error(message: '批量创建翻译失败');
    }
  }

  // 暴露用于路由绑定的方法引用
  Future<Response> Function(Request, String) get batchCreate => _batchCreateTranslations;

  Future<Response> batchDelete(Request request, String projectId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final entryIds = (data['entry_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

        if (entryIds.isEmpty) {
          throw ValidationException(message: 'entry_ids 不能为空');
        }

        final deletedBy = getCurrentUserId(request);
        for (final entryId in entryIds) {
          await _translationService.deleteTranslationEntry(entryId, deletedBy: deletedBy);
        }

        return ResponseUtils.success(
          message: '批量删除成功',
          data: {'deleted_count': entryIds.length},
        );
      },
      operationName: 'batchDelete',
    );
  }

  Future<Response> batchTranslate(Request request, int projectId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final entryIds = (data['entry_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

        if (entryIds.isEmpty) {
          throw ValidationException(message: 'entry_ids 不能为空');
        }

        final updatedBy = getCurrentUserId(request);
        final updatedEntries = await _translationService.bulkUpdateTranslationEntries(
          entryIds: entryIds,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '批量翻译成功',
          data: updatedEntries,
        );
      },
      operationName: 'batchTranslate',
    );
  }

  Future<Response> batchApprove(Request request, int projectId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final entryIds = (data['entry_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

        if (entryIds.isEmpty) {
          throw ValidationException(message: 'entry_ids 不能为空');
        }

        final updatedBy = getCurrentUserId(request);
        final updatedEntries = await _translationService.bulkUpdateTranslationEntries(
          entryIds: entryIds,
          reviewerId: updatedBy,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '批量批准成功',
          data: updatedEntries,
        );
      },
      operationName: 'batchApprove',
    );
  }

  Future<Response> getTranslationHistory(Request request, int projectId, String entryId) async {
    return execute(
      () async {
        final params = request.url.queryParameters;
        final limit = int.tryParse(params['limit'] ?? '50') ?? 50;

        final history = await _translationService.getTranslationHistory(entryId, limit: limit);

        return ResponseUtils.success(
          message: '获取翻译历史成功',
          data: history,
        );
      },
      operationName: 'getTranslationHistory',
    );
  }

  Future<Response> getTranslationVersions(Request request, int projectId, String entryId) async {
    return execute(
      () async {
        // 版本信息可以从历史记录中获取，这里简化处理
        final history = await _translationService.getTranslationHistory(entryId, limit: 100);

        return ResponseUtils.success(
          message: '获取翻译版本成功',
          data: history,
        );
      },
      operationName: 'getTranslationVersions',
    );
  }

  Future<Response> revertTranslation(Request request, int projectId, String entryId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final versionId = data['version_id']?.toString();

        if (versionId == null) {
          throw ValidationException(message: 'version_id 不能为空');
        }

        // 获取历史记录
        final history = await _translationService.getTranslationHistory(entryId, limit: 100);
        final targetVersion = history.firstWhere(
          (h) => h['id'].toString() == versionId,
          orElse: () => throw NotFoundException(message: '版本不存在'),
        );

        // 恢复到指定版本
        final updatedBy = getCurrentUserId(request);
        final targetText = targetVersion['old_target_text']?.toString() ?? targetVersion['new_target_text']?.toString();
        final targetLanguage =
            targetVersion['old_target_language']?.toString() ?? targetVersion['new_target_language']?.toString();
        final entry = await _translationService.updateTranslationEntry(
          entryId: entryId,
          targetText: targetText,
          targetLanguage: targetLanguage,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '回滚翻译成功',
          data: entry,
        );
      },
      operationName: 'revertTranslation',
    );
  }

  Future<Response> assignTranslator(Request request, int projectId, String entryId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final translatorId = ValidatorUtils.validateUuid(data['translator_id'], 'translator_id');

        final updatedBy = getCurrentUserId(request);
        final entry = await _translationService.updateTranslationEntry(
          entryId: entryId,
          translatorId: translatorId,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '分配翻译员成功',
          data: entry,
        );
      },
      operationName: 'assignTranslator',
    );
  }

  Future<Response> submitTranslation(Request request, int projectId, String entryId) async {
    return execute(
      () async {
        final updatedBy = getCurrentUserId(request);
        final entry = await _translationService.updateTranslationEntry(
          entryId: entryId,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '提交翻译成功',
          data: entry,
        );
      },
      operationName: 'submitTranslation',
    );
  }

  Future<Response> reviewTranslation(Request request, int projectId, String entryId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final reviewerId = getCurrentUserId(request);
        final comment = data['comment']?.toString();

        final entry = await _translationService.updateTranslationEntry(
          entryId: entryId,
          reviewerId: reviewerId,
          contextInfo: comment,
          updatedBy: reviewerId,
        );

        return ResponseUtils.success(
          message: '审核翻译成功',
          data: entry,
        );
      },
      operationName: 'reviewTranslation',
    );
  }

  Future<Response> approveTranslation(Request request, int projectId, String entryId) async {
    return execute(
      () async {
        final updatedBy = getCurrentUserId(request);
        final entry = await _translationService.updateTranslationEntry(
          entryId: entryId,
          reviewerId: updatedBy,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '批准翻译成功',
          data: entry,
        );
      },
      operationName: 'approveTranslation',
    );
  }

  Future<Response> rejectTranslation(Request request, int projectId, String entryId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final reason = data['reason']?.toString() ?? '翻译被拒绝';

        final updatedBy = getCurrentUserId(request);
        final entry = await _translationService.updateTranslationEntry(
          entryId: entryId,
          reviewerId: updatedBy,
          contextInfo: reason,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '拒绝翻译成功',
          data: entry,
        );
      },
      operationName: 'rejectTranslation',
    );
  }

  Future<Response> searchTranslations(Request request, int projectId) async {
    return execute(
      () async {
        final params = request.url.queryParameters;
        final query = params['q'] ?? params['query'] ?? params['search'];
        final page = int.tryParse(params['page'] ?? '1') ?? 1;
        final limit = int.tryParse(params['limit'] ?? '50') ?? 50;

        if (query == null || query.isEmpty) {
          throw ValidationException(message: '搜索关键词不能为空');
        }

        final result = await _translationService.getTranslationEntries(
          projectId: projectId,
          search: query,
          page: page,
          limit: limit,
        );

        return ResponseUtils.success(
          message: '搜索翻译成功',
          data: result,
        );
      },
      operationName: 'searchTranslations',
    );
  }

  Future<Response> filterTranslations(Request request, int projectId) async {
    return execute(
      () async {
        final params = request.url.queryParameters;
        final page = int.tryParse(params['page'] ?? '1') ?? 1;
        final limit = int.tryParse(params['limit'] ?? '50') ?? 50;
        final languageCode = params['language_code'];
        final status = params['status'];
        final translatorId = params['translator_id'];
        final reviewerId = params['reviewer_id'];

        final result = await _translationService.getTranslationEntries(
          projectId: projectId,
          languageCode: languageCode,
          status: status,
          translatorId: translatorId,
          reviewerId: reviewerId,
          page: page,
          limit: limit,
        );

        return ResponseUtils.success(
          message: '过滤翻译成功',
          data: result,
        );
      },
      operationName: 'filterTranslations',
    );
  }

  /// 翻译单个条目（调用翻译API + 入库）
  Future<Response> translate(Request request, String projectId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final entryId = ValidatorUtils.validateString(data['entry_id'], 'entry_id');
        final targetLanguages = (data['target_languages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        final providerData = data['provider'] as Map<String, dynamic>?;

        if (targetLanguages.isEmpty) {
          throw ValidationException(message: 'target_languages 不能为空');
        }
        if (providerData == null) {
          throw ValidationException(message: 'provider 不能为空');
        }

        final provider = TranslationProviderConfigModel.fromJson(providerData);
        final force = data['force'] == true;
        final updatedBy = getCurrentUserId(request);

        await _translationService.translateEntry(
          entryId: entryId,
          targetLanguages: targetLanguages,
          provider: provider,
          force: force,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '翻译成功',
        );
      },
      operationName: 'translate',
    );
  }

  /// 批量翻译整个项目（调用翻译API + 入库）
  Future<Response> batchTranslateEntries(Request request, String projectId) async {
    return execute(
      () async {
        final projectIdInt = int.tryParse(projectId);
        if (projectIdInt == null) {
          throw ValidationException(message: '项目ID格式无效');
        }

        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final targetLanguages = (data['target_languages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        final providerData = data['provider'] as Map<String, dynamic>?;

        if (targetLanguages.isEmpty) {
          throw ValidationException(message: 'target_languages 不能为空');
        }
        if (providerData == null) {
          throw ValidationException(message: 'provider 不能为空');
        }

        final provider = TranslationProviderConfigModel.fromJson(providerData);
        final force = data['force'] == true;
        final updatedBy = getCurrentUserId(request);

        await _translationService.batchTranslateEntries(
          projectId: projectIdInt,
          targetLanguages: targetLanguages,
          provider: provider,
          force: force,
          updatedBy: updatedBy,
        );

        return ResponseUtils.success(
          message: '批量翻译成功',
        );
      },
      operationName: 'batchTranslateEntries',
    );
  }
}
