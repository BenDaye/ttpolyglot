import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/join/controllers/join_project_controller.dart';
import 'package:ttpolyglot_model/model.dart';

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
        _buildDetailRow('🎭 你的角色', _getRoleName(invite.role)),
        _buildDetailRow('👥 当前成员', '${invite.project.currentMemberCount} / ${invite.project.memberLimit}'),
        if (invite.expiresAt != null) _buildDetailRow('⏰ 有效期至', _formatDate(invite.expiresAt!)),
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
    return Obx(
      () => Row(
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
      ),
    );
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

  String _getRoleName(ProjectRoleEnum role) {
    switch (role) {
      case ProjectRoleEnum.owner:
        return '所有者';
      case ProjectRoleEnum.admin:
        return '管理员';
      case ProjectRoleEnum.member:
        return '成员';
      case ProjectRoleEnum.viewer:
        return '查看者';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
