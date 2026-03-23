// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return _Article.fromJson(json);
}

/// @nodoc
mixin _$Article {
  String get source => throw _privateConstructorUsedError;
  String get sourceName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get excerpt => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get publishedAt => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isSkillGap => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get fetchedAt => throw _privateConstructorUsedError;

  /// Serializes this Article to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleCopyWith<Article> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleCopyWith<$Res> {
  factory $ArticleCopyWith(Article value, $Res Function(Article) then) =
      _$ArticleCopyWithImpl<$Res, Article>;
  @useResult
  $Res call({
    String source,
    String sourceName,
    String title,
    String excerpt,
    String url,
    @TimestampConverter() DateTime publishedAt,
    List<String> tags,
    bool isSkillGap,
    @TimestampConverter() DateTime fetchedAt,
  });
}

/// @nodoc
class _$ArticleCopyWithImpl<$Res, $Val extends Article>
    implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? sourceName = null,
    Object? title = null,
    Object? excerpt = null,
    Object? url = null,
    Object? publishedAt = null,
    Object? tags = null,
    Object? isSkillGap = null,
    Object? fetchedAt = null,
  }) {
    return _then(
      _value.copyWith(
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceName: null == sourceName
                ? _value.sourceName
                : sourceName // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            excerpt: null == excerpt
                ? _value.excerpt
                : excerpt // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            publishedAt: null == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isSkillGap: null == isSkillGap
                ? _value.isSkillGap
                : isSkillGap // ignore: cast_nullable_to_non_nullable
                      as bool,
            fetchedAt: null == fetchedAt
                ? _value.fetchedAt
                : fetchedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArticleImplCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$$ArticleImplCopyWith(
    _$ArticleImpl value,
    $Res Function(_$ArticleImpl) then,
  ) = __$$ArticleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String source,
    String sourceName,
    String title,
    String excerpt,
    String url,
    @TimestampConverter() DateTime publishedAt,
    List<String> tags,
    bool isSkillGap,
    @TimestampConverter() DateTime fetchedAt,
  });
}

/// @nodoc
class __$$ArticleImplCopyWithImpl<$Res>
    extends _$ArticleCopyWithImpl<$Res, _$ArticleImpl>
    implements _$$ArticleImplCopyWith<$Res> {
  __$$ArticleImplCopyWithImpl(
    _$ArticleImpl _value,
    $Res Function(_$ArticleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? source = null,
    Object? sourceName = null,
    Object? title = null,
    Object? excerpt = null,
    Object? url = null,
    Object? publishedAt = null,
    Object? tags = null,
    Object? isSkillGap = null,
    Object? fetchedAt = null,
  }) {
    return _then(
      _$ArticleImpl(
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceName: null == sourceName
            ? _value.sourceName
            : sourceName // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        excerpt: null == excerpt
            ? _value.excerpt
            : excerpt // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        publishedAt: null == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isSkillGap: null == isSkillGap
            ? _value.isSkillGap
            : isSkillGap // ignore: cast_nullable_to_non_nullable
                  as bool,
        fetchedAt: null == fetchedAt
            ? _value.fetchedAt
            : fetchedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleImpl implements _Article {
  const _$ArticleImpl({
    required this.source,
    required this.sourceName,
    required this.title,
    required this.excerpt,
    required this.url,
    @TimestampConverter() required this.publishedAt,
    final List<String> tags = const [],
    this.isSkillGap = false,
    @TimestampConverter() required this.fetchedAt,
  }) : _tags = tags;

  factory _$ArticleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleImplFromJson(json);

  @override
  final String source;
  @override
  final String sourceName;
  @override
  final String title;
  @override
  final String excerpt;
  @override
  final String url;
  @override
  @TimestampConverter()
  final DateTime publishedAt;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isSkillGap;
  @override
  @TimestampConverter()
  final DateTime fetchedAt;

  @override
  String toString() {
    return 'Article(source: $source, sourceName: $sourceName, title: $title, excerpt: $excerpt, url: $url, publishedAt: $publishedAt, tags: $tags, isSkillGap: $isSkillGap, fetchedAt: $fetchedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleImpl &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.sourceName, sourceName) ||
                other.sourceName == sourceName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isSkillGap, isSkillGap) ||
                other.isSkillGap == isSkillGap) &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    source,
    sourceName,
    title,
    excerpt,
    url,
    publishedAt,
    const DeepCollectionEquality().hash(_tags),
    isSkillGap,
    fetchedAt,
  );

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      __$$ArticleImplCopyWithImpl<_$ArticleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleImplToJson(this);
  }
}

abstract class _Article implements Article {
  const factory _Article({
    required final String source,
    required final String sourceName,
    required final String title,
    required final String excerpt,
    required final String url,
    @TimestampConverter() required final DateTime publishedAt,
    final List<String> tags,
    final bool isSkillGap,
    @TimestampConverter() required final DateTime fetchedAt,
  }) = _$ArticleImpl;

  factory _Article.fromJson(Map<String, dynamic> json) = _$ArticleImpl.fromJson;

  @override
  String get source;
  @override
  String get sourceName;
  @override
  String get title;
  @override
  String get excerpt;
  @override
  String get url;
  @override
  @TimestampConverter()
  DateTime get publishedAt;
  @override
  List<String> get tags;
  @override
  bool get isSkillGap;
  @override
  @TimestampConverter()
  DateTime get fetchedAt;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
