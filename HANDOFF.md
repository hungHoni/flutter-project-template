# Handoff: AI Skill Radar — Flutter Implementation

**Date:** 2026-03-21
**Branch:** main
**Last Commit:** 74ae694 feat: scaffold Flutter project with Anduin blue theme

## Goal

Build "AI Skill Radar" — a personalized weekly AI skill gap detector as a Flutter mobile app. The approved design doc is at `docs/design-ai-skill-radar.md`. The app uses Firebase backend, RSS feed ingestion, and Claude API for article summarization + skill extraction.

## Completed

- [x] Design doc created and approved (`docs/design-ai-skill-radar.md`)
- [x] Wireframes created (`docs/wireframe-sketch.html`, `docs/wireframe-sketch.png`)
- [x] Engineering review passed (plan-eng-review)
- [x] Design review passed (plan-design-review)
- [x] Implementation plan created (`.claude/archon/plans/flutter-scaffold-anduin-theme.md`)
- [x] **Step 1: Flutter scaffold with Anduin blue theme** — all 13 tasks complete:
  - Flutter project created with org `com.anduin`
  - Riverpod, GoRouter, Phosphor icons, Google Fonts, dio, freezed configured
  - 11 color tokens (Anduin Blue `#3FA6EE` primary)
  - 8 typography tokens (Instrument Serif, DM Sans, JetBrains Mono)
  - 7 spacing tokens (xs=4 through xxxl=60)
  - Phosphor icon mappings for nav, trends, actions, states
  - Full ThemeData with zero elevation, flat borders, no Material defaults
  - Custom bottom nav with dot indicator + count badge
  - 4 placeholder screens (onboarding with PageView, radar, feed, profile)
  - GoRouter with ShellRoute for tabs + full-screen onboarding route
  - ProviderScope + MaterialApp.router wired up
  - `flutter analyze`: zero issues, debug APK builds successfully

## In Progress / Next Steps

The design doc (`docs/design-ai-skill-radar.md`) outlines 11 implementation steps. Step 1 is done. Remaining:

- [ ] **Step 2: Onboarding flow** — 5-step PageView (welcome, role, skills, experience, sources) with chip selection UI
- [ ] **Step 3: Firebase setup** — Firestore, anonymous auth, Cloud Functions scaffold
- [ ] **Step 4: Firestore data model** — `users/{uid}`, `articles/{id}`, `briefs/{uid}/weekly/{weekId}`
- [ ] **Step 5: RSS feed ingestion** — Cloud Function to fetch Reddit, HN, blog RSS feeds
- [ ] **Step 6: Claude API integration** — Cloud Function for article summarization + skill extraction
- [ ] **Step 7: Radar dashboard** — Today's brief + skill gap list with trend labels (New/Rising/Hot)
- [ ] **Step 8: Feed screen** — Tabbed articles (All/Reddit/HN/Blogs) with SKILL GAP badges
- [ ] **Step 9: Profile screen** — Edit role, skills, feed sources
- [ ] **Step 10: Push notifications** — FCM for weekly skill brief
- [ ] **Step 11: Polish** — Animations, error states, empty states, offline mode

## Key Decisions

- **Anduin Blue `#3FA6EE`**: Extracted from anduintransact.com. Fails WCAG AA for text on white (2.9:1) — use `primaryDark` (`#2B7AB8`, 4.6:1) for text links.
- **Firebase over Supabase**: User chose Firebase for backend (Firestore, Cloud Functions, FCM, anonymous auth).
- **Trend labels computed client-side**: New/Rising/Hot classification happens in Dart, not by Claude API (Claude can't see historical data).
- **Critical-path tests only for MVP**: 4 tests (trend computation, RSS dedup, Claude JSON parsing, Firestore rules). Expanded coverage deferred to TODOS.md.
- **freezed + json_serializable**: Chosen for model serialization over manual fromJson.
- **Feature-first folder structure**: `lib/features/{feature}/screens/` not layer-first.
- **No Material defaults**: Zero elevation everywhere, custom everything, Phosphor icons only.
- **Editorial typography**: Instrument Serif (serif display), DM Sans (sans-serif body), JetBrains Mono (monospace meta).
- **First analysis triggers on onboarding completion**: User doesn't wait until 6AM cron for first brief.

## Dead Ends (Don't Repeat These)

- **Browse `file://` URLs**: gstack browse blocks `file://` scheme. Serve via `python3 -m http.server` and use `http://localhost:PORT/` instead.
- **Stitch MCP for UI**: User mentioned Stitch MCP for UI developing — it's available but not yet used. Can be leveraged for future screen implementations.

## Files Changed

### New (project scaffold)
- `lib/theme/app_colors.dart` — 11 color tokens
- `lib/theme/app_typography.dart` — 8 text style tokens with Google Fonts
- `lib/theme/app_spacing.dart` — 7 spacing constants
- `lib/theme/app_icons.dart` — Phosphor icon mappings
- `lib/theme/app_theme.dart` — ThemeData factory, zero elevation
- `lib/shared/widgets/app_bottom_nav.dart` — Custom bottom nav with badges
- `lib/features/onboarding/screens/onboarding_screen.dart` — 5-step PageView placeholder
- `lib/features/radar/screens/radar_screen.dart` — Radar placeholder
- `lib/features/feed/screens/feed_screen.dart` — Feed placeholder
- `lib/features/profile/screens/profile_screen.dart` — Profile placeholder
- `lib/app/router.dart` — GoRouter with ShellRoute + onboarding
- `lib/app/app.dart` — MaterialApp.router wrapper
- `lib/main.dart` — ProviderScope entry point
- `docs/design-ai-skill-radar.md` — Approved design doc (source of truth)
- `docs/wireframe-sketch.html` + `.png` — UI wireframes
- `docs/test-plan.md` — QA test plan
- `TODOS.md` — 3 deferred items
- `.claude/archon/plans/flutter-scaffold-anduin-theme.md` — Step 1 plan (executed)

## Current State

- **flutter analyze:** zero issues
- **flutter build apk --debug:** builds successfully
- **Tests:** Default smoke test updated, passes
- **Git:** Clean working tree, 1 unpushed commit on main

## Context for Next Session

Step 1 (scaffold) is fully complete and committed. The next major work is **Step 2: Onboarding flow** — building out the 5-step PageView with actual chip selection UI for role, skills, experience level, and feed sources. The design doc at `docs/design-ai-skill-radar.md` has the full spec including interaction states and user journey. The user wants to use the `/minimalist-flutter-ui` skill for all UI work and mentioned interest in using Stitch MCP for UI component generation.

**Recommended first action:** Read `docs/design-ai-skill-radar.md` and implement Step 2 (Onboarding flow) starting with the welcome screen, then role selection with chips.
