# 项目成员邀请功能设计文档

## 📋 目录

- [功能概述](#功能概述)
- [数据库设计](#数据库设计)
- [后端 API 设计](#后端-api-设计)
- [前端实现方案](#前端实现方案)
- [UI/UX 设计](#uiux-设计)
- [权限控制](#权限控制)
- [成员上限管理](#成员上限管理)
- [实现步骤](#实现步骤)
- [邀请链接与二维码统一设计](#邀请链接与二维码统一设计)
- [依赖包](#依赖包)
- [安全考虑](#安全考虑)
- [监控和日志](#监控和日志)
- [未来扩展](#未来扩展)
- [附录](#附录)

---

## 功能概述

### 核心需求

项目成员邀请功能支持两种方式：

1. **邀请链接/二维码**（适合外部邀请）
   - 生成唯一的邀请链接
   - 自动生成对应的二维码
   - **核心原理**：
     - ✨ **链接和二维码是同一个 URL 的两种展现形式**
     - 📋 复制链接分享 → 点击打开加入页面
     - 📱 扫描二维码 → 跳转到同一个 URL → 打开加入页面
     - 🔄 两者本质完全相同，只是触发方式不同（手动点击 vs 扫码）
   - 可设置有效期、使用次数、默认角色
   - **UI 布局（一体化展示）**：
     - 🔗 上方：邀请链接文本（可一键复制、分享）
     - 📱 下方：邀请二维码图片（内容=上方链接，可保存、截图分享）
     - 💡 说明：扫描二维码后跳转到上方链接

2. **直接添加成员**（适合内部已知用户）
   - 通过用户名/邮箱搜索用户
   - 选择角色后直接添加
   - 支持批量添加多个用户
   - 立即生效，无需用户确认

3. **加入页面** (`/join/:inviteCode`)
   - 用户点击邀请链接或扫描二维码后打开的独立页面
   - 显示项目信息、邀请人、将获得的角色等
   - 提供"接受邀请"和"拒绝"按钮
   - 处理各种错误状态（过期、已满、无效等）

4. **成员上限管理**
   - 每个项目有独立的成员上限（存储在 `projects.member_limit` 字段）
   - 创建项目时默认上限为 10 人
   - **仅项目所有者（Owner）可以在项目设置中修改上限**（1-1000 人）
   - 管理员（Admin）和其他成员无权修改成员上限
   - 修改上限时需满足：新上限 >= 当前成员数
   - 添加成员前自动检查是否超过上限

---

## 数据库设计

### 设计决策：融合邀请表到成员表

**设计思路：**

原本计划创建独立的 `project_invites` 表来管理邀请链接，但经过重新思考，我们决定将邀请功能直接融合到 `project_members` 表中。这样做有以下优势：

**优势：**
1. **简化数据结构**：减少一张表，降低数据库复杂度
2. **统一管理**：成员和邀请都在同一张表，便于查询和管理
3. **原子性更好**：接受邀请时，只需更新一条记录，而非删除邀请记录+创建成员记录
4. **减少冗余**：避免 project_id、invited_by、role 等字段重复存储

**实现方式：**

`project_members` 表通过 `user_id` 和 `invite_code` 字段区分两种记录类型：

1. **成员记录**：`user_id` 有值，`invite_code` 为 NULL
   - 表示已加入项目的成员
   
2. **邀请链接记录**：`user_id` 为 NULL，`invite_code` 有值
   - 表示待使用的邀请链接
   - 当用户通过邀请链接加入时，会创建新的成员记录，并增加该邀请记录的 `used_count`

**数据约束：**

通过 `CHECK` 约束确保每条记录只能是其中一种类型：
```sql
CHECK (
  (user_id IS NOT NULL AND invite_code IS NULL) OR 
  (user_id IS NULL AND invite_code IS NOT NULL)
)
```

---

### 1. 修改 `projects` 表

在 `006_projects_table.dart` 中添加 `member_limit` 字段：

```sql
ALTER TABLE projects 
ADD COLUMN member_limit INTEGER DEFAULT 10 NOT NULL;

-- 添加约束：成员上限必须大于 0 且不超过 1000
ALTER TABLE projects 
ADD CONSTRAINT projects_member_limit_check 
CHECK (member_limit > 0 AND member_limit <= 1000);
```

**字段说明：**
- `member_limit`: 项目成员上限，创建时默认 10 人
- 约束确保上限在合理范围内（1-1000）
- Owner 可以在项目设置页面中修改此值
- 修改时需要验证：新上限 >= 当前成员数

### 2. 扩展 `project_members` 表（融合邀请功能）

在已有的 `Migration018ProjectMembersTable` 中扩展字段，使其同时支持：
1. **已加入成员记录**：有 user_id，表示已加入的成员
2. **邀请链接记录**：user_id 为 NULL，有 invite_code，表示待使用的邀请链接

**扩展字段：**

```sql
-- 在 project_members 表中添加邀请相关字段
ALTER TABLE project_members 
  ALTER COLUMN user_id DROP NOT NULL,  -- 改为可为 NULL，邀请链接记录不需要 user_id
  ADD COLUMN invite_code UUID UNIQUE,  -- 邀请码，仅邀请链接记录有值
  ADD COLUMN expires_at TIMESTAMPTZ,   -- 过期时间（NULL 表示永久有效）
  ADD COLUMN max_uses INTEGER,         -- 最大使用次数（NULL 表示无限次）
  ADD COLUMN used_count INTEGER DEFAULT 0;  -- 已使用次数

-- 添加索引
CREATE INDEX idx_project_members_invite_code ON project_members(invite_code);
CREATE INDEX idx_project_members_expires_at ON project_members(expires_at);

-- 添加约束：确保记录类型的一致性
-- 要么是成员记录（有 user_id），要么是邀请链接记录（有 invite_code）
ALTER TABLE project_members 
ADD CONSTRAINT project_members_type_check 
CHECK (
  (user_id IS NOT NULL AND invite_code IS NULL) OR 
  (user_id IS NULL AND invite_code IS NOT NULL)
);
```

**字段说明：**

**已有字段（调整）：**
- `user_id`: 用户ID，**改为可为 NULL**。已加入成员有值，邀请链接记录为 NULL
- `status`: 状态，扩展支持更多值：
  - 成员记录：`pending`（待确认）、`active`（活跃）、`inactive`（停用）
  - 邀请链接：`active`（有效）、`expired`（过期）、`revoked`（已撤销）

**新增字段：**
- `invite_code`: UUID 格式的唯一邀请码，仅邀请链接记录有值
- `expires_at`: 过期时间（NULL 表示永久有效）
- `max_uses`: 最大使用次数（NULL 表示无限次）
- `used_count`: 已使用次数

**数据约束：**
- 通过 CHECK 约束确保每条记录要么是成员记录（有 user_id），要么是邀请链接记录（有 invite_code）
- `invite_code` 字段设置 UNIQUE 约束，确保邀请码唯一

### 3. 创建 `project_member_invite_logs` 表（可选）

记录邀请链接的使用历史：

```sql
CREATE TABLE project_member_invite_logs (
  id SERIAL PRIMARY KEY,
  member_id INTEGER NOT NULL,  -- 关联 project_members 表中的邀请链接记录
  user_id UUID NOT NULL,       -- 使用邀请的用户
  accepted BOOLEAN DEFAULT false,
  accepted_at TIMESTAMPTZ,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (member_id) REFERENCES project_members(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## 后端 API 设计

### 1. 邀请链接相关 API

#### 1.1 生成邀请链接

```
POST /api/projects/{projectId}/invites
```

**请求体：**
```json
{
  "role": "member",           // 角色：owner/admin/member/viewer
  "expiresIn": 7,            // 有效期（天），null=永久
  "maxUses": null            // 最大使用次数，null=无限
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": 123,
    "inviteCode": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "inviteUrl": "https://app.ttpolyglot.com/join/a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "qrCodeUrl": "https://api.ttpolyglot.com/qr/a1b2c3d4...",
    "role": "member",
    "expiresAt": "2025-11-04T12:00:00Z",
    "maxUses": null,
    "usedCount": 0
  }
}
```

**权限：** Owner, Admin

**业务逻辑：**
1. 检查用户是否有邀请权限（Owner/Admin）
2. 检查项目当前成员数是否已达上限
3. 生成唯一的 UUID 作为邀请码
4. 保存到数据库
5. 返回邀请链接和二维码

#### 1.2 获取邀请信息

```
GET /api/invites/{inviteCode}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "inviteCode": "a1b2c3d4-...",
    "project": {
      "id": 1,
      "name": "我的翻译项目",
      "description": "项目描述",
      "currentMemberCount": 8,
      "memberLimit": 10
    },
    "inviter": {
      "id": "user-uuid",
      "username": "zhangsan",
      "displayName": "张三"
    },
    "role": "member",
    "expiresAt": "2025-11-04T12:00:00Z",
    "isExpired": false,
    "isAvailable": true,
    "remainingUses": null
  }
}
```

**权限：** 公开（无需登录）

**业务逻辑：**
1. 根据邀请码查询邀请信息
2. 检查邀请是否过期
3. 检查邀请是否已达使用次数上限
4. 检查项目是否已达成员上限
5. 返回项目和邀请者信息

#### 1.3 接受邀请

```
POST /api/invites/{inviteCode}/accept
```

**请求头：**
```
Authorization: Bearer {token}
```

**响应：**
```json
{
  "success": true,
  "message": "成功加入项目",
  "data": {
    "projectId": 1,
    "role": "member"
  }
}
```

**权限：** 需要登录

**业务逻辑：**
1. 验证用户已登录
2. 验证邀请码有效性（未过期、未达使用上限）
3. 检查用户是否已是项目成员
4. 检查项目是否已达成员上限
5. 将用户添加为项目成员
6. 增加邀请使用次数
7. 记录邀请日志
8. 返回成功消息

#### 1.4 获取项目的所有邀请链接

```
GET /api/projects/{projectId}/invites
```

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": 123,
      "inviteCode": "a1b2c3d4-...",
      "role": "member",
      "expiresAt": "2025-11-04T12:00:00Z",
      "maxUses": 10,
      "usedCount": 3,
      "status": "active",
      "createdBy": "张三",
      "createdAt": "2025-10-28T12:00:00Z"
    }
  ]
}
```

**权限：** Owner, Admin

#### 1.5 删除/撤销邀请链接

```
DELETE /api/projects/{projectId}/invites/{inviteId}
```

**权限：** Owner, Admin

**业务逻辑：**
1. 将邀请状态设置为 `revoked`
2. 该邀请链接立即失效

### 2. 用户搜索 API

#### 2.1 搜索用户

```
GET /api/users/search?q={keyword}
```

**查询参数：**
- `q`: 搜索关键词（用户名、邮箱、显示名）
- `limit`: 返回结果数量，默认 10

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": "user-uuid",
      "username": "zhangsan",
      "displayName": "张三",
      "email": "zhangsan@example.com",
      "avatarUrl": "https://..."
    }
  ]
}
```

**权限：** 需要登录

**业务逻辑：**
1. 在用户表中搜索匹配的用户
2. 支持模糊搜索（ILIKE）
3. 排除当前用户自己
4. 返回匹配的用户列表

### 3. 成员管理 API

#### 3.1 直接添加成员

```
POST /api/projects/{projectId}/members
```

**请求体：**
```json
{
  "userId": "user-uuid",
  "role": "member"
}
```

**权限：** Owner, Admin

**业务逻辑：**
1. 检查权限
2. **检查项目成员上限**
3. 检查用户是否已是成员
4. 添加用户为项目成员
5. 更新 `projects.members_count`

#### 3.2 更新成员角色

```
PATCH /api/projects/{projectId}/members/{userId}
```

**请求体：**
```json
{
  "role": "admin"
}
```

**权限：** 
- Owner 可以修改任何人
- Admin 只能修改 Member/Viewer

#### 3.3 移除成员

```
DELETE /api/projects/{projectId}/members/{userId}
```

**权限：** 
- Owner 可以移除任何人（除了自己）
- Admin 只能移除 Member/Viewer

**业务逻辑：**
1. 更新 `project_members.is_active = false`
2. 更新 `projects.members_count`

#### 3.4 更新项目成员上限

```
PATCH /api/projects/{projectId}/member-limit
```

**请求体：**
```json
{
  "memberLimit": 20
}
```

**响应：**
```json
{
  "success": true,
  "message": "成员上限已更新",
  "data": {
    "projectId": 1,
    "memberLimit": 20,
    "currentMemberCount": 8
  }
}
```

**权限：** 仅 Owner（项目所有者）

**业务逻辑：**
1. **严格验证用户是项目 Owner**（不是 Admin）
2. 验证新上限 >= 当前成员数（不能小于现有成员数）
3. 验证新上限在合理范围内（1 <= newLimit <= 1000）
4. 更新 `projects.member_limit`
5. 返回更新后的项目信息

**权限检查：**
```sql
-- 验证用户是否为项目 Owner
SELECT COUNT(*) FROM projects 
WHERE id = @project_id 
  AND owner_id = @user_id;
```

**错误处理：**
- 如果用户不是 Owner：返回 403 错误，提示"只有项目所有者可以修改成员上限"
- 如果新上限 < 当前成员数：返回 400 错误，提示"新上限不能小于当前成员数(X)"
- 如果新上限 > 1000：返回 400 错误，提示"成员上限不能超过 1000"
- 如果新上限 < 1：返回 400 错误，提示"成员上限至少为 1"

---

## 前端实现方案

### 1. 数据模型

#### Project 模型扩展

```dart
class Project {
  final String id;
  final String name;
  final String description;
  final int memberLimit;        // 新增
  final int membersCount;       // 已有
  
  // Getter
  int get currentMemberCount => membersCount;
  bool get isMemberLimitReached => membersCount >= memberLimit;
  int get remainingSlots => memberLimit - membersCount;
}
```

#### ProjectInvite 模型

```dart
class ProjectInvite {
  final int id;
  final String inviteCode;
  final String inviteUrl;
  final int projectId;
  final String invitedBy;
  final ProjectRoleEnum role;
  final DateTime? expiresAt;
  final int? maxUses;
  final int usedCount;
  final InviteStatus status;
  final DateTime createdAt;
  
  bool get isExpired => 
    expiresAt != null && DateTime.now().isAfter(expiresAt!);
  
  bool get isUsesExhausted => 
    maxUses != null && usedCount >= maxUses!;
  
  bool get isAvailable => 
    status == InviteStatus.active && 
    !isExpired && 
    !isUsesExhausted;
}

enum InviteStatus { active, expired, revoked }
```

### 2. API 客户端

#### ProjectApi 扩展

```dart
class ProjectApi {
  // 邀请链接
  Future<ProjectInvite> generateInviteLink({
    required int projectId,
    required ProjectRoleEnum role,
    int? expiresInDays,
    int? maxUses,
  });
  
  Future<List<ProjectInvite>> getProjectInvites(int projectId);
  
  Future<void> revokeInvite(int projectId, int inviteId);
  
  Future<InviteInfo> getInviteInfo(String inviteCode);
  
  Future<void> acceptInvite(String inviteCode);
  
  // 用户搜索
  Future<List<UserSearchResult>> searchUsers(String query, {int limit = 10});
  
  // 成员管理
  Future<void> addProjectMember({
    required int projectId,
    required String userId,
    required ProjectRoleEnum role,
  });
  
  Future<void> updateMemberRole({
    required int projectId,
    required String userId,
    required ProjectRoleEnum role,
  });
  
  Future<void> removeMember(int projectId, String userId);
  
  // 成员上限
  Future<void> updateMemberLimit({
    required int projectId,
    required int newLimit,
  });
  
  // 验证成员上限（可选，前端验证用）
  bool validateMemberLimit({
    required int newLimit,
    required int currentMemberCount,
  }) {
    return newLimit >= currentMemberCount && 
           newLimit >= 1 && 
           newLimit <= 1000;
  }
}
```

### 3. 控制器

#### ProjectMemberInviteController

```dart
class ProjectMemberInviteController extends GetxController {
  final String projectId;
  
  // Tab 控制
  final _currentTab = 0.obs;  // 0: 邀请链接, 1: 直接添加
  
  // 邀请链接相关
  final _selectedRole = ProjectRoleEnum.member.obs;
  final _expiresIn = Rxn<int>(7);  // 7天
  final _maxUses = Rxn<int>();     // 无限
  final _generatedInvite = Rxn<ProjectInvite>();
  final _inviteList = <ProjectInvite>[].obs;
  final _isGenerating = false.obs;
  
  // 直接添加相关
  final _searchQuery = ''.obs;
  final _searchResults = <UserSearchResult>[].obs;
  final _selectedUsers = <UserSearchResult>[].obs;
  final _isSearching = false.obs;
  
  // 成员上限
  int get currentMemberCount => project?.membersCount ?? 0;
  int get memberLimit => project?.memberLimit ?? 10;
  bool get canInvite => currentMemberCount < memberLimit;
  int get remainingSlots => memberLimit - currentMemberCount;
  
  // 邀请链接方法
  Future<void> generateInviteLink();           // 生成邀请链接和二维码
  void copyInviteLink(String url);             // 复制链接到剪贴板
  Future<void> saveQRCode();                   // 保存二维码图片
  Future<void> shareInviteLink();              // 分享邀请链接（可选）
  
  // 直接添加方法
  Future<void> searchUsers(String query);
  void toggleUserSelection(UserSearchResult user);
  Future<void> addSelectedMembers();
  
  // 检查是否可以添加更多成员
  bool canAddMembers(int count) => 
    currentMemberCount + count <= memberLimit;
}
```

#### JoinProjectController

处理加入项目页面的逻辑（`/join/:inviteCode`）。

```dart
class JoinProjectController extends GetxController {
  final String inviteCode;
  
  // 状态
  final _inviteInfo = Rxn<InviteInfo>();
  final _isLoading = true.obs;
  final _error = Rxn<String>();
  final _isAccepting = false.obs;
  
  // Getters
  InviteInfo? get inviteInfo => _inviteInfo.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  bool get isAccepting => _isAccepting.value;
  
  bool get isValid => inviteInfo != null && 
                      !inviteInfo!.isExpired && 
                      !inviteInfo!.isUsesExhausted &&
                      inviteInfo!.project.currentMemberCount < inviteInfo!.project.memberLimit;
  
  @override
  void onInit() {
    super.onInit();
    loadInviteInfo();
  }
  
  // 加载邀请信息
  Future<void> loadInviteInfo() async {
    try {
      _isLoading.value = true;
      _error.value = null;
      
      final info = await ProjectApi.getInviteInfo(inviteCode);
      _inviteInfo.value = info;
    } catch (e, stackTrace) {
      log('[loadInviteInfo]', error: e, stackTrace: stackTrace, name: 'JoinProjectController');
      _error.value = _getErrorMessage(e);
    } finally {
      _isLoading.value = false;
    }
  }
  
  // 接受邀请
  Future<void> acceptInvite() async {
    if (!isValid) return;
    
    try {
      _isAccepting.value = true;
      await ProjectApi.acceptInvite(inviteCode);
      
      // 成功后跳转到项目页面
      Get.offNamed('/projects/${inviteInfo!.project.id}');
      
      // 显示成功提示
      Get.snackbar('成功', '你已成功加入项目 ${inviteInfo!.project.name}');
    } catch (e, stackTrace) {
      log('[acceptInvite]', error: e, stackTrace: stackTrace, name: 'JoinProjectController');
      Get.snackbar('失败', _getErrorMessage(e));
    } finally {
      _isAccepting.value = false;
    }
  }
  
  // 拒绝邀请
  void declineInvite() {
    Get.back();
  }
  
  String _getErrorMessage(dynamic error) {
    // 根据错误类型返回友好的错误信息
    if (error is ApiException) {
      switch (error.code) {
        case 404:
          return '邀请链接不存在或已被撤销';
        case 403:
          return '你已经是项目成员';
        case 410:
          return '邀请链接已过期';
        case 423:
          return '项目成员已达上限';
        default:
          return error.message ?? '未知错误';
      }
    }
    return '网络连接失败，请稍后重试';
  }
}
```

---

## UI/UX 设计

### 1. 成员列表页面（project_members_view.dart）

```
┌──────────────────────────────────────────────────────────┐
│  👥 成员管理                                              │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │ 📊 项目成员 (8/10)              [邀请成员] 按钮    │ │
│  │ ▓▓▓▓▓▓▓▓░░ 80%                                    │ │
│  │ 💡 还可以邀请 2 人                                  │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  成员列表：                                               │
│  ┌────────────────────────────────────────────────────┐ │
│  │ 👤 张三 (zhangsan@example.com)      [所有者]  ⋮   │ │
│  ├────────────────────────────────────────────────────┤ │
│  │ 👤 李四 (lisi@example.com)          [管理员]  ⋮   │ │
│  ├────────────────────────────────────────────────────┤ │
│  │ 👤 王五 (wangwu@example.com)        [成员]    ⋮   │ │
│  └────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘

--- 达到上限时 ---

┌──────────────────────────────────────────────────────────┐
│  ⚠️ 项目成员已达上限 (10/10)       [邀请成员] 禁用      │
│  ▓▓▓▓▓▓▓▓▓▓ 100%                                        │
│  💡 请先移除部分成员，或在设置中提升成员上限              │
└──────────────────────────────────────────────────────────┘
```

### 2. 邀请成员对话框

对话框支持两种模式，通过顶部的标签页切换：

```
┌─────────────────────────────────────────────────────────┐
│  邀请成员到项目                                     ✕   │
├─────────────────────────────────────────────────────────┤
│  📊 当前成员: 8/10  |  💡 还可以邀请 2 人              │
├─────────────────────────────────────────────────────────┤
│  [邀请链接]  [直接添加]                                │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Tab 1: 邀请链接                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │ 📋 邀请设置                                       │ │
│  │                                                   │ │
│  │ 角色权限      [Member      ▼]                    │ │
│  │                                                   │ │
│  │ 有效期        [7天          ▼]                   │ │
│  │               ○ 7天  ○ 30天  ○ 永久               │ │
│  │                                                   │ │
│  │ 使用次数      [无限制        ▼]                  │ │
│  │               ○ 1次  ○ 10次  ○ 无限               │ │
│  │                                                   │ │
│  │ [生成邀请链接]                                    │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │ 🔗 邀请链接                                       │ │
│  │                                                   │ │
│  │ https://app.ttpolyglot.com/join/a1b2c3d4-...     │ │
│  │                                                   │ │
│  │ [📋 复制链接]  [🔗 分享]                         │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │ 📱 邀请二维码                                     │ │
│  │                                                   │ │
│  │          ┌─────────────────┐                     │ │
│  │          │                 │                     │ │
│  │          │                 │                     │ │
│  │          │    QR CODE      │                     │ │
│  │          │                 │                     │ │
│  │          │                 │                     │ │
│  │          └─────────────────┘                     │ │
│  │                                                   │ │
│  │     扫描二维码加入项目                             │ │
│  │     （扫码后跳转到上方链接）                        │ │
│  │                                                   │ │
│  │ [💾 保存二维码]                                   │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │ 📊 邀请信息                                       │ │
│  │                                                   │ │
│  │ 💡 有效期至: 2025-11-04                           │ │
│  │ 📊 已使用: 0 / 无限次                             │ │
│  │ 👥 邀请角色: 成员                                 │ │
│  │ 📅 创建时间: 2025-10-28 15:30                     │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  ---                                                    │
│                                                         │
│  Tab 2: 直接添加                                        │
│  ┌───────────────────────────────────────────────────┐ │
│  │ 🔍 搜索用户（用户名、邮箱）                       │ │
│  │ [_________________]                               │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  搜索结果：                                             │
│  ┌───────────────────────────────────────────────────┐ │
│  │ ☐ 👤 赵六 (zhaoliu@example.com)                  │ │
│  │ ☑ 👤 孙七 (sunqi@example.com)                    │ │
│  │ ☐ 👤 周八 (zhouba@example.com)                   │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  已选择 1 人                                            │
│  角色权限  [Member      ▼]                             │
│                                                         │
│  [添加选中用户]                                         │
└─────────────────────────────────────────────────────────┘
```

### 3. 加入项目页面 (/join/:inviteCode)

用户点击邀请链接或扫描二维码后，会打开这个独立页面。

**路由说明：**
- 链接格式：`https://app.ttpolyglot.com/join/{inviteCode}`
- 二维码内容：同上链接
- 点击链接和扫码本质相同，都跳转到此页面

```
┌─────────────────────────────────────────────────────────┐
│                      TTPolyglot                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│               你收到了一个项目邀请                        │
│                                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │                                                   │ │
│  │  📦 我的翻译项目                                  │ │
│  │  这是一个多语言翻译管理项目                        │ │
│  │                                                   │ │
│  │  👤 邀请人：张三 (zhangsan)                       │ │
│  │  🎭 你的角色：成员                                │ │
│  │  👥 当前成员：8 / 10                              │ │
│  │  ⏰ 邀请有效期至：2025-11-04                       │ │
│  │                                                   │ │
│  │  作为成员，你可以：                                │ │
│  │  ✓ 翻译词条                                       │ │
│  │  ✓ 提交翻译                                       │ │
│  │  ✓ 查看项目进度                                   │ │
│  │                                                   │ │
│  │  [接受邀请]  [拒绝]                               │ │
│  │                                                   │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘

--- 错误状态 ---

☹️ 邀请链接已过期
该邀请链接已于 2025-10-20 过期

---

⚠️ 项目成员已满
该项目成员已达上限 (10/10)，暂时无法加入

---

🚫 邀请链接无效
该邀请链接不存在或已被撤销

---

ℹ️ 你已经是项目成员
你已经是该项目的成员，无需重复加入
[前往项目]
```

### 4. 项目设置 - 成员上限配置

> 注：此部分在项目设置页面中，而非邀请成员对话框

```
┌─────────────────────────────────────────────────────────┐
│  项目设置                                               │
├─────────────────────────────────────────────────────────┤
│  基本信息                                               │
│  语言设置                                               │
│  ➤ 成员管理                                             │
│    ├ 成员列表                                           │
│    └ 成员上限设置                                       │
│                                                         │
│  ─────────────────────────────────────────────────────  │
│                                                         │
│  👥 成员上限设置                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │                                                   │ │
│  │ 当前设置                                          │ │
│  │ ┌─────────────────────────────────────────────┐ │ │
│  │ │ 成员上限      [10        ] 人  [修改]      │ │ │
│  │ │ 当前成员       8 人                         │ │ │
│  │ │ 可用名额       2 个                         │ │ │
│  │ └─────────────────────────────────────────────┘ │ │
│  │                                                   │ │
│  │ 修改成员上限                                      │ │
│  │ ┌─────────────────────────────────────────────┐ │ │
│  │ │ 新的上限      [_________] 人                │ │ │
│  │ │                                             │ │ │
│  │ │ 💡 建议范围：5-50 人                        │ │ │
│  │ │ 📊 允许范围：1-1000 人                      │ │ │
│  │ │                                             │ │ │
│  │ │ ⚠️ 提示：                                   │ │ │
│  │ │ • 新上限不能小于当前成员数 (8)              │ │ │
│  │ │ • 修改上限不会移除现有成员                  │ │ │
│  │ │ • 建议根据团队规模合理设置                  │ │ │
│  │ └─────────────────────────────────────────────┘ │ │
│  │                                                   │ │
│  │ 权限说明                                          │ │
│  │ ℹ️ 只有项目所有者（Owner）可以修改成员上限         │ │
│  │ ⚠️ 管理员（Admin）和其他成员无此权限               │ │
│  │                                                   │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  [保存更改]  [取消]                                     │
│                                                         │
└─────────────────────────────────────────────────────────┘

--- 保存成功 ---

✅ 成员上限已更新为 20 人

--- 非 Owner 访问时 ---

┌─────────────────────────────────────────────────────────┐
│  👥 成员上限设置                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │                                                   │ │
│  │ 当前设置（只读）                                  │ │
│  │ ┌─────────────────────────────────────────────┐ │ │
│  │ │ 成员上限       10 人                        │ │ │
│  │ │ 当前成员        8 人                        │ │ │
│  │ │ 可用名额        2 个                        │ │ │
│  │ └─────────────────────────────────────────────┘ │ │
│  │                                                   │ │
│  │ ℹ️ 您当前的角色：管理员                            │ │
│  │ ⚠️ 只有项目所有者可以修改成员上限                  │ │
│  │                                                   │ │
│  └───────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

## 权限控制

### 角色权限矩阵

| 功能 | Owner | Admin | Member | Viewer |
|------|-------|-------|--------|--------|
| 生成邀请链接 | ✅ | ✅ | ❌ | ❌ |
| 直接添加成员 | ✅ | ✅ | ❌ | ❌ |
| 修改成员角色 | ✅ | ✅ (限制) | ❌ | ❌ |
| 移除成员 | ✅ | ✅ (限制) | ❌ | ❌ |
| 修改成员上限 | ✅ | ❌ | ❌ | ❌ |
| 撤销邀请链接 | ✅ | ✅ | ❌ | ❌ |
| **修改项目设置** | **✅** | **❌** | **❌** | **❌** |
| 转移项目所有权 | ✅ | ❌ | ❌ | ❌ |
| 删除项目 | ✅ | ❌ | ❌ | ❌ |

**权限说明：**

**Owner（项目所有者）：**
- 拥有项目的完全控制权
- **唯一可以修改项目设置的角色**（包括成员上限、项目信息等）
- 可以管理所有成员（包括其他 Owner 和 Admin）
- 可以转移项目所有权
- 可以删除项目

**Admin（管理员）的限制：**
- 只能修改/移除 Member 和 Viewer 角色的成员
- 不能修改/移除 Owner 和其他 Admin
- **不能修改项目设置**（包括成员上限、项目名称、描述等）
- 不能转移项目所有权
- 不能删除项目

---

## 成员上限管理

### 上限设置

1. **项目级别上限（仅 Owner 可修改）**
   - 存储在 `projects.member_limit` 字段
   - 创建项目时默认值：10 人
   - **仅项目所有者（Owner）可在项目设置中修改**
   - 管理员（Admin）和其他角色无权修改
   - 可配置范围：1-1000 人
   - 修改限制：
     - 必须是项目 Owner
     - 新上限必须 >= 当前成员数
     - 新上限必须 <= 1000（系统最大限制）
     - 新上限必须 >= 1（最小限制）

2. **系统级别限制（不可修改）**
   - 硬编码最大值：1000 人
   - 通过数据库约束强制执行：`CHECK (member_limit > 0 AND member_limit <= 1000)`
   - 所有项目都不能超过此限制

### 上限检查时机

1. **生成邀请链接时**
   - 检查当前成员数 < member_limit
   - 如果已达上限，提示用户

2. **直接添加成员时**
   - 检查 (当前成员数 + 要添加的人数) <= member_limit
   - 批量添加时，如果部分超过上限，只添加允许的数量

3. **通过邀请链接加入时**
   - 检查当前成员数 < member_limit
   - 如果已满，显示友好提示

### 超过上限的处理

**前端提示：**
```
⚠️ 项目成员已达上限 (10/10)

您可以：
1. 在项目设置中提升成员上限
2. 移除部分不活跃的成员
```

---

## 实现步骤

### Phase 1: 数据库和后端基础（第1-4天）

- [x] TODO 1: 修改 projects 表，添加 member_limit 字段
- [ ] TODO 2: 扩展 project_members 表，添加邀请相关字段（融合邀请功能）
- [ ] TODO 3: 更新 ProjectModel 和 ProjectMemberModel
- [ ] TODO 4: 实现用户搜索 API
- [ ] TODO 5: 在添加成员时检查成员上限
- [ ] TODO 6: 实现更新成员上限 API

### Phase 2: 邀请链接功能（第5-7天）

- [ ] TODO 7: 实现邀请链接 API
  - 生成邀请链接（在 project_members 表中创建邀请记录）
  - 获取邀请信息（查询邀请记录）
  - 接受邀请（更新邀请记录，创建成员记录）
  - 撤销邀请（更新邀请记录状态为 revoked）

### Phase 3: 前端数据层（第8-9天）

- [ ] TODO 8: 更新前端 Project 和 ProjectMember 模型
- [ ] TODO 9: 实现 ProjectApi 所有方法（包括邀请相关接口）

### Phase 4: 前端 UI（第10-15天）

- [ ] TODO 10: 创建邀请成员对话框控制器（ProjectMemberInviteController）
- [ ] TODO 11: 创建邀请链接 Tab UI
  - 邀请设置表单（角色、有效期、使用次数）
  - 邀请链接展示区（上方，可复制）
  - 邀请二维码展示区（下方，使用 qr_flutter 生成）
  - 邀请信息统计卡片
  - 复制、分享、保存二维码功能
- [ ] TODO 12: 创建直接添加成员 Tab UI
  - 用户搜索表单
  - 搜索结果列表（支持多选）
  - 角色选择
  - 批量添加功能
- [ ] TODO 13: 创建加入项目页面（JoinProjectView）和控制器（JoinProjectController）
  - 加载邀请信息
  - 显示项目详情和权限说明
  - 接受/拒绝邀请按钮
  - 错误状态处理（过期、已满、无效、已是成员等）
  - 成功后跳转到项目页面
- [ ] TODO 14: 添加 `/join/:inviteCode` 路由
- [ ] TODO 15: 更新成员列表页面，显示成员数量和上限
- [ ] TODO 16: 实现编辑/移除成员功能
- [ ] **TODO 17: 在项目设置中添加成员上限配置**
  - 显示当前配置（上限/成员数/可用名额）
  - 修改成员上限表单（带实时验证）
  - 集成保存功能（调用 updateMemberLimit API）
  - **严格的权限控制：**
    - Owner：显示可编辑表单，可以修改
    - Admin/Member/Viewer：显示只读信息，禁用编辑功能
    - 显示权限提示："只有项目所有者可以修改成员上限"
  - 友好的错误提示和成功反馈

### Phase 5: 测试和优化（第16天）

- [ ] TODO 18: 集成测试
- [ ] TODO 19: 优化和完善

---

## 邀请链接与二维码统一设计

### 1. 核心原理

邀请链接和二维码是同一个邀请机制的两种展现形式：

```
邀请链接生成
   ↓
生成 URL: https://app.ttpolyglot.com/join/{inviteCode}
   ↓
   ├─→ 文本链接（可复制、分享）
   │   用户点击 → 打开加入页面
   │
   └─→ 二维码图片（可扫描、保存）
       用户扫码 → 打开同一个链接 → 加入页面
```

**关键点：**
- 链接和二维码指向同一个 URL
- 两者只是触发方式不同，后续流程完全相同
- 都需要用户打开链接后在加入页面确认

### 2. 工作流程

**邀请者：**
```
1. 在项目成员页面点击"邀请成员"
   ↓
2. 切换到"邀请链接" Tab
   ↓
3. 设置角色、有效期、使用次数
   ↓
4. 点击"生成邀请链接"
   ↓
5. 获得：
   - 邀请链接（上方）：可复制、分享
   - 邀请二维码（下方）：可保存、截图分享
```

**被邀请者：**
```
方式 A：收到链接
1. 点击链接
   ↓
2. 浏览器/应用打开加入页面 (/join/{inviteCode})
   ↓
3. 查看项目信息和角色
   ↓
4. 点击"接受邀请"
   ↓
5. 成功加入项目

方式 B：收到二维码
1. 使用手机扫描二维码
   ↓
2. 跳转到同一个加入页面
   ↓
3-5. 后续流程与方式 A 相同
```

### 3. UI 布局设计

在邀请链接 Tab 中，采用上下结构：

```
┌───────────────────────────────────────┐
│ 📋 邀请设置                            │
│ [角色] [有效期] [使用次数]             │
│ [生成邀请链接]                         │
└───────────────────────────────────────┘
                 ↓
┌───────────────────────────────────────┐
│ 🔗 邀请链接                            │
│ https://app.ttpolyglot.com/join/...   │
│ [复制链接] [分享]                      │
└───────────────────────────────────────┘
                 ↓
┌───────────────────────────────────────┐
│ 📱 邀请二维码                          │
│      [二维码图片]                      │
│   扫描后跳转到上方链接                  │
│ [保存二维码]                           │
└───────────────────────────────────────┘
                 ↓
┌───────────────────────────────────────┐
│ 📊 邀请信息                            │
│ 有效期、使用次数、角色等统计            │
└───────────────────────────────────────┘
```

### 4. 技术实现

**生成邀请：**
```dart
Future<void> generateInviteLink() async {
  final invite = await ProjectApi.generateInviteLink(
    projectId: projectId,
    role: selectedRole,
    expiresInDays: expiresIn,
    maxUses: maxUses,
  );
  
  // invite.inviteUrl 是完整链接
  // 使用 qr_flutter 生成二维码图片
  // 二维码内容 = invite.inviteUrl
}
```

**二维码生成：**
```dart
QrImageView(
  data: invite.inviteUrl,  // 完整链接
  version: QrVersions.auto,
  size: 200.0,
)
```

**处理加入（/join/:inviteCode 页面）：**
```dart
// 无论是点击链接还是扫码，都会打开这个页面
class JoinProjectView extends StatelessWidget {
  final String inviteCode;
  
  // 1. 加载邀请信息
  // 2. 显示项目详情
  // 3. 用户点击"接受邀请"
  // 4. 调用 API 加入项目
}
```

### 5. 优势

✅ **统一原理**：链接和二维码本质相同，降低理解成本  
✅ **灵活分享**：可以选择复制链接或分享二维码图片  
✅ **跨平台**：链接适合桌面端，二维码适合移动端  
✅ **简单实现**：无需复杂的扫码逻辑，只需一个加入页面  
✅ **用户友好**：无论何种方式，最终都是在清晰的页面上确认加入  

---

## 依赖包

### 前端

```yaml
dependencies:
  qr_flutter: ^4.1.0           # 生成二维码（必需）
  flutter/services: ^0.0.0     # 复制到剪贴板（必需）
  get: ^4.6.6                  # 状态管理和路由（已有）
```

**可选：**
```yaml
  share_plus: ^7.2.1           # 分享邀请链接
  path_provider: ^2.1.0        # 保存二维码图片到本地
```

**说明：**
- `mobile_scanner` 不再需要，因为扫码由系统浏览器/手机相机处理
- 二维码扫描后直接打开链接，无需应用内扫码功能

### 后端

- 无需额外依赖，使用标准库

---

## 安全考虑

1. **邀请码安全**
   - 使用 UUID v4 生成唯一邀请码
   - 邀请码长度足够，防止暴力破解

2. **权限验证**
   - 所有 API 都进行权限检查
   - 使用中间件验证 JWT token

3. **速率限制**
   - 生成邀请链接：每个用户每小时最多 10 次
   - 接受邀请：每个 IP 每小时最多 5 次

4. **数据验证**
   - 验证所有输入参数
   - 防止 SQL 注入
   - 防止 XSS 攻击

---

## 监控和日志

1. **邀请链接使用情况**
   - 记录每次邀请链接的使用
   - 统计邀请转化率

2. **成员增长趋势**
   - 记录项目成员数变化
   - 分析成员活跃度

3. **错误日志**
   - 记录邀请失败原因
   - 监控成员上限相关错误

---

## 未来扩展

1. **邀请批准流程**
   - Owner 可设置邀请需要批准
   - 用户申请加入后等待批准

2. **邀请分析**
   - 查看哪些邀请链接最有效
   - 分析成员来源

3. **团队模板**
   - 预设成员角色和权限模板
   - 快速批量邀请

4. **邮件邀请**
   - 通过邮箱直接发送邀请
   - 自动发送欢迎邮件

---

## 附录

### A. 数据库 ER 图

```
┌─────────────┐         ┌───────────────────────┐         ┌─────────────┐
│   users     │         │  project_members      │         │  projects   │
├─────────────┤         ├───────────────────────┤         ├─────────────┤
│ id (PK)     │◄────────┤ user_id (FK,nullable) │────────►│ id (PK)     │
│ username    │         │ project_id (FK)       │         │ name        │
│ email       │         │ invited_by (FK)       │         │ member_limit│
└─────────────┘         │ role                  │         │ ...         │
       ▲                │ invite_code (unique)  │         └─────────────┘
       │                │ expires_at            │
       │                │ max_uses              │
       │                │ used_count            │
       └────────────────┤ status                │
        (invited_by)    │ joined_at             │
                        │ ...                   │
                        └───────────────────────┘
                                │
                                │
                                ▼
                   ┌──────────────────────────────┐
                   │ project_member_invite_logs   │
                   ├──────────────────────────────┤
                   │ id (PK)                      │
                   │ member_id (FK)               │
                   │ user_id (FK)                 │
                   │ accepted                     │
                   │ accepted_at                  │
                   │ ip_address                   │
                   │ user_agent                   │
                   └──────────────────────────────┘

说明：
- project_members 表同时存储两种记录：
  1. 成员记录：user_id 有值，invite_code 为 NULL
  2. 邀请链接记录：user_id 为 NULL，invite_code 有值
- 通过 CHECK 约束确保每条记录只能是其中一种类型
```

---

**文档版本：** v1.2  
**最后更新：** 2025-10-28  
**作者：** TTPolyglot Team

**更新日志：**
- v1.0 (2025-10-28): 初始版本

