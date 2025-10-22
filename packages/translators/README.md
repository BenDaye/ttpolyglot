# TTPolyglot Translators

TTPolyglot 翻译服务集成包，为 TTPolyglot 提供多种翻译 API 服务商的统一接口。

## 特性

- 🌐 **多服务商支持**：集成百度翻译、有道翻译、谷歌翻译和自定义翻译 API
- 📦 **批量翻译**：支持一次性将文本翻译到多个目标语言
- 🚫 **可取消操作**：使用 `CancelToken` 支持中止翻译请求
- 🔄 **语言代码转换**：自动处理不同服务商的语言代码格式差异
- 🔐 **自动签名**：自动生成百度和有道翻译所需的签名认证
- ⚡ **并行处理**：批量翻译时自动并行执行提升性能

## 支持的翻译服务商

| 服务商 | 类型 | 说明 |
|--------|------|------|
| 百度翻译 | `TranslationProvider.baidu` | 需要 appId 和 appKey |
| 有道翻译 | `TranslationProvider.youdao` | 需要 appId 和 appKey |
| 谷歌翻译 | `TranslationProvider.google` | 使用免费接口，无需配置 |
| 自定义 API | `TranslationProvider.custom` | 支持自定义翻译服务 |

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  ttpolyglot_translators: ^1.0.0
```

## 使用方法

### 基本用法 - 单个文本翻译

```dart
import 'package:ttpolyglot_translators/translators.dart';
import 'package:ttpolyglot_core/core.dart';

// 配置翻译服务
final config = TranslationProviderConfig(
  provider: TranslationProvider.baidu,
  appId: 'your_app_id',
  appKey: 'your_app_key',
);

// 翻译文本
final result = await TranslationApiService.translateText(
  text: 'Hello World',
  sourceLanguage: Language(code: 'en-US', name: 'English'),
  targetLanguage: Language(code: 'zh-CN', name: '简体中文'),
  config: config,
);

if (result.success) {
  print('翻译结果: ${result.translatedText}');
} else {
  print('翻译失败: ${result.error}');
}
```

### 批量翻译到多个语言

```dart
// 一次性翻译到多个目标语言
final batchResult = await TranslationApiService.translateBatchTexts(
  sourceText: 'Hello World',
  sourceLanguage: Language(code: 'en-US', name: 'English'),
  targetLanguages: [
    Language(code: 'zh-CN', name: '简体中文'),
    Language(code: 'ja-JP', name: '日语'),
    Language(code: 'ko-KR', name: '韩语'),
  ],
  config: config,
);

if (batchResult.success) {
  for (final item in batchResult.items) {
    if (item.success) {
      print('${item.targetLanguage.name}: ${item.translatedText}');
    }
  }
  
  print('成功: ${batchResult.successfulTranslations}');
  print('失败: ${batchResult.failedTranslations}');
}
```

### 使用取消令牌

```dart
// 创建取消令牌
final cancelToken = CancelToken();

// 开始翻译
final future = TranslationApiService.translateText(
  text: 'Hello World',
  sourceLanguage: Language(code: 'en-US', name: 'English'),
  targetLanguage: Language(code: 'zh-CN', name: '简体中文'),
  config: config,
  cancelToken: cancelToken,
);

// 在需要时取消翻译
cancelToken.cancel();

try {
  final result = await future;
} on CancelException catch (e) {
  print('翻译已取消: ${e.message}');
}
```

### 谷歌翻译（免费）

```dart
// 谷歌翻译无需 API 密钥
final googleConfig = TranslationProviderConfig(
  provider: TranslationProvider.google,
  appId: '',
  appKey: '',
);

final result = await TranslationApiService.translateText(
  text: 'Hello',
  sourceLanguage: Language(code: 'en-US', name: 'English'),
  targetLanguage: Language(code: 'zh-CN', name: '简体中文'),
  config: googleConfig,
);
```

### 自定义翻译 API

```dart
// 配置自定义翻译服务
final customConfig = TranslationProviderConfig(
  provider: TranslationProvider.custom,
  apiUrl: 'https://your-api.com/translate',
  appId: 'optional_app_id',
  appKey: 'optional_api_key',
);

