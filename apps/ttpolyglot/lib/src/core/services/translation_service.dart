import 'package:ttpolyglot_model/model.dart';

import 'export_options.dart';

/// 翻译服务抽象接口
abstract class TranslationService {
  /// 获取项目的所有翻译条目
  Future<List<TranslationEntryModel>> getTranslationEntries(
    String projectId, {
    bool includeSourceLanguage = false,
  });

  /// 按语言获取翻译条目
  Future<List<TranslationEntryModel>> getTranslationEntriesByLanguage(
    String projectId,
    LanguageEnum language,
  );

  /// 按状态获取翻译条目
  Future<List<TranslationEntryModel>> getTranslationEntriesByStatus(
    String projectId,
    TranslationStatusEnum status,
  );

  /// 创建翻译条目
  Future<TranslationEntryModel> createTranslationEntryModel(TranslationEntryModel entry);

  /// 批量创建翻译条目
  Future<List<TranslationEntryModel>> batchCreateTranslationEntries(
    List<TranslationEntryModel> entries,
  );

  /// 创建翻译键（为所有目标语言创建条目）
  Future<List<TranslationEntryModel>> createTranslationKey(
    CreateTranslationKeyRequest request,
  );

  /// 更新翻译条目
  Future<TranslationEntryModel> updateTranslationEntryModel(TranslationEntryModel entry);

  /// 删除翻译条目
  Future<void> deleteTranslationEntryModel(String entryId);

  /// 从项目中删除翻译条目
  Future<void> deleteTranslationEntryModelFromProject(String projectId, String entryId);

  /// 批量更新翻译条目
  Future<List<TranslationEntryModel>> batchUpdateTranslationEntries(
    List<TranslationEntryModel> entries,
  );

  /// 搜索翻译条目
  Future<List<TranslationEntryModel>> searchTranslationEntries(
    String projectId, {
    String? query,
    LanguageEnum? language,
    TranslationStatusEnum? status,
  });

  /// 获取翻译进度
  Future<Map<String, int>> getTranslationProgress(String projectId);

  /// 导出翻译
  Future<String> exportTranslations(
    String projectId,
    LanguageEnum language, {
    String format = 'json',
    TranslationKeyStyle keyStyle = TranslationKeyStyle.nested,
    List<TranslationEntryModel> entries = const [],
  });

  /// 导入翻译
  Future<List<TranslationEntryModel>> importTranslations(
    String projectId,
    String filePath, {
    String format = 'json',
    TranslationKeyStyle keyStyle = TranslationKeyStyle.nested,
  });

  /// 自动翻译条目
  Future<TranslationEntryModel> autoTranslate(
    TranslationEntryModel entry,
    String translationProvider,
  );

  /// 批量自动翻译
  Future<List<TranslationEntryModel>> batchAutoTranslate(
    List<TranslationEntryModel> entries,
    String translationProvider,
  );

  /// 验证翻译
  Future<Map<String, dynamic>> validateTranslation(TranslationEntryModel entry);
}
