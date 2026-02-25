import 'dart:developer';

import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_model/model.dart';

/// 翻译 API
class TranslationApi {
  /// 获取翻译条目列表
  Future<PagerModel<TranslationEntryModel>?> getTranslations({
    required int projectId,
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
    required int projectId,
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
    required int projectId,
    required List<TranslationEntryModel> items,
  }) async {
    try {
      // 为每个条目添加 language_code 字段（服务器端需要）
      final itemsData = items.map((e) {
        final json = e.toJson();
        // 从 target_languages 数组中提取第一个语言的 code
        if (e.targetLanguages.isNotEmpty) {
          json['language_code'] = e.targetLanguages.first.language.code;
        }
        return json;
      }).toList();

      final response = await HttpClient.post(
        '/projects/$projectId/translations/batch',
        data: {'items': itemsData},
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
    required int projectId,
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
    required int projectId,
    required String entryId,
  }) async {
    try {
      final response = await HttpClient.delete(
        '/projects/$projectId/translations/$entryId',
      );
      final ok = ModelUtils.toModel<bool>(response.data, (json) => json['code'] == DataCodeEnum.success) ?? false;
      return ok;
    } catch (error, stackTrace) {
      // 如果错误是"数据不存在"，视为删除成功（幂等性：删除一个不存在的条目应该返回成功）
      // HttpClient._fetch 会抛出 BaseModel 类型的错误
      if (error is BaseModel && error.code == DataCodeEnum.dataNotFound) {
        log(
          '[deleteTranslation] 翻译条目不存在，视为删除成功（entryId: $entryId）',
          name: 'TranslationApi',
        );
        return true;
      }
      log('[deleteTranslation]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      rethrow;
    }
  }

  /// 翻译单个条目（服务端翻译 + 入库）
  Future<TranslationEntryModel?> translateEntry({
    required int projectId,
    required String entryId,
    required List<String> targetLanguages,
    required TranslationProviderConfigModel provider,
    bool force = false,
  }) async {
    try {
      final response = await HttpClient.post(
        '/projects/$projectId/translations/translate',
        data: {
          'entry_id': entryId,
          'target_languages': targetLanguages,
          'provider': provider.toJson(),
          if (force) 'force': true,
        },
      );
      return ModelUtils.toModel<TranslationEntryModel>(
        response.data,
        (json) => TranslationEntryModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      log('[translateEntry]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      return null;
    }
  }

  /// 批量翻译整个项目（服务端翻译 + 入库）
  Future<bool> batchTranslateProject({
    required int projectId,
    required List<String> targetLanguages,
    required TranslationProviderConfigModel provider,
    bool force = false,
  }) async {
    try {
      await HttpClient.post(
        '/projects/$projectId/translations/batch/translate-save',
        data: {
          'target_languages': targetLanguages,
          'provider': provider.toJson(),
          if (force) 'force': true,
        },
      );
      return true;
    } catch (error, stackTrace) {
      log('[batchTranslateProject]', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      return false;
    }
  }

  /// 搜索翻译条目
  Future<List<TranslationEntryModel>?> searchTranslations({
    required int projectId,
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
