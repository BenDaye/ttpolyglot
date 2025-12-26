// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  /// 通知ID
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id => throw _privateConstructorUsedError;

  /// 用户ID
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// 通知标题
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;

  /// 通知内容
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;

  /// 通知类型
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;

  /// 通知优先级
  @JsonKey(name: 'priority')
  String get priority => throw _privateConstructorUsedError;

  /// 是否已读
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;

  /// 是否为系统通知
  @JsonKey(name: 'is_system')
  bool get isSystem => throw _privateConstructorUsedError;

  /// 操作URL
  @JsonKey(name: 'action_url')
  String? get actionUrl => throw _privateConstructorUsedError;

  /// 元数据（JSONB格式）
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 阅读时间
  @JsonKey(name: 'read_at')
  @NullableTimesConverter()
  DateTime? get readAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'priority') String priority,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'is_system') bool isSystem,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'read_at') @NullableTimesConverter() DateTime? readAt});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? priority = null,
    Object? isRead = null,
    Object? isSystem = null,
    Object? actionUrl = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? readAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'priority') String priority,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'is_system') bool isSystem,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'read_at') @NullableTimesConverter() DateTime? readAt});
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? priority = null,
    Object? isRead = null,
    Object? isSystem = null,
    Object? actionUrl = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? readAt = freezed,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystem: null == isSystem
          ? _value.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl extends _NotificationModel {
  const _$NotificationModelImpl(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'message') required this.message,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'priority') this.priority = 'normal',
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'is_system') this.isSystem = false,
      @JsonKey(name: 'action_url') this.actionUrl,
      @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'read_at') @NullableTimesConverter() this.readAt})
      : _metadata = metadata,
        super._();

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  /// 通知ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  final int id;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// 通知标题
  @override
  @JsonKey(name: 'title')
  final String title;

  /// 通知内容
  @override
  @JsonKey(name: 'message')
  final String message;

  /// 通知类型
  @override
  @JsonKey(name: 'type')
  final String type;

  /// 通知优先级
  @override
  @JsonKey(name: 'priority')
  final String priority;

  /// 是否已读
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;

  /// 是否为系统通知
  @override
  @JsonKey(name: 'is_system')
  final bool isSystem;

  /// 操作URL
  @override
  @JsonKey(name: 'action_url')
  final String? actionUrl;

  /// 元数据（JSONB格式）
  final Map<String, dynamic>? _metadata;

  /// 元数据（JSONB格式）
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  final DateTime createdAt;

  /// 阅读时间
  @override
  @JsonKey(name: 'read_at')
  @NullableTimesConverter()
  final DateTime? readAt;

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, title: $title, message: $message, type: $type, priority: $priority, isRead: $isRead, isSystem: $isSystem, actionUrl: $actionUrl, metadata: $metadata, createdAt: $createdAt, readAt: $readAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      message,
      type,
      priority,
      isRead,
      isSystem,
      actionUrl,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      readAt);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel extends NotificationModel {
  const factory _NotificationModel(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required final int id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'title') required final String title,
      @JsonKey(name: 'message') required final String message,
      @JsonKey(name: 'type') required final String type,
      @JsonKey(name: 'priority') final String priority,
      @JsonKey(name: 'is_read') final bool isRead,
      @JsonKey(name: 'is_system') final bool isSystem,
      @JsonKey(name: 'action_url') final String? actionUrl,
      @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'read_at')
      @NullableTimesConverter()
      final DateTime? readAt}) = _$NotificationModelImpl;
  const _NotificationModel._() : super._();

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  /// 通知ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// 通知标题
  @override
  @JsonKey(name: 'title')
  String get title;

  /// 通知内容
  @override
  @JsonKey(name: 'message')
  String get message;

  /// 通知类型
  @override
  @JsonKey(name: 'type')
  String get type;

  /// 通知优先级
  @override
  @JsonKey(name: 'priority')
  String get priority;

  /// 是否已读
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;

  /// 是否为系统通知
  @override
  @JsonKey(name: 'is_system')
  bool get isSystem;

  /// 操作URL
  @override
  @JsonKey(name: 'action_url')
  String? get actionUrl;

  /// 元数据（JSONB格式）
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;

  /// 阅读时间
  @override
  @JsonKey(name: 'read_at')
  @NullableTimesConverter()
  DateTime? get readAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
