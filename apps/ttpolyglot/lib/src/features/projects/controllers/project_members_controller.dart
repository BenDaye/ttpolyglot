import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/api/api.dart';
import 'package:ttpolyglot_core/core.dart' hide ProjectRole;
import 'package:ttpolyglot_model/model.dart';

/// 项目成员管理控制器
class ProjectMembersController extends GetxController {
  final ProjectMemberApi _api = ProjectMemberApi();

  // 项目ID
  late final int projectId;

  // 成员列表
  final _members = <ProjectMemberModel>[].obs;
  List<ProjectMemberModel> get members => _members;

  // 加载状态
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // 角色过滤
  final _roleFilter = Rxn<String>();
  String? get roleFilter => _roleFilter.value;

  // 状态过滤
  final _statusFilter = 'active'.obs;
  String get statusFilter => _statusFilter.value;

  // 分页
  final _currentPage = 1.obs;
  int get currentPage => _currentPage.value;

  final _totalPages = 1.obs;
  int get totalPages => _totalPages.value;

  final _pageSize = 20.0;

  @override
  void onInit() {
    super.onInit();
    projectId = Get.arguments as int? ?? 0;
    loadMembers();
  }

  /// 加载成员列表
  Future<void> loadMembers({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading.value = true;
    }

    try {
      final response = await _api.getProjectMembers(
        projectId: projectId,
        page: _currentPage.value,
        limit: _pageSize.toInt(),
        role: _roleFilter.value,
        status: _statusFilter.value,
      );

      _members.value = response?.items ?? [];
      _totalPages.value = response?.totalPage ?? 1;
    } catch (error, stackTrace) {
      Logger.error('[loadMembers] 加载成员列表失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 邀请成员
  Future<void> inviteMember({
    required String userId,
    required String role,
  }) async {
    try {
      await _api.inviteMember(
        projectId: projectId,
        userId: userId,
        role: role,
      );

      Get.back(); // 关闭邀请对话框
      await loadMembers(showLoading: false); // 刷新列表
    } catch (error, stackTrace) {
      Logger.error('[inviteMember] 邀请成员失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '邀请成员失败: $error');
    }
  }

  /// 更新成员角色
  Future<void> updateMemberRole({
    required int memberId,
    required String role,
  }) async {
    try {
      await _api.updateMemberRole(
        projectId: projectId,
        memberId: memberId,
        role: role,
      );

      await loadMembers(showLoading: false); // 刷新列表
    } catch (error, stackTrace) {
      Logger.error('[updateMemberRole] 更新成员角色失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '更新成员角色失败: $error');
    }
  }

  /// 移除成员
  Future<void> removeMember(int memberId) async {
    try {
      // 确认对话框
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('确认移除成员'),
          content: const Text('确定要移除该成员吗？此操作无法撤销。'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('移除'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      await _api.removeMember(
        projectId: projectId,
        memberId: memberId,
      );

      await loadMembers(showLoading: false); // 刷新列表
    } catch (error, stackTrace) {
      Logger.error('[removeMember] 移除成员失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '移除成员失败: $error');
    }
  }

  /// 更新角色过滤
  void updateRoleFilter(String? role) {
    _roleFilter.value = role;
    _currentPage.value = 1;
    loadMembers();
  }

  /// 更新状态过滤
  void updateStatusFilter(String status) {
    _statusFilter.value = status;
    _currentPage.value = 1;
    loadMembers();
  }

  /// 上一页
  void previousPage() {
    if (_currentPage.value > 1) {
      _currentPage.value--;
      loadMembers();
    }
  }

  /// 下一页
  void nextPage() {
    if (_currentPage.value < _totalPages.value) {
      _currentPage.value++;
      loadMembers();
    }
  }

  /// 显示邀请成员对话框
  Future<void> showInviteMemberDialog() async {
    final userIdController = TextEditingController();
    String selectedRole = 'member';

    await Get.dialog(
      AlertDialog(
        title: const Text('邀请成员'),
        content: SizedBox(
          width: 400.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: '用户 ID',
                  hintText: '请输入用户 ID',
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  labelText: '角色',
                ),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('管理员')),
                  DropdownMenuItem(value: 'member', child: Text('成员')),
                  DropdownMenuItem(value: 'viewer', child: Text('查看者')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedRole = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final userId = userIdController.text.trim();
              if (userId.isEmpty) {
                Get.snackbar('错误', '请输入用户 ID');
                return;
              }

              inviteMember(userId: userId, role: selectedRole);
            },
            child: const Text('邀请'),
          ),
        ],
      ),
    );
  }

  /// 显示编辑角色对话框
  Future<void> showEditRoleDialog(ProjectMemberModel member) async {
    String selectedRole = member.role.value;

    await Get.dialog(
      AlertDialog(
        title: Text('编辑成员角色: ${member.displayName ?? member.username}'),
        content: DropdownButtonFormField<String>(
          value: selectedRole,
          decoration: const InputDecoration(
            labelText: '角色',
          ),
          items: const [
            DropdownMenuItem(value: 'admin', child: Text('管理员')),
            DropdownMenuItem(value: 'member', child: Text('成员')),
            DropdownMenuItem(value: 'viewer', child: Text('查看者')),
          ],
          onChanged: (value) {
            if (value != null) {
              selectedRole = value;
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              updateMemberRole(memberId: member.id, role: selectedRole);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
