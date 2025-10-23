// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationSettingsModel _$NotificationSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettingsModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_id')
  int? get projectId => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_type')
  String get notificationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'channel')
  String get channel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_enabled')
  bool get isEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsModelCopyWith<NotificationSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsModelCopyWith<$Res> {
  factory $NotificationSettingsModelCopyWith(NotificationSettingsModel value,
          $Res Function(NotificationSettingsModel) then) =
      _$NotificationSettingsModelCopyWithImpl<$Res, NotificationSettingsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'project_id') int? projectId,
      @JsonKey(name: 'notification_type') String notificationType,
      @JsonKey(name: 'channel') String channel,
      @JsonKey(name: 'is_enabled') bool isEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$NotificationSettingsModelCopyWithImpl<$Res,
        $Val extends NotificationSettingsModel>
    implements $NotificationSettingsModelCopyWith<$Res> {
  _$NotificationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? projectId = freezed,
    Object? notificationType = null,
    Object? channel = null,
    Object? isEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int?,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsModelImplCopyWith<$Res>
    implements $NotificationSettingsModelCopyWith<$Res> {
  factory _$$NotificationSettingsModelImplCopyWith(
          _$NotificationSettingsModelImpl value,
          $Res Function(_$NotificationSettingsModelImpl) then) =
      __$$NotificationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'project_id') int? projectId,
      @JsonKey(name: 'notification_type') String notificationType,
      @JsonKey(name: 'channel') String channel,
      @JsonKey(name: 'is_enabled') bool isEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$NotificationSettingsModelImplCopyWithImpl<$Res>
    extends _$NotificationSettingsModelCopyWithImpl<$Res,
        _$NotificationSettingsModelImpl>
    implements _$$NotificationSettingsModelImplCopyWith<$Res> {
  __$$NotificationSettingsModelImplCopyWithImpl(
      _$NotificationSettingsModelImpl _value,
      $Res Function(_$NotificationSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? projectId = freezed,
    Object? notificationType = null,
    Object? channel = null,
    Object? isEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NotificationSettingsModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int?,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsModelImpl implements _NotificationSettingsModel {
  const _$NotificationSettingsModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'project_id') this.projectId,
      @JsonKey(name: 'notification_type') required this.notificationType,
      @JsonKey(name: 'channel') required this.channel,
      @JsonKey(name: 'is_enabled') this.isEnabled = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$NotificationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'project_id')
  final int? projectId;
  @override
  @JsonKey(name: 'notification_type')
  final String notificationType;
  @override
  @JsonKey(name: 'channel')
  final String channel;
  @override
  @JsonKey(name: 'is_enabled')
  final bool isEnabled;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NotificationSettingsModel(id: $id, userId: $userId, projectId: $projectId, notificationType: $notificationType, channel: $channel, isEnabled: $isEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, projectId,
      notificationType, channel, isEnabled, createdAt, updatedAt);

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
      get copyWith => __$$NotificationSettingsModelImplCopyWithImpl<
          _$NotificationSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettingsModel implements NotificationSettingsModel {
  const factory _NotificationSettingsModel(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'project_id') final int? projectId,
          @JsonKey(name: 'notification_type')
          required final String notificationType,
          @JsonKey(name: 'channel') required final String channel,
          @JsonKey(name: 'is_enabled') final bool isEnabled,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$NotificationSettingsModelImpl;

  factory _NotificationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'project_id')
  int? get projectId;
  @override
  @JsonKey(name: 'notification_type')
  String get notificationType;
  @override
  @JsonKey(name: 'channel')
  String get channel;
  @override
  @JsonKey(name: 'is_enabled')
  bool get isEnabled;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateNotificationSettingsRequest _$UpdateNotificationSettingsRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateNotificationSettingsRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateNotificationSettingsRequest {
  String get userId => throw _privateConstructorUsedError;
  int? get projectId => throw _privateConstructorUsedError;
  String get notificationType => throw _privateConstructorUsedError;
  String get channel => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this UpdateNotificationSettingsRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateNotificationSettingsRequestCopyWith<UpdateNotificationSettingsRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateNotificationSettingsRequestCopyWith<$Res> {
  factory $UpdateNotificationSettingsRequestCopyWith(
          UpdateNotificationSettingsRequest value,
          $Res Function(UpdateNotificationSettingsRequest) then) =
      _$UpdateNotificationSettingsRequestCopyWithImpl<$Res,
          UpdateNotificationSettingsRequest>;
  @useResult
  $Res call(
      {String userId,
      int? projectId,
      String notificationType,
      String channel,
      bool isEnabled});
}

/// @nodoc
class _$UpdateNotificationSettingsRequestCopyWithImpl<$Res,
        $Val extends UpdateNotificationSettingsRequest>
    implements $UpdateNotificationSettingsRequestCopyWith<$Res> {
  _$UpdateNotificationSettingsRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? projectId = freezed,
    Object? notificationType = null,
    Object? channel = null,
    Object? isEnabled = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int?,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateNotificationSettingsRequestImplCopyWith<$Res>
    implements $UpdateNotificationSettingsRequestCopyWith<$Res> {
  factory _$$UpdateNotificationSettingsRequestImplCopyWith(
          _$UpdateNotificationSettingsRequestImpl value,
          $Res Function(_$UpdateNotificationSettingsRequestImpl) then) =
      __$$UpdateNotificationSettingsRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int? projectId,
      String notificationType,
      String channel,
      bool isEnabled});
}

/// @nodoc
class __$$UpdateNotificationSettingsRequestImplCopyWithImpl<$Res>
    extends _$UpdateNotificationSettingsRequestCopyWithImpl<$Res,
        _$UpdateNotificationSettingsRequestImpl>
    implements _$$UpdateNotificationSettingsRequestImplCopyWith<$Res> {
  __$$UpdateNotificationSettingsRequestImplCopyWithImpl(
      _$UpdateNotificationSettingsRequestImpl _value,
      $Res Function(_$UpdateNotificationSettingsRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? projectId = freezed,
    Object? notificationType = null,
    Object? channel = null,
    Object? isEnabled = null,
  }) {
    return _then(_$UpdateNotificationSettingsRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int?,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateNotificationSettingsRequestImpl
    implements _UpdateNotificationSettingsRequest {
  const _$UpdateNotificationSettingsRequestImpl(
      {required this.userId,
      this.projectId,
      required this.notificationType,
      required this.channel,
      required this.isEnabled});

  factory _$UpdateNotificationSettingsRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateNotificationSettingsRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final int? projectId;
  @override
  final String notificationType;
  @override
  final String channel;
  @override
  final bool isEnabled;

  @override
  String toString() {
    return 'UpdateNotificationSettingsRequest(userId: $userId, projectId: $projectId, notificationType: $notificationType, channel: $channel, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateNotificationSettingsRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, projectId, notificationType, channel, isEnabled);

  /// Create a copy of UpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateNotificationSettingsRequestImplCopyWith<
          _$UpdateNotificationSettingsRequestImpl>
      get copyWith => __$$UpdateNotificationSettingsRequestImplCopyWithImpl<
          _$UpdateNotificationSettingsRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateNotificationSettingsRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateNotificationSettingsRequest
    implements UpdateNotificationSettingsRequest {
  const factory _UpdateNotificationSettingsRequest(
      {required final String userId,
      final int? projectId,
      required final String notificationType,
      required final String channel,
      required final bool isEnabled}) = _$UpdateNotificationSettingsRequestImpl;

  factory _UpdateNotificationSettingsRequest.fromJson(
          Map<String, dynamic> json) =
      _$UpdateNotificationSettingsRequestImpl.fromJson;

  @override
  String get userId;
  @override
  int? get projectId;
  @override
  String get notificationType;
  @override
  String get channel;
  @override
  bool get isEnabled;

  /// Create a copy of UpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateNotificationSettingsRequestImplCopyWith<
          _$UpdateNotificationSettingsRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BatchUpdateNotificationSettingsRequest
    _$BatchUpdateNotificationSettingsRequestFromJson(
        Map<String, dynamic> json) {
  return _BatchUpdateNotificationSettingsRequest.fromJson(json);
}

/// @nodoc
mixin _$BatchUpdateNotificationSettingsRequest {
  String get userId => throw _privateConstructorUsedError;
  int? get projectId => throw _privateConstructorUsedError;
  List<NotificationSettingUpdate> get updates =>
      throw _privateConstructorUsedError;

  /// Serializes this BatchUpdateNotificationSettingsRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchUpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchUpdateNotificationSettingsRequestCopyWith<
          BatchUpdateNotificationSettingsRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchUpdateNotificationSettingsRequestCopyWith<$Res> {
  factory $BatchUpdateNotificationSettingsRequestCopyWith(
          BatchUpdateNotificationSettingsRequest value,
          $Res Function(BatchUpdateNotificationSettingsRequest) then) =
      _$BatchUpdateNotificationSettingsRequestCopyWithImpl<$Res,
          BatchUpdateNotificationSettingsRequest>;
  @useResult
  $Res call(
      {String userId, int? projectId, List<NotificationSettingUpdate> updates});
}

/// @nodoc
class _$BatchUpdateNotificationSettingsRequestCopyWithImpl<$Res,
        $Val extends BatchUpdateNotificationSettingsRequest>
    implements $BatchUpdateNotificationSettingsRequestCopyWith<$Res> {
  _$BatchUpdateNotificationSettingsRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchUpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? projectId = freezed,
    Object? updates = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int?,
      updates: null == updates
          ? _value.updates
          : updates // ignore: cast_nullable_to_non_nullable
              as List<NotificationSettingUpdate>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchUpdateNotificationSettingsRequestImplCopyWith<$Res>
    implements $BatchUpdateNotificationSettingsRequestCopyWith<$Res> {
  factory _$$BatchUpdateNotificationSettingsRequestImplCopyWith(
          _$BatchUpdateNotificationSettingsRequestImpl value,
          $Res Function(_$BatchUpdateNotificationSettingsRequestImpl) then) =
      __$$BatchUpdateNotificationSettingsRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId, int? projectId, List<NotificationSettingUpdate> updates});
}

/// @nodoc
class __$$BatchUpdateNotificationSettingsRequestImplCopyWithImpl<$Res>
    extends _$BatchUpdateNotificationSettingsRequestCopyWithImpl<$Res,
        _$BatchUpdateNotificationSettingsRequestImpl>
    implements _$$BatchUpdateNotificationSettingsRequestImplCopyWith<$Res> {
  __$$BatchUpdateNotificationSettingsRequestImplCopyWithImpl(
      _$BatchUpdateNotificationSettingsRequestImpl _value,
      $Res Function(_$BatchUpdateNotificationSettingsRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchUpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? projectId = freezed,
    Object? updates = null,
  }) {
    return _then(_$BatchUpdateNotificationSettingsRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int?,
      updates: null == updates
          ? _value._updates
          : updates // ignore: cast_nullable_to_non_nullable
              as List<NotificationSettingUpdate>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchUpdateNotificationSettingsRequestImpl
    implements _BatchUpdateNotificationSettingsRequest {
  const _$BatchUpdateNotificationSettingsRequestImpl(
      {required this.userId,
      this.projectId,
      required final List<NotificationSettingUpdate> updates})
      : _updates = updates;

  factory _$BatchUpdateNotificationSettingsRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BatchUpdateNotificationSettingsRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final int? projectId;
  final List<NotificationSettingUpdate> _updates;
  @override
  List<NotificationSettingUpdate> get updates {
    if (_updates is EqualUnmodifiableListView) return _updates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_updates);
  }

  @override
  String toString() {
    return 'BatchUpdateNotificationSettingsRequest(userId: $userId, projectId: $projectId, updates: $updates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchUpdateNotificationSettingsRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            const DeepCollectionEquality().equals(other._updates, _updates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, projectId,
      const DeepCollectionEquality().hash(_updates));

  /// Create a copy of BatchUpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchUpdateNotificationSettingsRequestImplCopyWith<
          _$BatchUpdateNotificationSettingsRequestImpl>
      get copyWith =>
          __$$BatchUpdateNotificationSettingsRequestImplCopyWithImpl<
              _$BatchUpdateNotificationSettingsRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchUpdateNotificationSettingsRequestImplToJson(
      this,
    );
  }
}

abstract class _BatchUpdateNotificationSettingsRequest
    implements BatchUpdateNotificationSettingsRequest {
  const factory _BatchUpdateNotificationSettingsRequest(
          {required final String userId,
          final int? projectId,
          required final List<NotificationSettingUpdate> updates}) =
      _$BatchUpdateNotificationSettingsRequestImpl;

  factory _BatchUpdateNotificationSettingsRequest.fromJson(
          Map<String, dynamic> json) =
      _$BatchUpdateNotificationSettingsRequestImpl.fromJson;

  @override
  String get userId;
  @override
  int? get projectId;
  @override
  List<NotificationSettingUpdate> get updates;

  /// Create a copy of BatchUpdateNotificationSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchUpdateNotificationSettingsRequestImplCopyWith<
          _$BatchUpdateNotificationSettingsRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationSettingUpdate _$NotificationSettingUpdateFromJson(
    Map<String, dynamic> json) {
  return _NotificationSettingUpdate.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettingUpdate {
  String get notificationType => throw _privateConstructorUsedError;
  String get channel => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettingUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingUpdateCopyWith<NotificationSettingUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingUpdateCopyWith<$Res> {
  factory $NotificationSettingUpdateCopyWith(NotificationSettingUpdate value,
          $Res Function(NotificationSettingUpdate) then) =
      _$NotificationSettingUpdateCopyWithImpl<$Res, NotificationSettingUpdate>;
  @useResult
  $Res call({String notificationType, String channel, bool isEnabled});
}

/// @nodoc
class _$NotificationSettingUpdateCopyWithImpl<$Res,
        $Val extends NotificationSettingUpdate>
    implements $NotificationSettingUpdateCopyWith<$Res> {
  _$NotificationSettingUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationType = null,
    Object? channel = null,
    Object? isEnabled = null,
  }) {
    return _then(_value.copyWith(
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingUpdateImplCopyWith<$Res>
    implements $NotificationSettingUpdateCopyWith<$Res> {
  factory _$$NotificationSettingUpdateImplCopyWith(
          _$NotificationSettingUpdateImpl value,
          $Res Function(_$NotificationSettingUpdateImpl) then) =
      __$$NotificationSettingUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String notificationType, String channel, bool isEnabled});
}

/// @nodoc
class __$$NotificationSettingUpdateImplCopyWithImpl<$Res>
    extends _$NotificationSettingUpdateCopyWithImpl<$Res,
        _$NotificationSettingUpdateImpl>
    implements _$$NotificationSettingUpdateImplCopyWith<$Res> {
  __$$NotificationSettingUpdateImplCopyWithImpl(
      _$NotificationSettingUpdateImpl _value,
      $Res Function(_$NotificationSettingUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSettingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationType = null,
    Object? channel = null,
    Object? isEnabled = null,
  }) {
    return _then(_$NotificationSettingUpdateImpl(
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingUpdateImpl implements _NotificationSettingUpdate {
  const _$NotificationSettingUpdateImpl(
      {required this.notificationType,
      required this.channel,
      required this.isEnabled});

  factory _$NotificationSettingUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingUpdateImplFromJson(json);

  @override
  final String notificationType;
  @override
  final String channel;
  @override
  final bool isEnabled;

  @override
  String toString() {
    return 'NotificationSettingUpdate(notificationType: $notificationType, channel: $channel, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingUpdateImpl &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, notificationType, channel, isEnabled);

  /// Create a copy of NotificationSettingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingUpdateImplCopyWith<_$NotificationSettingUpdateImpl>
      get copyWith => __$$NotificationSettingUpdateImplCopyWithImpl<
          _$NotificationSettingUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingUpdateImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettingUpdate implements NotificationSettingUpdate {
  const factory _NotificationSettingUpdate(
      {required final String notificationType,
      required final String channel,
      required final bool isEnabled}) = _$NotificationSettingUpdateImpl;

  factory _NotificationSettingUpdate.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingUpdateImpl.fromJson;

  @override
  String get notificationType;
  @override
  String get channel;
  @override
  bool get isEnabled;

  /// Create a copy of NotificationSettingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingUpdateImplCopyWith<_$NotificationSettingUpdateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
