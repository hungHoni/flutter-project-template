// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_brief.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyBrief _$DailyBriefFromJson(Map<String, dynamic> json) {
  return _DailyBrief.fromJson(json);
}

/// @nodoc
mixin _$DailyBrief {
  String get summary => throw _privateConstructorUsedError;
  int get gapCount => throw _privateConstructorUsedError;
  List<SkillGap> get gaps => throw _privateConstructorUsedError;

  /// Serializes this DailyBrief to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyBrief
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyBriefCopyWith<DailyBrief> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyBriefCopyWith<$Res> {
  factory $DailyBriefCopyWith(
    DailyBrief value,
    $Res Function(DailyBrief) then,
  ) = _$DailyBriefCopyWithImpl<$Res, DailyBrief>;
  @useResult
  $Res call({String summary, int gapCount, List<SkillGap> gaps});
}

/// @nodoc
class _$DailyBriefCopyWithImpl<$Res, $Val extends DailyBrief>
    implements $DailyBriefCopyWith<$Res> {
  _$DailyBriefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyBrief
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? gapCount = null,
    Object? gaps = null,
  }) {
    return _then(
      _value.copyWith(
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            gapCount: null == gapCount
                ? _value.gapCount
                : gapCount // ignore: cast_nullable_to_non_nullable
                      as int,
            gaps: null == gaps
                ? _value.gaps
                : gaps // ignore: cast_nullable_to_non_nullable
                      as List<SkillGap>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyBriefImplCopyWith<$Res>
    implements $DailyBriefCopyWith<$Res> {
  factory _$$DailyBriefImplCopyWith(
    _$DailyBriefImpl value,
    $Res Function(_$DailyBriefImpl) then,
  ) = __$$DailyBriefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String summary, int gapCount, List<SkillGap> gaps});
}

/// @nodoc
class __$$DailyBriefImplCopyWithImpl<$Res>
    extends _$DailyBriefCopyWithImpl<$Res, _$DailyBriefImpl>
    implements _$$DailyBriefImplCopyWith<$Res> {
  __$$DailyBriefImplCopyWithImpl(
    _$DailyBriefImpl _value,
    $Res Function(_$DailyBriefImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyBrief
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? gapCount = null,
    Object? gaps = null,
  }) {
    return _then(
      _$DailyBriefImpl(
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        gapCount: null == gapCount
            ? _value.gapCount
            : gapCount // ignore: cast_nullable_to_non_nullable
                  as int,
        gaps: null == gaps
            ? _value._gaps
            : gaps // ignore: cast_nullable_to_non_nullable
                  as List<SkillGap>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyBriefImpl implements _DailyBrief {
  const _$DailyBriefImpl({
    required this.summary,
    required this.gapCount,
    final List<SkillGap> gaps = const [],
  }) : _gaps = gaps;

  factory _$DailyBriefImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyBriefImplFromJson(json);

  @override
  final String summary;
  @override
  final int gapCount;
  final List<SkillGap> _gaps;
  @override
  @JsonKey()
  List<SkillGap> get gaps {
    if (_gaps is EqualUnmodifiableListView) return _gaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gaps);
  }

  @override
  String toString() {
    return 'DailyBrief(summary: $summary, gapCount: $gapCount, gaps: $gaps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyBriefImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.gapCount, gapCount) ||
                other.gapCount == gapCount) &&
            const DeepCollectionEquality().equals(other._gaps, _gaps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    summary,
    gapCount,
    const DeepCollectionEquality().hash(_gaps),
  );

  /// Create a copy of DailyBrief
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyBriefImplCopyWith<_$DailyBriefImpl> get copyWith =>
      __$$DailyBriefImplCopyWithImpl<_$DailyBriefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyBriefImplToJson(this);
  }
}

abstract class _DailyBrief implements DailyBrief {
  const factory _DailyBrief({
    required final String summary,
    required final int gapCount,
    final List<SkillGap> gaps,
  }) = _$DailyBriefImpl;

  factory _DailyBrief.fromJson(Map<String, dynamic> json) =
      _$DailyBriefImpl.fromJson;

  @override
  String get summary;
  @override
  int get gapCount;
  @override
  List<SkillGap> get gaps;

  /// Create a copy of DailyBrief
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyBriefImplCopyWith<_$DailyBriefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkillGap _$SkillGapFromJson(Map<String, dynamic> json) {
  return _SkillGap.fromJson(json);
}

/// @nodoc
mixin _$SkillGap {
  String get name => throw _privateConstructorUsedError;
  String? get trend => throw _privateConstructorUsedError;
  int get mentionCount => throw _privateConstructorUsedError;
  String get suggestedAction => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get detectedAt => throw _privateConstructorUsedError;
  String? get weekId => throw _privateConstructorUsedError;

  /// Serializes this SkillGap to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillGap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillGapCopyWith<SkillGap> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillGapCopyWith<$Res> {
  factory $SkillGapCopyWith(SkillGap value, $Res Function(SkillGap) then) =
      _$SkillGapCopyWithImpl<$Res, SkillGap>;
  @useResult
  $Res call({
    String name,
    String? trend,
    int mentionCount,
    String suggestedAction,
    @TimestampConverter() DateTime detectedAt,
    String? weekId,
  });
}

/// @nodoc
class _$SkillGapCopyWithImpl<$Res, $Val extends SkillGap>
    implements $SkillGapCopyWith<$Res> {
  _$SkillGapCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillGap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? trend = freezed,
    Object? mentionCount = null,
    Object? suggestedAction = null,
    Object? detectedAt = null,
    Object? weekId = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            trend: freezed == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as String?,
            mentionCount: null == mentionCount
                ? _value.mentionCount
                : mentionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            suggestedAction: null == suggestedAction
                ? _value.suggestedAction
                : suggestedAction // ignore: cast_nullable_to_non_nullable
                      as String,
            detectedAt: null == detectedAt
                ? _value.detectedAt
                : detectedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weekId: freezed == weekId
                ? _value.weekId
                : weekId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SkillGapImplCopyWith<$Res>
    implements $SkillGapCopyWith<$Res> {
  factory _$$SkillGapImplCopyWith(
    _$SkillGapImpl value,
    $Res Function(_$SkillGapImpl) then,
  ) = __$$SkillGapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String? trend,
    int mentionCount,
    String suggestedAction,
    @TimestampConverter() DateTime detectedAt,
    String? weekId,
  });
}

/// @nodoc
class __$$SkillGapImplCopyWithImpl<$Res>
    extends _$SkillGapCopyWithImpl<$Res, _$SkillGapImpl>
    implements _$$SkillGapImplCopyWith<$Res> {
  __$$SkillGapImplCopyWithImpl(
    _$SkillGapImpl _value,
    $Res Function(_$SkillGapImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillGap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? trend = freezed,
    Object? mentionCount = null,
    Object? suggestedAction = null,
    Object? detectedAt = null,
    Object? weekId = freezed,
  }) {
    return _then(
      _$SkillGapImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        trend: freezed == trend
            ? _value.trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as String?,
        mentionCount: null == mentionCount
            ? _value.mentionCount
            : mentionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        suggestedAction: null == suggestedAction
            ? _value.suggestedAction
            : suggestedAction // ignore: cast_nullable_to_non_nullable
                  as String,
        detectedAt: null == detectedAt
            ? _value.detectedAt
            : detectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weekId: freezed == weekId
            ? _value.weekId
            : weekId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillGapImpl implements _SkillGap {
  const _$SkillGapImpl({
    required this.name,
    this.trend,
    required this.mentionCount,
    required this.suggestedAction,
    @TimestampConverter() required this.detectedAt,
    this.weekId,
  });

  factory _$SkillGapImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillGapImplFromJson(json);

  @override
  final String name;
  @override
  final String? trend;
  @override
  final int mentionCount;
  @override
  final String suggestedAction;
  @override
  @TimestampConverter()
  final DateTime detectedAt;
  @override
  final String? weekId;

  @override
  String toString() {
    return 'SkillGap(name: $name, trend: $trend, mentionCount: $mentionCount, suggestedAction: $suggestedAction, detectedAt: $detectedAt, weekId: $weekId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillGapImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.mentionCount, mentionCount) ||
                other.mentionCount == mentionCount) &&
            (identical(other.suggestedAction, suggestedAction) ||
                other.suggestedAction == suggestedAction) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            (identical(other.weekId, weekId) || other.weekId == weekId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    trend,
    mentionCount,
    suggestedAction,
    detectedAt,
    weekId,
  );

  /// Create a copy of SkillGap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillGapImplCopyWith<_$SkillGapImpl> get copyWith =>
      __$$SkillGapImplCopyWithImpl<_$SkillGapImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillGapImplToJson(this);
  }
}

abstract class _SkillGap implements SkillGap {
  const factory _SkillGap({
    required final String name,
    final String? trend,
    required final int mentionCount,
    required final String suggestedAction,
    @TimestampConverter() required final DateTime detectedAt,
    final String? weekId,
  }) = _$SkillGapImpl;

  factory _SkillGap.fromJson(Map<String, dynamic> json) =
      _$SkillGapImpl.fromJson;

  @override
  String get name;
  @override
  String? get trend;
  @override
  int get mentionCount;
  @override
  String get suggestedAction;
  @override
  @TimestampConverter()
  DateTime get detectedAt;
  @override
  String? get weekId;

  /// Create a copy of SkillGap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillGapImplCopyWith<_$SkillGapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
