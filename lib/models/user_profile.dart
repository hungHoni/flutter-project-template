import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Firestore document: `users/{uid}`
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String role,
    required List<String> skills,
    required String level,
    required List<String> feedSources,
    String? fcmToken,
    @TimestampConverter() required DateTime createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
