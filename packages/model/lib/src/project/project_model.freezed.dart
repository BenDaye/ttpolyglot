// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return _ProjectModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'language_count')
  int get languageCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_count')
  int get memberCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_entries')
  int get totalEntries => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_entries')
  int get completedEntries => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewing_entries')
  int get reviewingEntries => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_entries')
  int get approvedEntries => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_quality_score')
  double get avgQualityScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectModelCopyWith<ProjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectModelCopyWith<$Res> {
  factory $ProjectModelCopyWith(
          ProjectModel value, $Res Function(ProjectModel) then) =
      _$ProjectModelCopyWithImpl<$Res, ProjectModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'language_count') int languageCount,
      @JsonKey(name: 'member_count') int memberCount,
      @JsonKey(name: 'total_entries') int totalEntries,
      @JsonKey(name: 'completed_entries') int completedEntries,
      @JsonKey(name: 'reviewing_entries') int reviewingEntries,
      @JsonKey(name: 'approved_entries') int approvedEntries,
      @JsonKey(name: 'avg_quality_score') double avgQualityScore,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ProjectModelCopyWithImpl<$Res, $Val extends ProjectModel>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? languageCount = null,
    Object? memberCount = null,
    Object? totalEntries = null,
    Object? completedEntries = null,
    Object? reviewingEntries = null,
    Object? approvedEntries = null,
    Object? avgQualityScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      languageCount: null == languageCount
          ? _value.languageCount
          : languageCount // ignore: cast_nullable_to_non_nullable
              as int,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalEntries: null == totalEntries
          ? _value.totalEntries
          : totalEntries // ignore: cast_nullable_to_non_nullable
              as int,
      completedEntries: null == completedEntries
          ? _value.completedEntries
          : completedEntries // ignore: cast_nullable_to_non_nullable
              as int,
      reviewingEntries: null == reviewingEntries
          ? _value.reviewingEntries
          : reviewingEntries // ignore: cast_nullable_to_non_nullable
              as int,
      approvedEntries: null == approvedEntries
          ? _value.approvedEntries
          : approvedEntries // ignore: cast_nullable_to_non_nullable
              as int,
      avgQualityScore: null == avgQualityScore
          ? _value.avgQualityScore
          : avgQualityScore // ignore: cast_nullable_to_non_nullable
              as double,
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
abstract class _$$ProjectModelImplCopyWith<$Res>
    implements $ProjectModelCopyWith<$Res> {
  factory _$$ProjectModelImplCopyWith(
          _$ProjectModelImpl value, $Res Function(_$ProjectModelImpl) then) =
      __$$ProjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'language_count') int languageCount,
      @JsonKey(name: 'member_count') int memberCount,
      @JsonKey(name: 'total_entries') int totalEntries,
      @JsonKey(name: 'completed_entries') int completedEntries,
      @JsonKey(name: 'reviewing_entries') int reviewingEntries,
      @JsonKey(name: 'approved_entries') int approvedEntries,
      @JsonKey(name: 'avg_quality_score') double avgQualityScore,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ProjectModelImplCopyWithImpl<$Res>
    extends _$ProjectModelCopyWithImpl<$Res, _$ProjectModelImpl>
    implements _$$ProjectModelImplCopyWith<$Res> {
  __$$ProjectModelImplCopyWithImpl(
      _$ProjectModelImpl _value, $Res Function(_$ProjectModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? languageCount = null,
    Object? memberCount = null,
    Object? totalEntries = null,
    Object? completedEntries = null,
    Object? reviewingEntries = null,
    Object? approvedEntries = null,
    Object? avgQualityScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProjectModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      languageCount: null == languageCount
          ? _value.languageCount
          : languageCount // ignore: cast_nullable_to_non_nullable
              as int,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalEntries: null == totalEntries
          ? _value.totalEntries
          : totalEntries // ignore: cast_nullable_to_non_nullable
              as int,
      completedEntries: null == completedEntries
          ? _value.completedEntries
          : completedEntries // ignore: cast_nullable_to_non_nullable
              as int,
      reviewingEntries: null == reviewingEntries
          ? _value.reviewingEntries
          : reviewingEntries // ignore: cast_nullable_to_non_nullable
              as int,
      approvedEntries: null == approvedEntries
          ? _value.approvedEntries
          : approvedEntries // ignore: cast_nullable_to_non_nullable
              as int,
      avgQualityScore: null == avgQualityScore
          ? _value.avgQualityScore
          : avgQualityScore // ignore: cast_nullable_to_non_nullable
              as double,
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
class _$ProjectModelImpl implements _ProjectModel {
  const _$ProjectModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'language_count') required this.languageCount,
      @JsonKey(name: 'member_count') required this.memberCount,
      @JsonKey(name: 'total_entries') required this.totalEntries,
      @JsonKey(name: 'completed_entries') required this.completedEntries,
      @JsonKey(name: 'reviewing_entries') required this.reviewingEntries,
      @JsonKey(name: 'approved_entries') required this.approvedEntries,
      @JsonKey(name: 'avg_quality_score') required this.avgQualityScore,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'language_count')
  final int languageCount;
  @override
  @JsonKey(name: 'member_count')
  final int memberCount;
  @override
  @JsonKey(name: 'total_entries')
  final int totalEntries;
  @override
  @JsonKey(name: 'completed_entries')
  final int completedEntries;
  @override
  @JsonKey(name: 'reviewing_entries')
  final int reviewingEntries;
  @override
  @JsonKey(name: 'approved_entries')
  final int approvedEntries;
  @override
  @JsonKey(name: 'avg_quality_score')
  final double avgQualityScore;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProjectModel(id: $id, languageCount: $languageCount, memberCount: $memberCount, totalEntries: $totalEntries, completedEntries: $completedEntries, reviewingEntries: $reviewingEntries, approvedEntries: $approvedEntries, avgQualityScore: $avgQualityScore, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.languageCount, languageCount) ||
                other.languageCount == languageCount) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.totalEntries, totalEntries) ||
                other.totalEntries == totalEntries) &&
            (identical(other.completedEntries, completedEntries) ||
                other.completedEntries == completedEntries) &&
            (identical(other.reviewingEntries, reviewingEntries) ||
                other.reviewingEntries == reviewingEntries) &&
            (identical(other.approvedEntries, approvedEntries) ||
                other.approvedEntries == approvedEntries) &&
            (identical(other.avgQualityScore, avgQualityScore) ||
                other.avgQualityScore == avgQualityScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      languageCount,
      memberCount,
      totalEntries,
      completedEntries,
      reviewingEntries,
      approvedEntries,
      avgQualityScore,
      createdAt,
      updatedAt);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      __$$ProjectModelImplCopyWithImpl<_$ProjectModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectModel implements ProjectModel {
  const factory _ProjectModel(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'language_count') required final int languageCount,
      @JsonKey(name: 'member_count') required final int memberCount,
      @JsonKey(name: 'total_entries') required final int totalEntries,
      @JsonKey(name: 'completed_entries') required final int completedEntries,
      @JsonKey(name: 'reviewing_entries') required final int reviewingEntries,
      @JsonKey(name: 'approved_entries') required final int approvedEntries,
      @JsonKey(name: 'avg_quality_score') required final double avgQualityScore,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$ProjectModelImpl;

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'language_count')
  int get languageCount;
  @override
  @JsonKey(name: 'member_count')
  int get memberCount;
  @override
  @JsonKey(name: 'total_entries')
  int get totalEntries;
  @override
  @JsonKey(name: 'completed_entries')
  int get completedEntries;
  @override
  @JsonKey(name: 'reviewing_entries')
  int get reviewingEntries;
  @override
  @JsonKey(name: 'approved_entries')
  int get approvedEntries;
  @override
  @JsonKey(name: 'avg_quality_score')
  double get avgQualityScore;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
