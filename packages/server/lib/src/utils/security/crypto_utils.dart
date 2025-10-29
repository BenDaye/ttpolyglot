import 'dart:convert';
import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:ttpolyglot_utils/utils.dart';

import '../../config/server_config.dart';

/// 加密工具类
class CryptoUtils {
  CryptoUtils();

  /// 生成密码哈希值
  String hashPassword(String password) {
    try {
      return BCrypt.hashpw(password, BCrypt.gensalt(logRounds: ServerConfig.bcryptRounds));
    } catch (error, stackTrace) {
      LoggerUtils.error('密码哈希生成失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 验证密码
  bool verifyPassword(String password, String hash) {
    try {
      return BCrypt.checkpw(password, hash);
    } catch (error, stackTrace) {
      LoggerUtils.error('密码验证失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 生成随机字符串
  String generateRandomString(int length, {bool includeNumbers = true, bool includeSymbols = false}) {
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = letters;
    if (includeNumbers) chars += numbers;
    if (includeSymbols) chars += symbols;

    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  /// 生成安全的随机token
  String generateSecureToken([int length = 32]) {
    return generateRandomString(length, includeNumbers: true, includeSymbols: false);
  }

  /// 生成SHA256哈希值
  String sha256Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 生成MD5哈希值
  String md5Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// 简单的字符串加密（用于敏感配置）
  String encryptString(String plaintext, String key) {
    try {
      // 使用XOR加密（简单但有效）
      final keyBytes = utf8.encode(key);
      final plaintextBytes = utf8.encode(plaintext);
      final encryptedBytes = <int>[];

      for (int i = 0; i < plaintextBytes.length; i++) {
        encryptedBytes.add(plaintextBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return base64.encode(encryptedBytes);
    } catch (error, stackTrace) {
      LoggerUtils.error('字符串加密失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 简单的字符串解密
  String decryptString(String ciphertext, String key) {
    try {
      final keyBytes = utf8.encode(key);
      final ciphertextBytes = base64.decode(ciphertext);
      final decryptedBytes = <int>[];

      for (int i = 0; i < ciphertextBytes.length; i++) {
        decryptedBytes.add(ciphertextBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(decryptedBytes);
    } catch (error, stackTrace) {
      LoggerUtils.error('字符串解密失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 验证密码强度
  PasswordStrength checkPasswordStrength(String password) {
    int score = 0;
    final checks = <String>[];

    // 长度检查
    if (password.length >= 8) {
      score += 1;
      checks.add('长度足够');
    } else {
      checks.add('长度不足（至少8位）');
    }

    // 包含小写字母
    if (password.contains(RegExp(r'[a-z]'))) {
      score += 1;
      checks.add('包含小写字母');
    } else {
      checks.add('缺少小写字母');
    }

    // 包含大写字母
    if (password.contains(RegExp(r'[A-Z]'))) {
      score += 1;
      checks.add('包含大写字母');
    } else {
      checks.add('缺少大写字母');
    }

    // 包含数字
    if (password.contains(RegExp(r'[0-9]'))) {
      score += 1;
      checks.add('包含数字');
    } else {
      checks.add('缺少数字');
    }

    // 包含特殊字符
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score += 1;
      checks.add('包含特殊字符');
    } else {
      checks.add('缺少特殊字符');
    }

    // 长度奖励
    if (password.length >= 12) {
      score += 1;
      checks.add('长度优秀');
    }

    PasswordStrengthLevel level;
    if (score <= 2) {
      level = PasswordStrengthLevel.weak;
    } else if (score <= 4) {
      level = PasswordStrengthLevel.medium;
    } else {
      level = PasswordStrengthLevel.strong;
    }

    return PasswordStrength(
      level: level,
      score: score,
      maxScore: 6,
      checks: checks,
    );
  }

  /// 生成双因子认证密钥
  String generateTwoFactorSecret() {
    // 生成32字符的Base32编码密钥
    const base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final random = Random.secure();

    return String.fromCharCodes(
        Iterable.generate(32, (_) => base32Chars.codeUnitAt(random.nextInt(base32Chars.length))));
  }

  /// 验证邮箱格式
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// 生成验证码
  String generateVerificationCode([int length = 6]) {
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(length, (_) => '0123456789'.codeUnitAt(random.nextInt(10))));
  }

  /// 生成文件哈希值（用于文件去重）
  String generateFileHash(List<int> fileBytes) {
    final digest = sha256.convert(fileBytes);
    return digest.toString();
  }
}

/// 密码强度级别
enum PasswordStrengthLevel {
  weak,
  medium,
  strong,
}

/// 密码强度检查结果
class PasswordStrength {
  final PasswordStrengthLevel level;
  final int score;
  final int maxScore;
  final List<String> checks;

  const PasswordStrength({
    required this.level,
    required this.score,
    required this.maxScore,
    required this.checks,
  });

  /// 获取强度描述
  String get description {
    switch (level) {
      case PasswordStrengthLevel.weak:
        return '弱';
      case PasswordStrengthLevel.medium:
        return '中等';
      case PasswordStrengthLevel.strong:
        return '强';
    }
  }

  /// 获取强度百分比
  double get percentage => score / maxScore;

  /// 是否通过最低要求
  bool get isAcceptable => level != PasswordStrengthLevel.weak;
}

/// 令牌哈希方法
extension TokenHashing on CryptoUtils {
  /// 生成令牌的SHA256哈希值
  String hashToken(String token) {
    final bytes = utf8.encode(token);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
