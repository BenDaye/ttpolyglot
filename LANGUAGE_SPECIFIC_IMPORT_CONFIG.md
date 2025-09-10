# 语言特定导入配置功能

## 功能概述

TTPolyglot 现在支持为不同语言设置独立的导入配置，让您可以更精细地控制翻译文件的导入行为。

## 功能特性

### 1. 全局配置
- **覆盖现有翻译**：控制是否覆盖已存在的翻译条目
- **自动审核**：新导入的翻译自动标记为已审核状态
- **忽略空值**：跳过空的翻译内容

### 2. 语言特定配置
为每个目标语言单独设置导入配置：
- 每个语言都可以有独立的导入规则
- 未设置特定配置的语言使用全局配置作为默认值
- 支持一键重置所有语言配置为全局设置

## 使用方法

### 在导入界面中设置

1. **打开项目导入页面**
2. **选择文件并设置语言映射**
3. **配置全局导入选项**（可选）
4. **展开"语言特定配置"部分**
5. **为每个语言单独配置导入选项**
6. **点击"导入"开始导入**

### 配置选项说明

#### 覆盖现有翻译
- **启用**：如果翻译键已存在，会覆盖现有翻译
- **禁用**：保留现有翻译，跳过冲突条目

#### 自动审核
- **启用**：导入的翻译自动标记为"已完成"状态
- **禁用**：导入的翻译标记为"待审核"状态

#### 忽略空值
- **启用**：跳过翻译值为空的条目
- **禁用**：允许导入空值的翻译条目

## 实际应用场景

### 场景1：质量控制
为不同语言设置不同的审核标准：
- **中文(zh-CN)**：自动审核=禁用，需要人工审核
- **英文(en-US)**：自动审核=启用，直接完成
- **日文(ja-JP)**：自动审核=禁用，需要人工审核

### 场景2：内容覆盖策略
根据语言的重要性设置不同的覆盖策略：
- **主要语言**：覆盖现有翻译=启用，确保最新内容
- **次要语言**：覆盖现有翻译=禁用，保留现有优质翻译

### 场景3：空值处理
针对不同语言的翻译完整性要求：
- **严格要求语言**：忽略空值=禁用，强制提供翻译
- **宽松处理语言**：忽略空值=启用，允许部分缺失

## 配置示例

```dart
// 设置中文的严格配置
final zhConfig = ImportLanguageConfig(
  overrideExisting: true,    // 覆盖现有翻译
  autoReview: false,         // 需要人工审核
  ignoreEmpty: false,        // 不允许空值
);
controller.setLanguageConfig('zh-CN', zhConfig);

// 设置英文的宽松配置
final enConfig = ImportLanguageConfig(
  overrideExisting: false,   // 不覆盖现有翻译
  autoReview: true,          // 自动审核
  ignoreEmpty: true,         // 忽略空值
);
controller.setLanguageConfig('en-US', enConfig);
```

## 技术实现

### 核心类

#### ImportLanguageConfig
```dart
class ImportLanguageConfig {
  final bool overrideExisting;
  final bool autoReview;
  final bool ignoreEmpty;

  const ImportLanguageConfig({
    required this.overrideExisting,
    required this.autoReview,
    required this.ignoreEmpty,
  });

  ImportLanguageConfig copyWith({
    bool? overrideExisting,
    bool? autoReview,
    bool? ignoreEmpty,
  });
}
```

#### ProjectController 扩展
- 新增 `_languageConfigs` 响应式Map存储语言特定配置
- 新增 `getLanguageConfig()` 方法获取语言配置
- 新增 `setLanguageConfig()` 方法设置语言配置
- 新增 `resetLanguageConfigs()` 方法重置所有配置

### 导入流程

1. **文件选择**：用户选择翻译文件
2. **语言映射**：为每个文件指定目标语言
3. **配置应用**：根据目标语言获取对应的导入配置
4. **内容解析**：使用相应解析器解析文件内容
5. **配置应用**：根据配置处理翻译条目（状态、空值、冲突）
6. **数据写入**：将处理后的翻译条目写入数据库

## 优势

### 1. 灵活性
- 支持为每个语言定制导入策略
- 可以根据项目需求动态调整配置

### 2. 精确控制
- 精细化管理不同语言的翻译质量
- 避免批量操作的"一刀切"问题

### 3. 用户友好
- 直观的UI界面进行配置
- 实时预览配置效果
- 支持一键重置功能

### 4. 可扩展性
- 易于添加新的配置选项
- 支持更多语言的特殊处理逻辑

## 版本兼容性

此功能向后兼容，不影响现有导入流程。未设置语言特定配置的项目将继续使用全局配置。

## 未来扩展

### 可能的新功能
1. **模板配置**：保存常用配置模板
2. **批量设置**：为多个语言同时设置相同配置
3. **条件规则**：基于文件类型或内容特征的自动配置
4. **导入历史分析**：基于历史数据推荐配置
