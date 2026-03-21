# Plan: Onboarding Flow — 5-Step PageView with Chip Selection UI

## Overview
Build the complete onboarding experience: a 5-step full-screen flow (Welcome → Role → Skills → Experience → Sources) with editorial chip selection UI, Riverpod state management, local persistence via SharedPreferences, and router redirect logic. This is Step 2 of the AI Skill Radar implementation.

## Success Criteria
- [ ] 5 onboarding screens render with editorial typography (serif headlines, mono labels)
- [ ] Welcome screen has large serif headline + CTA button
- [ ] Role selection uses single-select chip picker (8+ role options)
- [ ] Skills selection uses multi-select chips with search/filter
- [ ] Experience level uses 3-option picker (beginner/intermediate/advanced)
- [ ] Sources selection uses toggle switches with pre-selected defaults
- [ ] Step indicator shows progress (colored bars)
- [ ] Back/Next navigation works across all steps
- [ ] Onboarding state persists across app restarts (SharedPreferences)
- [ ] Router redirects to `/onboarding` on first launch, `/radar` after completion
- [ ] All tappable elements have 48dp minimum touch targets
- [ ] `flutter analyze` passes with zero issues
- [ ] App builds successfully

## Affected Areas
- `lib/features/onboarding/` — screens, widgets, providers, models
- `lib/app/router.dart` — redirect logic
- `lib/shared/widgets/` — reusable chip components
- `pubspec.yaml` — add `shared_preferences` dependency

## Architecture Notes

### File Structure
```
lib/
├── features/
│   └── onboarding/
│       ├── models/
│       │   └── onboarding_state.dart       # Onboarding data model
│       ├── providers/
│       │   └── onboarding_provider.dart    # Riverpod StateNotifier
│       ├── screens/
│       │   └── onboarding_screen.dart      # PageView controller (MODIFY)
│       └── widgets/
│           ├── welcome_step.dart           # Step 1: hero headline + CTA
│           ├── role_step.dart              # Step 2: single-select chips
│           ├── skills_step.dart            # Step 3: multi-select chips
│           ├── experience_step.dart        # Step 4: 3-option picker
│           └── sources_step.dart           # Step 5: toggle list
├── shared/
│   └── widgets/
│       ├── app_bottom_nav.dart             # (existing, no change)
│       ├── selectable_chip.dart            # Reusable chip component
│       └── step_header.dart               # Reusable step header (serif title + mono label)
└── app/
    └── router.dart                         # (MODIFY: add redirect)
```

### Key Decisions
- **SharedPreferences** for onboarding completion flag — lightweight, no Firebase dependency yet
- **StateNotifier + Riverpod** — mutable onboarding state that persists selections across steps
- **No code generation** for this step — manual Riverpod providers (simpler for a single StateNotifier)
- **Chip data** — hardcoded role/skill/source lists for MVP. Will be dynamic later when Firebase is connected
- **No "skip" option** — all steps are required for personalization quality
- **Animated page transitions** — PageView with custom curve for editorial feel

