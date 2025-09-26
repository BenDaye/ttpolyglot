/// API响应模型
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? pagination;
  final Map<String, dynamic>? metadata;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.pagination,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': data,
      if (pagination != null) 'pagination': pagination,
      if (metadata != null) 'metadata': metadata,
    };
    return json;
  }

  factory ApiResponse.success({
    required String message,
    T? data,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      metadata: metadata,
    );
  }

  factory ApiResponse.paginated({
    required String message,
    required T data,
    required int page,
    required int limit,
    required int total,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      pagination: {
        'page': page,
        'limit': limit,
        'total': total,
        'pages': (total / limit).ceil(),
        'has_next': page * limit < total,
        'has_prev': page > 1,
      },
      metadata: metadata,
    );
  }

  factory ApiResponse.error({
    required String message,
    String? code,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      data: null,
      metadata: {
        if (code != null) 'code': code,
        ...?metadata,
      },
    );
  }
}

/// 分页信息
class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int pages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationInfo.fromMap(Map<String, dynamic> map) {
    return PaginationInfo(
      page: map['page'] as int,
      limit: map['limit'] as int,
      total: map['total'] as int,
      pages: map['pages'] as int,
      hasNext: map['has_next'] as bool,
      hasPrev: map['has_prev'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'pages': pages,
      'has_next': hasNext,
      'has_prev': hasPrev,
    };
  }
}

/// 响应元数据
class ResponseMetadata {
  final String requestId;
  final DateTime timestamp;
  final String path;
  final String method;
  final String? userId;
  final String? traceId;

  const ResponseMetadata({
    required this.requestId,
    required this.timestamp,
    required this.path,
    required this.method,
    this.userId,
    this.traceId,
  });

  factory ResponseMetadata.fromMap(Map<String, dynamic> map) {
    return ResponseMetadata(
      requestId: map['request_id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      path: map['path'] as String,
      method: map['method'] as String,
      userId: map['user_id'] as String?,
      traceId: map['trace_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'timestamp': timestamp.toIso8601String(),
      'path': path,
      'method': method,
      if (userId != null) 'user_id': userId,
      if (traceId != null) 'trace_id': traceId,
    };
  }
}
