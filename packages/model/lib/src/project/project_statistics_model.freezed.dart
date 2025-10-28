// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_statistics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectStatisticsModel _$ProjectStatisticsModelFromJson(
    Map<String, dynamic> json) {
  return _ProjectStatisticsModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectStatisticsModel {
  /// 项目语言数
  @JsonKey(name: 'language_count')
  @FlexibleIntConverter()
  int get languageCount => throw _privateConstructorUsedError;

  /// 项目成员数
  @JsonKey(name: 'member_count')
  @FlexibleIntConverter()
  int get memberCount => throw _privateConstructorUsedError;

  /// 项目总键数
  @JsonKey(name: 'total_entries')
  @FlexibleIntConverter()
  int get totalEntries => throw _privateConstructorUsedError;

  /// 项目已翻译键数
  @JsonKey(name: 'translated_entries')
  @FlexibleIntConverter()
  int get translatedEntries => throw _privateConstructorUsedError;

  /// 项目审核中键数
  @JsonKey(name: 'reviewing_entries')
  @FlexibleIntConverter()
  int get reviewingEntries => throw _privateConstructorUsedError;

  /// 项目批准键数
  @JsonKey(name: 'approved_entries')
  @FlexibleIntConverter()
  int get approvedEntries => throw _privateConstructorUsedError;

  /// 项目平均质量分数
  @JsonKey(name: 'avg_quality_score')
  @FlexibleDoubleConverter()
  double get avgQualityScore => throw _privateConstructorUsedError;

  /// Serializes this ProjectStatisticsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectStatisticsModelCopyWith<ProjectStatisticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectStatisticsModelCopyWith<$Res> {
  factory $ProjectStatisticsModelCopyWith(ProjectStatisticsModel value,
          $Res Function(ProjectStatisticsModel) then) =
      _$ProjectStatisticsModelCopyWithImpl<$Res, ProjectStatisticsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'language_count')
      @FlexibleIntConverter()
      int languageCount,
      @JsonKey(name: 'member_count') @FlexibleIntConverter() int memberCount,
      @JsonKey(name: 'total_entries') @FlexibleIntConverter() int totalEntries,
      @JsonKey(name: 'translated_entries')
      @FlexibleIntConverter()
      int translatedEntries,
      @JsonKey(name: 'reviewing_entries')
      @FlexibleIntConverter()
      int reviewingEntries,
      @JsonKey(name: 'approved_entries')
      @FlexibleIntConverter()
      int approvedEntries,
      @JsonKey(name: 'avg_quality_score')
      @FlexibleDoubleConverter()
      double avgQualityScore});
}

/// @nodoc
class _$ProjectStatisticsModelCopyWithImpl<$Res,
        $Val extends ProjectStatisticsModel>
    implements $ProjectStatisticsModelCopyWith<$Res> {
  _$ProjectStatisticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCount = null,
    Object? memberCount = null,
    Object? totalEntries = null,
    Object? translatedEntries = null,
    Object? reviewingEntries = null,
    Object? approvedEntries = null,
    Object? avgQualityScore = null,
  }) {
    return _then(_value.copyWith(
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
      translatedEntries: null == translatedEntries
          ? _value.translatedEntries
          : translatedEntries // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectStatisticsModelImplCopyWith<$Res>
    implements $ProjectStatisticsModelCopyWith<$Res> {
  factory _$$ProjectStatisticsModelImplCopyWith(
          _$ProjectStatisticsModelImpl value,
          $Res Function(_$ProjectStatisticsModelImpl) then) =
      __$$ProjectStatisticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'language_count')
      @FlexibleIntConverter()
      int languageCount,
      @JsonKey(name: 'member_count') @FlexibleIntConverter() int memberCount,
      @JsonKey(name: 'total_entries') @FlexibleIntConverter() int totalEntries,
      @JsonKey(name: 'translated_entries')
      @FlexibleIntConverter()
      int translatedEntries,
      @JsonKey(name: 'reviewing_entries')
      @FlexibleIntConverter()
      int reviewingEntries,
      @JsonKey(name: 'approved_entries')
      @FlexibleIntConverter()
      int approvedEntries,
      @JsonKey(name: 'avg_quality_score')
      @FlexibleDoubleConverter()
      double avgQualityScore});
}

