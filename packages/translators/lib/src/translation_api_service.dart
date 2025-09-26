import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:ttpolyglot_core/core.dart';

/// 取消令牌，用于中止翻译请求
class CancelToken {
  CancelToken();

  bool _isCancelled = false;
  final Completer<void> _completer = Completer<void>();

  /// 是否已取消
  bool get isCancelled => _isCancelled;

  /// 取消future，当取消时会完成
  Future<void> get whenCancelled => _completer.future;

  /// 取消操作
  void cancel() {
    if (!_isCancelled) {
      _isCancelled = true;
      if (!_completer.isCompleted) {
        _completer.complete();
      }
    }
  }

  /// 检查是否被取消，如果被取消则抛出异常
  void throwIfCancelled() {
    if (_isCancelled) {
      throw CancelException('翻译请求已被取消');
    }
  }
}

/// 取消异常
class CancelException implements Exception {
  const CancelException(this.message);
  final String message;

  @override
  String toString() => 'CancelException: $message';
}

/// 翻译API服务
class TranslationApiService {
  /// 翻译文本
  static Future<TranslationResult> translateText({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    required TranslationProviderConfig config,
    String? context,
    CancelToken? cancelToken,
  }) async {
    try {
      // 检查是否已被取消
      cancelToken?.throwIfCancelled();

      switch (config.provider) {
        case TranslationProvider.baidu:
          return await _translateWithBaidu(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
            cancelToken: cancelToken,
          );
        case TranslationProvider.youdao:
          return await _translateWithYoudao(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
            cancelToken: cancelToken,
          );
        case TranslationProvider.google:
          return await _translateWithGoogle(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
            cancelToken: cancelToken,
          );
        case TranslationProvider.custom:
          return await _translateWithCustom(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
            cancelToken: cancelToken,
          );
      }
    } catch (error, stackTrace) {
      log('翻译失败', error: error, stackTrace: stackTrace, name: 'TranslationApiService');
      return TranslationResult(
        success: false,
        translatedText: '',
        error: error.toString(),
      );
    }
  }

  /// 批量翻译文本
  /// 支持将多个文本翻译到多个目标语言
  static Future<BatchTranslationResult> translateBatchTexts({
    required String sourceText,
    required Language sourceLanguage,
    required List<Language> targetLanguages,
    required TranslationProviderConfig config,
    String? context,
    CancelToken? cancelToken,
  }) async {
    try {
      // 检查是否已被取消
      cancelToken?.throwIfCancelled();

      // 对于自定义翻译提供商，使用专门的批量翻译方法
      if (config.provider == TranslationProvider.custom) {
        return await _translateBatchWithCustom(
          sourceText: sourceText,
          sourceLanguage: sourceLanguage,
          targetLanguages: targetLanguages,
          config: config,
          cancelToken: cancelToken,
        );
      }

      // 对于其他翻译提供商，逐个翻译
      final List<Future<TranslationResult>> translationFutures = [];
      for (final targetLanguage in targetLanguages) {
        // 在添加每个翻译任务前检查是否被取消
        cancelToken?.throwIfCancelled();

        translationFutures.add(
          translateText(
            text: sourceText,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
            cancelToken: cancelToken,
          ),
        );
      }

      // 并行执行所有翻译任务
      final results = await Future.wait(translationFutures);

      final items = <TranslationItem>[];
      for (int i = 0; i < targetLanguages.length; i++) {
        final targetLanguage = targetLanguages[i];
        final result = i < results.length ? results[i] : null;

        items.add(
          TranslationItem(
            originalText: sourceText,
            targetLanguage: targetLanguage,
            translatedText: result?.translatedText ?? '',
            success: result?.success ?? false,
            error: result?.error ?? '翻译请求失败',
          ),
        );
      }

      return BatchTranslationResult(
        success: results.every((result) => result.success),
        items: items,
        sourceLanguage: sourceLanguage,
      );
    } catch (error, stackTrace) {
      log('批量翻译失败', error: error, stackTrace: stackTrace, name: 'TranslationApiService');

      // 返回失败的结果，所有项目都标记为失败
      final failedItems = <TranslationItem>[];
      for (final targetLanguage in targetLanguages) {
        failedItems.add(
          TranslationItem(
            originalText: sourceText,
            translatedText: '',
            targetLanguage: targetLanguage,
            success: false,
            error: error.toString(),
          ),
        );
      }

      return BatchTranslationResult(
        success: false,
        items: failedItems,
        sourceLanguage: sourceLanguage,
        error: error.toString(),
      );
    }
  }

