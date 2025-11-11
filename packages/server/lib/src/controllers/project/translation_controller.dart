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

  Future<Response> getTranslations(Request request) async {
    return ResponseUtils.success(message: '获取翻译列表功能待实现');
  }

  Future<Response> createTranslation(Request request) async {
    return ResponseUtils.success(message: '创建翻译功能待实现');
  }

  Future<Response> getTranslation(Request request) async {
    return ResponseUtils.success(message: '获取翻译详情功能待实现');
  }

  Future<Response> updateTranslation(Request request) async {
    return ResponseUtils.success(message: '更新翻译功能待实现');
  }

  Future<Response> patchTranslation(Request request) async {
    return ResponseUtils.success(message: '部分更新翻译功能待实现');
  }

  Future<Response> deleteTranslation(Request request) async {
    return ResponseUtils.success(message: '删除翻译功能待实现');
  }

  Future<Response> batchOperations(Request request) async {
    return ResponseUtils.success(message: '批量操作功能待实现');
  }

  /// POST /api/v1/projects/<projectId>/translations/batch
  Future<Response> _batchCreateTranslations(Request request, String projectId) async {
    try {
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
        projectId: projectId,
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

  Future<Response> batchDelete(Request request) async {
    return ResponseUtils.success(message: '批量删除功能待实现');
  }

  Future<Response> batchTranslate(Request request) async {
    return ResponseUtils.success(message: '批量翻译功能待实现');
  }

  Future<Response> batchApprove(Request request) async {
    return ResponseUtils.success(message: '批量批准功能待实现');
  }

  Future<Response> getTranslationHistory(Request request) async {
    return ResponseUtils.success(message: '获取翻译历史功能待实现');
  }

  Future<Response> getTranslationVersions(Request request) async {
    return ResponseUtils.success(message: '获取翻译版本功能待实现');
  }

  Future<Response> revertTranslation(Request request) async {
    return ResponseUtils.success(message: '回滚翻译功能待实现');
  }

  Future<Response> assignTranslator(Request request) async {
    return ResponseUtils.success(message: '分配翻译员功能待实现');
  }

  Future<Response> submitTranslation(Request request) async {
    return ResponseUtils.success(message: '提交翻译功能待实现');
  }

  Future<Response> reviewTranslation(Request request) async {
    return ResponseUtils.success(message: '审核翻译功能待实现');
  }

  Future<Response> approveTranslation(Request request) async {
    return ResponseUtils.success(message: '批准翻译功能待实现');
  }

  Future<Response> rejectTranslation(Request request) async {
    return ResponseUtils.success(message: '拒绝翻译功能待实现');
  }

  Future<Response> searchTranslations(Request request) async {
    return ResponseUtils.success(message: '搜索翻译功能待实现');
  }

  Future<Response> filterTranslations(Request request) async {
    return ResponseUtils.success(message: '过滤翻译功能待实现');
  }
}
