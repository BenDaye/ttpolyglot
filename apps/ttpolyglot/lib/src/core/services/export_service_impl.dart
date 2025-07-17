import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/platform/platform_adapter.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot_core/core.dart';

class ExportServiceImpl extends GetxService implements ExportService {
  final PlatformAdapter _platformAdapter;

  ExportServiceImpl(this._platformAdapter);

  static Future<ExportServiceImpl> create() async {
    try {
      final platformAdapter = PlatformAdapter();
      return ExportServiceImpl(platformAdapter);
    } catch (error, stackTrace) {
      log('创建导出服务失败', error: error, stackTrace: stackTrace, name: 'ExportServiceImpl');
      rethrow;
    }
  }

  @override
  Future<bool> exportTranslationsJson({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.nested,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
  }) async {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
        return await ExportServiceImplDesktop.exportTranslationsJson(
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
  Future<bool> exportTranslationsYaml({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.nested,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
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
  Future<bool> exportTranslationsCsv({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.flat,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
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
  Future<bool> exportTranslationsArb({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.nested,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
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
  Future<bool> exportTranslationsProperties({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.flat,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
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
  Future<bool> exportTranslationsPo({
    required Project project,
    required List<TranslationEntry> entries,
    ExportOptions options = const ExportOptions(
      languages: [],
      keyStyle: TranslationKeyStyle.flat,
      separateFirstLevelKeyIntoFiles: false,
      useLanguageCodeAsFolderName: false,
    ),
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
