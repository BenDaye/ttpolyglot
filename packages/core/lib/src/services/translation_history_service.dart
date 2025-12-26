import 'package:ttpolyglot_model/model.dart';

/// 翻译历史服务接口
abstract class TranslationHistoryService {
  /// 创建翻译历史记录
  Future<TranslationHistoryModel> createHistory(TranslationHistoryModel history);

  /// 获取翻译条目的历史记录
  Future<List<TranslationHistoryModel>> getEntryHistory(
    int entryId, {
    int? limit,
    int? offset,
  });

  /// 根据UUID获取翻译条目的历史记录
  Future<List<TranslationHistoryModel>> getEntryHistoryByUuid(
    String entryUuid, {
    int? limit,
    int? offset,
  });

  /// 获取项目的历史记录
  Future<List<TranslationHistoryModel>> getProjectHistory(
    int projectId, {
    String? action,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// 获取用户的历史记录
  Future<List<TranslationHistoryModel>> getUserHistory(
    String userId, {
    int? projectId,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// 删除历史记录（通常用于数据清理）
  Future<void> deleteHistory(int historyId);

  /// 批量删除历史记录
  Future<int> deleteHistoryByDateRange(DateTime startDate, DateTime endDate);
}
