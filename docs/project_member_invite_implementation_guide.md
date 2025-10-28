# 项目成员邀请功能 - 前端实现指南

## 📋 概述

本文档提供剩余前端 UI 组件的详细实现指南。后端 API 和前端 API 层已全部完成，现在需要实现用户界面。

---

## ✅ 已完成的工作

### 后端（100%）
- ✅ 数据库表结构（projects.member_limit, project_members 扩展字段）
- ✅ Service 层（ProjectMemberService 所有方法）
- ✅ Controller 层（ProjectMemberController）
- ✅ 路由配置完成

### 前端 API 层（100%）
- ✅ `ProjectApi` 新增方法：
  - `generateInviteLink()` - 生成邀请链接
  - `getProjectInvites()` - 获取项目邀请列表
  - `revokeInvite()` - 撤销邀请
  - `getInviteInfo()` - 获取邀请信息
  - `acceptInvite()` - 接受邀请
  - `addProjectMember()` - 直接添加成员
  - `removeProjectMember()` - 移除成员
  - `updateMemberRole()` - 更新成员角色
  - `updateMemberLimit()` - 更新成员上限
- ✅ `UserApi.searchUsers()` - 用户搜索

---

## 📦 所需依赖包

在 `apps/ttpolyglot/pubspec.yaml` 中添加：

```yaml
dependencies:
  qr_flutter: ^4.1.0           # 生成二维码
  flutter/services: ^0.0.0     # 复制到剪贴板（已有）
  get: ^4.6.6                  # 状态管理（已有）
  
  # 可选
  share_plus: ^7.2.1           # 分享邀请链接
  path_provider: ^2.1.0        # 保存二维码图片
```

---

## 🎯 待实现任务清单

### Phase 4: UI 组件

#### ✅ TODO 10: 创建邀请成员对话框控制器
**文件位置**: `apps/ttpolyglot/lib/src/features/project/controllers/project_member_invite_controller.dart`

#### ✅ TODO 11: 邀请链接 Tab UI
**文件位置**: `apps/ttpolyglot/lib/src/features/project/views/widgets/invite_link_tab.dart`

#### ✅ TODO 12: 直接添加成员 Tab UI
**文件位置**: `apps/ttpolyglot/lib/src/features/project/views/widgets/add_member_tab.dart`

#### ✅ TODO 13: 加入项目页面
**文件位置**: 
- `apps/ttpolyglot/lib/src/features/join/controllers/join_project_controller.dart`
- `apps/ttpolyglot/lib/src/features/join/views/join_project_view.dart`

#### ✅ TODO 14: 添加路由
**文件位置**: `apps/ttpolyglot/lib/src/routes/app_routes.dart`

#### ✅ TODO 15: 成员列表页面更新
**文件位置**: `apps/ttpolyglot/lib/src/features/project/views/project_members_view.dart`

#### ✅ TODO 16: 编辑/移除成员功能
**集成到**: `project_members_view.dart`

#### ✅ TODO 17: 项目设置中的成员上限配置
**文件位置**: `apps/ttpolyglot/lib/src/features/project/views/project_settings_view.dart`

---

## 📝 详细实现指南

### TODO 10: 邀请成员对话框控制器

创建 `ProjectMemberInviteController` 来管理邀请对话框的状态。

