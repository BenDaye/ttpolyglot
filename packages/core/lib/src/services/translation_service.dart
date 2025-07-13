import '../enums/translation_status.dart';
import '../models/language.dart';
import '../models/translation_entry.dart';

/// 翻译服务接口
abstract class TranslationService {
  /// 获取项目的所有翻译条目
  Future<List<TranslationEntry>> getTranslationEntries(String projectId);

  /// 根据语言获取翻译条目
  Future<List<TranslationEntry>> getTranslationEntriesByLanguage(
    String projectId,
    Language targetLanguage,
  );

  /// 根据状态获取翻译条目
  Future<List<TranslationEntry>> getTranslationEntriesByStatus(
    String projectId,
    TranslationStatus status,
  );

  /// 创建翻译条目
  Future<TranslationEntry> createTranslationEntry(TranslationEntry entry);

  /// 更新翻译条目
  Future<TranslationEntry> updateTranslationEntry(TranslationEntry entry);

  /// 删除翻译条目
  Future<void> deleteTranslationEntry(String entryId);

  /// 批量更新翻译条目
  Future<List<TranslationEntry>> batchUpdateTranslationEntries(
    List<TranslationEntry> entries,
  );

  /// 搜索翻译条目
  Future<List<TranslationEntry>> searchTranslationEntries(
    String projectId,
    String query, {
    Language? sourceLanguage,
    Language? targetLanguage,
    TranslationStatus? status,
  });

  /// 获取翻译进度统计
  Future<Map<String, int>> getTranslationProgress(String projectId);

  /// 导出翻译文件
  Future<String> exportTranslations(
    String projectId,
    Language language,
    String format,
  );

  /// 导入翻译文件
  Future<List<TranslationEntry>> importTranslations(
    String projectId,
    String filePath,
    String format,
  );

  /// 自动翻译
  Future<TranslationEntry> autoTranslate(
    TranslationEntry entry,
    String translationProvider,
  );

  /// 批量自动翻译
  Future<List<TranslationEntry>> batchAutoTranslate(
    List<TranslationEntry> entries,
    String translationProvider,
  );

  /// 验证翻译质量
  Future<Map<String, dynamic>> validateTranslation(TranslationEntry entry);
}
