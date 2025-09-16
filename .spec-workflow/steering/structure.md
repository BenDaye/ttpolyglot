# Project Structure

## Directory Organization

```
ttpolyglot/                    # Monorepo根目录
├── apps/                      # 应用目录
│   └── ttpolyglot/            # 主Flutter应用
│       ├── lib/src/           # 应用源码
│       ├── android/           # Android平台配置
│       ├── ios/               # iOS平台配置
│       ├── macos/             # macOS平台配置
│       ├── linux/             # Linux平台配置
│       ├── windows/           # Windows平台配置
│       ├── web/               # Web平台配置
│       ├── test/              # 单元测试
│       └── example/           # 使用示例
├── packages/                  # 共享包目录
│   ├── core/                  # 核心功能包
│   │   ├── lib/src/           # 核心源码
│   │   ├── test/              # 包测试
│   │   └── example/           # 核心包示例
│   └── parsers/               # 解析器包
│       ├── lib/src/           # 解析器源码
│       ├── test/              # 包测试
│       └── example/           # 解析器示例
├── .spec-workflow/            # 规范工作流文档
├── pubspec.yaml               # 根级依赖配置
├── melos.yaml                 # Monorepo配置
└── README.md                  # 项目文档
```

## Code Structure Patterns

### 应用架构 (apps/ttpolyglot/lib/src/)

```
src/
├── app.dart                   # 应用入口配置
├── core/                      # 核心功能层
│   ├── layout/                # 布局系统
│   │   ├── widgets/           # 布局组件
│   │   ├── utils/             # 布局工具
│   │   └── [bindings/controllers] # 布局逻辑
│   ├── routing/               # 路由配置
│   ├── services/              # 业务服务
│   ├── storage/               # 存储服务
│   ├── theme/                 # 主题配置
│   ├── platform/              # 平台适配
│   └── widgets/               # 通用组件
└── features/                  # 功能模块层
    ├── [feature_name]/        # 具体功能模块
    │   ├── bindings/          # 依赖注入
    │   ├── controllers/       # 业务逻辑
    │   ├── views/             # UI界面
    │   └── widgets/           # 功能组件
    └── features.dart          # 功能模块导出
```

### 包结构 (packages/)

```
packages/[package_name]/
├── lib/
│   ├── [package_name].dart    # 包入口文件
│   └── src/                   # 包源码
├── test/                      # 单元测试
├── example/                   # 使用示例
└── pubspec.yaml               # 包配置
```

## Naming Conventions

### Files
- **页面/视图**: `[feature]_view.dart` (e.g., `dashboard_view.dart`)
- **控制器**: `[feature]_controller.dart` (e.g., `project_controller.dart`)
- **绑定**: `[feature]_binding.dart` (e.g., `project_binding.dart`)
- **组件**: `[feature]_widget.dart` 或 `[component].dart` (e.g., `stat_card.dart`)
- **服务**: `[feature]_service.dart` (e.g., `project_service.dart`)
- **工具**: `[feature]_utils.dart` (e.g., `layout_utils.dart`)

### Code
- **类名**: `PascalCase` (e.g., `ProjectController`)
- **方法名**: `camelCase` (e.g., `loadProjects()`)
- **变量名**: `camelCase` (e.g., `projectList`)
- **常量名**: `UPPER_SNAKE_CASE` (e.g., `MAX_RETRY_COUNT`)
- **文件名**: `snake_case.dart` (e.g., `project_controller.dart`)

## Import Patterns

### Import Order
1. Flutter/Dart标准库导入
2. 第三方包导入
3. 本地包导入 (packages/)
4. 相对路径导入 (./)

### Import Style
```dart
// 标准库导入
import 'dart:convert';
import 'dart:io';

// 第三方包 - 使用package:导入
import 'package:get/get.dart';
import 'package:dio/dio.dart';

// 本地包 - 使用package:导入
import 'package:core/core.dart';
import 'package:parsers/parsers.dart';

// 相对导入 - 仅在同一包内
import '../controllers/project_controller.dart';
import './widgets/project_card.dart';
```

## Module Boundaries

### 架构分层
1. **Features层**: 具体业务功能模块
   - 每个feature自包含完整的MVC结构
   - 通过bindings进行依赖注入
   - 不应直接依赖其他features

2. **Core层**: 通用功能和基础设施
   - 提供跨feature的服务
   - 包含通用组件和工具
   - 其他层可以依赖core，但反之不行

3. **Packages层**: 可重用的核心包
   - core包: 核心业务逻辑
   - parsers包: 数据解析功能
   - 可以被多个应用使用

### 依赖方向
```
Features → Core → Packages
    ↓
External Dependencies
```

## Code Size Guidelines

### 文件大小
- **控制器文件**: 最大300行
- **视图文件**: 最大200行
- **组件文件**: 最大150行
- **服务文件**: 最大250行

### 方法大小
- **控制器方法**: 最大50行
- **工具方法**: 最大30行
- **组件方法**: 最大20行

### 复杂度控制
- **圈复杂度**: 方法不超过10
- **嵌套深度**: 最大4层
- **参数数量**: 方法参数不超过5个

## Code Organization Principles

1. **单一职责**: 每个文件/类只负责一个明确的功能
2. **依赖倒置**: 高层模块不应依赖低层模块，两者都应依赖抽象
3. **开闭原则**: 对扩展开放，对修改关闭
4. **接口隔离**: 不应强迫客户端依赖它们不使用的方法

## Features组织原则

每个feature模块应包含：
- `bindings/`: 依赖注入配置
- `controllers/`: 业务逻辑处理
- `views/`: UI界面实现
- `widgets/`: 功能专用组件
- `[feature].dart`: 模块导出文件

## Documentation Standards

- **公共API**: 必须包含完整的文档注释
- **复杂逻辑**: 应包含必要的内联注释
- **模块说明**: 重要模块应有README文档
- **代码示例**: 复杂功能应提供使用示例

## 包管理原则

- 使用Melos进行monorepo管理
- 各包保持相对独立，减少耦合
- 通过pubspec_overrides.yaml管理本地包版本
- 遵循语义化版本控制