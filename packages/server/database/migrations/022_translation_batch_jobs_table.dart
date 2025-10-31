import 'dart:developer';

import 'package:ttpolyglot_model/model.dart';

import 'base_migration.dart';

/// 迁移: 022 - 创建翻译批量任务队列表
/// 创建时间: 2025-10-31
/// 描述: 创建翻译批量任务队列表，用于管理批量导入、导出、翻译等长时间运行的任务
class Migration022TranslationBatchJobsTable extends BaseMigration {
  @override
  String get name => '022_translation_batch_jobs_table';

  @override
  String get description => '创建翻译批量任务队列表，用于管理批量操作任务';

  @override
  String get createdAt => '2025-10-31';

  @override
  Future<void> up() async {
    try {
      ServerLogger.info('开始执行迁移: $name');

      // 创建批量任务队列表
      await createTable('translation_batch_jobs', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          project_id INTEGER NOT NULL,
          job_type VARCHAR(50) NOT NULL,
          status VARCHAR(20) DEFAULT 'pending',
          
          -- 任务配置
          config JSONB NOT NULL DEFAULT '{}'::jsonb,
          
          -- 进度跟踪
          total_items INTEGER DEFAULT 0,
          processed_items INTEGER DEFAULT 0,
          success_items INTEGER DEFAULT 0,
          failed_items INTEGER DEFAULT 0,
          
          -- 结果和错误
          result JSONB,
          error_message TEXT,
          error_details JSONB,
          
          -- 时间追踪
          created_by UUID NOT NULL,
          created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
          started_at TIMESTAMPTZ,
          completed_at TIMESTAMPTZ,
          
          -- 文件路径（导入导出用）
          file_path TEXT,
          
          CONSTRAINT valid_progress CHECK (processed_items <= total_items),
          CONSTRAINT valid_status CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
          CONSTRAINT valid_job_type CHECK (job_type IN ('import', 'export', 'batch_translate', 'batch_update', 'batch_delete'))
        );
      ''');

      // 创建外键约束
      await addForeignKey('translation_batch_jobs_project_id', 'translation_batch_jobs', 'project_id', 'projects', 'id',
          onDelete: 'CASCADE');
      await addForeignKey('translation_batch_jobs_created_by', 'translation_batch_jobs', 'created_by', 'users', 'id');

      // 创建索引
      await createIndex('tbj_project_id', 'translation_batch_jobs', 'project_id, created_at DESC');
      await createIndex('tbj_status', 'translation_batch_jobs', 'status, created_at DESC');
      await createIndex('tbj_created_by', 'translation_batch_jobs', 'created_by');
      await createIndex('tbj_job_type', 'translation_batch_jobs', 'job_type');
      await createIndex('tbj_created_at', 'translation_batch_jobs', 'created_at DESC');

      // 为 JSONB 字段创建 GIN 索引
      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_tbj_config 
        ON ${tablePrefix}translation_batch_jobs 
        USING GIN (config);
      ''');

      await connection.execute('''
        CREATE INDEX IF NOT EXISTS ${tablePrefix}idx_tbj_result 
        ON ${tablePrefix}translation_batch_jobs 
        USING GIN (result);
      ''');

      // 添加表注释
      await addTableComment('translation_batch_jobs', '翻译批量任务队列表，管理批量操作任务');
      await addColumnComment('translation_batch_jobs', 'id', '任务ID，UUID主键');
      await addColumnComment('translation_batch_jobs', 'project_id', '项目ID，外键关联projects表');
      await addColumnComment(
          'translation_batch_jobs', 'job_type', '任务类型：import/export/batch_translate/batch_update/batch_delete');
      await addColumnComment('translation_batch_jobs', 'status', '任务状态：pending/processing/completed/failed/cancelled');
      await addColumnComment('translation_batch_jobs', 'config', '任务配置，JSON格式');
      await addColumnComment('translation_batch_jobs', 'total_items', '总条目数');
      await addColumnComment('translation_batch_jobs', 'processed_items', '已处理条目数');
      await addColumnComment('translation_batch_jobs', 'success_items', '成功条目数');
      await addColumnComment('translation_batch_jobs', 'failed_items', '失败条目数');
      await addColumnComment('translation_batch_jobs', 'result', '任务结果，JSON格式');
      await addColumnComment('translation_batch_jobs', 'error_message', '错误信息');
      await addColumnComment('translation_batch_jobs', 'error_details', '错误详情，JSON格式');
      await addColumnComment('translation_batch_jobs', 'created_by', '创建者ID，外键关联users表');
      await addColumnComment('translation_batch_jobs', 'created_at', '创建时间');
      await addColumnComment('translation_batch_jobs', 'started_at', '开始执行时间');
      await addColumnComment('translation_batch_jobs', 'completed_at', '完成时间');
      await addColumnComment('translation_batch_jobs', 'file_path', '文件路径（用于导入导出）');

      ServerLogger.info('迁移完成: $name');
    } catch (error, stackTrace) {
      log('[Migration022TranslationBatchJobsTable]',
          error: error, stackTrace: stackTrace, name: 'Migration022TranslationBatchJobsTable');
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      ServerLogger.info('开始回滚迁移: $name');

      // 删除翻译批量任务表
      await dropTable('translation_batch_jobs');

      ServerLogger.info('回滚完成: $name');
    } catch (error, stackTrace) {
      log('[Migration022TranslationBatchJobsTable]',
          error: error, stackTrace: stackTrace, name: 'Migration022TranslationBatchJobsTable');
      rethrow;
    }
  }
}
