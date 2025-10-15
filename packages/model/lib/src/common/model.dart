import 'dart:convert';

typedef Converter<T> = T Function(Map<String, dynamic>);

abstract class Model<T extends Model<T>> {
  const Model();

  int get id => 0;

  Map<String, dynamic> toJson();

  @override
  String toString() => json.encode(this);
}
