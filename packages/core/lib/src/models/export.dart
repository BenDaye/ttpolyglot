import 'package:equatable/equatable.dart';
import 'package:ttpolyglot_core/core.dart';

class ExportOptions extends Equatable {
  const ExportOptions({
    required this.languages,
    this.keyStyle = TranslationKeyStyle.nested,
    this.separateFirstLevelKeyIntoFiles = false,
    this.useLanguageCodeAsFolderName = false,
  });

  final List<Language> languages;
  final TranslationKeyStyle keyStyle;
  final bool separateFirstLevelKeyIntoFiles;
  final bool useLanguageCodeAsFolderName;

  @override
  List<Object?> get props => [
        languages,
        keyStyle,
        separateFirstLevelKeyIntoFiles,
        useLanguageCodeAsFolderName,
      ];
}
