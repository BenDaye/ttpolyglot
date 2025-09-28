import 'dart:async';

import '../utils/structured_logger.dart';

/// 指标类型
enum MetricType {
  counter, // 计数器
  gauge, // 仪表盘
  histogram, // 直方图
  summary, // 摘要
}

/// 指标标签
class MetricLabel {
  final String name;
  final String value;

  MetricLabel(this.name, this.value);
}

/// 指标值
class MetricValue {
  final String name;
  final String help;
  final MetricType type;
  final List<MetricLabel> labels;
  final double value;
  final DateTime timestamp;

  MetricValue({
    required this.name,
    required this.help,
    required this.type,
    required this.labels,
    required this.value,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// 转换为Prometheus格式
  String toPrometheusFormat() {
    final labelsStr = labels.isNotEmpty ? '{${labels.map((l) => '${l.name}="${l.value}"').join(',')}}' : '';

    final typeStr = _getTypeString();
    final helpStr = '# HELP $name $help\n';
    final typeLine = '# TYPE $name $typeStr\n';

    return '$helpStr$typeLine$name$labelsStr $value\n';
  }

  String _getTypeString() {
    switch (type) {
      case MetricType.counter:
        return 'counter';
      case MetricType.gauge:
        return 'gauge';
      case MetricType.histogram:
        return 'histogram';
      case MetricType.summary:
        return 'summary';
    }
  }
}

/// 指标收集器
class MetricsCollector {
  static final _logger = LoggerFactory.getLogger('MetricsCollector');
  final Map<String, List<MetricValue>> _metrics = {};
  final Map<String, String> _helpTexts = {};
  final Map<String, MetricType> _metricTypes = {};

  /// 注册指标
  void registerMetric(String name, String help, MetricType type) {
    _helpTexts[name] = help;
    _metricTypes[name] = type;
    _metrics[name] = [];
    _logger.debug('注册指标: $name ($type)');
  }

  /// 记录指标值
  void recordMetric(String name, double value, {List<MetricLabel> labels = const []}) {
    if (!_metrics.containsKey(name)) {
      throw Exception('指标未注册: $name');
    }

    final metricValue = MetricValue(
      name: name,
      help: _helpTexts[name]!,
      type: _metricTypes[name]!,
      labels: labels,
      value: value,
    );

    _metrics[name]!.add(metricValue);
    _logger.debug('记录指标: $name = $value');
  }

  /// 增加计数器
  void incrementCounter(String name, {double value = 1.0, List<MetricLabel> labels = const []}) {
    recordMetric(name, value, labels: labels);
  }

  /// 设置仪表盘值
  void setGauge(String name, double value, {List<MetricLabel> labels = const []}) {
    recordMetric(name, value, labels: labels);
  }

  /// 记录直方图值
  void recordHistogram(String name, double value, {List<MetricLabel> labels = const []}) {
    recordMetric(name, value, labels: labels);
  }

  /// 获取所有指标
  Map<String, List<MetricValue>> getAllMetrics() => Map.unmodifiable(_metrics);

  /// 获取特定指标
  List<MetricValue> getMetric(String name) => _metrics[name] ?? [];

  /// 清空指标
  void clearMetrics() {
    _metrics.clear();
    _logger.debug('清空所有指标');
  }

  /// 清空特定指标
  void clearMetric(String name) {
    _metrics.remove(name);
    _logger.debug('清空指标: $name');
  }
}

/// 指标服务
class MetricsService {
  static final _logger = LoggerFactory.getLogger('MetricsService');
  final MetricsCollector _collector = MetricsCollector();
  Timer? _cleanupTimer;

  MetricsService() {
    _initializeMetrics();
    _startCleanupTimer();
  }

  /// 初始化指标
  void _initializeMetrics() {
    // HTTP请求指标
    _collector.registerMetric('http_requests_total', 'HTTP请求总数', MetricType.counter);
    _collector.registerMetric('http_request_duration_seconds', 'HTTP请求持续时间', MetricType.histogram);
    _collector.registerMetric('http_requests_in_flight', '正在处理的HTTP请求数', MetricType.gauge);

    // 数据库指标
    _collector.registerMetric('database_connections_total', '数据库连接总数', MetricType.gauge);
    _collector.registerMetric('database_connections_active', '活跃数据库连接数', MetricType.gauge);
    _collector.registerMetric('database_queries_total', '数据库查询总数', MetricType.counter);
    _collector.registerMetric('database_query_duration_seconds', '数据库查询持续时间', MetricType.histogram);

    // 缓存指标
    _collector.registerMetric('cache_hits_total', '缓存命中总数', MetricType.counter);
    _collector.registerMetric('cache_misses_total', '缓存未命中总数', MetricType.counter);
    _collector.registerMetric('cache_size', '缓存大小', MetricType.gauge);

    // Redis指标
    _collector.registerMetric('redis_connections_total', 'Redis连接总数', MetricType.gauge);
    _collector.registerMetric('redis_operations_total', 'Redis操作总数', MetricType.counter);
    _collector.registerMetric('redis_operation_duration_seconds', 'Redis操作持续时间', MetricType.histogram);

    // 系统指标
    _collector.registerMetric('server_uptime_seconds', '服务器运行时间', MetricType.gauge);
    _collector.registerMetric('server_memory_usage_bytes', '服务器内存使用量', MetricType.gauge);
    _collector.registerMetric('server_cpu_usage_percent', '服务器CPU使用率', MetricType.gauge);

    // 业务指标
    _collector.registerMetric('users_total', '用户总数', MetricType.gauge);
    _collector.registerMetric('projects_total', '项目总数', MetricType.gauge);
    _collector.registerMetric('translations_total', '翻译总数', MetricType.gauge);
    _collector.registerMetric('api_calls_total', 'API调用总数', MetricType.counter);

    _logger.info('指标初始化完成');
  }

  /// 启动清理定时器
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      _cleanupOldMetrics();
    });
  }

  /// 清理旧指标
  void _cleanupOldMetrics() {
    final cutoffTime = DateTime.now().subtract(Duration(hours: 1));

    for (final metricName in _collector.getAllMetrics().keys) {
      final metrics = _collector.getMetric(metricName);
      final recentMetrics = metrics.where((m) => m.timestamp.isAfter(cutoffTime)).toList();

      if (recentMetrics.length != metrics.length) {
        _collector.clearMetric(metricName);
        for (final metric in recentMetrics) {
          _collector.recordMetric(metricName, metric.value, labels: metric.labels);
        }
      }
    }

    _logger.debug('清理旧指标完成');
  }

  /// 记录HTTP请求指标
  void recordHttpRequest(String method, String path, int statusCode, double duration) {
    _collector.incrementCounter('http_requests_total', labels: [
      MetricLabel('method', method),
      MetricLabel('path', path),
      MetricLabel('status_code', statusCode.toString()),
    ]);

    _collector.recordHistogram('http_request_duration_seconds', duration, labels: [
      MetricLabel('method', method),
      MetricLabel('path', path),
    ]);
  }

  /// 记录数据库指标
  void recordDatabaseQuery(String operation, double duration) {
    _collector.incrementCounter('database_queries_total', labels: [
      MetricLabel('operation', operation),
    ]);

    _collector.recordHistogram('database_query_duration_seconds', duration, labels: [
      MetricLabel('operation', operation),
    ]);
  }

  /// 记录缓存指标
  void recordCacheHit(String cacheType) {
    _collector.incrementCounter('cache_hits_total', labels: [
      MetricLabel('cache_type', cacheType),
    ]);
  }

  void recordCacheMiss(String cacheType) {
    _collector.incrementCounter('cache_misses_total', labels: [
      MetricLabel('cache_type', cacheType),
    ]);
  }

  /// 记录Redis指标
  void recordRedisOperation(String operation, double duration) {
    _collector.incrementCounter('redis_operations_total', labels: [
      MetricLabel('operation', operation),
    ]);

    _collector.recordHistogram('redis_operation_duration_seconds', duration, labels: [
      MetricLabel('operation', operation),
    ]);
  }

  /// 记录系统指标
  void recordSystemMetrics({
    required double uptimeSeconds,
    required double memoryUsageBytes,
    required double cpuUsagePercent,
  }) {
    _collector.setGauge('server_uptime_seconds', uptimeSeconds);
    _collector.setGauge('server_memory_usage_bytes', memoryUsageBytes);
    _collector.setGauge('server_cpu_usage_percent', cpuUsagePercent);
  }

  /// 记录业务指标
  void recordBusinessMetrics({
    required int usersTotal,
    required int projectsTotal,
    required int translationsTotal,
  }) {
    _collector.setGauge('users_total', usersTotal.toDouble());
    _collector.setGauge('projects_total', projectsTotal.toDouble());
    _collector.setGauge('translations_total', translationsTotal.toDouble());
  }

  /// 记录API调用
  void recordApiCall(String endpoint) {
    _collector.incrementCounter('api_calls_total', labels: [
      MetricLabel('endpoint', endpoint),
    ]);
  }

  /// 获取Prometheus格式的指标
  String getPrometheusMetrics() {
    final buffer = StringBuffer();

    for (final metricName in _collector.getAllMetrics().keys) {
      final metrics = _collector.getMetric(metricName);
      if (metrics.isEmpty) continue;

      // 添加帮助文本和类型
      final help = _collector._helpTexts[metricName] ?? '';
      final type = _collector._metricTypes[metricName] ?? MetricType.gauge;

      buffer.writeln('# HELP $metricName $help');
      buffer.writeln('# TYPE $metricName ${_getTypeString(type)}');

      // 添加指标值
      for (final metric in metrics) {
        final labelsStr =
            metric.labels.isNotEmpty ? '{${metric.labels.map((l) => '${l.name}="${l.value}"').join(',')}}' : '';
        buffer.writeln('$metricName$labelsStr ${metric.value}');
      }

      buffer.writeln(); // 空行分隔
    }

    return buffer.toString();
  }

  String _getTypeString(MetricType type) {
    switch (type) {
      case MetricType.counter:
        return 'counter';
      case MetricType.gauge:
        return 'gauge';
      case MetricType.histogram:
        return 'histogram';
      case MetricType.summary:
        return 'summary';
    }
  }

  /// 获取指标统计信息
  Map<String, dynamic> getMetricsStats() {
    final allMetrics = _collector.getAllMetrics();
    final totalMetrics = allMetrics.values.fold(0, (sum, metrics) => sum + metrics.length);

    return {
      'total_metrics': allMetrics.length,
      'total_data_points': totalMetrics,
      'metrics_by_type': {
        'http': allMetrics.keys.where((k) => k.startsWith('http_')).length,
        'database': allMetrics.keys.where((k) => k.startsWith('database_')).length,
        'cache': allMetrics.keys.where((k) => k.startsWith('cache_')).length,
        'redis': allMetrics.keys.where((k) => k.startsWith('redis_')).length,
        'system': allMetrics.keys.where((k) => k.startsWith('server_')).length,
        'business': allMetrics.keys
            .where((k) => ['users_total', 'projects_total', 'translations_total', 'api_calls_total'].contains(k))
            .length,
      },
    };
  }

  /// 清理所有指标
  void clearAllMetrics() {
    _collector.clearMetrics();
    _logger.debug('清理所有指标');
  }

  /// 关闭服务
  void dispose() {
    _cleanupTimer?.cancel();
    _logger.info('指标服务已关闭');
  }
}

/// 全局指标服务实例
final MetricsService metricsService = MetricsService();
