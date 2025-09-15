# 翻译服务使用指南

## 概述

TTPolyglot 现在集成了完整的翻译服务功能，支持多种翻译接口，包括百度翻译、有道翻译、谷歌翻译和自定义翻译接口。

## 功能特性

### 1. 多翻译接口支持
- **百度翻译**: 支持中英文等多种语言互译
- **有道翻译**: 提供高质量的翻译服务
- **谷歌翻译**: 免费翻译接口
- **自定义翻译**: 支持自定义API接口

### 2. 智能语言选择
- 自动检测可用的源语言
- 多语言时提供选择弹窗
- 支持语言代码转换

### 3. 批量翻译
- 支持单个翻译条目翻译
- 支持批量翻译多个条目
- 自动处理翻译结果和错误

### 4. 配置管理
- 翻译接口配置检查
- 配置不完整时自动提示
- 支持多个翻译接口配置

## 使用方法

### 1. 配置翻译接口

首先需要在设置页面配置翻译接口：

1. 打开应用设置页面
2. 找到"翻译设置"部分
3. 点击"添加翻译接口"
4. 选择翻译提供商（百度、有道、谷歌或自定义）
5. 填写相应的API密钥和配置信息
6. 启用翻译接口

### 2. 使用翻译功能

在翻译管理页面：

1. 找到需要翻译的翻译键
2. 点击翻译按钮（翻译图标）
3. 如果有多个源语言，选择要翻译的源语言
4. 系统会自动调用配置的翻译接口进行翻译
5. 翻译完成后会显示结果统计

### 3. 翻译结果处理

- **成功翻译**: 自动更新翻译条目状态为"已完成"
- **翻译失败**: 显示错误详情，可查看具体失败原因
- **批量翻译**: 显示成功和失败的统计信息

## 技术架构

### 核心组件

1. **TranslationApiService**: 翻译API调用服务
   - 处理不同翻译接口的API调用
   - 统一翻译结果格式
   - 错误处理和重试机制

2. **TranslationServiceManager**: 翻译服务管理器
   - 统一管理翻译配置
   - 提供翻译服务接口
   - 配置检查和验证

3. **LanguageSelectionDialog**: 语言选择弹窗
   - 提供友好的语言选择界面
   - 支持多语言选择
   - 自动语言匹配

### 文件结构

```
lib/src/
├── core/services/
│   ├── translation_api_service.dart      # 翻译API服务
│   └── translation_service_manager.dart  # 翻译服务管理器
├── features/translation/
│   ├── widgets/
│   │   ├── language_selection_dialog.dart # 语言选择弹窗
│   │   └── translation_widgets.dart      # 翻译组件导出
│   └── views/
│       └── translations_card_key.dart    # 翻译卡片（集成翻译功能）
└── features/settings/
    ├── controllers/
    │   └── translation_config_controller.dart # 翻译配置控制器
    └── models/
        └── translation_provider.dart     # 翻译提供商模型
```

## 配置示例

### 百度翻译配置
```dart
TranslationProviderConfig(
  provider: TranslationProvider.baidu,
  appId: 'your_app_id',
  appKey: 'your_app_key',
  isEnabled: true,
  isDefault: true,
)
```

### 有道翻译配置
```dart
TranslationProviderConfig(
  provider: TranslationProvider.youdao,
  appId: 'your_app_id',
  appKey: 'your_app_key',
  isEnabled: true,
)
```

### 自定义翻译配置
```dart
TranslationProviderConfig(
  provider: TranslationProvider.custom,
  appId: 'your_auth_token',
  appKey: 'your_auth_key',
  apiUrl: 'https://your-api.com/translate',
  isEnabled: true,
)
```

## 错误处理

### 常见错误类型

1. **配置错误**: 翻译接口未配置或配置不完整
   - 解决方案: 前往设置页面配置翻译接口

2. **API错误**: 翻译接口返回错误
   - 解决方案: 检查API密钥是否正确，网络是否正常

3. **网络错误**: 网络连接问题
   - 解决方案: 检查网络连接，稍后重试

4. **语言不支持**: 翻译接口不支持该语言对
   - 解决方案: 尝试使用其他翻译接口

### 错误提示

系统会通过以下方式提示错误：
- 弹窗提示配置问题
- SnackBar显示翻译结果
- 详细错误对话框显示失败原因

## 最佳实践

### 1. 翻译接口配置
- 建议配置多个翻译接口作为备选
- 设置一个默认翻译接口
- 定期检查API密钥的有效性

### 2. 翻译使用
- 批量翻译时注意API调用频率限制
- 对于重要内容，建议人工审核翻译结果
- 利用上下文信息提高翻译质量

### 3. 错误处理
- 遇到翻译失败时，检查错误信息
- 可以尝试使用不同的翻译接口
- 对于网络问题，可以稍后重试

## 扩展开发

### 添加新的翻译接口

1. 在 `TranslationProvider` 枚举中添加新的提供商
2. 在 `TranslationApiService` 中实现对应的翻译方法
3. 更新语言代码转换逻辑
4. 在设置界面添加相应的配置选项

### 自定义翻译逻辑

可以通过继承 `TranslationServiceManager` 类来自定义翻译逻辑：

```dart
class CustomTranslationManager extends TranslationServiceManager {
  @override
  Future<TranslationResult> translateText({
    required String text,
    required Language sourceLanguage,
    required Language targetLanguage,
    TranslationProviderConfig? provider,
    String? context,
  }) async {
    // 自定义翻译逻辑
    return super.translateText(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      provider: provider,
      context: context,
    );
  }
}
```

## 注意事项

1. **API限制**: 不同翻译接口有不同的调用频率限制
2. **费用**: 部分翻译接口可能产生费用，请注意使用量
3. **隐私**: 翻译内容会发送到第三方服务，请注意隐私保护
4. **准确性**: 机器翻译结果仅供参考，重要内容建议人工审核

## 更新日志

- **v1.0.0**: 初始版本，支持百度、有道、谷歌翻译接口
- 支持批量翻译和错误处理
- 集成语言选择弹窗
- 完整的配置管理系统
