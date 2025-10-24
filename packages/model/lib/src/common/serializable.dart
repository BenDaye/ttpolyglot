import 'dart:convert';

/// 序列化接口
/// 所有需要序列化的模型都应该实现此接口
typedef Converter<T> = T Function(Map<String, dynamic>);

abstract class Serializable<T extends Serializable<T>> {
  const Serializable();

  Map<String, dynamic> toJson();

  @override
  String toString() => json.encode(this);
}