```dart
// apps/ttpolyglot/lib/src/features/project/controllers/project_member_invite_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot_model/model.dart';

class ProjectMemberInviteController extends GetxController {
  final int projectId;
  final ProjectApi _projectApi = Get.find<ProjectApi>();
  final UserApi _userApi = Get.find<UserApi>();

  ProjectMemberInviteController({required this.projectId});

  // Tab 控制
  final _currentTab = 0.obs;
  int get currentTab => _currentTab.value;
  void setTab(int index) => _currentTab.value = index;

  // 邀请链接相关
  final _selectedRole = 'member'.obs;
  final _expiresIn = Rxn<int>(7); // 默认7天
  final _maxUses = Rxn<int>(); // 默认无限
  final _generatedInvite = Rxn<Map<String, dynamic>>();
  final _isGenerating = false.obs;

  String get selectedRole => _selectedRole.value;
  int? get expiresIn => _expiresIn.value;
  int? get maxUses => _maxUses.value;
  Map<String, dynamic>? get generatedInvite => _generatedInvite.value;
  bool get isGenerating => _isGenerating.value;

  void setRole(String role) => _selectedRole.value = role;
  void setExpiresIn(int? days) => _expiresIn.value = days;
  void setMaxUses(int? uses) => _maxUses.value = uses;

  // 直接添加相关
  final _searchQuery = ''.obs;
  final _searchResults = <UserSearchResultModel>[].obs;
  final _selectedUsers = <UserSearchResultModel>[].obs;
  final _isSearching = false.obs;
  final _isAdding = false.obs;

  String get searchQuery => _searchQuery.value;
  List<UserSearchResultModel> get searchResults => _searchResults;
  List<UserSearchResultModel> get selectedUsers => _selectedUsers;
  bool get isSearching => _isSearching.value;
  bool get isAdding => _isAdding.value;

  /// 生成邀请链接
  Future<void> generateInviteLink() async {
    try {
      _isGenerating.value = true;
      
      final result = await _projectApi.generateInviteLink(
        projectId: projectId,
        role: _selectedRole.value,
        expiresInDays: _expiresIn.value,
        maxUses: _maxUses.value,
      );

      _generatedInvite.value = result;
      
      Get.snackbar('成功', '邀请链接已生成');
    } catch (error, stackTrace) {
      log('[generateInviteLink]', error: error, stackTrace: stackTrace, name: 'ProjectMemberInviteController');
      Get.snackbar('失败', '生成邀请链接失败');
    } finally {
      _isGenerating.value = false;
    }
  }

  /// 复制邀请链接
  void copyInviteLink() {
    if (_generatedInvite.value == null) return;
    
    final url = _generatedInvite.value!['invite_url'] as String;
    Clipboard.setData(ClipboardData(text: url));
    Get.snackbar('成功', '邀请链接已复制到剪贴板');
  }

  /// 搜索用户
  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      _searchResults.clear();
      return;
    }

    try {
      _isSearching.value = true;
      _searchQuery.value = query;
      
      final results = await _userApi.searchUsers(query: query, limit: 10);
      _searchResults.assignAll(results ?? []);
    } catch (error, stackTrace) {
      log('[searchUsers]', error: error, stackTrace: stackTrace, name: 'ProjectMemberInviteController');
      Get.snackbar('失败', '搜索用户失败');
    } finally {
      _isSearching.value = false;
    }
  }

  /// 切换用户选择
  void toggleUserSelection(UserSearchResultModel user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
  }

  /// 添加选中的用户
  Future<void> addSelectedMembers() async {
    if (_selectedUsers.isEmpty) return;

    try {
      _isAdding.value = true;
      
      for (final user in _selectedUsers) {
        await _projectApi.addProjectMember(
          projectId: projectId,
          userId: user.id,
          role: _selectedRole.value,
        );
      }
      
      Get.snackbar('成功', '已添加 ${_selectedUsers.length} 位成员');
      _selectedUsers.clear();
      _searchResults.clear();
      _searchQuery.value = '';
      
      // 刷新成员列表
      Get.back();
    } catch (error, stackTrace) {
      log('[addSelectedMembers]', error: error, stackTrace: stackTrace, name: 'ProjectMemberInviteController');
      Get.snackbar('失败', '添加成员失败');
    } finally {
      _isAdding.value = false;
    }
  }

  @override
  void onClose() {
    _currentTab.close();
    _selectedRole.close();
    _expiresIn.close();
    _maxUses.close();
    _generatedInvite.close();
    _isGenerating.close();
    _searchQuery.close();
    _searchResults.close();
    _selectedUsers.close();
    _isSearching.close();
    _isAdding.close();
    super.onClose();
  }
}
```

---

### TODO 11: 邀请链接 Tab UI

创建邀请链接标签页，包含表单、链接展示和二维码。

