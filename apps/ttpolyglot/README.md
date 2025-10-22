# TTPolyglot App 🌍

TTPolyglot 翻译管理平台的跨平台客户端应用，基于 Flutter 构建，支持 Web、桌面（macOS、Windows、Linux）和移动端（iOS、Android）。

## 📱 应用特性

### 跨平台支持
- ✅ **Web**: Chrome、Safari、Firefox、Edge 等现代浏览器
- ✅ **桌面**: macOS、Windows、Linux
- ✅ **移动**: iOS、Android

### 核心功能
- 📊 **仪表板**: 项目概览、统计信息、快速操作
- 📁 **项目管理**: 创建、编辑、删除、导入、导出翻译项目
- 🌐 **多语言翻译**: 支持 47+ 种语言的翻译管理
- 👥 **团队协作**: 用户管理、权限控制、成员邀请
- ⚙️ **设置中心**: 翻译服务配置、应用偏好设置
- 🔐 **认证系统**: 用户注册、登录、JWT Token 管理
- 📤 **文件操作**: 支持拖拽上传、批量导入/导出、多格式支持

### 技术亮点
- 🎨 **Material Design 3**: 现代化、美观的用户界面
- 🔥 **热重载**: 快速开发和调试
- 📦 **GetX 状态管理**: 轻量级、高性能的状态管理方案
- 🌓 **主题支持**: FlexColorScheme 提供的丰富主题系统
- 💾 **本地存储**: 支持文件系统存储和 Web 存储
- 🔌 **插件化服务**: 模块化的服务层设计
- 📱 **响应式布局**: 适配各种屏幕尺寸

## 🚀 快速开始

### 前置要求
- Flutter SDK >= 3.27.3
- Dart SDK >= 3.6.1
- 对应平台的开发环境（Xcode for iOS/macOS, Android Studio for Android）

### 安装依赖

```bash
# 进入应用目录
cd apps/ttpolyglot

# 获取依赖
flutter pub get

# 代码生成（如需要）
flutter pub run build_runner build
```

### 运行应用

#### Web 版本
```bash
flutter run -d chrome

# 或指定其他浏览器
flutter run -d edge
flutter run -d safari
```

#### 桌面版本
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

#### 移动版本
```bash
# iOS (需要 macOS 和 Xcode)
flutter run -d ios

# Android
flutter run -d android
```

### 查看可用设备
```bash
flutter devices
```

## 🏗️ 项目结构

