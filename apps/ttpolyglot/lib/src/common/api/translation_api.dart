import 'dart:developer';

import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_model/model.dart';

/// 翻译 API
class TranslationApi {
  /// 获取翻译条目列表
  Future<PagerModel<TranslationEntryModel>?> getTranslations({
    required String projectId,
    String? languageCode,
    String? status,
    String? translatorId,
    String? reviewerId,
    int page = 1,
    int limit = 50,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (languageCode != null && languageCode.isNotEmpty) 'language_code': languageCode,
        if (status != null && status.isNotEmpty) 'status': status,
        if (translatorId != null && translatorId.isNotEmpty) 'translator_id': translatorId,
        if (reviewerId != null && reviewerId.isNotEmpty) 'reviewer_id': reviewerId,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await HttpClient.get(
        '/projects/$projectId/translations',
        query: queryParams,
      );

      // 转换为 PagerModel
      return ModelUtils.toModel<PagerModel<TranslationEntryModel>>(
        response.data,
        (json) => PagerModel.fromJson(json, (data) => TranslationEntryModel.fromJson(data as Map<String, dynamic>)),
      );
    } catch (error, stackTrace) {
      log('[getTranslations]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      rethrow;
    }
  }

  /// 创建翻译条目
  Future<TranslationEntryModel?> createTranslation({
    required String projectId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await HttpClient.post(
        '/projects/$projectId/translations',
        data: data,
      );
      return ModelUtils.toModel<TranslationEntryModel>(
        response.data,
        (json) => TranslationEntryModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      log('[createTranslation]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      rethrow;
    }
  }

  /// 批量创建翻译条目
  Future<List<TranslationEntryModel>?> batchCreateTranslations({
    required String projectId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await HttpClient.post(
        '/projects/$projectId/translations/batch',
        data: {'items': items},
      );
      return ModelUtils.toModelArray<TranslationEntryModel>(
        response.data,
        (json) => TranslationEntryModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      log('[batchCreateTranslations]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      rethrow;
    }
  }

  /// 更新翻译条目
  Future<TranslationEntryModel?> updateTranslation({
    required String projectId,
    required String entryId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await HttpClient.put(
        '/projects/$projectId/translations/$entryId',
        data: data,
      );
      return ModelUtils.toModel<TranslationEntryModel>(
        response.data,
        (json) => TranslationEntryModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      log('[updateTranslation]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      rethrow;
    }
  }

  /// 删除翻译条目
  Future<bool> deleteTranslation({
    required String projectId,
    required String entryId,
  }) async {
    try {
      final response = await HttpClient.delete(
        '/projects/$projectId/translations/$entryId',
      );
      final ok = ModelUtils.toModel<bool>(response.data, (json) => json['code'] == DataCodeEnum.success) ?? false;
      return ok;
    } catch (error, stackTrace) {
      log('[deleteTranslation]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      rethrow;
    }
  }

  /// 搜索翻译条目
  Future<List<TranslationEntryModel>?> searchTranslations({
    required String projectId,
    required String query,
    String? status,
    String? languageCode,
  }) async {
    try {
      final response = await HttpClient.get(
        '/projects/$projectId/translations/search',
        query: {
          'q': query,
          if (status != null) 'status': status,
          if (languageCode != null) 'language_code': languageCode,
        },
      );
      return ModelUtils.toModelArray<TranslationEntryModel>(
        response.data,
        (json) => TranslationEntryModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      log('[searchTranslations]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      rethrow;
    }
  }
}
