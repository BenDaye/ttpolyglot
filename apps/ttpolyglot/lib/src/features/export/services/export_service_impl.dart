import 'package:ttpolyglot/src/core/platform/platform_adapter.dart';
import 'package:ttpolyglot/src/features/export/export.dart';
import 'package:ttpolyglot_core/core.dart';

class ExportServiceImpl implements ExportService {
  static ExportServiceImpl? _instance;
  late final PlatformAdapter _platformAdapter;

  ExportServiceImpl._internal() {
    _platformAdapter = PlatformAdapter();
  }

  factory ExportServiceImpl() {
    return _instance ??= ExportServiceImpl._internal();
  }

  @override
  Future<bool> exportTranslationsShortcutJson({
    required Project project,
    required List<TranslationEntry> entries,
  }) async {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
        return await ExportServiceImplDesktop.exportTranslationsShortcutJson(
          project: project,
          entries: entries,
        );
      case PlatformType.web:
      case PlatformType.mobile:
      case PlatformType.unknown:
        throw UnimplementedError();
    }
  }

  @override
  Future<bool> exportTranslationsShortcutYaml({
    required Project project,
    required List<TranslationEntry> entries,
  }) async {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
      case PlatformType.web:
      case PlatformType.mobile:
      case PlatformType.unknown:
        throw UnimplementedError();
    }
  }

  @override
  Future<bool> exportTranslationsShortcutCsv({
    required Project project,
    required List<TranslationEntry> entries,
  }) async {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
      case PlatformType.web:
      case PlatformType.mobile:
      case PlatformType.unknown:
        throw UnimplementedError();
    }
  }

  @override
  Future<bool> exportTranslationsShortcutArb({
    required Project project,
    required List<TranslationEntry> entries,
  }) async {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
      case PlatformType.web:
      case PlatformType.mobile:
      case PlatformType.unknown:
        throw UnimplementedError();
    }
  }

  @override
  Future<bool> exportTranslationsShortcutProperties({
    required Project project,
    required List<TranslationEntry> entries,
  }) async {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
      case PlatformType.web:
      case PlatformType.mobile:
      case PlatformType.unknown:
        throw UnimplementedError();
    }
  }

  @override
  Future<bool> exportTranslationsShortcutPo({
    required Project project,
    required List<TranslationEntry> entries,
  }) async {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
      case PlatformType.web:
      case PlatformType.mobile:
      case PlatformType.unknown:
        throw UnimplementedError();
    }
  }
}
