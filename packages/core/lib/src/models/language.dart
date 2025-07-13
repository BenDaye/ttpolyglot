import 'package:equatable/equatable.dart';

/// 语言模型
class Language extends Equatable {
  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    this.isRtl = false,
  });

  /// 语言代码 (如: en, zh-CN, ja)
  final String code;

  /// 英文名称 (如: English, Chinese, Japanese)
  final String name;

  /// 本地名称 (如: English, 中文, 日本語)
  final String nativeName;

  /// 是否为从右到左的语言
  final bool isRtl;

  /// 复制并更新语言信息
  Language copyWith({
    String? code,
    String? name,
    String? nativeName,
    bool? isRtl,
  }) {
    return Language(
      code: code ?? this.code,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      isRtl: isRtl ?? this.isRtl,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'isRtl': isRtl,
    };
  }

  /// 从 JSON 创建
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String,
      isRtl: json['isRtl'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [code, name, nativeName, isRtl];

  @override
  String toString() => 'Language(code: $code, name: $name)';
}
