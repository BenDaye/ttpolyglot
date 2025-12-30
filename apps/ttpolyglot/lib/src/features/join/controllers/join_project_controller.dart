import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';

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

  bool get isValid => inviteInfo != null && !inviteInfo!.isExpired && inviteInfo!.isAvailable;

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
      Get.offNamed('/home/projects/${inviteInfo!.project.id}');

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
