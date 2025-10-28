import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';

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
  final _selectedRole = ProjectRoleEnum.member.obs;
  final _expiresIn = Rxn<int>(7); // 默认7天
  final _maxUses = Rxn<int>(); // 默认无限
  final _generatedInvite = Rxn<Map<String, dynamic>>();
  final _isGenerating = false.obs;

  ProjectRoleEnum get selectedRole => _selectedRole.value;
  int? get expiresIn => _expiresIn.value;
  int? get maxUses => _maxUses.value;
  Map<String, dynamic>? get generatedInvite => _generatedInvite.value;
  bool get isGenerating => _isGenerating.value;

  void setRole(ProjectRoleEnum role) => _selectedRole.value = role;
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
        role: _selectedRole.value.name,
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
          role: _selectedRole.value.name,
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
