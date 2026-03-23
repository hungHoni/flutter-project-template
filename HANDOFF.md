# Handoff: AI Skill Radar — Steps 1-4 Complete

**Date:** 2026-03-21
**Branch:** main
**Last Commit:** 5631fd9 docs: update HANDOFF.md for Step 3 completion, clean up template docs

## Goal

Build "AI Skill Radar" — a personalized weekly AI skill gap detector as a Flutter mobile app. The approved design doc is at `docs/design-ai-skill-radar.md`. The app uses Firebase backend, RSS feed ingestion, and Claude API for article summarization + skill extraction.

## Completed

- [x] Design doc created and approved (`docs/design-ai-skill-radar.md`)
- [x] Wireframes created (`docs/wireframe-sketch.html`, `docs/wireframe-sketch.png`)
- [x] Engineering review passed (plan-eng-review)
- [x] Design review passed (plan-design-review)
- [x] **Step 1: Flutter scaffold with Anduin blue theme** — all 13 tasks complete:
  - Flutter project with org `com.anduin`, Riverpod, GoRouter, Phosphor icons, Google Fonts
  - 13 color tokens, 8 typography tokens, 7 spacing tokens, Phosphor icon mappings
  - Full ThemeData with zero elevation, flat borders, no Material defaults
  - Custom bottom nav with dot indicator + count badge
  - GoRouter with ShellRoute for tabs + full-screen onboarding route
- [x] **Step 2: Onboarding flow** — 5-step PageView fully implemented:
  - Welcome step (serif headline "Your AI Radar" + CTA)
  - Role step (single-select chips, 8 roles)
  - Skills step (multi-select chips, 17 AI skills, selected count display)
  - Experience step (3 large tappable cards: beginner/intermediate/advanced)
  - Sources step (toggle switch list, 6 feed sources with defaults)
  - SharedPreferences persistence for onboarding completion
  - Router redirect logic (non-completed → /onboarding, completed → /radar)
  - Reusable SelectableChip and StepHeader shared widgets
  - 2 widget tests passing (first launch → onboarding, completed → radar)
- [x] Design system QA fixes applied:
  - textSecondary corrected to `#777777`, typography sizes matched to design doc
  - Label font changed to JetBrains Mono, button color to primaryDark for WCAG AA
  - Added missing color tokens (trending `#B8860B`, surfaceDark `#1A1A1A`)

- [x] **Step 3: Firebase setup** — all tasks complete:
  - Added firebase_core, cloud_firestore, firebase_auth, firebase_messaging to pubspec.yaml
  - Firebase.initializeApp() in main.dart with DefaultFirebaseOptions
  - Placeholder firebase_options.dart (replace via `flutterfire configure`)
  - Anonymous auth Riverpod provider (authStateProvider, authStreamProvider)
  - Auth kicked off in background from app.dart (non-blocking)
  - iOS minimum set to 13.0 (Podfile), Android minSdk set to 23
  - **Manual step required:** Create Firebase project → run `flutterfire configure` → enable Anonymous Auth + Firestore in console
- [x] **Step 4: Firestore data model** — all freezed + json_serializable models complete:
  - `UserProfile` — role, skills, level, feedSources, fcmToken, createdAt
  - `Article` — source, sourceName, title, excerpt, url, tags, isSkillGap, timestamps
  - `DailyBrief` — summary, gapCount, embedded list of `SkillGap`
  - `SkillGap` — name, trend, mentionCount, suggestedAction, detectedAt, weekId (shared by DailyBrief + WeeklySkillGaps)
  - `WeeklySkillGaps` — gaps list keyed by weekId
  - `TimestampConverter` — Firestore Timestamp ↔ DateTime (uses `dynamic` JSON type to avoid import issues in generated code)
  - Barrel export at `lib/models/models.dart`
  - Moved `freezed_annotation` to dependencies, added `json_annotation`

## In Progress / Next Steps

- [ ] **Step 5: RSS feed ingestion** — Cloud Function to fetch Reddit, HN, blog RSS feeds
- [ ] **Step 6: Claude API integration** — Cloud Function for article summarization + skill extraction
- [ ] **Step 7: Radar dashboard** — Today's brief + skill gap list with trend labels
- [ ] **Step 8: Feed screen** — Tabbed articles with SKILL GAP badges
- [ ] **Step 9: Profile screen** — Edit role, skills, feed sources
- [ ] **Step 10: Push notifications** — FCM for weekly skill brief
- [ ] **Step 11: Polish** — Animations, error states, empty states, offline mode

## Key Decisions

- **Router architecture**: `createRouter(bool)` receives sync bool, App widget handles async SharedPreferences via FutureProvider — avoids async issues in redirect callbacks
- **Anduin Blue `#3FA6EE`**: Fails WCAG AA for text on white (2.9:1) — use `primaryDark` (`#2B7AB8`, 4.6:1) for text links
- **Firebase over Supabase**: User chose Firebase for backend
- **Trend labels computed client-side**: New/Rising/Hot classification in Dart, not Claude API
- **freezed + json_serializable**: For model serialization. `TimestampConverter` uses `dynamic` as JSON type (not `Timestamp`) so generated `.g.dart` files don't need `cloud_firestore` import
- **Feature-first folder structure**: `lib/features/{feature}/screens/`
- **No Material defaults**: Zero elevation everywhere, Phosphor icons only
- **Editorial typography**: Instrument Serif (display), DM Sans (body), JetBrains Mono (meta)

