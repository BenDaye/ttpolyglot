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
                    controller.searchQuery.isEmpty ? '请输入用户名、邮箱搜索用户' : '未找到匹配的用户',
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
                backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                child: user.avatarUrl == null && user.username.isNotEmpty ? Text(user.username[0].toUpperCase()) : null,
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
              DropdownButtonFormField<ProjectRoleEnum>(
                value: controller.selectedRole,
                decoration: const InputDecoration(
                  labelText: '角色权限',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                items: const [
                  DropdownMenuItem(value: ProjectRoleEnum.viewer, child: Text('查看者')),
                  DropdownMenuItem(value: ProjectRoleEnum.member, child: Text('成员')),
                  DropdownMenuItem(value: ProjectRoleEnum.admin, child: Text('管理员')),
                ],
                onChanged: (value) {
                  if (value != null) controller.setRole(value);
                },
              ),

              const SizedBox(height: 12.0),

              // 添加按钮
              ElevatedButton(
                onPressed: selectedCount > 0 && !controller.isAdding ? controller.addSelectedMembers : null,
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
