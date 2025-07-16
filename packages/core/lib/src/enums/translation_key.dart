enum TranslationKeyStyle {
  /// 嵌套
  nested,

  /// 平铺
  flat,
}

extension TranslationKeyStyleExtension on TranslationKeyStyle {
  String get displayName {
    switch (this) {
      case TranslationKeyStyle.nested:
        return '嵌套';
      case TranslationKeyStyle.flat:
        return '平铺';
    }
  }
}