```dart
// apps/ttpolyglot/lib/src/features/project/views/widgets/invite_link_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_member_invite_controller.dart';

class InviteLinkTab extends GetView<ProjectMemberInviteController> {
  const InviteLinkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 邀请设置
          _buildInviteSettings(),
          
          const SizedBox(height: 24.0),
          
          // 生成按钮
          Obx(() => ElevatedButton(
            onPressed: controller.isGenerating ? null : controller.generateInviteLink,
            child: controller.isGenerating
                ? const SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  )
                : const Text('生成邀请链接'),
          )),
          
          const SizedBox(height: 24.0),
          
          // 邀请链接展示
          Obx(() {
            final invite = controller.generatedInvite;
            if (invite == null) return const SizedBox.shrink();
            
            return Column(
              children: [
                _buildInviteLinkDisplay(invite),
                const SizedBox(height: 24.0),
                _buildQRCode(invite),
                const SizedBox(height: 24.0),
                _buildInviteInfo(invite),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInviteSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📋 邀请设置', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            
            // 角色选择
            _buildRoleSelector(),
            const SizedBox(height: 16.0),
            
            // 有效期选择
            _buildExpiresSelector(),
            const SizedBox(height: 16.0),
            
            // 使用次数选择
            _buildMaxUsesSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('角色权限'),
        const SizedBox(height: 8.0),
        Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedRole,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
          items: const [
            DropdownMenuItem(value: 'viewer', child: Text('查看者 - 只能查看')),
            DropdownMenuItem(value: 'member', child: Text('成员 - 可以翻译')),
            DropdownMenuItem(value: 'admin', child: Text('管理员 - 可以管理')),
          ],
          onChanged: (value) {
            if (value != null) controller.setRole(value);
          },
        )),
      ],
    );
  }

  Widget _buildExpiresSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('有效期'),
        const SizedBox(height: 8.0),
        Obx(() => Wrap(
          spacing: 8.0,
          children: [
            ChoiceChip(
              label: const Text('7天'),
              selected: controller.expiresIn == 7,
              onSelected: (_) => controller.setExpiresIn(7),
            ),
            ChoiceChip(
              label: const Text('30天'),
              selected: controller.expiresIn == 30,
              onSelected: (_) => controller.setExpiresIn(30),
            ),
            ChoiceChip(
              label: const Text('永久'),
              selected: controller.expiresIn == null,
              onSelected: (_) => controller.setExpiresIn(null),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildMaxUsesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('使用次数'),
        const SizedBox(height: 8.0),
        Obx(() => Wrap(
          spacing: 8.0,
          children: [
            ChoiceChip(
              label: const Text('1次'),
              selected: controller.maxUses == 1,
              onSelected: (_) => controller.setMaxUses(1),
            ),
            ChoiceChip(
              label: const Text('10次'),
              selected: controller.maxUses == 10,
              onSelected: (_) => controller.setMaxUses(10),
            ),
            ChoiceChip(
              label: const Text('无限'),
              selected: controller.maxUses == null,
              onSelected: (_) => controller.setMaxUses(null),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildInviteLinkDisplay(Map<String, dynamic> invite) {
    final url = invite['invite_url'] as String;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🔗 邀请链接', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: SelectableText(
                url,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: controller.copyInviteLink,
                  icon: const Icon(Icons.copy, size: 18.0),
                  label: const Text('复制链接'),
                ),
                const SizedBox(width: 8.0),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: 实现分享功能（可选）
                  },
                  icon: const Icon(Icons.share, size: 18.0),
                  label: const Text('分享'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCode(Map<String, dynamic> invite) {
    final url = invite['invite_url'] as String;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('📱 邀请二维码', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: QrImageView(
                data: url,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              '扫描二维码加入项目',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Text(
              '（扫码后跳转到上方链接）',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteInfo(Map<String, dynamic> invite) {
    final expiresAt = invite['expires_at'] as String?;
    final maxUses = invite['max_uses'] as int?;
    final usedCount = invite['used_count'] as int? ?? 0;
    final role = invite['role'] as String;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📊 邀请信息', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12.0),
            _buildInfoRow('💡 有效期至', expiresAt ?? '永久有效'),
            _buildInfoRow('📊 已使用', '$usedCount / ${maxUses ?? "无限"}次'),
            _buildInfoRow('👥 邀请角色', _getRoleName(role)),
            _buildInfoRow('📅 创建时间', invite['created_at'] as String? ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'owner':
        return '所有者';
      case 'admin':
        return '管理员';
      case 'member':
        return '成员';
      case 'viewer':
        return '查看者';
      default:
        return role;
    }
  }
}
```

