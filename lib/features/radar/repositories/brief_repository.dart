import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/firestore_provider.dart';
import '../../../models/daily_brief.dart';
import '../../../shared/utils/date_utils.dart';

/// Firestore CRUD for `users/{uid}/briefs/{date}`.
class BriefRepository {
  BriefRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _firestore.collection('users').doc(uid).collection('briefs');

  /// Saves today's brief.
  Future<void> saveBrief(String uid, String date, DailyBrief brief) {
    return _collection(uid).doc(date).set(brief.toJson());
  }

  /// Watches today's brief document.
  Stream<DailyBrief?> watchBrief(String uid, String date) {
    return _collection(uid).doc(date).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return DailyBrief.fromJson(snap.data()!);
    });
  }

  /// Watches today's brief by date string. No composite index required.
  Stream<DailyBrief?> watchTodaysBrief(String uid) {
    return watchBrief(uid, todayId());
  }
}

/// Provides the BriefRepository.
final briefRepositoryProvider = Provider<BriefRepository>((ref) {
  return BriefRepository(ref.watch(firestoreProvider));
});
