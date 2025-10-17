

import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';
import 'base_migration.dart';

/// 迁移: 014 - 创建文件上传表
/// 创建时间: 2024-12-26
/// 描述: 创建文件上传表，存储文件上传信息
class Migration014FileUploadsTable extends BaseMigration {
  @override
  String get name => '014_file_uploads_table';

  @override
  String get description => '创建文件上传表，存储文件上传信息';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> up() async {
    try {
      LoggerUtils.info('开始执行迁移: $name');

      // 创建文件上传表
      await createTable('file_uploads', '''
        CREATE TABLE IF NOT EXISTS {table_name} (
          id SERIAL PRIMARY KEY,
          user_id UUID NOT NULL,
          original_filename VARCHAR(255) NOT NULL,
          stored_filename VARCHAR(255) NOT NULL,
          file_path TEXT NOT NULL,
          file_size BIGINT NOT NULL,
          mime_type VARCHAR(100),
          file_hash VARCHAR(64),
          upload_type VARCHAR(50),
          is_processed BOOLEAN DEFAULT false,
          processing_status VARCHAR(20) DEFAULT 'pending',
          metadata JSONB,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          expires_at TIMESTAMP
        );
      ''');

      // 创建外键约束
      await addForeignKey('file_uploads_user_id', 'file_uploads', 'user_id', 'users', 'id');

      // 创建索引
      await createIndex('file_uploads_user_id', 'file_uploads', 'user_id');
      await createIndex('file_uploads_original_filename', 'file_uploads', 'original_filename');
      await createIndex('file_uploads_stored_filename', 'file_uploads', 'stored_filename');
      await createIndex('file_uploads_file_hash', 'file_uploads', 'file_hash');
      await createIndex('file_uploads_upload_type', 'file_uploads', 'upload_type');
      await createIndex('file_uploads_is_processed', 'file_uploads', 'is_processed');
      await createIndex('file_uploads_processing_status', 'file_uploads', 'processing_status');
      await createIndex('file_uploads_created_at', 'file_uploads', 'created_at');
      await createIndex('file_uploads_expires_at', 'file_uploads', 'expires_at');

      // 添加表注释
      await addTableComment('file_uploads', '文件上传表，存储文件上传信息');
      await addColumnComment('file_uploads', 'id', '文件ID，主键');
      await addColumnComment('file_uploads', 'user_id', '用户ID，外键关联users表');
      await addColumnComment('file_uploads', 'original_filename', '原始文件名');
      await addColumnComment('file_uploads', 'stored_filename', '存储文件名');
      await addColumnComment('file_uploads', 'file_path', '文件路径');
      await addColumnComment('file_uploads', 'file_size', '文件大小');
      await addColumnComment('file_uploads', 'mime_type', 'MIME类型');
      await addColumnComment('file_uploads', 'file_hash', '文件哈希值');
      await addColumnComment('file_uploads', 'upload_type', '上传类型');
      await addColumnComment('file_uploads', 'is_processed', '是否已处理');
      await addColumnComment('file_uploads', 'processing_status', '处理状态');
      await addColumnComment('file_uploads', 'metadata', '元数据，JSON格式');
      await addColumnComment('file_uploads', 'created_at', '创建时间');
      await addColumnComment('file_uploads', 'expires_at', '过期时间');

      LoggerUtils.info('迁移完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('迁移失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> down() async {
    try {
      LoggerUtils.info('开始回滚迁移: $name');

      // 删除文件上传表
      await dropTable('file_uploads');

      LoggerUtils.info('回滚完成: $name');
    } catch (error, stackTrace) {
      LoggerUtils.error('回滚失败: $name', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
