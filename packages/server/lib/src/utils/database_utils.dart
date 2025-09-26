/// 数据库工具类
class DatabaseUtils {
  /// 构建分页查询
  static String buildPaginationQuery(
    String baseQuery,
    int page,
    int limit,
    String? orderBy,
  ) {
    final offset = (page - 1) * limit;
    final query = StringBuffer(baseQuery);

    if (orderBy != null && orderBy.isNotEmpty) {
      query.write(' ORDER BY $orderBy');
    }

    query.write(' LIMIT $limit OFFSET $offset');
    return query.toString();
  }

  /// 构建计数查询
  static String buildCountQuery(String baseQuery) {
    return 'SELECT COUNT(*) FROM ($baseQuery) AS count_query';
  }

  /// 构建搜索查询条件
  static String buildSearchCondition(
    List<String> searchFields,
    String searchTerm,
  ) {
    if (searchFields.isEmpty || searchTerm.isEmpty) {
      return '';
    }

    final conditions = searchFields.map((field) => '$field ILIKE @search').join(' OR ');
    return '($conditions)';
  }

  /// 转义SQL LIKE通配符
  static String escapeLike(String input) {
    return input.replaceAll('\\', '\\\\').replaceAll('%', '\\%').replaceAll('_', '\\_');
  }

  /// 构建IN查询条件
  static String buildInCondition(String field, List<String> values) {
    if (values.isEmpty) {
      return '$field IS NULL';
    }

    final placeholders = List.generate(values.length, (i) => '@in_$i');
    return '$field IN (${placeholders.join(', ')})';
  }

  /// 获取IN查询参数
  static Map<String, dynamic> buildInParameters(List<String> values) {
    final parameters = <String, dynamic>{};
    for (var i = 0; i < values.length; i++) {
      parameters['in_$i'] = values[i];
    }
    return parameters;
  }

  /// 构建日期范围查询条件
  static String buildDateRangeCondition(
    String field,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    final conditions = <String>[];

    if (startDate != null) {
      conditions.add('$field >= @start_date');
    }

    if (endDate != null) {
      conditions.add('$field <= @end_date');
    }

    return conditions.isNotEmpty ? conditions.join(' AND ') : '';
  }

  /// 获取日期范围查询参数
  static Map<String, dynamic> buildDateRangeParameters(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    final parameters = <String, dynamic>{};

    if (startDate != null) {
      parameters['start_date'] = startDate.toIso8601String();
    }

    if (endDate != null) {
      parameters['end_date'] = endDate.toIso8601String();
    }

    return parameters;
  }

  /// 构建JSON查询条件
  static String buildJsonCondition(String field, String path, dynamic value) {
    return '$field ->> @json_path = @json_value';
  }

  /// 构建JSON数组包含查询条件
  static String buildJsonArrayContainsCondition(String field, String value) {
    return '$field @> json_build_array(@json_array_value)';
  }

  /// 构建全文搜索条件
  static String buildFullTextSearchCondition(String field, String searchTerm) {
    return "to_tsvector('english', $field) @@ plainto_tsquery('english', @search_term)";
  }

  /// 转义SQL标识符
  static String escapeIdentifier(String identifier) {
    // 简单的标识符转义，实际应用中应该使用更严格的验证
    return identifier.replaceAll('"', '""');
  }

  /// 验证SQL标识符
  static bool isValidIdentifier(String identifier) {
    // 检查是否包含危险字符
    final dangerousChars = [';', '--', '/*', '*/', 'xp_', 'sp_'];
    return !dangerousChars.any((char) => identifier.contains(char));
  }

  /// 构建UPDATE语句的SET子句
  static String buildUpdateSetClause(Map<String, dynamic> updates) {
    return updates.keys.map((key) => '$key = @update_$key').join(', ');
  }

  /// 获取UPDATE语句的参数
  static Map<String, dynamic> buildUpdateParameters(Map<String, dynamic> updates) {
    final parameters = <String, dynamic>{};
    updates.forEach((key, value) {
      parameters['update_$key'] = value;
    });
    return parameters;
  }

  /// 构建INSERT语句的VALUES子句
  static String buildInsertValuesClause(Map<String, dynamic> values) {
    final columns = values.keys.join(', ');
    final placeholders = values.keys.map((key) => '@insert_$key').join(', ');
    return '($columns) VALUES ($placeholders)';
  }

  /// 获取INSERT语句的参数
  static Map<String, dynamic> buildInsertParameters(Map<String, dynamic> values) {
    final parameters = <String, dynamic>{};
    values.forEach((key, value) {
      parameters['insert_$key'] = value;
    });
    return parameters;
  }
}