## Dead Ends (Don't Repeat These)

- **FutureProvider in router redirect**: Tried having `createRouter(WidgetRef ref)` read `onboardingCompletedProvider` inside redirect callback. Provider hadn't resolved when redirect ran. Fix: App watches provider, passes resolved bool to router.
- **`find.text('Your AI\nRadar')` in tests**: Newline didn't match rendered Text widget. Use `find.textContaining('Your AI')` instead.
- **Switch.adaptive `activeColor`**: Deprecated after Flutter v3.31.0-2.0.pre. Use `activeTrackColor` + `activeThumbColor` separately.
- **Browse `file://` URLs**: gstack browse blocks `file://` scheme. Serve via `python3 -m http.server` instead.
- **TimestampConverter with `Timestamp` type**: `JsonConverter<DateTime, Timestamp>` causes `cast_to_non_type` errors in generated `.g.dart` files because they don't import `cloud_firestore`. Fix: use `JsonConverter<DateTime, dynamic>` instead.

## Files Changed

### Step 4 (Firestore data model)
- `pubspec.yaml` — Moved freezed_annotation to dependencies, added json_annotation
- `lib/models/timestamp_converter.dart` — NEW: Firestore Timestamp ↔ DateTime converter
- `lib/models/user_profile.dart` — NEW: freezed model for users/{uid}
- `lib/models/article.dart` — NEW: freezed model for articles/{id}
- `lib/models/daily_brief.dart` — NEW: DailyBrief + SkillGap freezed models
- `lib/models/weekly_skill_gaps.dart` — NEW: freezed model for skillGaps/{weekId}
- `lib/models/models.dart` — NEW: barrel export
- `lib/models/*.freezed.dart` + `*.g.dart` — GENERATED: build_runner output

### Step 3 (Firebase setup)
- `pubspec.yaml` — Added firebase_core, cloud_firestore, firebase_auth, firebase_messaging
- `lib/main.dart` — Firebase.initializeApp() before runApp
- `lib/firebase_options.dart` — NEW: Placeholder config (replace via flutterfire configure)
- `lib/app/providers/auth_provider.dart` — NEW: Anonymous auth + auth stream providers
- `lib/app/app.dart` — Watches authStateProvider to kick off auth
- `ios/Podfile` — Set platform to iOS 13.0
- `android/app/build.gradle.kts` — Set minSdk to 23

### Step 1 (scaffold)
- `lib/theme/` — app_colors.dart, app_typography.dart, app_spacing.dart, app_icons.dart, app_theme.dart
- `lib/shared/widgets/app_bottom_nav.dart` — Custom bottom nav with badges
- `lib/features/{radar,feed,profile}/screens/` — Placeholder screens
- `lib/app/router.dart` — GoRouter with ShellRoute
- `lib/app/app.dart` — MaterialApp.router wrapper
- `lib/main.dart` — ProviderScope entry point

### Step 2 (onboarding)
- `lib/features/onboarding/models/onboarding_state.dart` — NEW: Data model with per-step validation
- `lib/features/onboarding/providers/onboarding_provider.dart` — NEW: StateNotifier + FutureProvider
- `lib/features/onboarding/screens/onboarding_screen.dart` — REWRITTEN: ConsumerStatefulWidget with PageView
- `lib/features/onboarding/widgets/` — NEW: welcome_step, role_step, skills_step, experience_step, sources_step
- `lib/shared/widgets/selectable_chip.dart` — NEW: Reusable animated chip
- `lib/shared/widgets/step_header.dart` — NEW: Reusable step header
- `lib/app/app.dart` — REWRITTEN: ConsumerWidget with async loading
- `lib/app/router.dart` — REWRITTEN: `createRouter(bool onboardingCompleted)`
- `test/widget_test.dart` — REWRITTEN: SharedPreferences mock tests

## Current State

- **Tests:** 2/2 passing (`flutter test`)
- **Analyze:** 0 issues (`flutter analyze`)
- **Build:** Working (iOS simulator verified via QA)
- **Git:** 4 unpushed commits on main (pending Step 4 commit)
- **Firebase:** Dependencies added, initialization code in place. Needs `flutterfire configure` with a real Firebase project before the app can connect.
- **Models:** All 5 Firestore document models generated with freezed + json_serializable. Ready for Riverpod providers + Firestore repository layer.

## Context for Next Session

Steps 1–4 are complete — scaffold, onboarding, Firebase setup, and data models all in place. The app compiles and tests pass, but Firebase won't connect until the user creates a project and runs `flutterfire configure`. Next is Step 5 (RSS Cloud Functions), which requires a `functions/` directory with Node.js Cloud Functions. All placeholder screens (radar, feed, profile) are minimal and ready to be replaced in Steps 7–9.

**Manual prerequisite before Step 5:** User must create a Firebase project, run `flutterfire configure`, and enable Anonymous Auth + Firestore in the Firebase console. Then `firebase init functions` to scaffold the Cloud Functions directory.

**Recommended first action:** `Read docs/design-ai-skill-radar.md and HANDOFF.md, then proceed with Step 5: RSS feed ingestion Cloud Function.`
