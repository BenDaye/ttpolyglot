import 'dart:developer';

import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 翻译模型转换器
class TranslationConverter {
  TranslationConverter._();

  /// Model -> Core
  static TranslationEntry toCore(TranslationEntryModel model) {
    try {
      final sourceLang = _fromLanguageEnum(model.languageCode) ??
          Language(
            id: model.sourceLanguageId ?? 0,
            code: model.languageCode != null ? model.languageCode!.code : 'en-US',
            name: model.languageCode?.name ?? 'English (United States)',
            nativeName: model.languageCode?.nativeName ?? 'English (United States)',
            isRtl: false,
            sortIndex: 0,
          );

      final targetLang = _fromLanguageEnum(model.languageCode) ?? sourceLang;

      return TranslationEntry(
        id: (model.id?.toString() ?? model.uuid ?? '${DateTime.now().millisecondsSinceEpoch}'),
        key: model.entryKey,
        projectId: model.projectId,
        sourceLanguage: sourceLang,
        targetLanguage: targetLang,
        sourceText: model.sourceText ?? '',
        targetText: model.targetText ?? '',
        status: _statusFromString(model.status),
        createdAt: model.createdAt ?? DateTime.now(),
        updatedAt: model.updatedAt ?? DateTime.now(),
        comment: null,
        context: model.contextInfo,
        maxLength: null,
        isPlural: false,
        pluralForms: null,
      );
    } catch (error, stackTrace) {
      log('[toCore]', error: error, stackTrace: stackTrace, name: 'TranslationConverter');
      rethrow;
    }
  }

  /// Core -> Model (部分字段)
  static Map<String, dynamic> toCreatePayload(TranslationEntry entry) {
    return {
      'project_id': entry.projectId,
      'entry_key': entry.key,
      'language_code': entry.targetLanguage.code,
      'source_text': entry.sourceText,
      'target_text': entry.targetText,
      'context_info': entry.context,
    };
  }

  static TranslationStatus _statusFromString(String status) {
    switch (status) {
      case 'completed':
        return TranslationStatus.completed;
      case 'reviewing':
        return TranslationStatus.reviewing;
      case 'approved':
        return TranslationStatus.completed;
      case 'pending':
      default:
        return TranslationStatus.pending;
    }
  }

  static Language? _fromLanguageEnum(LanguageEnum? lang) {
    if (lang == null) return null;
    return Language(
      id: 0,
      code: lang.code,
      name: lang.name,
      nativeName: lang.nativeName,
      isRtl: false,
      sortIndex: 0,
    );
  }
}