```
lib/
├── main.dart                      # 应用入口
└── src/
    ├── app.dart                   # 主应用组件
    ├── common/                    # 通用层
    │   ├── api/                   # API 客户端
    │   │   ├── auth_api.dart      # 认证 API
    │   │   └── api.dart           # API 导出
    │   ├── config/                # 应用配置
    │   ├── network/               # 网络层
    │   │   ├── http_client.dart   # HTTP 客户端
    │   │   └── interceptors/      # 请求拦截器
    │   │       ├── token_interceptor.dart    # Token 拦截器
    │   │       ├── error_interceptor.dart    # 错误拦截器
    │   │       ├── loading_interceptor.dart  # 加载拦截器
    │   │       └── response_interceptor.dart # 响应拦截器
    │   └── services/              # 通用服务
    │       ├── auth_service.dart          # 认证服务
    │       └── token_storage_service.dart # Token 存储服务
    ├── core/                      # 核心层
    │   ├── layout/                # 布局系统
    │   │   ├── layout_controller.dart  # 布局控制器
    │   │   ├── layout_bindings.dart    # 布局绑定
    │   │   ├── layout_config.dart      # 布局配置
    │   │   ├── utils/
    │   │   │   └── layout_breakpoints.dart  # 响应式断点
    │   │   └── widgets/
    │   │       ├── main_shell.dart          # 主框架
    │   │       └── responsive_sidebar.dart  # 响应式侧边栏
    │   ├── platform/              # 平台适配
    │   │   └── platform_adapter.dart
    │   ├── routing/               # 路由系统
    │   │   ├── app_routes.dart    # 路由定义
    │   │   └── app_pages.dart     # 页面配置
    │   ├── services/              # 核心服务
    │   │   ├── project_service_impl.dart      # 项目服务
    │   │   ├── translation_service_impl.dart  # 翻译服务
    │   │   ├── export_service_impl.dart       # 导出服务
    │   │   ├── conflict_detection_service.dart # 冲突检测
    │   │   └── translation_service_manager.dart
    │   ├── storage/               # 存储层
    │   │   ├── storage_provider.dart         # 存储提供者
    │   │   ├── filesystem_storage_service.dart  # 文件系统存储
    │   │   └── web_storage_service.dart      # Web 存储
    │   ├── theme/                 # 主题系统
    │   │   └── app_theme.dart
    │   ├── utils/                 # 工具类
    │   │   ├── file_save_util.dart          # 文件保存工具
    │   │   ├── import_history_cache.dart    # 导入历史缓存
    │   │   └── project_data_initializer.dart
    │   └── widgets/               # 核心组件
    │       ├── stat_card.dart              # 统计卡片
    │       ├── clickable_stat_card.dart    # 可点击统计卡片
    │       ├── format_card.dart            # 格式卡片
    │       └── widgets.dart
    └── features/                  # 功能模块
        ├── dashboard/             # 仪表板
        │   └── views/
        │       └── dashboard_view.dart
        ├── sign_in/               # 登录
        │   ├── bindings/
        │   ├── controllers/
        │   └── views/
        ├── sign_up/               # 注册
        │   ├── bindings/
        │   ├── controllers/
        │   └── views/
        ├── projects/              # 项目列表
        │   ├── bindings/
        │   ├── controllers/
        │   └── views/
        │       ├── projects_shell.dart    # 项目外壳
        │       └── projects_sidebar.dart  # 项目侧边栏
        ├── project/               # 项目详情
        │   ├── bindings/
        │   ├── controllers/
        │   │   ├── project_controller.dart
        │   │   ├── project_dialog_controller.dart
        │   │   ├── project_export_controller.dart
        │   │   └── project_navigation_controller.dart
        │   ├── views/
        │   │   ├── project_shell.dart          # 项目框架
        │   │   ├── project_dashboard_view.dart # 项目仪表板
        │   │   ├── project_import_view.dart    # 导入视图
        │   │   ├── project_export_view.dart    # 导出视图
        │   │   ├── project_languages_view.dart # 语言管理
        │   │   ├── project_members_view.dart   # 成员管理
        │   │   └── project_settings_view.dart  # 项目设置
        │   └── widgets/
        │       ├── upload_drop.dart       # 拖拽上传
        │       ├── upload_file.dart       # 文件上传
        │       └── upload_file_list.dart  # 文件列表
        ├── translation/           # 翻译管理
        │   ├── controllers/
        │   ├── views/
        │   │   ├── translations_view.dart        # 翻译视图
        │   │   ├── translations_list.dart        # 翻译列表
        │   │   ├── translations_card_key.dart    # 翻译键卡片
        │   │   └── translations_card_language.dart # 语言卡片
        │   └── widgets/
        ├── settings/              # 设置
        │   ├── bindings/
        │   ├── controllers/
        │   │   ├── settings_controller.dart
        │   │   └── translation_config_controller.dart
        │   ├── views/
        │   └── widgets/
        │       └── provider_dialog.dart
        ├── profile/               # 用户资料
        │   ├── bindings/
        │   ├── controllers/
        │   └── views/
        └── root/                  # 根视图
            ├── bindings/
            ├── controllers/
            └── views/
```

## 🎨 架构设计

### 分层架构
```
Presentation Layer (Views/Widgets)
         ↓
Controller Layer (GetX Controllers)
         ↓
Service Layer (Business Logic)
         ↓
Repository/Storage Layer
         ↓
Data Source (API/Local Storage)
```

### 核心设计模式
- **MVC**: Model-View-Controller 架构
- **Dependency Injection**: GetX 依赖注入
- **Repository Pattern**: 数据访问抽象
- **Singleton Services**: 全局服务单例
- **Interceptor Pattern**: 网络请求拦截器链

