import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts between Firestore [Timestamp] and [DateTime] for json_serializable.
///
/// Uses `dynamic` as the JSON type so generated `.g.dart` files don't need
/// to import `cloud_firestore`.
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  dynamic toJson(DateTime date) => Timestamp.fromDate(date);
}

/// Nullable version for optional timestamp fields.
class NullableTimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  dynamic toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}
