// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_skill_gaps.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeeklySkillGaps _$WeeklySkillGapsFromJson(Map<String, dynamic> json) {
  return _WeeklySkillGaps.fromJson(json);
}

/// @nodoc
mixin _$WeeklySkillGaps {
  List<SkillGap> get gaps => throw _privateConstructorUsedError;

  /// Serializes this WeeklySkillGaps to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklySkillGaps
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklySkillGapsCopyWith<WeeklySkillGaps> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklySkillGapsCopyWith<$Res> {
  factory $WeeklySkillGapsCopyWith(
    WeeklySkillGaps value,
    $Res Function(WeeklySkillGaps) then,
  ) = _$WeeklySkillGapsCopyWithImpl<$Res, WeeklySkillGaps>;
  @useResult
  $Res call({List<SkillGap> gaps});
}

/// @nodoc
class _$WeeklySkillGapsCopyWithImpl<$Res, $Val extends WeeklySkillGaps>
    implements $WeeklySkillGapsCopyWith<$Res> {
  _$WeeklySkillGapsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklySkillGaps
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gaps = null}) {
    return _then(
      _value.copyWith(
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
abstract class _$$WeeklySkillGapsImplCopyWith<$Res>
    implements $WeeklySkillGapsCopyWith<$Res> {
  factory _$$WeeklySkillGapsImplCopyWith(
    _$WeeklySkillGapsImpl value,
    $Res Function(_$WeeklySkillGapsImpl) then,
  ) = __$$WeeklySkillGapsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SkillGap> gaps});
}

/// @nodoc
class __$$WeeklySkillGapsImplCopyWithImpl<$Res>
    extends _$WeeklySkillGapsCopyWithImpl<$Res, _$WeeklySkillGapsImpl>
    implements _$$WeeklySkillGapsImplCopyWith<$Res> {
  __$$WeeklySkillGapsImplCopyWithImpl(
    _$WeeklySkillGapsImpl _value,
    $Res Function(_$WeeklySkillGapsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklySkillGaps
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gaps = null}) {
    return _then(
      _$WeeklySkillGapsImpl(
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
class _$WeeklySkillGapsImpl implements _WeeklySkillGaps {
  const _$WeeklySkillGapsImpl({final List<SkillGap> gaps = const []})
    : _gaps = gaps;

  factory _$WeeklySkillGapsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklySkillGapsImplFromJson(json);

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
    return 'WeeklySkillGaps(gaps: $gaps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklySkillGapsImpl &&
            const DeepCollectionEquality().equals(other._gaps, _gaps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_gaps));

  /// Create a copy of WeeklySkillGaps
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklySkillGapsImplCopyWith<_$WeeklySkillGapsImpl> get copyWith =>
      __$$WeeklySkillGapsImplCopyWithImpl<_$WeeklySkillGapsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklySkillGapsImplToJson(this);
  }
}

abstract class _WeeklySkillGaps implements WeeklySkillGaps {
  const factory _WeeklySkillGaps({final List<SkillGap> gaps}) =
      _$WeeklySkillGapsImpl;

  factory _WeeklySkillGaps.fromJson(Map<String, dynamic> json) =
      _$WeeklySkillGapsImpl.fromJson;

  @override
  List<SkillGap> get gaps;

  /// Create a copy of WeeklySkillGaps
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklySkillGapsImplCopyWith<_$WeeklySkillGapsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
