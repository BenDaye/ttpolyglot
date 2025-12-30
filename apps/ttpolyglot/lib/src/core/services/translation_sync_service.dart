import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/storage/storage_provider.dart';
import 'package:ttpolyglot/src/core/storage/storage_service.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 待同步操作
class _PendingOp {
  _PendingOp({
    required this.opType,
    required this.projectId,
    required this.payload,
    required this.createdAt,
  });

  final String opType; // create | update | delete | batchCreate
  final String projectId;
  final Map<String, dynamic> payload;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'opType': opType,
        'projectId': projectId,
        'payload': payload,
        'createdAt': createdAt.toIso8601String(),
      };

  static _PendingOp fromJson(Map<String, dynamic> json) {
    return _PendingOp(
      opType: json['opType'] as String,
      projectId: json['projectId'] as String,
      payload: Map<String, dynamic>.from(json['payload'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// 翻译同步服务：将离线期间写入的本地变更在网络可用时同步到服务器
class TranslationSyncService extends GetxService {
  static TranslationSyncService get instance => Get.isRegistered<TranslationSyncService>()
      ? Get.find<TranslationSyncService>()
      : Get.put(TranslationSyncService());

  late final StorageService _storage;
  final TranslationApi _api = TranslationApi();

  Future<TranslationSyncService> init() async {
    final provider = StorageProvider();
    await provider.initialize();
    _storage = provider.storageService;
    return this;
  }

  String _queueKey(String projectId) => 'projects.$projectId.translation.pending_ops';

  Future<List<_PendingOp>> _loadQueue(String projectId) async {
    try {
      final raw = await _storage.read(_queueKey(projectId));
      if (raw == null || raw.isEmpty) return [];
      final list = (jsonDecode(raw) as List).whereType<Map<String, dynamic>>().toList();
      return list.map((e) => _PendingOp.fromJson(e)).toList();
    } catch (error, stackTrace) {
      log('[loadQueue]', error: error, stackTrace: stackTrace, name: 'TranslationSyncService');
      return [];
    }
  }

  Future<void> _saveQueue(String projectId, List<_PendingOp> queue) async {
    final data = jsonEncode(queue.map((e) => e.toJson()).toList());
    await _storage.write(_queueKey(projectId), data);
  }

  /// 入队：在 API 写失败时调用
  Future<void> enqueue({
    required String projectId,
    required String opType, // create | update | delete | batchCreate
    required Map<String, dynamic> payload,
  }) async {
    try {
      final queue = await _loadQueue(projectId);
      queue.add(_PendingOp(
        opType: opType,
        projectId: projectId,
        payload: payload,
        createdAt: DateTime.now(),
      ));
      await _saveQueue(projectId, queue);
      log('[enqueue] $opType queued (${queue.length})', name: 'TranslationSyncService');
    } catch (error, stackTrace) {
      LoggerUtils.error('[enqueue]', error: error, stackTrace: stackTrace, name: 'TranslationSyncService');
    }
  }

  /// 手动触发同步（可在网络恢复时或用户点击“立即同步”时调用）
  Future<void> drain(String projectId) async {
    try {
      var queue = await _loadQueue(projectId);
      if (queue.isEmpty) return;

      final remaining = <_PendingOp>[];

      for (final op in queue) {
        final ok = await _perform(op);
        if (!ok) {
          remaining.add(op);
        }
      }

      await _saveQueue(projectId, remaining);
      if (remaining.isNotEmpty) {
        LoggerUtils.warning('部分同步失败，剩余 ${remaining.length} 条待同步', name: 'TranslationSyncService');
      } else {
        log('[drain] 同步完成，队列清空', name: 'TranslationSyncService');
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('[drain]', error: error, stackTrace: stackTrace, name: 'TranslationSyncService');
    }
  }

  Future<bool> _perform(_PendingOp op) async {
    try {
      switch (op.opType) {
        case 'create':
          await _api.createTranslation(projectId: op.projectId, data: op.payload);
          return true;
        case 'batchCreate':
          final items = (op.payload['items'] as List).whereType<Map<String, dynamic>>().toList();
          await _api.batchCreateTranslations(projectId: op.projectId, items: items);
          return true;
        case 'update':
          await _api.updateTranslation(
            projectId: op.projectId,
            entryId: op.payload['entry_id'] as String,
            data: Map<String, dynamic>.from(op.payload['data'] as Map),
          );
          return true;
        case 'delete':
          await _api.deleteTranslation(
            projectId: op.projectId,
            entryId: op.payload['entry_id'] as String,
          );
          return true;
        default:
          return false;
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('[perform:${op.opType}]', error: error, stackTrace: stackTrace, name: 'TranslationSyncService');
      return false;
    }
  }
}
