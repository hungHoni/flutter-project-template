import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the FirebaseAuth instance.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Signs in anonymously and returns the current [User].
///
/// If a session already exists, returns the existing user without
/// creating a new anonymous account.
final authStateProvider = FutureProvider<User?>((ref) async {
  final auth = ref.watch(firebaseAuthProvider);
  final currentUser = auth.currentUser;
  if (currentUser != null) return currentUser;

  final credential = await auth.signInAnonymously();
  return credential.user;
});

/// Stream of auth state changes for reactive listeners.
final authStreamProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});
