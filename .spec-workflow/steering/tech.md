# Technology Stack

## Project Type

TTPolyglot 是一个多语言翻译工具，采用 Flutter 应用 + Dart 包的混合架构，为 Flutter 开发者提供完整的国际化解决方案。

## Core Technologies

### Primary Language(s)

- **Language**: Dart 3.6.0 (Flutter SDK)
- **Runtime/Compiler**: Flutter Engine / Dart VM
- **Language-specific tools**: Flutter CLI, Dart SDK, Pub package manager

### Key Dependencies/Libraries

- **Flutter**: UI 框架和跨平台开发 (3.27.3)
- **Dart**: 编程语言和运行时 (3.6.0)
- **Path**: 文件路径处理 (1.x)
- **Yaml**: YAML 文件解析 (3.x)
- **GetX**: 状态管理和路由管理，轻量级响应式框架 (4.6.6)
- **Dio**: HTTP 网络请求库，支持拦截器和重试机制 (5.7.0)
- **Freezed**: 代码生成工具，自动生成数据模型和序列化代码

### Application Architecture

采用分层架构设计：

- **Presentation Layer**: Flutter widgets 和路由系统
- **Business Logic Layer**: Controller 和 Service 层
- **Data Layer**: 文件系统和内存数据管理
- **Package Architecture**: Core 包处理核心逻辑，Parsers 包处理数据解析

### Data Storage (if applicable)

- **Primary storage**: 文件系统 (JSON/YAML 翻译文件)
- **Caching**: 内存缓存翻译数据
- **Data formats**: JSON (翻译文件), YAML (配置)

### External Integrations (if applicable)

- **APIs**: 无外部 API 依赖
- **Protocols**: 文件系统操作
- **Authentication**: 无需认证 (本地工具)

### Monitoring & Dashboard Technologies (if applicable)

- **Dashboard Framework**: Flutter Web
- **Real-time Communication**: WebSocket (可选)
- **Visualization Libraries**: Flutter 内置 widgets
- **State Management**: GetX 状态管理

## Development Environment

### Build & Development Tools

- **Build System**: Flutter build system
- **Package Management**: Pub (Dart package manager)
- **Development workflow**: Hot reload, Flutter DevTools

### Code Quality Tools

- **Static Analysis**: Dart analyzer, Flutter lints
- **Formatting**: dartfmt
- **Testing Framework**: Flutter test framework
- **Documentation**: Dart doc

### Version Control & Collaboration

- **VCS**: Git
- **Branching Strategy**: Git Flow
- **Code Review Process**: Pull Request review

### Dashboard Development (if applicable)

- **Live Reload**: Flutter hot reload
- **Port Management**: 可配置端口
- **Multi-Instance Support**: 支持多实例运行

## Deployment & Distribution (if applicable)

- **Target Platform(s)**: macOS, Windows, Linux, iOS, Android, Web
- **Distribution Method**: GitHub releases, Pub.dev packages
- **Installation Requirements**: Flutter SDK 3.27.3
- **Update Mechanism**: 手动更新

## Technical Requirements & Constraints

### Performance Requirements

- 启动时间: < 2 秒
- 翻译加载时间: < 500ms
- 内存使用: < 100MB

### Compatibility Requirements

- **Platform Support**: Flutter 支持的所有平台
- **Dependency Versions**: Flutter 3.27.3, Dart 3.6.0
- **Standards Compliance**: Flutter 项目标准

### Security & Compliance

- **Security Requirements**: 本地文件安全，无网络传输
- **Compliance Standards**: 遵循 Flutter 安全最佳实践
- **Threat Model**: 本地工具，无远程安全风险

### Scalability & Reliability

- **Expected Load**: 单用户本地工具
- **Availability Requirements**: 本地运行可靠性
- **Growth Projections**: 支持大型项目翻译文件

## Technical Decisions & Rationale

### Decision Log

1. **Flutter 框架选择**: 为实现跨平台一致性，选择了 Flutter 而不是原生开发
2. **GetX 状态管理**: 轻量级且功能完整，适合中小型项目
3. **包化架构**: 将核心功能拆分为独立包，提高可维护性和可重用性
4. **文件系统存储**: 适合本地工具，无需复杂的数据持久化

## Known Limitations

- Web 平台功能受限: 某些文件系统操作在 Web 环境中受限
- 大文件处理性能: 超大翻译文件的处理可能需要优化
- 实时协作: 当前不支持多用户实时协作翻译
