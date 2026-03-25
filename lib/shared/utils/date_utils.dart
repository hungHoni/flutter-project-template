/// Formats a DateTime as yyyy-MM-dd for Firestore doc IDs.
String todayId([DateTime? date]) {
  final d = date ?? DateTime.now();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

/// Returns an ISO 8601 week ID (e.g. "2026-W12") for the given date.
///
/// Handles year-boundary edge cases per ISO 8601:
/// - Jan 1-3 may belong to the last week of the previous year.
/// - Dec 29-31 may belong to the first week of the next year.
String isoWeekId([DateTime? date]) {
  final d = date ?? DateTime.now();
  // Thursday of the same ISO week determines the year.
  final thursday = d.add(Duration(days: DateTime.thursday - d.weekday));
  final jan1 = DateTime(thursday.year, 1, 1);
  final dayOfYear = thursday.difference(jan1).inDays;
  final weekNumber = (dayOfYear ~/ 7) + 1;
  return '${thursday.year}-W${weekNumber.toString().padLeft(2, '0')}';
}
