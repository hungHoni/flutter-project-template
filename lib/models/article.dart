import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'article.freezed.dart';
part 'article.g.dart';

/// Firestore document: `articles/{id}` where id = hash of url.
@freezed
class Article with _$Article {
  const factory Article({
    required String source,
    required String sourceName,
    required String title,
    required String excerpt,
    required String url,
    @TimestampConverter() required DateTime publishedAt,
    @Default([]) List<String> tags,
    @Default(false) bool isSkillGap,
    @TimestampConverter() required DateTime fetchedAt,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