### Chip Design (per minimalist-flutter-ui)
- Background: `AppColors.background` (#FFFFFF) when unselected
- Background: `AppColors.primaryLight` (#E8F4FD) when selected
- Border: `AppColors.border` (#EAEAEA) when unselected
- Border: `AppColors.primary` (#3FA6EE) when selected
- Text: `AppTypography.label` (DM Sans 14px)
- Min height: 48dp (accessibility)
- Border radius: 20dp (pill shape)
- Horizontal padding: 16dp, vertical: 12dp

## Implementation Tasks

### Task 1: Add shared_preferences dependency
**File:** `pubspec.yaml`
**Type:** Modify
**Description:** Add `shared_preferences` package for persisting onboarding completion status locally.
**Depends on:** none

### Task 2: Create onboarding data model
**File:** `lib/features/onboarding/models/onboarding_state.dart`
**Type:** Create
**Description:** Define `OnboardingState` class holding: `currentStep` (int), `role` (String?), `skills` (List<String>), `experienceLevel` (String?), `feedSources` (List<String>), `isComplete` (bool). Include predefined lists: `availableRoles`, `availableSkills`, `availableSources` with defaults.
**Depends on:** none

### Task 3: Create onboarding Riverpod provider
**File:** `lib/features/onboarding/providers/onboarding_provider.dart`
**Type:** Create
**Description:** `OnboardingNotifier` extends `StateNotifier<OnboardingState>`. Methods: `setRole(String)`, `toggleSkill(String)`, `setExperienceLevel(String)`, `toggleSource(String)`, `nextStep()`, `previousStep()`, `completeOnboarding()`. The `completeOnboarding` method writes the completion flag to SharedPreferences. Also create `onboardingCompletedProvider` — a FutureProvider that reads the SharedPreferences flag (used by router for redirect).
**Depends on:** Task 1, Task 2

### Task 4: Create reusable SelectableChip widget
**File:** `lib/shared/widgets/selectable_chip.dart`
**Type:** Create
**Description:** A reusable chip component following the design system. Props: `label` (String), `isSelected` (bool), `onTap` (VoidCallback). Uses editorial styling: pill shape, 48dp min height, Anduin blue selected state, 1px border. Supports single-select and multi-select usage patterns (selection logic is in the parent).
**Depends on:** none

### Task 5: Create reusable StepHeader widget
**File:** `lib/shared/widgets/step_header.dart`
**Type:** Create
**Description:** Reusable header for onboarding steps. Shows: serif headline (`AppTypography.display`), optional body text (`AppTypography.body`), monospace step label (`AppTypography.meta`, e.g., "STEP 2 OF 5"). Consistent padding using `AppSpacing`.
**Depends on:** none

### Task 6: Build Welcome step (Step 1)
**File:** `lib/features/onboarding/widgets/welcome_step.dart`
**Type:** Create
**Description:** Full-screen welcome with large serif headline "Your AI Radar", body text "Know exactly what's rising in AI — and what to learn next.", and a primary CTA button "Get Started" at the bottom. No selection — just branding and CTA. Button triggers `nextStep()`.
**Depends on:** Task 5

### Task 7: Build Role step (Step 2)
**File:** `lib/features/onboarding/widgets/role_step.dart`
**Type:** Create
**Description:** StepHeader "What's your current role?" + single-select chip grid with 8+ roles: Software Engineer, ML Engineer, Data Scientist, Product Manager, Designer, DevOps Engineer, Student, Other. Uses `SelectableChip` with single-select behavior. Selecting a role enables the "Continue" button.
**Depends on:** Task 3, Task 4, Task 5

### Task 8: Build Skills step (Step 3)
**File:** `lib/features/onboarding/widgets/skills_step.dart`
**Type:** Create
**Description:** StepHeader "What do you already know?" + multi-select chip grid with 15+ AI/tech skills: Python, RAG, LangChain, Prompt Engineering, Fine-tuning, Computer Vision, NLP, Transformers, PyTorch, TensorFlow, MLOps, LLM APIs, Agents, Vector Databases, Embeddings, MCP, Structured Outputs. Users can select multiple. Minimum 0 (can skip), no maximum. Shows selected count.
**Depends on:** Task 3, Task 4, Task 5

### Task 9: Build Experience step (Step 4)
**File:** `lib/features/onboarding/widgets/experience_step.dart`
**Type:** Create
**Description:** StepHeader "How deep are you?" + 3 large tappable cards (not chips): Beginner ("Just getting started"), Intermediate ("Building projects"), Advanced ("Production experience"). Each card has title + subtitle. Single-select with visual highlight on selection.
**Depends on:** Task 3, Task 5

### Task 10: Build Sources step (Step 5)
**File:** `lib/features/onboarding/widgets/sources_step.dart`
**Type:** Create
**Description:** StepHeader "Where should we look?" + list of feed sources with toggle switches. Pre-selected defaults: r/MachineLearning, r/LocalLLaMA, Hacker News, AI blogs. Each row: source icon/name + toggle. Has a "Complete Setup" primary button at the bottom that calls `completeOnboarding()` and navigates to `/radar`.
**Depends on:** Task 3, Task 5

### Task 11: Rewrite onboarding_screen.dart with real steps
**File:** `lib/features/onboarding/screens/onboarding_screen.dart`
**Type:** Modify
**Description:** Replace placeholder PageView with real step widgets. Wire up Riverpod provider for state. Add back/next buttons in a bottom action bar. Step indicator uses provider's `currentStep`. PageView is controlled (no manual swipe — only button navigation). Back button hidden on step 1. Next/Continue button disabled until step requirements are met (role selected, experience selected, at least one source toggled).
**Depends on:** Task 3, Task 6, Task 7, Task 8, Task 9, Task 10

### Task 12: Update router with onboarding redirect
**File:** `lib/app/router.dart`
**Type:** Modify
**Description:** Add `redirect` logic to GoRouter that checks `onboardingCompletedProvider`. If onboarding is not complete and user navigates to any tab route, redirect to `/onboarding`. If onboarding is complete and user navigates to `/onboarding`, redirect to `/radar`. This requires making `router` depend on a `Ref` — wrap it in a Provider or pass the completion status.
**Depends on:** Task 3

### Task 13: Verify and fix analysis
**Type:** Verify
**Description:** Run `flutter analyze` and fix any issues. Verify the app launches, shows onboarding on first run, completes all 5 steps, and navigates to radar dashboard.
**Depends on:** Task 11, Task 12

## Validation Steps
1. `flutter analyze` — must pass with zero errors
2. `flutter build apk --debug` — must build successfully
3. Manual: first launch shows onboarding (not radar)
4. Manual: welcome screen has serif headline + CTA
5. Manual: role step shows chips, single-select works
6. Manual: skills step shows chips, multi-select works
7. Manual: experience step shows 3 cards, single-select works
8. Manual: sources step shows toggles, pre-selected defaults present
9. Manual: "Complete Setup" navigates to radar dashboard
10. Manual: subsequent launches go directly to radar (skip onboarding)
11. Manual: all chips/buttons are 48dp+ touch targets
12. Manual: no Material elevation, no default colors visible

## Rollback Notes
Greenfield feature addition. Rollback: `git checkout .` on `lib/features/onboarding/` and `lib/shared/widgets/` new files. Router change is a small diff — easy to revert.

## Estimated Complexity
- **Tasks:** 13
- **New files:** 10
- **Modified files:** 3 (pubspec.yaml, onboarding_screen.dart, router.dart)
- **Effort:** human ~3 days / CC ~25 min
- **Risk:** Low — no external dependencies, no backend, pure UI + local state
- **New package:** `shared_preferences` (well-maintained, standard Flutter package)
