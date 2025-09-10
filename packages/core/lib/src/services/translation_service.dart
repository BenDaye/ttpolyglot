import '../enums/translation_key.dart';
import '../enums/translation_status.dart';
import '../models/language.dart';
import '../models/translation_entry.dart';

/// 翻译服务接口
abstract class TranslationService {
  /// 获取项目的所有翻译条目
  ///
  /// [projectId] 项目 ID
  ///
  /// [includeSourceLanguage] 是否包含源语言的翻译条目
  Future<List<TranslationEntry>> getTranslationEntries(
    String projectId, {
    bool includeSourceLanguage = false,
  });

  /// 根据语言获取翻译条目
  ///
  /// [projectId] 项目 ID
  ///
  /// [targetLanguage] 目标语言
  ///
  /// [includeSourceLanguage] 是否包含源语言的翻译条目
  Future<List<TranslationEntry>> getTranslationEntriesByLanguage(
    String projectId,
    Language targetLanguage, {
    bool includeSourceLanguage = false,
  });

  /// 根据状态获取翻译条目
  ///
  /// [projectId] 项目 ID
  ///
  /// [status] 状态
  Future<List<TranslationEntry>> getTranslationEntriesByStatus(
    String projectId,
    TranslationStatus status,
  );

  /// 创建翻译条目
  ///
  /// [entry] 翻译条目
  Future<TranslationEntry> createTranslationEntry(TranslationEntry entry);

  /// 批量创建翻译条目
  ///
  /// [entries] 翻译条目列表
  Future<List<TranslationEntry>> batchCreateTranslationEntries(
    List<TranslationEntry> entries,
  );

  /// 为指定的 key 创建多个语言版本的翻译条目
  Future<List<TranslationEntry>> createTranslationKey(
    CreateTranslationKeyRequest request,
  );

  /// 更新翻译条目
  Future<TranslationEntry> updateTranslationEntry(TranslationEntry entry);

  /// 删除翻译条目
  Future<void> deleteTranslationEntry(String entryId);

  /// 删除翻译条目（指定项目ID）
  Future<void> deleteTranslationEntryFromProject(String projectId, String entryId);

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
    Language language, {
    String format,
    TranslationKeyStyle keyStyle = TranslationKeyStyle.nested,
    List<TranslationEntry> entries = const [],
  });

  /// 导入翻译文件
  Future<List<TranslationEntry>> importTranslations(
    String projectId,
    String filePath, {
    String format,
    TranslationKeyStyle keyStyle = TranslationKeyStyle.nested,
  });

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

/// 创建翻译键请求
class CreateTranslationKeyRequest {
  const CreateTranslationKeyRequest({
    required this.projectId,
    required this.key,
    required this.sourceLanguage,
    required this.sourceText,
    required this.targetLanguages,
    this.context,
    this.comment,
    this.maxLength,
    this.isPlural = false,
    this.pluralForms,
    this.initialStatus = TranslationStatus.pending,
    this.generateForDefaultLanguage = true,
  });

  /// 项目 ID
  final String projectId;

  /// 翻译键名
  final String key;

  /// 源语言
  final Language sourceLanguage;

  /// 源文本
  final String sourceText;

  /// 目标语言列表
  final List<Language> targetLanguages;

  /// 上下文信息
  final String? context;

  /// 备注
  final String? comment;

  /// 最大长度限制
  final int? maxLength;

  /// 是否为复数形式
  final bool isPlural;

  /// 复数形式的翻译
  final Map<String, String>? pluralForms;

  /// 初始状态
  final TranslationStatus initialStatus;

  /// 是否为默认语言也生成翻译条目
  final bool generateForDefaultLanguage;

  /// 验证请求数据
  List<String> validate() {
    final errors = <String>[];

    // 验证项目 ID
    if (projectId.trim().isEmpty) {
      errors.add('项目 ID 不能为空');
    }

    // 验证翻译键名
    if (key.trim().isEmpty) {
      errors.add('翻译键名不能为空');
    }

    // 验证源文本
    if (sourceText.trim().isEmpty) {
      errors.add('源文本不能为空');
    }

    // 验证源语言
    if (!Language.isValidLanguageCode(sourceLanguage.code)) {
      errors.add('源语言代码格式错误: ${sourceLanguage.code}');
    }

    if (!Language.isLanguageSupported(sourceLanguage.code)) {
      errors.add('不支持的源语言: ${sourceLanguage.code}');
    }

    // 验证目标语言
    if (targetLanguages.isEmpty) {
      errors.add('至少需要指定一个目标语言');
    }

    for (final language in targetLanguages) {
      if (!Language.isValidLanguageCode(language.code)) {
        errors.add('目标语言代码格式错误: ${language.code}');
      }

      if (!Language.isLanguageSupported(language.code)) {
        errors.add('不支持的目标语言: ${language.code}');
      }
    }

    // 验证目标语言不能重复
    final targetLanguageCodes = targetLanguages.map((lang) => lang.code).toList();
    final uniqueCodes = targetLanguageCodes.toSet();
    if (targetLanguageCodes.length != uniqueCodes.length) {
      errors.add('目标语言不能重复');
    }

    // 验证源语言不能在目标语言中（除非 generateForDefaultLanguage 为 true）
    if (!generateForDefaultLanguage && targetLanguages.any((lang) => lang.code == sourceLanguage.code)) {
      errors.add('源语言不能同时作为目标语言');
    }

    return errors;
  }

  /// 是否有效
  bool get isValid => validate().isEmpty;
}