/// @nodoc
class __$$ProjectStatisticsModelImplCopyWithImpl<$Res>
    extends _$ProjectStatisticsModelCopyWithImpl<$Res,
        _$ProjectStatisticsModelImpl>
    implements _$$ProjectStatisticsModelImplCopyWith<$Res> {
  __$$ProjectStatisticsModelImplCopyWithImpl(
      _$ProjectStatisticsModelImpl _value,
      $Res Function(_$ProjectStatisticsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCount = null,
    Object? memberCount = null,
    Object? totalEntries = null,
    Object? translatedEntries = null,
    Object? reviewingEntries = null,
    Object? approvedEntries = null,
    Object? avgQualityScore = null,
  }) {
    return _then(_$ProjectStatisticsModelImpl(
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
      translatedEntries: null == translatedEntries
          ? _value.translatedEntries
          : translatedEntries // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectStatisticsModelImpl implements _ProjectStatisticsModel {
  const _$ProjectStatisticsModelImpl(
      {@JsonKey(name: 'language_count')
      @FlexibleIntConverter()
      this.languageCount = 0,
      @JsonKey(name: 'member_count')
      @FlexibleIntConverter()
      this.memberCount = 1,
      @JsonKey(name: 'total_entries')
      @FlexibleIntConverter()
      this.totalEntries = 0,
      @JsonKey(name: 'translated_entries')
      @FlexibleIntConverter()
      this.translatedEntries = 0,
      @JsonKey(name: 'reviewing_entries')
      @FlexibleIntConverter()
      this.reviewingEntries = 0,
      @JsonKey(name: 'approved_entries')
      @FlexibleIntConverter()
      this.approvedEntries = 0,
      @JsonKey(name: 'avg_quality_score')
      @FlexibleDoubleConverter()
      this.avgQualityScore = 0.0});

  factory _$ProjectStatisticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectStatisticsModelImplFromJson(json);

  /// 项目语言数
  @override
  @JsonKey(name: 'language_count')
  @FlexibleIntConverter()
  final int languageCount;

  /// 项目成员数
  @override
  @JsonKey(name: 'member_count')
  @FlexibleIntConverter()
  final int memberCount;

  /// 项目总键数
  @override
  @JsonKey(name: 'total_entries')
  @FlexibleIntConverter()
  final int totalEntries;

  /// 项目已翻译键数
  @override
  @JsonKey(name: 'translated_entries')
  @FlexibleIntConverter()
  final int translatedEntries;

  /// 项目审核中键数
  @override
  @JsonKey(name: 'reviewing_entries')
  @FlexibleIntConverter()
  final int reviewingEntries;

  /// 项目批准键数
  @override
  @JsonKey(name: 'approved_entries')
  @FlexibleIntConverter()
  final int approvedEntries;

  /// 项目平均质量分数
  @override
  @JsonKey(name: 'avg_quality_score')
  @FlexibleDoubleConverter()
  final double avgQualityScore;

  @override
  String toString() {
    return 'ProjectStatisticsModel(languageCount: $languageCount, memberCount: $memberCount, totalEntries: $totalEntries, translatedEntries: $translatedEntries, reviewingEntries: $reviewingEntries, approvedEntries: $approvedEntries, avgQualityScore: $avgQualityScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectStatisticsModelImpl &&
            (identical(other.languageCount, languageCount) ||
                other.languageCount == languageCount) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.totalEntries, totalEntries) ||
                other.totalEntries == totalEntries) &&
            (identical(other.translatedEntries, translatedEntries) ||
                other.translatedEntries == translatedEntries) &&
            (identical(other.reviewingEntries, reviewingEntries) ||
                other.reviewingEntries == reviewingEntries) &&
            (identical(other.approvedEntries, approvedEntries) ||
                other.approvedEntries == approvedEntries) &&
            (identical(other.avgQualityScore, avgQualityScore) ||
                other.avgQualityScore == avgQualityScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      languageCount,
      memberCount,
      totalEntries,
      translatedEntries,
      reviewingEntries,
      approvedEntries,
      avgQualityScore);

  /// Create a copy of ProjectStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectStatisticsModelImplCopyWith<_$ProjectStatisticsModelImpl>
      get copyWith => __$$ProjectStatisticsModelImplCopyWithImpl<
          _$ProjectStatisticsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectStatisticsModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectStatisticsModel implements ProjectStatisticsModel {
  const factory _ProjectStatisticsModel(
      {@JsonKey(name: 'language_count')
      @FlexibleIntConverter()
      final int languageCount,
      @JsonKey(name: 'member_count')
      @FlexibleIntConverter()
      final int memberCount,
      @JsonKey(name: 'total_entries')
      @FlexibleIntConverter()
      final int totalEntries,
      @JsonKey(name: 'translated_entries')
      @FlexibleIntConverter()
      final int translatedEntries,
      @JsonKey(name: 'reviewing_entries')
      @FlexibleIntConverter()
      final int reviewingEntries,
      @JsonKey(name: 'approved_entries')
      @FlexibleIntConverter()
      final int approvedEntries,
      @JsonKey(name: 'avg_quality_score')
      @FlexibleDoubleConverter()
      final double avgQualityScore}) = _$ProjectStatisticsModelImpl;

  factory _ProjectStatisticsModel.fromJson(Map<String, dynamic> json) =
      _$ProjectStatisticsModelImpl.fromJson;

  /// 项目语言数
  @override
  @JsonKey(name: 'language_count')
  @FlexibleIntConverter()
  int get languageCount;

  /// 项目成员数
  @override
  @JsonKey(name: 'member_count')
  @FlexibleIntConverter()
  int get memberCount;

  /// 项目总键数
  @override
  @JsonKey(name: 'total_entries')
  @FlexibleIntConverter()
  int get totalEntries;

  /// 项目已翻译键数
  @override
  @JsonKey(name: 'translated_entries')
  @FlexibleIntConverter()
  int get translatedEntries;

  /// 项目审核中键数
  @override
  @JsonKey(name: 'reviewing_entries')
  @FlexibleIntConverter()
  int get reviewingEntries;

  /// 项目批准键数
  @override
  @JsonKey(name: 'approved_entries')
  @FlexibleIntConverter()
  int get approvedEntries;

  /// 项目平均质量分数
  @override
  @JsonKey(name: 'avg_quality_score')
  @FlexibleDoubleConverter()
  double get avgQualityScore;

  /// Create a copy of ProjectStatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectStatisticsModelImplCopyWith<_$ProjectStatisticsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
