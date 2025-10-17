/// 日期时间工具类
class DateTimeUtils {
  /// 格式化日期时间为ISO字符串
  static String toIsoString(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  /// 从ISO字符串解析日期时间
  static DateTime fromIsoString(String isoString) {
    return DateTime.parse(isoString);
  }

  /// 格式化日期时间为可读格式
  static String toReadableString(DateTime dateTime, {bool showTime = true}) {
    final local = dateTime.toLocal();
    final date = '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';

    if (!showTime) return date;

    final time =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}:${local.second.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  /// 获取相对时间描述
  static String toRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).round();
      return '$months个月前';
    } else {
      final years = (difference.inDays / 365).round();
      return '$years年前';
    }
  }

  /// 检查日期是否在范围内
  static bool isInRange(DateTime date, DateTime? start, DateTime? end) {
    if (start != null && date.isBefore(start)) return false;
    if (end != null && date.isAfter(end)) return false;
    return true;
  }

  /// 获取日期范围内的天数
  static int getDaysInRange(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  /// 获取本周的开始和结束日期
  static (DateTime, DateTime) getWeekRange(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    final sunday = monday.add(Duration(days: 6));
    return (monday, sunday);
  }

  /// 获取本月的开始和结束日期
  static (DateTime, DateTime) getMonthRange(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return (firstDay, lastDay);
  }

  /// 获取本年的开始和结束日期
  static (DateTime, DateTime) getYearRange(DateTime date) {
    final firstDay = DateTime(date.year, 1, 1);
    final lastDay = DateTime(date.year, 12, 31);
    return (firstDay, lastDay);
  }

  /// 格式化为数据库时间戳字符串
  static String toTimestampString(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  /// 从数据库时间戳字符串解析
  static DateTime fromTimestampString(String timestamp) {
    return DateTime.parse(timestamp).toLocal();
  }

  /// 验证日期字符串格式
  static bool isValidDateString(String dateString) {
    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取两个日期之间的所有日期
  static List<DateTime> getDatesBetween(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      dates.add(current);
      current = current.add(Duration(days: 1));
    }

    return dates;
  }

  /// 检查是否是工作日
  static bool isWeekday(DateTime date) {
    return date.weekday >= 1 && date.weekday <= 5;
  }

  /// 检查是否是周末
  static bool isWeekend(DateTime date) {
    return date.weekday == 6 || date.weekday == 7;
  }

  /// 获取下个工作日
  static DateTime getNextWeekday(DateTime date) {
    var next = date.add(Duration(days: 1));
    while (!isWeekday(next)) {
      next = next.add(Duration(days: 1));
    }
    return next;
  }

  /// 计算年龄
  static int calculateAge(DateTime birthDate, {DateTime? currentDate}) {
    final now = currentDate ?? DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// 格式化时间间隔
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}天 ${duration.inHours % 24}小时';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}小时 ${duration.inMinutes % 60}分钟';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}分钟 ${duration.inSeconds % 60}秒';
    } else {
      return '${duration.inSeconds}秒';
    }
  }
}
