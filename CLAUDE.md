# TTPolyglot - Claude Code 项目规则

## 项目概述

TTPolyglot 是一个开发者友好的多语言翻译管理平台，使用 Melos monorepo 架构，全栈 Dart 技术栈。

## 技术栈

- **语言**: Dart 3.6+, Flutter 3.27+
- **后端框架**: Shelf + Drift ORM + PostgreSQL + Redis
- **前端框架**: Flutter (跨平台: Web/Desktop/Mobile)
- **状态管理**: GetX
- **HTTP 客户端**: Dio
- **Monorepo 工具**: Melos
- **数据模型**: Freezed + json_serializable

## 项目结构

```
ttpolyglot/
├── apps/ttpolyglot/          # Flutter 跨平台应用
│   └── lib/src/
│       ├── core/             # 核心层 (theme, routing, widgets, layout, platform, storage, services, utils)
│       ├── common/           # 公共层 (api, network, config, services, utils)
│       └── features/         # 功能模块 (每个功能一个文件夹)
│           └── <feature>/
│               ├── controllers/  # GetX Controller
│               ├── views/        # 页面视图
│               ├── widgets/      # 功能专属组件
│               └── <feature>.dart  # 桶文件导出
├── packages/
│   ├── server/               # 后端 REST API 服务 (Shelf)
│   │   └── lib/src/
│   │       ├── controllers/  # HTTP 控制器 (继承 BaseController)
│   │       ├── services/     # 服务层 (infrastructure/business/feature)
│   │       ├── middleware/    # 中间件 (auth, permission, rate-limit, logging, cors)
│   │       ├── routes/       # 路由定义
│   │       ├── config/       # 配置
│   │       ├── di/           # 依赖注入
│   │       ├── exceptions/   # 自定义异常
│   │       └── utils/        # 工具类
│   ├── model/                # 共享数据模型 (Freezed + json_serializable)
│   ├── parsers/              # 翻译文件解析器 (JSON, PO, YAML, CSV, ARB)
│   ├── translators/          # 翻译服务集成
│   └── utils/                # 共享工具类
└── melos.yaml
```

## 开发命令

```bash
# 初始化工作区
melos bootstrap

# 分析代码
melos exec -- dart analyze

# 运行测试
melos exec -- dart test

# 生成代码 (Freezed/json_serializable/Drift)
cd packages/server && dart run build_runner build --delete-conflicting-outputs
cd apps/ttpolyglot && dart run build_runner build --delete-conflicting-outputs

# 启动后端
cd packages/server && dart run bin/server.dart

# 启动前端
cd apps/ttpolyglot && flutter run -d chrome
```

## 编码规范

### 通用规则

1. **日志**: 使用 `dart:developer` 的 `log` 替代 `print`。catch 时捕获 error 和 stackTrace:
   ```dart
   log('[函数名称]', error: error, stackTrace: stackTrace, name: '[类名称]');
   ```

2. **导入风格**: 始终使用 package 风格导入，不使用相对路径:
   ```dart
   import 'package:ttpolyglot/src/features/translation/translation.dart';
   ```

3. **桶文件导出**: features 目录下的每个 feature 文件夹都需要一个默认导出文件

4. **行宽**: 120 字符 (dart.lineLength = 120)

5. **生成文件**: 不要手动编辑 `*.g.dart` 和 `*.freezed.dart` 文件

### Flutter/UI 规则

1. **尺寸值使用 double**: padding/margin/width/height 等始终使用 double 字面量:
   ```dart
   // 正确
   padding: EdgeInsets.all(10.0)
   // 错误
   padding: EdgeInsets.all(10)
   ```

2. **Border Radius**: 只使用 `2.0`、`4.0`、`8.0` 三种值

3. **Trailing commas**: 始终使用 trailing commas (linter 强制)

### 后端规则

1. **控制器**: 所有控制器继承 `BaseController`，使用 `execute` 方法包装业务逻辑
2. **服务层**: 业务服务和功能服务继承 `BaseService`
3. **服务分层**:
   - `infrastructure/` - 基础设施 (数据库、缓存，不继承 BaseService)
   - `business/` - 业务服务 (auth, user, project, translation 等)
   - `feature/` - 功能服务 (email, file-upload, metrics)
4. **响应构建**: 使用 `ResponseUtils` 构建标准化响应
5. **参数验证**: 使用 `ValidatorUtils` 进行参数验证
6. **异常处理**: 使用 BaseService 提供的 `throwNotFound`/`throwBusiness`/`throwValidation` 等方法

### 数据模型规则

1. 使用 Freezed 定义不可变数据模型
2. 使用 json_serializable 处理 JSON 序列化
3. 模型定义在 `packages/model` 中共享

## Git 规范

遵循 Conventional Commits:
- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `style:` 代码格式
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建/辅助工具

支持 scope: `feat(translation-service): description`

## 注意事项

- 不要提交 `.env` 文件 (`.env.example` 除外)
- 不要提交 `.env.development`、`.env.production`、`.env.test` (已在 gitignore 允许列表)
- 不要修改 `pubspec_overrides.yaml` (Melos 自动生成)
- 代码生成后的 `.g.dart` 和 `.freezed.dart` 文件不应手动修改
