import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';

/// 语言模型
class Language extends Equatable {
  const Language({
    required this.id,
    required this.code,
    required this.name,
    required this.nativeName,
    this.isRtl = false,
    this.sortIndex = 0,
  });

  /// 语言ID (可选，用于API调用)
  final int id;

  /// 语言代码 (如: en-US, zh-CN, ja-JP)
  final String code;

  /// 英文名称 (如: English, Chinese, Japanese)
  final String name;

  /// 本地名称 (如: English, 中文, 日本語)
  final String nativeName;

  /// 是否为从右到左的语言
  final bool isRtl;

  /// 排序索引
  final int sortIndex;

  /// 获取所有支持的语言列表
  static List<Language> get supportedLanguages => [
        Language(
            id: 1,
            code: 'en-US',
            name: 'English (United States)',
            nativeName: 'English (United States)',
            sortIndex: 11),
        Language(id: 2, code: 'zh-CN', name: 'Chinese (Simplified)', nativeName: '简体中文', sortIndex: 21),
        Language(id: 3, code: 'zh-TW', name: 'Chinese (Traditional)', nativeName: '繁體中文', sortIndex: 21),
        Language(id: 4, code: 'th-TH', name: 'Thai', nativeName: 'ภาษาไทย', sortIndex: 31),
        Language(id: 5, code: 'ja-JP', name: 'Japanese', nativeName: '日本語', sortIndex: 41),
        Language(id: 6, code: 'ko-KR', name: 'Korean', nativeName: '한국어', sortIndex: 51),
        Language(id: 7, code: 'my-MM', name: 'Myanmar', nativeName: 'မြန်မာဘာသာ', sortIndex: 61),
        Language(id: 8, code: 'tr-TR', name: 'Turkish', nativeName: 'Türkçe', sortIndex: 71),
        Language(id: 9, code: 'de-DE', name: 'German', nativeName: 'Deutschland', sortIndex: 81),
        Language(id: 10, code: 'sv-SE', name: 'Swedish', nativeName: 'Svenska', sortIndex: 91),
      ];

  /// 验证语言代码格式是否正确 (必须是 language_code-country_code 格式)
  static bool isValidLanguageCode(String code) {
    try {
      // 检查格式是否为 xx-XX 形式
      final RegExp languageCodePattern = RegExp(r'^[a-z]{2}-[A-Z]{2}$');
      final isValid = languageCodePattern.hasMatch(code);

      if (!isValid) {
        developer.log('isValidLanguageCode',
            error: 'Invalid language code format: $code. Must be in format: xx-XX (e.g., en-US, zh-CN)');
      }

      return isValid;
    } catch (error, stackTrace) {
      developer.log('isValidLanguageCode', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 根据语言代码获取支持的语言
  static Language? getLanguageByCode(String code) {
    try {
      if (!isValidLanguageCode(code)) {
        return null;
      }

      return supportedLanguages.where((lang) => lang.code == code).firstOrNull;
    } catch (error, stackTrace) {
      developer.log('getLanguageByCode', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 检查语言代码是否被支持
  static bool isLanguageSupported(String code) {
    try {
      return getLanguageByCode(code) != null;
    } catch (error, stackTrace) {
      developer.log('isLanguageSupported', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 获取按语言分组的支持语言列表
  static Map<String, List<Language>> get supportedLanguagesByGroup {
    try {
      final Map<String, List<Language>> grouped = {};

      for (final language in supportedLanguages) {
        final languageCode = language.code.split('-')[0];
        grouped.putIfAbsent(languageCode, () => []).add(language);
      }

      return grouped;
    } catch (error, stackTrace) {
      developer.log('supportedLanguagesByGroup', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 搜索支持的语言
  static List<Language> searchSupportedLanguages(String query) {
    try {
      if (query.isEmpty) {
        return supportedLanguages;
      }

      final lowerQuery = query.toLowerCase();
      return supportedLanguages.where((language) {
        return language.code.toLowerCase().contains(lowerQuery) ||
            language.name.toLowerCase().contains(lowerQuery) ||
            language.nativeName.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (error, stackTrace) {
      developer.log('searchSupportedLanguages', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  /// 复制并更新语言信息
  Language copyWith({
    int? id,
    String? code,
    String? name,
    String? nativeName,
    bool? isRtl,
    int? sortIndex,
  }) {
    return Language(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      isRtl: isRtl ?? this.isRtl,
      sortIndex: sortIndex ?? this.sortIndex,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'isRtl': isRtl,
      'sortIndex': sortIndex,
    };
  }

  /// 从 JSON 创建
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String,
      isRtl: json['isRtl'] as bool? ?? false,
      sortIndex: json['sortIndex'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, code, name, nativeName, isRtl, sortIndex];

  @override
  String toString() =>
      'Language(code: $code, name: $name, nativeName: $nativeName, isRtl: $isRtl, sortIndex: $sortIndex)';
}
