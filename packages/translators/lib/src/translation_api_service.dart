import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:ttpolyglot_core/core.dart';

/// 翻译API服务
class TranslationApiService {
  /// 翻译文本
  static Future<TranslationResult> translateText({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    required TranslationProviderConfig config,
    String? context,
  }) async {
    try {
      switch (config.provider) {
        case TranslationProvider.baidu:
          return await _translateWithBaidu(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
          );
        case TranslationProvider.youdao:
          return await _translateWithYoudao(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
          );
        case TranslationProvider.google:
          return await _translateWithGoogle(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
          );
        case TranslationProvider.custom:
          return await _translateWithCustom(
            text: text,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            config: config,
            context: context,
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

  /// 百度翻译API
  static Future<TranslationResult> _translateWithBaidu({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    required TranslationProviderConfig config,
    String? context,
  }) async {
    try {
      final appId = config.appId;
      final appKey = config.appKey;
      final salt = DateTime.now().millisecondsSinceEpoch.toString();
      final sign = _generateBaiduSign(appId, text, salt, appKey);

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
  }) async {
    try {
      final appId = config.appId;
      final appKey = config.appKey;
      final salt = DateTime.now().millisecondsSinceEpoch.toString();
      final sign = _generateYoudaoSign(appId, text, salt, appKey);

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
  }) async {
    try {
      final url = 'https://translate.googleapis.com/translate_a/single?'
          'client=gtx&'
          'sl=${_convertLanguageCode(sourceLanguage.code, TranslationProvider.google)}&'
          'tl=${_convertLanguageCode(targetLanguage.code, TranslationProvider.google)}&'
          'dt=t&q=${Uri.encodeComponent(text)}';

      final response = await _makeHttpRequest(
        url: url,
        method: 'GET',
        timeout: const Duration(seconds: 30),
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
  }) async {
    try {
      if (config.apiUrl == null || config.apiUrl!.isEmpty) {
        return TranslationResult(
          success: false,
          translatedText: '',
          error: '自定义翻译API地址未配置',
        );
      }

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
        return languageCode; // 自定义API使用原始语言代码
    }
  }

  /// 转换为百度语言代码
  static String _convertToBaiduLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'zh-CN':
        return 'zh';
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

  /// 发起HTTP请求
  static Future<dynamic> _makeHttpRequest({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.openUrl(method, Uri.parse(url));

      // 设置超时
      if (timeout != null) {
        // HttpClientRequest 没有直接的 timeout 属性，这里跳过超时设置
        // 实际项目中可以使用 Timer 或其他方式实现超时
      }

      // 设置请求头
      request.headers.set('User-Agent', 'TTPolyglot/1.0');
      if (headers != null) {
        headers.forEach((key, value) {
          request.headers.set(key, value);
        });
      }

      // 设置请求体
      if (body != null) {
        if (method == 'POST') {
          final jsonBody = jsonEncode(body);
          request.headers.set('Content-Type', 'application/json');
          request.headers.set('Content-Length', jsonBody.length.toString());
          request.write(jsonBody);
        }
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('HTTP ${response.statusCode}: $responseBody');
      }
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
