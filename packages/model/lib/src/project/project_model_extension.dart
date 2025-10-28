import 'package:ttpolyglot_model/model.dart';

/// ProjectModel 扩展方法
extension ProjectModelExtension on ProjectModel {
  /// 获取当前成员数
  int get currentMemberCount => membersCount;

  /// 是否达到成员上限
  bool get isMemberLimitReached => membersCount >= memberLimit;

  /// 剩余可用名额
  int get remainingSlots => memberLimit - membersCount;

  /// 是否可以邀请更多成员
  bool get canInviteMembers => !isMemberLimitReached;

  /// 检查是否可以添加指定数量的成员
  bool canAddMembers(int count) => membersCount + count <= memberLimit;

  /// 成员占用百分比
  double get memberOccupancyPercentage => memberLimit > 0 ? (membersCount / memberLimit * 100.0) : 0.0;
}
