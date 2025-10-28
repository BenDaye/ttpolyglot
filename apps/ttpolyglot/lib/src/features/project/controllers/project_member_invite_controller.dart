import 'dart:async';
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
  Timer? _searchDebounceTimer;

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

  /// 搜索用户（带防抖）
  void searchUsers(String query) {
    // 取消之前的定时器
    _searchDebounceTimer?.cancel();

    // 去除前后空格
    final trimmedQuery = query.trim();

    // 更新搜索关键字
    _searchQuery.value = trimmedQuery;

    // 如果输入为空，立即清空结果
    if (trimmedQuery.isEmpty) {
      _searchResults.clear();
      _isSearching.value = false;
      return;
    }

    // 如果少于2个字符，不搜索
    if (trimmedQuery.length < 2) {
      _searchResults.clear();
      return;
    }

    // 设置防抖定时器（500毫秒）
    _isSearching.value = true;
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(trimmedQuery);
    });
  }

  /// 执行实际的搜索请求
  Future<void> _performSearch(String query) async {
    try {
      final results = await _userApi.searchUsers(query: query, limit: 10);
      _searchResults.assignAll(results ?? []);
    } catch (error, stackTrace) {
      log('[_performSearch]', error: error, stackTrace: stackTrace, name: 'ProjectMemberInviteController');
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
    // 取消防抖定时器
    _searchDebounceTimer?.cancel();
    // 不需要手动关闭 Rx 变量，GetX 会自动处理
    // 手动关闭会导致 Obx widget 在 dispose 时出现 null check 错误
    super.onClose();
  }
}
