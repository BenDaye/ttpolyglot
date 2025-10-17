import 'dart:math';

/// 字符串工具类
class StringUtils {
  /// 生成URL友好的slug
  static String generateSlug(String input) {
    if (input.isEmpty) return '';

    // 转换为小写
    String slug = input.toLowerCase();

    // 移除特殊字符，只保留字母、数字和连字符
    slug = slug.replaceAll(RegExp(r'[^a-z0-9\s-]'), '');

    // 将空格替换为连字符
    slug = slug.replaceAll(RegExp(r'\s+'), '-');

    // 移除多余的连字符
    slug = slug.replaceAll(RegExp(r'-+'), '-');

    // 移除开头和结尾的连字符
    slug = slug.replaceAll(RegExp(r'^-+|-+$'), '');

    // 如果结果为空，生成随机字符串
    if (slug.isEmpty) {
      slug = 'project-${generateRandomString(8)}';
    }

    return slug;
  }

  /// 生成随机字符串
  static String generateRandomString(int length, {bool numbersOnly = false}) {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';

    final chars = numbersOnly ? numbers : letters + numbers;
    final random = Random();

    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  /// 截断字符串
  static String truncate(String input, int maxLength, {String suffix = '...'}) {
    if (input.length <= maxLength) return input;

    final truncated = input.substring(0, maxLength - suffix.length);
    return '$truncated$suffix';
  }

  /// 首字母大写
  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  /// 每个单词首字母大写
  static String titleCase(String input) {
    if (input.isEmpty) return input;

    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// 检查字符串是否为空或只包含空白字符
  static bool isBlank(String? input) {
    return input == null || input.trim().isEmpty;
  }

  /// 检查字符串是否不为空且不只包含空白字符
  static bool isNotBlank(String? input) {
    return !isBlank(input);
  }

  /// 移除字符串中的HTML标签
  static String stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// 转义HTML特殊字符
  static String escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }

  /// 计算字符串的字符数（支持Unicode）
  static int getCharacterCount(String input) {
    return input.runes.length;
  }

  /// 计算字符串的单词数
  static int getWordCount(String input) {
    if (input.trim().isEmpty) return 0;

    return input.trim().split(RegExp(r'\s+')).length;
  }

  /// 生成缩写
  static String generateAbbreviation(String input, {int maxLength = 3}) {
    if (input.isEmpty) return '';

    final words = input.trim().split(RegExp(r'\s+'));

    if (words.length == 1) {
      // 单个单词，取前几个字符
      return words.first.substring(0, min(maxLength, words.first.length)).toUpperCase();
    } else {
      // 多个单词，取每个单词的首字母
      final abbreviation =
          words.where((word) => word.isNotEmpty).take(maxLength).map((word) => word[0].toUpperCase()).join();

      return abbreviation;
    }
  }

  /// 检查字符串是否为有效的URL slug
  static bool isValidSlug(String input) {
    if (input.isEmpty) return false;

    // slug应该只包含小写字母、数字和连字符
    // 不能以连字符开头或结尾
    final slugPattern = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
    return slugPattern.hasMatch(input);
  }

  /// 将驼峰命名转换为连字符分隔
  static String camelToKebab(String input) {
    return input
        .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (match) => '${match.group(1)}-${match.group(2)}')
        .toLowerCase();
  }

  /// 将连字符分隔转换为驼峰命名
  static String kebabToCamel(String input) {
    final parts = input.split('-');
    if (parts.length <= 1) return input;

    return parts.first + parts.skip(1).map((part) => capitalize(part)).join();
  }

  /// 生成密码强度指示器文本
  static String getPasswordStrengthText(double strength) {
    if (strength < 0.3) return '弱';
    if (strength < 0.7) return '中等';
    return '强';
  }

  /// 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 格式化数字（添加千位分隔符）
  static String formatNumber(num number) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return number.toString().replaceAllMapped(formatter, (match) => '${match.group(1)},');
  }

  /// 生成随机颜色（十六进制）
  static String generateRandomColor() {
    final random = Random();
    return '#${random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }

  /// 验证颜色格式（十六进制）
  static bool isValidHexColor(String color) {
    final hexColorPattern = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$');
    return hexColorPattern.hasMatch(color);
  }
}