final result = await TranslationApiService.translateText(
  text: 'Hello',
  sourceLanguage: Language(code: 'en-US', name: 'English'),
  targetLanguage: Language(code: 'zh-CN', name: '简体中文'),
  config: customConfig,
  context: 'Optional context for translation',
);
```

#### 自定义 API 请求格式

单个翻译请求：
```json
{
  "text": "Hello",
  "source_language": "en-US",
  "target_language": "zh-CN",
  "context": "optional context"
}
```

批量翻译请求：
```json
{
  "data": [
    {"lang": "zh", "content": "Hello"},
    {"lang": "ja", "content": "Hello"}
  ],
  "force_trans": true,
  "trans": ["zh", "ja"]
}
```

期望的响应格式：
```json
{
  "code": 200,
  "data": [
    {
      "zh": "你好",
      "ja": "こんにちは"
    }
  ]
}
```

## API 文档

### TranslationApiService

主要的翻译服务类。

#### 方法

##### translateText

翻译单个文本。

```dart
static Future<TranslationResult> translateText({
  required String text,
  required Language sourceLanguage,
  required Language targetLanguage,
  required TranslationProviderConfig config,
  String? context,
  CancelToken? cancelToken,
})
```

**参数：**
- `text`: 要翻译的文本
- `sourceLanguage`: 源语言
- `targetLanguage`: 目标语言
- `config`: 翻译服务配置
- `context`: 翻译上下文（可选）
- `cancelToken`: 取消令牌（可选）

**返回：** `TranslationResult` - 翻译结果

##### translateBatchTexts

批量翻译文本到多个目标语言。

```dart
static Future<BatchTranslationResult> translateBatchTexts({
  required String sourceText,
  required Language sourceLanguage,
  required List<Language> targetLanguages,
  required TranslationProviderConfig config,
  String? context,
  CancelToken? cancelToken,
})
```

**参数：**
- `sourceText`: 要翻译的源文本
- `sourceLanguage`: 源语言
- `targetLanguages`: 目标语言列表
- `config`: 翻译服务配置
- `context`: 翻译上下文（可选）
- `cancelToken`: 取消令牌（可选）

**返回：** `BatchTranslationResult` - 批量翻译结果

### CancelToken

用于取消翻译请求的令牌。

```dart
final cancelToken = CancelToken();
cancelToken.cancel(); // 取消请求
```

### 数据模型

#### TranslationResult

单个翻译结果。

```dart
class TranslationResult {
  final bool success;           // 是否成功
  final String translatedText;  // 翻译后的文本
  final Language? sourceLanguage;
  final Language? targetLanguage;
  final String? error;          // 错误信息
}
```

#### BatchTranslationResult

批量翻译结果。

```dart
class BatchTranslationResult {
  final bool success;                    // 整体是否成功
  final List<TranslationItem> items;     // 翻译项列表
  final Language? sourceLanguage;
  final String? error;
  
  int get successfulTranslations;        // 成功数量
  int get failedTranslations;            // 失败数量
  List<String> get successfulTranslatedTexts;
  List<TranslationItem> get failedItems;
}
```

#### TranslationItem

单个翻译项。

```dart
class TranslationItem {
  final String originalText;     // 原文
  final String translatedText;   // 译文
  final Language targetLanguage; // 目标语言
  final bool success;            // 是否成功
  final String? error;           // 错误信息
}
```

## 支持的语言

支持多种语言的翻译，包括但不限于：

- 简体中文 (zh-CN)
- 繁体中文 (zh-TW)
- 英语 (en-US)
- 日语 (ja-JP)
- 韩语 (ko-KR)
- 法语 (fr-FR)
- 德语 (de-DE)
- 西班牙语 (es-ES)
- 俄语 (ru-RU)
- 意大利语 (it-IT)
- 葡萄牙语 (pt-PT)

不同的翻译服务商会自动转换为相应的语言代码格式。

## 注意事项

1. **API 密钥安全**：请妥善保管您的 API 密钥，不要提交到版本控制系统
2. **频率限制**：各翻译服务商都有调用频率和配额限制，请注意控制调用频率
3. **网络超时**：默认超时时间为 30 秒
4. **谷歌翻译**：使用的是免费接口，稳定性可能不如付费服务
5. **批量翻译**：自定义 API 支持真正的批量翻译，其他服务商会并行执行单次翻译

## 依赖

- `flutter`: Flutter SDK
- `crypto`: 用于生成 MD5 和 SHA256 签名
- `ttpolyglot_core`: TTPolyglot 核心库

## 许可证

本项目采用与 TTPolyglot 主项目相同的许可证。

## 贡献

欢迎提交 Issue 和 Pull Request！

## 相关链接

- [百度翻译 API 文档](https://fanyi-api.baidu.com/doc/21)
- [有道智云翻译 API 文档](https://ai.youdao.com/DOCSIRMA/html/trans/api/wbfy/index.html)
- [Google Translate API](https://cloud.google.com/translate)
