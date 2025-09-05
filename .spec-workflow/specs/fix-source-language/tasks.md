# 修复源语言设计问题 - Tasks Document

- [-] 1. 创建SourceLanguageValidator工具类
  - File: packages/core/lib/src/utils/source_language_validator.dart
  - 实现数据一致性验证和修复逻辑
  - 添加项目源语言验证方法
  - 添加翻译条目源语言一致性检查
  - _Purpose: 提供源语言数据一致性验证的核心工具_
  - _Leverage: 现有的Language和TranslationEntry模型_
  - _Requirements: 2.1, 2.2, 2.3_

- [ ] 2. 修改Project模型定义
  - File: packages/core/lib/src/models/project.dart
  - 将defaultLanguage重命名为primaryLanguage
  - 移除copyWith方法中的primaryLanguage参数
  - 更新JSON序列化方法
  - 更新文档注释说明primaryLanguage不可修改
  - _Purpose: 实现固定主语言的数据模型_
  - _Leverage: 现有的Project类结构_
  - _Requirements: 1.1, 1.2_

- [ ] 3. 修改ProjectService接口
  - File: packages/core/lib/src/services/project_service.dart
  - 更新CreateProjectRequest验证逻辑，移除源语言修改检查
  - 更新UpdateProjectRequest，移除primaryLanguage字段
  - 添加数据一致性验证方法
  - _Purpose: 移除源语言修改的业务逻辑支持_
  - _Leverage: 现有的项目服务接口_
  - _Requirements: 1.3, 2.1_

- [ ] 4. 实现ProjectService具体修改
  - File: packages/core/lib/src/services/project_service_impl.dart (如果存在)
  - 实现数据一致性验证逻辑
  - 添加项目加载时的源语言检查
  - 实现自动修复不一致数据的功能
  - _Purpose: 确保运行时数据一致性_
  - _Leverage: SourceLanguageValidator工具类_
  - _Requirements: 2.2, 3.2_

- [ ] 5. 修改ProjectController逻辑
  - File: apps/ttpolyglot/lib/src/features/project/controllers/project_controller.dart
  - 移除源语言编辑相关方法
  - 添加数据一致性验证调用
  - 更新项目加载逻辑包含一致性检查
  - _Purpose: 移除UI层源语言修改功能_
  - _Leverage: 现有的ProjectController结构_
  - _Requirements: 1.3, 2.3_

- [ ] 6. 修改ProjectDialogController
  - File: apps/ttpolyglot/lib/src/features/project/controllers/project_dialog_controller.dart
  - 修改创建项目逻辑，强化主语言选择提示
  - 移除编辑项目时的源语言修改功能
  - 添加主语言固定性的用户提示
  - _Purpose: 防止用户意外尝试修改主语言_
  - _Leverage: 现有的对话框控制器逻辑_
  - _Requirements: 1.1, 1.2_

- [ ] 7. 更新项目设置页面UI
  - File: apps/ttpolyglot/lib/src/features/project/views/project_settings_view.dart
  - 移除任何源语言相关的设置选项
  - 添加主语言固定性的说明文本
  - 更新页面布局适应新设计
  - _Purpose: 移除UI层源语言修改入口_
  - _Leverage: 现有的设置页面结构_
  - _Requirements: 1.3_

- [ ] 8. 更新项目语言设置页面
  - File: apps/ttpolyglot/lib/src/features/project/views/project_languages_view.dart
  - 修改默认语言显示，移除编辑功能
  - 添加主语言固定性的视觉提示
  - 更新页面说明文字
  - _Purpose: 明确告知用户主语言不可修改_
  - _Leverage: 现有的语言设置页面结构_
  - _Requirements: 1.1, 1.2_

- [ ] 9. 添加SourceLanguageValidator单元测试
  - File: packages/core/test/source_language_validator_test.dart
  - 测试数据一致性验证逻辑
  - 测试自动修复功能
  - 测试错误场景处理
  - _Purpose: 确保验证逻辑的正确性和可靠性_
  - _Leverage: 现有的测试框架和fixtures_
  - _Requirements: 2.1, 2.2_

- [ ] 10. 添加Project模型单元测试
  - File: packages/core/test/models/project_test.dart
  - 测试primaryLanguage字段的不可修改性
  - 测试数据序列化和反序列化
  - 测试计算属性正确性
  - _Purpose: 验证模型修改的正确性_
  - _Leverage: 现有的模型测试模式_
  - _Requirements: 1.1, 1.2_

- [ ] 11. 添加ProjectService集成测试
  - File: packages/core/test/services/project_service_test.dart
  - 测试数据一致性验证集成
  - 测试项目创建时主语言设置
  - 测试项目更新时主语言保护
  - _Purpose: 验证服务层修改的正确性_
  - _Leverage: 现有的服务测试模式_
  - _Requirements: 1.3, 2.3_

- [ ] 12. 添加ProjectController集成测试
  - File: apps/ttpolyglot/test/controllers/project_controller_test.dart
  - 测试控制器层的数据一致性验证
  - 测试UI层源语言修改功能的移除
  - 测试错误处理和用户反馈
  - _Purpose: 验证控制器层修改的正确性_
  - _Leverage: 现有的控制器测试模式_
  - _Requirements: 1.3, 2.3_

- [ ] 13. 更新翻译条目创建逻辑
  - File: apps/ttpolyglot/lib/src/features/translation/controllers/translation_controller.dart
  - 确保新翻译条目使用项目主语言
  - 添加源语言一致性检查
  - 更新翻译导入逻辑
  - _Purpose: 保证翻译数据的源语言一致性_
  - _Leverage: 现有的翻译控制器逻辑_
  - _Requirements: 2.1, 2.2_

- [ ] 14. 添加数据迁移验证
  - File: packages/core/lib/src/utils/data_migration_validator.dart
  - 创建数据迁移验证工具
  - 验证现有项目数据的源语言一致性
  - 提供迁移报告和修复建议
  - _Purpose: 确保现有数据在升级后的兼容性_
  - _Leverage: SourceLanguageValidator_
  - _Requirements: 2.3, 3.1_

- [ ] 15. 更新文档和注释
  - 更新所有相关文件的文档注释
  - 添加主语言固定性的说明
  - 更新API文档和使用示例
  - _Purpose: 确保代码文档的一致性_
  - _Requirements: 所有_

- [ ] 16. 最终集成测试和验证
  - 执行完整的端到端测试
  - 验证所有功能正常工作
  - 检查性能影响
  - _Purpose: 确保整体系统功能的正确性_
  - _Leverage: 所有修改的组件_
  - _Requirements: 所有_