### 状态管理
使用 GetX 提供的状态管理方案：
- **Reactive State**: 响应式状态更新
- **Dependency Injection**: 服务和控制器的依赖注入
- **Route Management**: 声明式路由管理
- **Bindings**: 页面级依赖绑定

## 📦 核心依赖

### UI & 主题
- `flutter`: Flutter 框架
- `flex_color_scheme`: 主题系统
- `google_fonts`: Google 字体
- `material_symbols_icons`: Material Symbols 图标
- `cupertino_icons`: iOS 风格图标

### 状态管理 & 导航
- `get`: GetX 状态管理和路由
- `equatable`: 值对象比较

### 网络 & 数据
- `dio`: HTTP 客户端
- `http`: HTTP 请求
- `json_annotation`: JSON 序列化注解
- `freezed_annotation`: 不可变数据类

### 文件处理
- `file_picker`: 文件选择器
- `desktop_drop`: 桌面拖拽
- `flutter_dropzone`: Web 拖拽区域
- `path_provider`: 路径提供者
- `archive`: 压缩/解压
- `csv`: CSV 解析
- `excel`: Excel 文件处理

### 本地存储
- `shared_preferences`: 键值存储
- `path`: 路径处理

### 平台特定
- `window_manager`: 桌面窗口管理
- `tray_manager`: 系统托盘
- `hotkey_manager`: 热键管理
- `universal_platform`: 平台检测

### 工具库
- `intl`: 国际化
- `uuid`: UUID 生成
- `crypto`: 加密工具
- `watcher`: 文件监听

### 内部包
- `ttpolyglot_core`: 核心业务逻辑
- `ttpolyglot_model`: 数据模型
- `ttpolyglot_parsers`: 文件解析器
- `ttpolyglot_translators`: 翻译服务

## 🛠️ 开发指南

### 代码规范

遵循项目的 workspace rules：

1. **日志输出**: 使用 `dart:developer` 的 `log` 替代 `print`
   ```dart
   import 'dart:developer' as dev;
   
   dev.log('Message', name: 'ClassName');
   ```

2. **异常处理**: catch error 和 stackTrace
   ```dart
   try {
     // ...
   } catch (error, stackTrace) {
     log('[functionName]', error: error, stackTrace: stackTrace, name: 'ClassName');
   }
   ```

3. **数值类型**: 尺寸参数使用 double
   ```dart
   // ✅ 正确
   padding: EdgeInsets.all(10.0),
   width: 100.0,
   
   // ❌ 错误
   padding: EdgeInsets.all(10),
   width: 100,
   ```

4. **Border Radius**: 只使用 2.0/4.0/8.0
   ```dart
   // ✅ 正确
   borderRadius: BorderRadius.circular(4.0),
   borderRadius: BorderRadius.circular(8.0),
   
   // ❌ 错误
   borderRadius: BorderRadius.circular(5.0),
   borderRadius: BorderRadius.circular(12.0),
   ```

5. **导入风格**: 使用 package 风格，不使用相对路径
   ```dart
   // ✅ 正确
   import 'package:ttpolyglot/src/features/dashboard/dashboard.dart';
   
   // ❌ 错误
   import '../dashboard/dashboard.dart';
   ```

6. **Feature 导出**: 每个 feature 提供默认导出文件
   ```dart
   // features/dashboard/dashboard.dart
   export 'views/dashboard_view.dart';
   export 'controllers/dashboard_controller.dart';
   export 'bindings/dashboard_binding.dart';
   ```

### 添加新功能模块

1. 创建 feature 目录结构：
   ```bash
   lib/src/features/my_feature/
   ├── bindings/
   │   └── my_feature_binding.dart
   ├── controllers/
   │   └── my_feature_controller.dart
   ├── views/
   │   └── my_feature_view.dart
   ├── widgets/
   │   └── my_widget.dart
   └── my_feature.dart  # 导出文件
   ```

2. 创建 Binding:
   ```dart
   class MyFeatureBinding extends Bindings {
     @override
     void dependencies() {
       Get.lazyPut<MyFeatureController>(() => MyFeatureController());
     }
   }
   ```

