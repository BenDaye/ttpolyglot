import '../utils/structured_logger.dart';

/// SQL解析工具类
class SqlParser {
  static final _logger = LoggerFactory.getLogger('SqlParser');

  /// 将SQL中的表名替换为带前缀的表名
  static String applyTablePrefix(String sql, String tablePrefix) {
    try {
      _logger.info('应用表前缀: $tablePrefix');

      // 定义需要替换的表名列表
      final tableNames = [
        'users',
        'roles',
        'permissions',
        'role_permissions',
        'languages',
        'projects',
        'user_roles',
        'project_members',
        'translations',
        'translation_keys',
        'translation_values',
        'translation_providers',
        'system_configs',
        'schema_migrations',
        'sessions',
        'api_keys',
        'audit_logs'
      ];

      String result = sql;

      // 为每个表名添加前缀
      for (final tableName in tableNames) {
        // 使用正则表达式匹配表名，确保是完整的单词
        final regex = RegExp(r'\b' + tableName + r'\b', caseSensitive: false);
        result = result.replaceAllMapped(regex, (match) {
          return '${tablePrefix}${tableName}';
        });
      }

      _logger.info('表前缀应用完成');
      return result;
    } catch (error, stackTrace) {
      _logger.error('应用表前缀失败', error: error, stackTrace: stackTrace);
      return sql; // 如果失败，返回原始SQL
    }
  }

  /// 从SQL中提取表名
  static List<String> extractTableNames(String sql) {
    try {
      final tableNames = <String>[];

      // 匹配CREATE TABLE语句
      final createTableRegex = RegExp(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)', caseSensitive: false);
      final createMatches = createTableRegex.allMatches(sql);
      for (final match in createMatches) {
        tableNames.add(match.group(1)!);
      }

      // 匹配INSERT INTO语句
      final insertRegex = RegExp(r'INSERT\s+INTO\s+(\w+)', caseSensitive: false);
      final insertMatches = insertRegex.allMatches(sql);
      for (final match in insertMatches) {
        tableNames.add(match.group(1)!);
      }

      // 匹配UPDATE语句
      final updateRegex = RegExp(r'UPDATE\s+(\w+)', caseSensitive: false);
      final updateMatches = updateRegex.allMatches(sql);
      for (final match in updateMatches) {
        tableNames.add(match.group(1)!);
      }

      // 匹配DELETE FROM语句
      final deleteRegex = RegExp(r'DELETE\s+FROM\s+(\w+)', caseSensitive: false);
      final deleteMatches = deleteRegex.allMatches(sql);
      for (final match in deleteMatches) {
        tableNames.add(match.group(1)!);
      }

      // 匹配SELECT FROM语句
      final selectRegex = RegExp(r'FROM\s+(\w+)', caseSensitive: false);
      final selectMatches = selectRegex.allMatches(sql);
      for (final match in selectMatches) {
        tableNames.add(match.group(1)!);
      }

      // 去重并返回
      return tableNames.toSet().toList();
    } catch (error, stackTrace) {
      _logger.error('提取表名失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  /// 检查表是否存在（带前缀）
  static String buildTableExistsQuery(String tableName, String tablePrefix) {
    final prefixedTableName = '${tablePrefix}${tableName}';
    return '''
      SELECT EXISTS (
        SELECT 1 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = '$prefixedTableName'
      );
    ''';
  }

  /// 检查表中是否有数据
  static String buildTableHasDataQuery(String tableName, String tablePrefix) {
    final prefixedTableName = '${tablePrefix}${tableName}';
    return 'SELECT COUNT(*) FROM $prefixedTableName;';
  }

  /// 分割SQL语句，支持dollar-quoted字符串和多行语句
  static List<String> splitSqlStatements(String sql) {
    try {
      final statements = <String>[];
      final lines = sql.split('\n');
      final buffer = StringBuffer();
      bool inDollarQuote = false;
      String? dollarTag;
      bool inStatement = false;

      for (final line in lines) {
        final trimmedLine = line.trim();

        // 跳过注释行
        if (trimmedLine.startsWith('--')) {
          continue;
        }

        // 跳过空行
        if (trimmedLine.isEmpty) {
          if (inStatement) {
            buffer.write(' ');
          }
          continue;
        }

        // 检查dollar-quoted字符串
        if (!inDollarQuote && trimmedLine.contains('\$\$')) {
          final parts = trimmedLine.split('\$\$');
          if (parts.length >= 2) {
            dollarTag = '\$\$';
            inDollarQuote = true;
            inStatement = true;
            buffer.write(trimmedLine);
            continue;
          }
        }

        if (inDollarQuote && trimmedLine.contains(dollarTag ?? '\$\$')) {
          buffer.write(' ');
          buffer.write(trimmedLine);
          inDollarQuote = false;
          dollarTag = null;
          continue;
        }

        if (inDollarQuote) {
          buffer.write(' ');
          buffer.write(trimmedLine);
          continue;
        }

        // 检查是否是SQL语句的开始
        final upperLine = trimmedLine.toUpperCase();
        if (!inStatement &&
            (upperLine.startsWith('CREATE') ||
                upperLine.startsWith('ALTER') ||
                upperLine.startsWith('DROP') ||
                upperLine.startsWith('INSERT') ||
                upperLine.startsWith('UPDATE') ||
                upperLine.startsWith('DELETE') ||
                upperLine.startsWith('SELECT') ||
                upperLine.startsWith('GRANT') ||
                upperLine.startsWith('REVOKE') ||
                upperLine.startsWith('COMMENT') ||
                upperLine.startsWith('BEGIN') ||
                upperLine.startsWith('COMMIT') ||
                upperLine.startsWith('ROLLBACK'))) {
          inStatement = true;
        }

        if (inStatement) {
          buffer.write(trimmedLine);

          // 检查语句是否结束
          if (trimmedLine.endsWith(';')) {
            final statement = buffer.toString().trim();
            if (statement.isNotEmpty) {
              statements.add(statement);
            }
            buffer.clear();
            inStatement = false;
          } else {
            buffer.write(' ');
          }
        }
      }

      // 添加最后一个语句（如果没有分号结尾）
      final lastStatement = buffer.toString().trim();
      if (lastStatement.isNotEmpty && !lastStatement.endsWith(';')) {
        statements.add(lastStatement);
      }

      _logger.info('分割SQL语句完成，共 ${statements.length} 个语句');
      return statements;
    } catch (error, stackTrace) {
      _logger.error('分割SQL语句失败', error: error, stackTrace: stackTrace);
      return [sql]; // 如果失败，返回原始SQL
    }
  }
}
