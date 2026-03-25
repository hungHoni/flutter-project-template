import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/firestore_provider.dart';
import '../../../models/user_profile.dart';

/// Firestore CRUD layer for `users/{uid}`.
class UserProfileRepository {
  UserProfileRepository(this._firestore);
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid);

  /// Watches the user profile in real time.
  Stream<UserProfile?> watchProfile(String uid) {
    return _doc(uid).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return UserProfile.fromJson(snap.data()!);
    });
  }

  /// Creates or overwrites the full profile document.
  Future<void> saveProfile(String uid, UserProfile profile) {
    return _doc(uid).set(profile.toJson());
  }

  /// Updates a single field on the profile.
  /// Uses set+merge so it works even if the document doesn't exist yet.
  Future<void> updateField(String uid, String field, dynamic value) {
    return _doc(uid).set({field: value}, SetOptions(merge: true));
  }
}

/// Provides the UserProfileRepository.
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(ref.watch(firestoreProvider));
});