3. 创建 Controller:
   ```dart
   class MyFeatureController extends GetxController {
     // 状态
     final count = 0.obs;
     
     // 方法
     void increment() => count++;
     
     @override
     void onInit() {
       super.onInit();
       // 初始化逻辑
     }
   }
   ```

4. 创建 View:
   ```dart
   class MyFeatureView extends GetView<MyFeatureController> {
     const MyFeatureView({super.key});
     
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: const Text('My Feature')),
         body: Obx(() => Text('Count: ${controller.count}')),
       );
     }
   }
   ```

5. 添加路由 (app_routes.dart):
   ```dart
   static const MY_FEATURE = '/my-feature';
   ```

6. 添加页面配置 (app_pages.dart):
   ```dart
   GetPage(
     name: Routes.MY_FEATURE,
     page: () => const MyFeatureView(),
     binding: MyFeatureBinding(),
   ),
   ```

### 测试

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/my_test.dart

# 运行集成测试
flutter test integration_test/
```

## 🔨 构建和部署

### 开发构建

```bash
# Web (开发模式)
flutter run -d chrome --web-renderer html

# 桌面 (开发模式)
flutter run -d macos  # 或 windows/linux
```

### 生产构建

#### Web
```bash
# 构建 Web 应用
flutter build web --release --web-renderer html

# 输出目录: build/web/
# 可直接部署到静态服务器 (Nginx, Apache, GitHub Pages 等)
```

#### 桌面
```bash
# macOS
flutter build macos --release
# 输出: build/macos/Build/Products/Release/ttpolyglot.app

# Windows
flutter build windows --release
# 输出: build/windows/x64/runner/Release/

# Linux
flutter build linux --release
# 输出: build/linux/x64/release/bundle/
```

#### 移动端
```bash
# Android APK
flutter build apk --release
# 输出: build/app/outputs/flutter-apk/app-release.apk

# Android App Bundle (推荐用于 Google Play)
flutter build appbundle --release
# 输出: build/app/outputs/bundle/release/app-release.aab

# iOS (需要 macOS 和 Xcode)
flutter build ios --release
# 需要通过 Xcode 进一步打包和签名
```

### 配置应用信息

修改包名:
```bash
# 修改应用包名
flutter pub run change_app_package_name:main com.yourcompany.ttpolyglot
```

修改应用名称:
```bash
# 使用 rename_app
flutter pub run rename_app:main all="My App Name"
```

修改应用图标:
```bash
# 1. 准备图标文件 (至少 1024x1024 PNG)
# 2. 在 pubspec.yaml 中配置 flutter_launcher_icons
# 3. 运行生成命令
flutter pub run flutter_launcher_icons
```

## 🔧 配置说明

### 环境变量
应用支持通过环境变量配置后端 API 地址：

```bash
# .env (不包含在版本控制中)
API_BASE_URL=http://localhost:8080
# 或生产环境
API_BASE_URL=https://api.ttpolyglot.dev
```

### 平台配置

#### macOS
- 最小版本: macOS 10.14
- 配置文件: `macos/Runner/Configs/AppInfo.xcconfig`

#### Windows
- 最小版本: Windows 10
- 配置文件: `windows/runner/main.cpp`

#### Linux
- 依赖: GTK 3.0+
- 配置文件: `linux/CMakeLists.txt`

#### iOS
- 最小版本: iOS 12.0
- 配置文件: `ios/Runner/Info.plist`

#### Android
- 最小 SDK: 21 (Android 5.0)
- 目标 SDK: 34 (Android 14)
- 配置文件: `android/app/build.gradle`

## 📚 相关链接

- [项目主文档](../../README.md)
- [Flutter 官方文档](https://docs.flutter.dev/)
- [GetX 文档](https://pub.dev/packages/get)
- [Material Design 3](https://m3.material.io/)

## 🐛 问题反馈

如遇到问题，请在 [GitHub Issues](https://github.com/ttpolyglot/ttpolyglot/issues) 提交。

## 📄 许可证

Apache License 2.0 - 详见 [LICENSE](../../LICENSE)