  /// 百度翻译API
  static Future<TranslationResult> _translateWithBaidu({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    required TranslationProviderConfig config,
    String? context,
    CancelToken? cancelToken,
  }) async {
    try {
      // 检查是否已被取消
      cancelToken?.throwIfCancelled();

      final appId = config.appId;
      final appKey = config.appKey;
      final salt = DateTime.now().millisecondsSinceEpoch.toString();
      final sign = _generateBaiduSign(appId, text, salt, appKey);

      // 再次检查是否已被取消
      cancelToken?.throwIfCancelled();

      final requestBody = {
        'q': text,
        'from': _convertLanguageCode(sourceLanguage.code, TranslationProvider.baidu),
        'to': _convertLanguageCode(targetLanguage.code, TranslationProvider.baidu),
        'appid': appId,
        'salt': salt,
        'sign': sign,
      };

      final response = await _makeHttpRequest(
        url: 'https://fanyi-api.baidu.com/api/trans/vip/translate',
        method: 'POST',
        body: requestBody,
        timeout: const Duration(seconds: 30),
        cancelToken: cancelToken,
      );

      if (response['error_code'] != null) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '百度翻译错误: ${response['error_msg']}',
        );
      }

      final result = response['trans_result'] as List?;
      if (result == null || result.isEmpty) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '翻译结果为空',
        );
      }

      final translatedText = result.first['dst'] as String? ?? '';
      return TranslationResult(
        success: true,
        translatedText: translatedText,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } catch (error, stackTrace) {
      log('百度翻译失败', error: error, stackTrace: stackTrace, name: 'TranslationApiService');
      return TranslationResult(
        success: false,
        translatedText: '',
        error: '百度翻译请求失败: $error',
      );
    }
  }

  /// 有道翻译API
  static Future<TranslationResult> _translateWithYoudao({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    required TranslationProviderConfig config,
    String? context,
    CancelToken? cancelToken,
  }) async {
    try {
      // 检查是否已被取消
      cancelToken?.throwIfCancelled();

      final appId = config.appId;
      final appKey = config.appKey;
      final salt = DateTime.now().millisecondsSinceEpoch.toString();
      final sign = _generateYoudaoSign(appId, text, salt, appKey);

      // 再次检查是否已被取消
      cancelToken?.throwIfCancelled();

      final requestBody = {
        'q': text,
        'from': _convertLanguageCode(sourceLanguage.code, TranslationProvider.youdao),
        'to': _convertLanguageCode(targetLanguage.code, TranslationProvider.youdao),
        'appKey': appId,
        'salt': salt,
        'sign': sign,
        'signType': 'v3',
        'curtime': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      };

      final response = await _makeHttpRequest(
        url: 'https://openapi.youdao.com/api',
        method: 'POST',
        body: requestBody,
        timeout: const Duration(seconds: 30),
        cancelToken: cancelToken,
      );

      if (response['errorCode'] != '0') {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '有道翻译错误: ${response['errorCode']}',
        );
      }

      final result = response['translation'] as List?;
      if (result == null || result.isEmpty) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '翻译结果为空',
        );
      }

      final translatedText = result.first as String? ?? '';
      return TranslationResult(
        success: true,
        translatedText: translatedText,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } catch (error, stackTrace) {
      log('有道翻译失败', error: error, stackTrace: stackTrace, name: 'TranslationApiService');
      return TranslationResult(
        success: false,
        translatedText: '',
        error: '有道翻译请求失败: $error',
      );
    }
  }

  /// 谷歌翻译API（使用免费接口）
  static Future<TranslationResult> _translateWithGoogle({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    required TranslationProviderConfig config,
    String? context,
    CancelToken? cancelToken,
  }) async {
    try {
      // 检查是否已被取消
      cancelToken?.throwIfCancelled();

      final url = 'https://translate.googleapis.com/translate_a/single?'
          'client=gtx&'
          'sl=${_convertLanguageCode(sourceLanguage.code, TranslationProvider.google)}&'
          'tl=${_convertLanguageCode(targetLanguage.code, TranslationProvider.google)}&'
          'dt=t&q=${Uri.encodeComponent(text)}';

      final response = await _makeHttpRequest(
        url: url,
        method: 'GET',
        timeout: const Duration(seconds: 30),
        cancelToken: cancelToken,
      );

      if (response is List && response.isNotEmpty) {
        final result = response.first as List?;
        if (result != null && result.isNotEmpty) {
          final translatedText = result.first.first as String? ?? '';
          return TranslationResult(
            success: true,
            translatedText: translatedText,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
          );
        }
      }

      return TranslationResult(
        success: false,
        translatedText: '',
        error: '翻译结果为空',
      );
    } catch (error, stackTrace) {
      log('谷歌翻译失败', error: error, stackTrace: stackTrace, name: 'TranslationApiService');
      return TranslationResult(
        success: false,
        translatedText: '',
        error: '谷歌翻译请求失败: $error',
      );
    }
  }

  /// 自定义翻译API
  static Future<TranslationResult> _translateWithCustom({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    required TranslationProviderConfig config,
    String? context,
    CancelToken? cancelToken,
  }) async {
    try {
      // 检查是否已被取消
      cancelToken?.throwIfCancelled();

      if (config.apiUrl == null || config.apiUrl!.isEmpty) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '自定义翻译API地址未配置',
        );
      }

      // 再次检查是否已被取消
      cancelToken?.throwIfCancelled();

      final requestBody = {
        'text': text,
        'source_language': sourceLanguage.code,
        'target_language': targetLanguage.code,
        'context': context,
      };

      final response = await _makeHttpRequest(
        url: config.apiUrl!,
        method: 'POST',
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
          if (config.appId.isNotEmpty) 'appId': config.appId,
          if (config.appKey.isNotEmpty) 'Authorization': 'Bearer ${config.appKey}',
        },
        timeout: const Duration(seconds: 30),
        cancelToken: cancelToken,
      );

      // 自定义API的响应格式需要根据实际API文档调整
      final translatedText = response['translated_text'] as String? ?? '';
      if (translatedText.isEmpty) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '翻译结果为空',
        );
      }

      return TranslationResult(
        success: true,
        translatedText: translatedText,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } catch (error, stackTrace) {
      log('自定义翻译失败', error: error, stackTrace: stackTrace, name: 'TranslationApiService');
      return TranslationResult(
        success: false,
        translatedText: '',
        error: '自定义翻译请求失败: $error',
      );
    }
  }

  /// 生成百度翻译签名
  static String _generateBaiduSign(String appId, String text, String salt, String appKey) {
    final input = appId + text + salt + appKey;
    return _md5(input);
  }

  /// 生成有道翻译签名
  static String _generateYoudaoSign(String appId, String text, String salt, String appKey) {
    final input = appId + text + salt + appKey;
    return _sha256(input);
  }

  /// 转换语言代码
  static String _convertLanguageCode(String languageCode, TranslationProvider provider) {
    switch (provider) {
      case TranslationProvider.baidu:
        return _convertToBaiduLanguageCode(languageCode);
      case TranslationProvider.youdao:
        return _convertToYoudaoLanguageCode(languageCode);
      case TranslationProvider.google:
        return _convertToGoogleLanguageCode(languageCode);
      case TranslationProvider.custom:
        return _convertToCustomLanguageCode(languageCode);
    }
  }

  /// 转换为百度语言代码
  static String _convertToBaiduLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'zh-CN':
        return 'zh';
      case 'zh-TW':
        return 'cht';
      case 'zh-HK':
        return 'zh-HK';
      case 'en-US':
        return 'en';
      case 'ja-JP':
        return 'jp';
      case 'ko-KR':
        return 'kor';
      case 'fr-FR':
        return 'fra';
      case 'de-DE':
        return 'de';
      case 'es-ES':
        return 'spa';
      case 'ru-RU':
        return 'ru';
      case 'it-IT':
        return 'it';
      case 'pt-PT':
        return 'pt';
      default:
        return 'auto';
    }
  }

  /// 转换为有道语言代码
  static String _convertToYoudaoLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'zh-CN':
        return 'zh-CHS';
      case 'zh-TW':
        return 'zh-CHT';
      case 'zh-HK':
        return 'zh-HK';
      case 'en-US':
        return 'en';
      case 'ja-JP':
        return 'ja';
      case 'ko-KR':
        return 'ko';
      case 'fr-FR':
        return 'fr';
      case 'de-DE':
        return 'de';
      case 'es-ES':
        return 'es';
      case 'ru-RU':
        return 'ru';
      case 'it-IT':
        return 'it';
      case 'pt-PT':
        return 'pt';
      default:
        return 'auto';
    }
  }

  /// 转换为谷歌语言代码
  static String _convertToGoogleLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'zh-CN':
        return 'zh-cn';
      case 'zh-TW':
        return 'zh_tw';
      case 'zh-HK':
        return 'zh_hk';
      case 'en-US':
        return 'en';
      case 'ja-JP':
        return 'ja';
      case 'ko-KR':
        return 'ko';
      case 'fr-FR':
        return 'fr';
      case 'de-DE':
        return 'de';
      case 'es-ES':
        return 'es';
      case 'ru-RU':
        return 'ru';
      case 'it-IT':
        return 'it';
      case 'pt-PT':
        return 'pt';
      default:
        return 'auto';
    }
  }

  /// 转换为自定义API语言代码
  static String _convertToCustomLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'zh-CN':
        return 'zh';
      case 'zh-TW':
        return 'zhtw';
      case 'en-US':
        return 'en';
      case 'ja-JP':
        return 'ja';
      case 'ko-KR':
        return 'ko';
      case 'fr-FR':
        return 'fr';
      case 'de-DE':
        return 'de';
      case 'es-ES':
        return 'es';
      case 'ru-RU':
        return 'ru';
      case 'it-IT':
        return 'it';
      case 'pt-PT':
        return 'pt';
      default:
        return languageCode.toLowerCase();
    }
  }

  /// 发起HTTP请求
  static Future<dynamic> _makeHttpRequest({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
    CancelToken? cancelToken,
  }) async {
    final client = HttpClient();
    HttpClientRequest? request;

    try {
      // 检查是否已被取消
      cancelToken?.throwIfCancelled();

      request = await client.openUrl(method, Uri.parse(url));

      // 设置超时
      if (timeout != null) {
        // HttpClientRequest 没有直接的 timeout 属性，这里跳过超时设置
        // 实际项目中可以使用 Timer 或其他方式实现超时
      }

      // 设置请求头
      request.headers.set('User-Agent', 'TTPolyglot/1.0');
      headers?.forEach((key, value) {
        request?.headers.set(key, value);
      });

      // 设置请求体
      if (body != null) {
        if (method == 'POST') {
          final jsonBody = jsonEncode(body);
          request.headers.set('Content-Type', 'application/json; charset=UTF-8');
          request.headers.set('Content-Length', utf8.encode(jsonBody).length.toString());
          request.add(utf8.encode(jsonBody));
        }
      }

      // 再次检查是否已被取消
      cancelToken?.throwIfCancelled();

      // 如果有取消令牌，使用 Future.any 来实现取消机制
      late Future<HttpClientResponse> responseFuture;

      if (cancelToken != null) {
        responseFuture = Future.any([
          request.close(),
          cancelToken.whenCancelled.then<HttpClientResponse>((_) {
            // 如果被取消，中止请求
            request?.abort();
            throw CancelException('请求已被取消');
          }),
        ]);
      } else {
        responseFuture = request.close();
      }

      final response = await responseFuture;

      // 检查是否在读取响应时被取消
      cancelToken?.throwIfCancelled();

      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('HTTP ${response.statusCode}: $responseBody');
      }
    } catch (error) {
      // 如果是取消异常，直接重新抛出
      if (error is CancelException) {
        rethrow;
      }
      // 其他异常继续抛出
      rethrow;
    } finally {
      client.close();
    }
  }

  /// MD5哈希
  static String _md5(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// SHA256哈希
  static String _sha256(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 自定义翻译API批量翻译（内部方法）
  static Future<BatchTranslationResult> _translateBatchWithCustom({
    required String sourceText,
    required Language sourceLanguage,
    required List<Language> targetLanguages,
    required TranslationProviderConfig config,
    CancelToken? cancelToken,
  }) async {
    try {
      // 检查是否已被取消
      cancelToken?.throwIfCancelled();

      final apiUrl = config.apiUrl;
      if (apiUrl == null || apiUrl.isEmpty) {
        return BatchTranslationResult(
          success: false,
          items: _createFailedItems(sourceText, targetLanguages, '自定义翻译API地址未配置'),
          sourceLanguage: sourceLanguage,
          error: '自定义翻译API地址未配置',
        );
      }

      // 再次检查是否已被取消
      cancelToken?.throwIfCancelled();

      final targetLanguageCode =
          targetLanguages.map((language) => _convertToCustomLanguageCode(language.code)).toList();

      // 按照curl命令构建请求体
      final requestBody = {
        'data': targetLanguages
            .map((targetLanguage) => {
                  'lang': _convertToCustomLanguageCode(targetLanguage.code),
                  'content': sourceText,
                })
            .toList(),
        'force_trans': true, // 是否强制翻译
        'trans': targetLanguageCode,
      };

      // 按照curl命令设置请求头
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      // 如果配置了appId或appKey，可以添加到请求头中
      if (config.appId.isNotEmpty) {
        headers['appId'] = config.appId;
      }
      if (config.appKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${config.appKey}';
      }

      final response = await _makeHttpRequest(
        url: apiUrl,
        method: 'POST',
        body: requestBody,
        headers: headers,
        timeout: const Duration(seconds: 30),
        cancelToken: cancelToken,
      );

      // 解析响应结果
      if (response is Map) {
        // 检查是否有错误码
        final code = response['code'];
        if (code != null && code != 200) {
          final message = response['message'] as String? ?? '未知错误';
          return BatchTranslationResult(
            success: false,
            items: _createFailedItems(sourceText, targetLanguages, '翻译API错误 [$code]: $message'),
            sourceLanguage: sourceLanguage,
            error: '翻译API错误 [$code]: $message',
          );
        }

        // 处理响应数据
        final data = response['data'];
        if (data is List && data.isNotEmpty) {
          final items = _parseCustomBatchResponse(data, sourceText, targetLanguages);
          final allSuccessful = items.every((item) => item.success);

          return BatchTranslationResult(
            success: allSuccessful,
            items: items,
            sourceLanguage: sourceLanguage,
          );
        }
      }

      return BatchTranslationResult(
        success: false,
        items: _createFailedItems(sourceText, targetLanguages, '翻译结果为空或响应格式不正确'),
        sourceLanguage: sourceLanguage,
        error: '翻译结果为空或响应格式不正确',
      );
    } catch (error, stackTrace) {
      log('自定义批量翻译失败', error: error, stackTrace: stackTrace, name: 'TranslationApiService');
      return BatchTranslationResult(
        success: false,
        items: _createFailedItems(sourceText, targetLanguages, error.toString()),
        sourceLanguage: sourceLanguage,
        error: error.toString(),
      );
    }
  }

  /// 解析自定义API批量翻译响应
  static List<TranslationItem> _parseCustomBatchResponse(
    List<dynamic> responseData,
    String originalText,
    List<Language> targetLanguages,
  ) {
    final items = <TranslationItem>[];

    for (final targetLanguage in targetLanguages) {
      final targetCode = _convertToCustomLanguageCode(targetLanguage.code);

      String translatedText = '';
      bool success = false;
      String? error;

      try {
        // 尝试从响应数据中获取翻译结果
        if (responseData.isNotEmpty) {
          final itemData = responseData[0] as Map?;
          if (itemData != null && itemData.containsKey(targetCode)) {
            translatedText = itemData[targetCode] as String? ?? '';
            success = translatedText.isNotEmpty;
          } else {
            error = '响应数据中缺少目标语言 [$targetCode] 的翻译结果';
          }
        } else {
          error = '响应数据长度不匹配';
        }
      } catch (e) {
        error = '解析翻译结果失败: $e';
      }

      items.add(TranslationItem(
        originalText: originalText,
        translatedText: translatedText,
        targetLanguage: targetLanguage,
        success: success,
        error: error,
      ));
    }

    return items;
  }

  /// 创建失败的翻译项列表
  static List<TranslationItem> _createFailedItems(
    String sourceText,
    List<Language> targetLanguages,
    String error,
  ) {
    final items = <TranslationItem>[];

    for (final targetLanguage in targetLanguages) {
      items.add(TranslationItem(
        originalText: sourceText,
        translatedText: '',
        targetLanguage: targetLanguage,
        success: false,
        error: error,
      ));
    }

    return items;
  }
}

/// 翻译结果
class TranslationResult {
  const TranslationResult({
    required this.success,
    required this.translatedText,
    this.sourceLanguage,
    this.targetLanguage,
    this.error,
  });

  /// 是否成功
  final bool success;

  /// 翻译后的文本
  final String translatedText;

  /// 源语言
  final Language? sourceLanguage;

  /// 目标语言
  final Language? targetLanguage;

  /// 错误信息
  final String? error;
}

/// 单个翻译项结果
class TranslationItem {
  const TranslationItem({
    required this.originalText,
    required this.translatedText,
    required this.targetLanguage,
    required this.success,
    this.error,
  });

  /// 原文
  final String originalText;

  /// 译文
  final String translatedText;

  /// 目标语言
  final Language targetLanguage;

  /// 是否成功
  final bool success;

  /// 错误信息
  final String? error;
}

/// 批量翻译结果
class BatchTranslationResult {
  const BatchTranslationResult({
    required this.success,
    required this.items,
    this.sourceLanguage,
    this.error,
  });

  /// 整体是否成功
  final bool success;

  /// 翻译项列表
  final List<TranslationItem> items;

  /// 源语言
  final Language? sourceLanguage;

  /// 整体错误信息（如果有）
  final String? error;

  /// 获取成功翻译的数量
  int get successfulTranslations => items.where((item) => item.success).length;

  /// 获取失败翻译的数量
  int get failedTranslations => items.where((item) => !item.success).length;

  /// 获取所有成功翻译的文本
  List<String> get successfulTranslatedTexts =>
      items.where((item) => item.success).map((item) => item.translatedText).toList();

  /// 获取所有失败翻译的项目
  List<TranslationItem> get failedItems => items.where((item) => !item.success).toList();
}