---

### TODO 12: 直接添加成员 Tab UI

创建用户搜索和批量添加界面。

```dart
// apps/ttpolyglot/lib/src/features/project/views/widgets/add_member_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_member_invite_controller.dart';
import 'package:ttpolyglot_model/model.dart';

class AddMemberTab extends GetView<ProjectMemberInviteController> {
  const AddMemberTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 搜索框
          _buildSearchField(),
          
          const SizedBox(height: 16.0),
          
          // 搜索结果
          Expanded(
            child: Obx(() {
              if (controller.isSearching) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchQuery.isEmpty
                        ? '请输入用户名、邮箱搜索用户'
                        : '未找到匹配的用户',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }
              
              return _buildSearchResults();
            }),
          ),
          
          const SizedBox(height: 16.0),
          
          // 底部操作栏
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: '🔍 搜索用户（用户名、邮箱）',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      onChanged: (value) {
        if (value.length >= 2) {
          controller.searchUsers(value);
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return Card(
      child: ListView.separated(
        itemCount: controller.searchResults.length,
        separatorBuilder: (_, __) => const Divider(height: 1.0),
        itemBuilder: (context, index) {
          final user = controller.searchResults[index];
          return Obx(() {
            final isSelected = controller.selectedUsers.contains(user);
            
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(user.username[0].toUpperCase())
                    : null,
              ),
              title: Text(user.displayName ?? user.username),
              subtitle: Text(user.email ?? user.username),
              trailing: Checkbox(
                value: isSelected,
                onChanged: (_) => controller.toggleUserSelection(user),
              ),
              onTap: () => controller.toggleUserSelection(user),
            );
          });
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final selectedCount = controller.selectedUsers.length;
      
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '已选择 $selectedCount 人',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (selectedCount > 0)
                    TextButton(
                      onPressed: controller.selectedUsers.clear,
                      child: const Text('清空'),
                    ),
                ],
              ),
              
              const SizedBox(height: 12.0),
              
              // 角色选择
              DropdownButtonFormField<String>(
                value: controller.selectedRole,
                decoration: const InputDecoration(
                  labelText: '角色权限',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                items: const [
                  DropdownMenuItem(value: 'viewer', child: Text('查看者')),
                  DropdownMenuItem(value: 'member', child: Text('成员')),
                  DropdownMenuItem(value: 'admin', child: Text('管理员')),
                ],
                onChanged: (value) {
                  if (value != null) controller.setRole(value);
                },
              ),
              
              const SizedBox(height: 12.0),
              
              // 添加按钮
              ElevatedButton(
                onPressed: selectedCount > 0 && !controller.isAdding
                    ? controller.addSelectedMembers
                    : null,
                child: controller.isAdding
                    ? const SizedBox(
                        width: 16.0,
                        height: 16.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : Text('添加选中用户 ($selectedCount)'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
```

---

### TODO 13 & 14: 加入项目页面和路由

#### 1. 创建控制器

