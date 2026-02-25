---
paths: "**/*.dart"
---

# Dart/Flutter 代码风格规范

> 编写 Dart 代码时必须遵守的规范。适用于 apps/ 和 packages/ 下的所有 Dart 文件。

---

## 通用规则

### 导入风格

```dart
// 必须使用 package 风格导入
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/src/services/services.dart';

// 禁止使用相对路径导入
// import '../../../common/api/translation_api.dart';  ❌
```

### 日志规范

```dart
import 'dart:developer';

try {
  await someOperation();
} catch (error, stackTrace) {
  // 必须捕获 error 和 stackTrace 两个参数
  log('[函数名]', error: error, stackTrace: stackTrace, name: '[类名]');
}
```

**规则**：
- 使用 `dart:developer` 的 `log` 替代 `print`
- catch 必须捕获 `error` 和 `stackTrace`
- 日志格式: `log('[函数名]', error: error, stackTrace: stackTrace, name: '[类名]')`

### 行宽与格式

- 行宽 **120** 字符
- 始终使用 **trailing commas**（linter 强制: `require_trailing_commas`）
- 不手动编辑 `*.g.dart` 和 `*.freezed.dart` 生成文件

---

## Flutter / UI 规则

### 尺寸值

```dart
// 必须使用 double 字面量
padding: EdgeInsets.all(10.0),    // ✅
width: 200.0,                     // ✅
height: 48.0,                     // ✅

// 禁止使用整数
padding: EdgeInsets.all(10),      // ❌
width: 200,                       // ❌
```

### 圆角半径

只允许三种值: `2.0` / `4.0` / `8.0`

```dart
BorderRadius.circular(2.0)   // ✅ 小圆角
BorderRadius.circular(4.0)   // ✅ 中圆角
BorderRadius.circular(8.0)   // ✅ 大圆角
BorderRadius.circular(12.0)  // ❌ 禁止
```

### 桶文件导出

每个 feature 文件夹必须有一个默认导出文件:

```dart
// features/translation/translation.dart
export 'controllers/translation_controller.dart';
export 'views/translations_view.dart';
export 'widgets/translation_widgets.dart';
```

---

## GetX 状态管理

### Controller 规范

```dart
class TranslationController extends GetxController {
  // 服务依赖通过 Get.find 获取
  final translationService = Get.find<TranslationServiceImpl>();

  // 状态变量
  final translations = <TranslationEntryModel>[].obs;
  final isLoading = false.obs;
}
```

### API 调用规范

```dart
class TranslationApi {
  final HttpClient _httpClient = Get.find<HttpClient>();

  Future<bool> createTranslation(Map<String, dynamic> data) async {
    try {
      final response = await _httpClient.post('/api/v1/translations', data: data);
      return response.success;
    } catch (error, stackTrace) {
      log('createTranslation', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      return false;
    }
  }

  Future<TranslationEntryModel?> getTranslation(int id) async {
    try {
      final response = await _httpClient.get('/api/v1/translations/$id');
      if (response.success) {
        return TranslationEntryModel.fromJson(response.data);
      }
      return null;
    } catch (error, stackTrace) {
      log('getTranslation', error: error, stackTrace: stackTrace, name: 'TranslationApi');
      return null;
    }
  }
}
```

**规则**：
- 查询类方法返回 `T?`（成功返回数据，失败返回 null）
- 操作类方法返回 `bool`（成功 true，失败 false）
- try-catch 必须捕获 `error` 和 `stackTrace`

---

## 后端 Server 规则

### Controller 规范

```dart
// 必须继承 BaseController
class TranslationController extends BaseController {
  final TranslationService _translationService;

  TranslationController({required TranslationService translationService})
      : _translationService = translationService,
        super('TranslationController');

  // 使用 execute 包装业务逻辑
  Future<Response> createTranslation(Request request) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body);
        final result = await _translationService.createTranslation(data);
        return ResponseUtils.success(data: result);
      },
      operationName: 'createTranslation',
    );
  }
}
```

### Service 规范

```dart
// 业务服务必须继承 BaseService
class TranslationService extends BaseService {
  final DatabaseService _databaseService;

  TranslationService({required DatabaseService databaseService})
      : _databaseService = databaseService,
        super('TranslationService');

  // 使用 BaseService 提供的日志方法
  Future<Map<String, dynamic>> createTranslation(Map<String, dynamic> data) async {
    logInfo('创建翻译', context: {'key': data['key']});
    // ...
  }

  // 使用 BaseService 提供的异常方法
  Future<Map<String, dynamic>> getTranslation(int id) async {
    final result = await _databaseService.query('...');
    if (result == null) {
      throwNotFound('翻译不存在');
    }
    return result;
  }
}
```

**服务层级**：
- `infrastructure/` - 基础设施服务（不继承 BaseService）: DatabaseService、RedisService
- `business/` - 业务服务（继承 BaseService）: AuthService、TranslationService、ProjectService
- `feature/` - 功能服务（继承 BaseService）: EmailService、FileUploadService

### 响应构建

```dart
// 使用 ResponseUtils 构建标准化响应
ResponseUtils.success(data: result);
ResponseUtils.error(message: '操作失败');
ResponseUtils.notFound(message: '资源不存在');
```

---

## 数据模型规则

### Freezed 模型

```dart
@freezed
class TranslationEntryModel with _$TranslationEntryModel {
  const factory TranslationEntryModel({
    required int id,
    required String key,
    required int projectId,
    List<TranslationTargetLanguageModel>? targetLanguages,
  }) = _TranslationEntryModel;

  factory TranslationEntryModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationEntryModelFromJson(json);
}
```

**规则**：
- 模型定义在 `packages/model/` 中跨前后端共享
- 使用 Freezed 保证不可变性
- 使用 json_serializable 处理序列化
- 修改模型后需运行 `build_runner build --delete-conflicting-outputs`

---

## 命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 类名 | PascalCase | `TranslationController` |
| 文件名 | snake_case | `translation_controller.dart` |
| 变量名 | camelCase | `translationKey`、`isLoading` |
| 常量名 | camelCase | `defaultTimeout`、`maxRetries` |
| 私有成员 | `_name` | `_translations`、`_loadData()` |
| 枚举值 | camelCase | `TranslationStatus.pending` |

---

## 代码质量检查清单

### 编码前

- [ ] 理解涉及的架构层级（Controller → Service → Infrastructure）
- [ ] 确认模型是否已在 packages/model 中定义
- [ ] 确认 API 端点是否已在 routes 中注册

### 提交前

- [ ] 使用 `log` 而非 `print`
- [ ] 所有尺寸值使用 `double`
- [ ] border radius 仅使用 2.0/4.0/8.0
- [ ] 使用 package 风格导入
- [ ] trailing commas
- [ ] `dart analyze` 无错误
- [ ] 生成文件已更新（如修改了模型）
