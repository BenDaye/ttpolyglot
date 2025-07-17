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