```dart
// apps/ttpolyglot/lib/src/features/join/controllers/join_project_controller.dart

import 'dart:developer';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot_model/model.dart';

class JoinProjectController extends GetxController {
  final String inviteCode;
  final ProjectApi _projectApi = Get.find<ProjectApi>();

  JoinProjectController({required this.inviteCode});

  // 状态
  final _inviteInfo = Rxn<InviteInfoModel>();
  final _isLoading = true.obs;
  final _error = Rxn<String>();
  final _isAccepting = false.obs;

  // Getters
  InviteInfoModel? get inviteInfo => _inviteInfo.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  bool get isAccepting => _isAccepting.value;

  bool get isValid =>
      inviteInfo != null &&
      !inviteInfo!.isExpired &&
      inviteInfo!.isAvailable;

  @override
  void onInit() {
    super.onInit();
    loadInviteInfo();
  }

  /// 加载邀请信息
  Future<void> loadInviteInfo() async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final info = await _projectApi.getInviteInfo(inviteCode);
      _inviteInfo.value = info;
    } catch (error, stackTrace) {
      log('[loadInviteInfo]', error: error, stackTrace: stackTrace, name: 'JoinProjectController');
      _error.value = _getErrorMessage(error);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 接受邀请
  Future<void> acceptInvite() async {
    if (!isValid) return;

    try {
      _isAccepting.value = true;
      await _projectApi.acceptInvite(inviteCode);

      // 成功后跳转到项目页面
      Get.offNamed('/projects/${inviteInfo!.project.id}');

      Get.snackbar('成功', '你已成功加入项目 ${inviteInfo!.project.name}');
    } catch (error, stackTrace) {
      log('[acceptInvite]', error: error, stackTrace: stackTrace, name: 'JoinProjectController');
      Get.snackbar('失败', _getErrorMessage(error));
    } finally {
      _isAccepting.value = false;
    }
  }

  /// 拒绝邀请
  void declineInvite() {
    Get.back();
  }

  String _getErrorMessage(dynamic error) {
    // 根据错误类型返回友好的错误信息
    return '加载邀请信息失败，请稍后重试';
  }

  @override
  void onClose() {
    _inviteInfo.close();
    _isLoading.close();
    _error.close();
    _isAccepting.close();
    super.onClose();
  }
}
```

#### 2. 创建视图

```dart
// apps/ttpolyglot/lib/src/features/join/views/join_project_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/join/controllers/join_project_controller.dart';

class JoinProjectView extends GetView<JoinProjectController> {
  const JoinProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TTPolyglot'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error != null) {
          return _buildErrorState();
        }

        if (controller.inviteInfo == null) {
          return _buildInvalidState();
        }

        return _buildInviteContent();
      }),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64.0, color: Colors.red),
          const SizedBox(height: 16.0),
          Text(
            controller.error!,
            style: const TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: controller.loadInviteInfo,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvalidState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.block, size: 64.0, color: Colors.orange),
          const SizedBox(height: 16.0),
          const Text(
            '🚫 邀请链接无效',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          const Text(
            '该邀请链接不存在或已被撤销',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteContent() {
    final invite = controller.inviteInfo!;
    final project = invite.project;

    if (invite.isExpired) {
      return _buildExpiredState();
    }

    if (!invite.isAvailable) {
      return _buildUnavailableState();
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500.0),
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '你收到了一个项目邀请',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  
                  // 项目信息
                  _buildProjectInfo(project),
                  
                  const SizedBox(height: 24.0),
                  
                  // 邀请详情
                  _buildInviteDetails(invite),
                  
                  const SizedBox(height: 24.0),
                  
                  // 操作按钮
                  _buildActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectInfo(InviteProjectInfo project) {
    return Column(
      children: [
        Text(
          '📦 ${project.name}',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        if (project.description != null && project.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              project.description!,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildInviteDetails(InviteInfoModel invite) {
    return Column(
      children: [
        _buildDetailRow('👤 邀请人', invite.inviter.displayName ?? invite.inviter.username),
        _buildDetailRow('🎭 你的角色', _getRoleName(invite.role.name)),
        _buildDetailRow('👥 当前成员', '${invite.project.currentMemberCount} / ${invite.project.memberLimit}'),
        if (invite.expiresAt != null)
          _buildDetailRow('⏰ 有效期至', _formatDate(invite.expiresAt!)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Obx(() => Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: controller.isAccepting ? null : controller.declineInvite,
            child: const Text('拒绝'),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isAccepting ? null : controller.acceptInvite,
            child: controller.isAccepting
                ? const SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  )
                : const Text('接受邀请'),
          ),
        ),
      ],
    ));
  }

  Widget _buildExpiredState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.schedule, size: 64.0, color: Colors.orange),
          const SizedBox(height: 16.0),
          const Text(
            '☹️ 邀请链接已过期',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableState() {
    final invite = controller.inviteInfo!;
    
    String message = '⚠️ 邀请链接不可用';
    if (invite.project.currentMemberCount >= invite.project.memberLimit) {
      message = '⚠️ 项目成员已满\n该项目成员已达上限 (${invite.project.memberLimit}/${invite.project.memberLimit})';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_amber, size: 64.0, color: Colors.orange),
          const SizedBox(height: 16.0),
          Text(
            message,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'owner':
        return '所有者';
      case 'admin':
        return '管理员';
      case 'member':
        return '成员';
      case 'viewer':
        return '查看者';
      default:
        return role;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
```

