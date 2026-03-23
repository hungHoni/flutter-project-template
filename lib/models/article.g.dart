// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleImpl _$$ArticleImplFromJson(Map<String, dynamic> json) =>
    _$ArticleImpl(
      source: json['source'] as String,
      sourceName: json['sourceName'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      url: json['url'] as String,
      publishedAt: const TimestampConverter().fromJson(json['publishedAt']),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isSkillGap: json['isSkillGap'] as bool? ?? false,
      fetchedAt: const TimestampConverter().fromJson(json['fetchedAt']),
    );

Map<String, dynamic> _$$ArticleImplToJson(_$ArticleImpl instance) =>
    <String, dynamic>{
      'source': instance.source,
      'sourceName': instance.sourceName,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'url': instance.url,
      'publishedAt': const TimestampConverter().toJson(instance.publishedAt),
      'tags': instance.tags,
      'isSkillGap': instance.isSkillGap,
      'fetchedAt': const TimestampConverter().toJson(instance.fetchedAt),
    };
