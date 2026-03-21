import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/onboarding_state.dart';

const _onboardingCompleteKey = 'onboarding_complete';

/// Whether onboarding has been completed (persisted in SharedPreferences).
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_onboardingCompleteKey) ?? false;
});

/// Manages onboarding flow state.
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(ref),
);

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier(this._ref)
      : super(OnboardingState(
          feedSources: availableSources
              .where((s) => s.defaultEnabled)
              .map((s) => s.name)
              .toList(),
        ));

  final Ref _ref;

  void setRole(String role) {
    state = state.copyWith(role: role);
  }

  void toggleSkill(String skill) {
    final skills = List<String>.from(state.skills);
    if (skills.contains(skill)) {
      skills.remove(skill);
    } else {
      skills.add(skill);
    }
    state = state.copyWith(skills: skills);
  }

  void setExperienceLevel(String level) {
    state = state.copyWith(experienceLevel: level);
  }

  void toggleSource(String source) {
    final sources = List<String>.from(state.feedSources);
    if (sources.contains(source)) {
      sources.remove(source);
    } else {
      sources.add(source);
    }
    state = state.copyWith(feedSources: sources);
  }

  void nextStep() {
    if (state.currentStep < OnboardingState.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
    state = state.copyWith(isComplete: true);
    _ref.invalidate(onboardingCompletedProvider);
  }
}