#### 3. 添加路由

在 `apps/ttpolyglot/lib/src/routes/app_routes.dart` 中添加：

```dart
GetPage(
  name: '/join/:inviteCode',
  page: () {
    final inviteCode = Get.parameters['inviteCode']!;
    return JoinProjectView();
  },
  binding: BindingsBuilder(() {
    final inviteCode = Get.parameters['inviteCode']!;
    Get.put(JoinProjectController(inviteCode: inviteCode));
  }),
),
```

---

### TODO 15 & 16: 成员列表页面更新

在现有的成员列表页面中添加成员上限进度条和邀请按钮。

```dart
// 在 ProjectMembersView 中添加以下内容

Widget _buildMemberLimitHeader(ProjectModel project) {
  final currentCount = project.membersCount;
  final limit = project.memberLimit;
  final percentage = currentCount / limit;
  final remaining = limit - currentCount;
  
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📊 项目成员 ($currentCount/$limit)',
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: remaining > 0 ? _showInviteDialog : null,
                icon: const Icon(Icons.person_add, size: 18.0),
                label: const Text('邀请成员'),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 1.0 ? Colors.red : Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            percentage >= 1.0
                ? '⚠️ 项目成员已达上限，请先移除部分成员或在设置中提升上限'
                : '💡 还可以邀请 $remaining 人',
            style: TextStyle(
              color: percentage >= 1.0 ? Colors.red : Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    ),
  );
}

void _showInviteDialog() {
  Get.dialog(
    Dialog(
      child: SizedBox(
        width: 600.0,
        height: 700.0,
        child: Column(
          children: [
            // 对话框标题
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    '邀请成员到项目',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0),
            
            // 成员信息提示
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final project = controller.project;
                if (project == null) return const SizedBox.shrink();
                
                return Text(
                  '📊 当前成员: ${project.membersCount}/${project.memberLimit}  |  💡 还可以邀请 ${project.memberLimit - project.membersCount} 人',
                  style: TextStyle(color: Colors.grey[600]),
                );
              }),
            ),
            
            // Tab 栏
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '邀请链接'),
                Tab(text: '直接添加'),
              ],
            ),
            
            // Tab 内容
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  InviteLinkTab(),
                  AddMemberTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

---

### TODO 17: 项目设置中的成员上限配置

在项目设置页面添加成员上限配置部分。

```dart
// 在 ProjectSettingsView 中添加

Widget _buildMemberLimitSettings(ProjectModel project) {
  final isOwner = _isCurrentUserOwner(); // 检查当前用户是否是 Owner
  
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👥 成员上限设置',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          
          if (isOwner) ...[
            // Owner 可编辑
            _buildOwnerMemberLimitEditor(project),
          ] else ...[
            // 其他角色只读
            _buildReadOnlyMemberLimit(project),
          ],
        ],
      ),
    ),
  );
}

Widget _buildOwnerMemberLimitEditor(ProjectModel project) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Text('成员上限'),
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: TextField(
              controller: _memberLimitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                suffixText: '人',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: _updateMemberLimit,
            child: const Text('保存'),
          ),
        ],
      ),
      const SizedBox(height: 12.0),
      Text('当前成员: ${project.membersCount} 人', style: TextStyle(color: Colors.grey[600])),
      Text('可用名额: ${project.memberLimit - project.membersCount} 个', style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 12.0),
      Text(
        '💡 建议范围：5-50 人\n📊 允许范围：1-1000 人',
        style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
      ),
      const SizedBox(height: 8.0),
      Text(
        '⚠️ 提示：\n• 新上限不能小于当前成员数 (${project.membersCount})\n• 修改上限不会移除现有成员',
        style: const TextStyle(color: Colors.orange, fontSize: 12.0),
      ),
    ],
  );
}

