import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/auth_provider.dart';
import '../../../models/user_profile.dart';
import '../repositories/user_profile_repository.dart';

/// Streams the current user's profile from Firestore.
/// Returns `null` if not authenticated or profile doesn't exist.
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return Stream.value(null);

  final repo = ref.watch(userProfileRepositoryProvider);
  return repo.watchProfile(user.uid);
});
