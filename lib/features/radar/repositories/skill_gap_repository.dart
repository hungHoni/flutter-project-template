import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/firestore_provider.dart';
import '../../../models/daily_brief.dart';
import '../../../models/weekly_skill_gaps.dart';
import '../../../shared/utils/date_utils.dart';

/// Firestore CRUD for `users/{uid}/skillGaps/{weekId}`.
class SkillGapRepository {
  SkillGapRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _firestore.collection('users').doc(uid).collection('skillGaps');

  /// Saves or merges the current week's skill gaps.
  Future<void> saveWeeklyGaps(
    String uid,
    String weekId,
    List<SkillGap> gaps,
  ) {
    final doc = WeeklySkillGaps(gaps: gaps);
    return _collection(uid).doc(weekId).set(doc.toJson());
  }

  /// Watches the current week's gaps.
  Stream<WeeklySkillGaps?> watchWeek(String uid, String weekId) {
    return _collection(uid).doc(weekId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return WeeklySkillGaps.fromJson(snap.data()!);
    });
  }

  /// Reads the last [count] weeks of skill gaps for trend computation.
  /// Uses direct document reads by week ID to avoid needing a composite index.
  Future<List<WeeklySkillGaps>> getPreviousWeeks(
    String uid,
    int count,
  ) async {
    // Generate the last N week IDs and read them directly.
    final now = DateTime.now();
    final results = <WeeklySkillGaps>[];
    for (var i = 1; i <= count; i++) {
      final date = now.subtract(Duration(days: 7 * i));
      final weekId = isoWeekId(date);
      final snap = await _collection(uid).doc(weekId).get();
      if (snap.exists && snap.data() != null) {
        results.add(WeeklySkillGaps.fromJson(snap.data()!));
      }
    }
    return results;
  }
}

/// Provides the SkillGapRepository.
final skillGapRepositoryProvider = Provider<SkillGapRepository>((ref) {
  return SkillGapRepository(ref.watch(firestoreProvider));
});