Widget _buildReadOnlyMemberLimit(ProjectModel project) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('成员上限: ${project.memberLimit} 人'),
      Text('当前成员: ${project.membersCount} 人'),
      Text('可用名额: ${project.memberLimit - project.membersCount} 个'),
      const SizedBox(height: 12.0),
      Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange, size: 20.0),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'ℹ️ 只有项目所有者可以修改成员上限',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Future<void> _updateMemberLimit() async {
  final newLimit = int.tryParse(_memberLimitController.text);
  if (newLimit == null || newLimit < 1 || newLimit > 1000) {
    Get.snackbar('错误', '成员上限必须在 1-1000 之间');
    return;
  }
  
  final project = controller.project;
  if (project == null) return;
  
  if (newLimit < project.membersCount) {
    Get.snackbar('错误', '新上限不能小于当前成员数 (${project.membersCount})');
    return;
  }
  
  try {
    await _projectApi.updateMemberLimit(
      projectId: project.id,
      memberLimit: newLimit,
    );
    
    Get.snackbar('成功', '成员上限已更新为 $newLimit 人');
    controller.refreshProject(); // 刷新项目数据
  } catch (error) {
    Get.snackbar('失败', '更新成员上限失败');
  }
}
```

---

## 📚 补充说明

### 1. 导出文件

确保在相应的导出文件中添加新创建的文件：

```dart
// apps/ttpolyglot/lib/src/features/join/join.dart
export 'controllers/join_project_controller.dart';
export 'views/join_project_view.dart';

// apps/ttpolyglot/lib/src/features/project/project.dart
export 'controllers/project_member_invite_controller.dart';
export 'views/widgets/invite_link_tab.dart';
export 'views/widgets/add_member_tab.dart';
```

### 2. 需要创建的目录结构

```
apps/ttpolyglot/lib/src/features/
├── join/
│   ├── controllers/
│   │   └── join_project_controller.dart
│   ├── views/
│   │   └── join_project_view.dart
│   └── join.dart
└── project/
    ├── controllers/
    │   └── project_member_invite_controller.dart
    └── views/
        └── widgets/
            ├── invite_link_tab.dart
            └── add_member_tab.dart
```

### 3. 权限检查示例

```dart
bool _isCurrentUserOwner() {
  final currentUserId = Get.find<AuthService>().currentUser?.id;
  final project = controller.project;
  return project?.ownerId == currentUserId;
}

bool _canManageMembers() {
  final currentUser = Get.find<AuthService>().currentUser;
  if (currentUser == null) return false;
  
  final member = controller.members.firstWhereOrNull(
    (m) => m.userId == currentUser.id
  );
  
  if (member == null) return false;
  
  return member.role == ProjectRoleEnum.owner || 
         member.role == ProjectRoleEnum.admin;
}
```

---

## ✅ 实现步骤

1. **安装依赖包** - 在 pubspec.yaml 添加 qr_flutter
2. **创建控制器** - 实现 ProjectMemberInviteController 和 JoinProjectController
3. **创建 UI 组件** - 实现 InviteLinkTab 和 AddMemberTab
4. **创建加入页面** - 实现 JoinProjectView
5. **配置路由** - 添加 /join/:inviteCode 路由
6. **更新现有页面** - 在成员列表和设置页面中集成新功能
7. **测试功能** - 测试邀请链接生成、加入流程、成员管理等

---

## 🧪 测试要点

1. **邀请链接生成** - 测试不同角色、有效期、使用次数的组合
2. **二维码扫描** - 测试二维码是否正确指向邀请链接
3. **成员上限检查** - 测试达到上限时的提示
4. **权限控制** - 测试 Owner/Admin 的权限区别
5. **加入流程** - 测试各种错误状态（过期、已满、无效等）
6. **响应式UI** - 测试不同屏幕尺寸下的显示

---

## 📖 参考资源

- [qr_flutter 文档](https://pub.dev/packages/qr_flutter)
- [GetX 状态管理](https://pub.dev/packages/get)
- [Flutter Material 组件](https://docs.flutter.dev/ui/widgets/material)

---

**祝您实现顺利！如有问题，随时询问。** 🚀

