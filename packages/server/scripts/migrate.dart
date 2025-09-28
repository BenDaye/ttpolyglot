#!/usr/bin/env dart

import 'dart:io';

import 'package:ttpolyglot_server/src/config/server_config.dart';
import 'package:ttpolyglot_server/src/services/database_service.dart';
import 'package:ttpolyglot_server/src/utils/structured_logger.dart';

/// 数据库迁移脚本
class DatabaseMigration {
  final DatabaseService _databaseService;
  static final StructuredLogger _logger = LoggerFactory.getLogger('DatabaseMigration');

  DatabaseMigration({
    required DatabaseService databaseService,
  }) : _databaseService = databaseService;

  /// 运行所有迁移
  Future<void> runMigrations() async {
    try {
      _logger.info('开始数据库迁移');

      // 检查迁移表是否存在
      await _createMigrationsTable();

      // 获取已执行的迁移
      final executedMigrations = await _getExecutedMigrations();

      // 执行所有迁移
      final migrations = _getAllMigrations();

      for (final migration in migrations) {
        if (!executedMigrations.contains(migration.name)) {
          _logger.info('执行迁移: ${migration.name}');
          await migration.execute(_databaseService);
          await _recordMigration(migration.name);
          _logger.info('迁移完成: ${migration.name}');
        } else {
          _logger.info('跳过已执行的迁移: ${migration.name}');
        }
      }

      _logger.info('数据库迁移完成');
    } catch (error, stackTrace) {
      _logger.error('数据库迁移失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 创建迁移表
  Future<void> _createMigrationsTable() async {
    await _databaseService.query('''
      CREATE TABLE IF NOT EXISTS migrations (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL UNIQUE,
        executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  /// 获取已执行的迁移
  Future<List<String>> _getExecutedMigrations() async {
    final result = await _databaseService.query('SELECT name FROM migrations');
    return result.map((row) => row[0] as String).toList();
  }

  /// 记录迁移执行
  Future<void> _recordMigration(String name) async {
    await _databaseService.query(
      'INSERT INTO migrations (name) VALUES (@name)',
      {'name': name},
    );
  }

  /// 获取所有迁移
  List<Migration> _getAllMigrations() {
    return [
      // 初始迁移 - 创建基础表结构
      Migration(
        name: '001_create_initial_tables',
        execute: (db) async {
          // 创建用户表
          await db.query('''
            CREATE TABLE IF NOT EXISTS users (
              id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
              username VARCHAR(50) NOT NULL UNIQUE,
              email VARCHAR(255) NOT NULL UNIQUE,
              password_hash VARCHAR(255) NOT NULL,
              display_name VARCHAR(100),
              avatar_url TEXT,
              phone VARCHAR(20),
              timezone VARCHAR(50) DEFAULT 'UTC',
              locale VARCHAR(10) DEFAULT 'en-US',
              is_active BOOLEAN DEFAULT true,
              is_email_verified BOOLEAN DEFAULT false,
              email_verified_at TIMESTAMP,
              login_attempts INTEGER DEFAULT 0,
              locked_until TIMESTAMP,
              last_login_at TIMESTAMP,
              last_login_ip INET,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          ''');

          // 创建用户会话表
          await db.query('''
            CREATE TABLE IF NOT EXISTS user_sessions (
              id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
              user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
              token_hash VARCHAR(255) NOT NULL,
              refresh_token_hash VARCHAR(255) NOT NULL,
              device_id VARCHAR(255),
              device_name VARCHAR(255),
              device_type VARCHAR(50),
              ip_address INET,
              user_agent TEXT,
              is_active BOOLEAN DEFAULT true,
              expires_at TIMESTAMP NOT NULL,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          ''');

          // 创建项目表
          await db.query('''
            CREATE TABLE IF NOT EXISTS projects (
              id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
              name VARCHAR(255) NOT NULL,
              description TEXT,
              owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
              is_active BOOLEAN DEFAULT true,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          ''');

          // 创建翻译表
          await db.query('''
            CREATE TABLE IF NOT EXISTS translations (
              id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
              project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
              key VARCHAR(500) NOT NULL,
              language VARCHAR(10) NOT NULL,
              value TEXT,
              is_active BOOLEAN DEFAULT true,
              created_by UUID REFERENCES users(id),
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              UNIQUE(project_id, key, language)
            )
          ''');

          // 创建索引
          await db.query('CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_users_username ON users(username)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_user_sessions_token_hash ON user_sessions(token_hash)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_projects_owner_id ON projects(owner_id)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_translations_project_id ON translations(project_id)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_translations_language ON translations(language)');
        },
      ),

      // 添加文件上传相关表
      Migration(
        name: '002_create_file_uploads_table',
        execute: (db) async {
          await db.query('''
            CREATE TABLE IF NOT EXISTS file_uploads (
              id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
              user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
              file_name VARCHAR(255) NOT NULL,
              original_name VARCHAR(255) NOT NULL,
              file_path TEXT NOT NULL,
              file_size BIGINT NOT NULL,
              content_type VARCHAR(100) NOT NULL,
              file_type VARCHAR(50) NOT NULL,
              is_active BOOLEAN DEFAULT true,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          ''');

          await db.query('CREATE INDEX IF NOT EXISTS idx_file_uploads_user_id ON file_uploads(user_id)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_file_uploads_file_type ON file_uploads(file_type)');
        },
      ),

      // 添加审计日志表
      Migration(
        name: '003_create_audit_logs_table',
        execute: (db) async {
          await db.query('''
            CREATE TABLE IF NOT EXISTS audit_logs (
              id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
              user_id UUID REFERENCES users(id) ON DELETE SET NULL,
              action VARCHAR(100) NOT NULL,
              resource_type VARCHAR(100) NOT NULL,
              resource_id UUID,
              details JSONB,
              ip_address INET,
              user_agent TEXT,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          ''');

          await db.query('CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action)');
          await db
              .query('CREATE INDEX IF NOT EXISTS idx_audit_logs_resource ON audit_logs(resource_type, resource_id)');
          await db.query('CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at)');
        },
      ),
    ];
  }
}

/// 迁移类
class Migration {
  final String name;
  final Future<void> Function(DatabaseService) execute;

  const Migration({
    required this.name,
    required this.execute,
  });
}

/// 主函数
Future<void> main(List<String> args) async {
  final StructuredLogger logger = LoggerFactory.getLogger('DatabaseMigration');
  try {
    // 加载配置
    final config = ServerConfig();
    await config.load();

    // 创建数据库服务
    final databaseService = DatabaseService(config);
    await databaseService.initialize();

    // 运行迁移
    final migration = DatabaseMigration(databaseService: databaseService);
    await migration.runMigrations();

    logger.info('数据库迁移脚本执行完成');
    exit(0);
  } catch (error, stackTrace) {
    logger.error('数据库迁移脚本执行失败', error: error, stackTrace: stackTrace);
    exit(1);
  }
}
