import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_member_invite_controller.dart';
import 'package:ttpolyglot_model/model.dart';

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
        Obx(() => DropdownButtonFormField<ProjectRoleEnum>(
              value: controller.selectedRole,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              items: const [
                DropdownMenuItem(value: ProjectRoleEnum.viewer, child: Text('查看者 - 只能查看')),
                DropdownMenuItem(value: ProjectRoleEnum.member, child: Text('成员 - 可以翻译')),
                DropdownMenuItem(value: ProjectRoleEnum.admin, child: Text('管理员 - 可以管理')),
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

    return Builder(
      builder: (context) => Card(
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
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        url,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.copyInviteLink,
                      icon: const Icon(Icons.copy),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRCode(Map<String, dynamic> invite) {
    final url = invite['invite_url'] as String;

    return Builder(
      builder: (context) => Card(
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
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
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
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              Text(
                '（扫码后跳转到上方链接）',
                style: TextStyle(fontSize: 12.0, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
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
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
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
