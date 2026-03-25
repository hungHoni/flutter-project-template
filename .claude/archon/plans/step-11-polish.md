# Plan: Step 11 — Polish (Animations, Error States, Offline Mode)

## Overview
Add scroll-entry animations, skeleton loading states, offline-aware UI, haptic feedback, and refined error/empty states across all three screens. The app currently works end-to-end but feels static — this step makes it feel premium and resilient.

## Success Criteria
- [ ] Scroll-entry animations on Radar gaps, Feed articles, and Profile sections (staggered fade+slide)
- [ ] Skeleton/shimmer loading replaces raw CircularProgressIndicator on Feed and Radar
- [ ] Offline banner shown when device has no connectivity
- [ ] Firestore offline persistence explicitly enabled with cache size config
- [ ] Empty states have illustrations (Phosphor icons) and contextual copy
- [ ] Pull-to-refresh has haptic feedback on iOS/Android
- [ ] Tab transitions are smooth (no flicker on first load)
- [ ] `flutter analyze` = 0 issues, `flutter test` = 2/2 passing

## Architecture Notes

**Animation approach:** Reusable `ScrollEntryWidget` wrapping each list item with staggered delay (index * 80ms). Uses `AnimatedOpacity` + `SlideTransition` triggered when item enters viewport via `VisibilityDetector` or simpler approach: trigger on build with post-frame callback + delay.

**Offline approach:** Use `connectivity_plus` package to detect network state. Show a persistent banner (not a snackbar) at the top. Firestore's built-in offline cache handles data availability — we just need to inform the user visually.

**Skeleton approach:** Use `shimmer` package for loading placeholders that match the shape of actual content cards. One shared `SkeletonCard` widget reused across screens.

**No new providers needed** — just UI-layer enhancements and one connectivity stream.

## Implementation Tasks

### Task 1: Add dependencies
**File:** `pubspec.yaml` (modify)
**Type:** Modify
**Description:** Add `shimmer: ^3.0.0`, `connectivity_plus: ^6.1.0`, and `visibility_detector: ^0.4.0+2`.
**Depends on:** none

### Task 2: Create ScrollEntryWidget
**File:** `lib/shared/widgets/scroll_entry.dart` (new)
**Type:** Create
**Description:** Reusable widget that fades in + slides up when first built. Parameters: `delay` (Duration), `child` (Widget). Uses `AnimationController` with 400ms duration, `CurvedAnimation(Curves.easeOutQuart)`. Triggers after `delay` via `Future.delayed` in `initState`. This follows the design system spec: "fade + slide (300ms easeOut), scroll entry (600ms easeOutQuart)".
**Depends on:** none

### Task 3: Create SkeletonCard widget
**File:** `lib/shared/widgets/skeleton_card.dart` (new)
**Type:** Create
**Description:** Shimmer loading placeholder matching article/gap card shape. Two variants: `SkeletonCard.article()` (title line + 2 body lines + meta) and `SkeletonCard.gap()` (badge + title + action line). Uses `Shimmer.fromColors` with warm monochrome colors from AppColors.
**Depends on:** Task 1

### Task 4: Create ConnectivityProvider
**File:** `lib/app/providers/connectivity_provider.dart` (new)
**Type:** Create
**Description:** `StreamProvider<bool>` wrapping `Connectivity().onConnectivityChanged`. Maps `ConnectivityResult.none` to `false`, everything else to `true`. Initial value from `Connectivity().checkConnectivity()`.
**Depends on:** Task 1

### Task 5: Create OfflineBanner widget
**File:** `lib/shared/widgets/offline_banner.dart` (new)
**Type:** Create
**Description:** Thin persistent banner (32px height, warm gray bg) showing "You're offline — showing cached data" with a Phosphor wifi-slash icon. Slides down with animation when offline, slides up when back online. Used in the app shell above the tab content.
**Depends on:** Task 4

### Task 6: Wire OfflineBanner into app shell
**File:** `lib/app/router.dart` (modify)
**Type:** Modify
**Description:** Add `OfflineBanner` above the `child` in `_ScaffoldWithNav`. Watch `connectivityProvider` and show/hide the banner. The banner sits between the SafeArea top and the page content.
**Depends on:** Task 5

### Task 7: Configure Firestore offline persistence
**File:** `lib/app/app.dart` or `lib/main.dart` (modify)
**Type:** Modify
**Description:** Call `FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED)` after Firebase init. This is already the default on mobile, but making it explicit documents the intent and ensures web also gets it.
**Depends on:** none

### Task 8: Polish Radar screen — skeleton loading + scroll entry
**File:** `lib/features/radar/screens/radar_screen.dart` (modify)
**Type:** Modify
**Description:**
- Replace `_LoadingState` spinner with 1 `SkeletonCard.gap()` for brief + 3 `SkeletonCard.gap()` for gaps
- Wrap `_BriefCard` in `ScrollEntryWidget(delay: Duration.zero)`
- Wrap each `_GapCard` in `ScrollEntryWidget(delay: Duration(milliseconds: 80 * index))`
- Improve `_EmptyState` with large Phosphor `radar` icon above the text
- Add haptic feedback (`HapticFeedback.mediumImpact()`) on pull-to-refresh trigger
**Depends on:** Tasks 2, 3

### Task 9: Polish Feed screen — skeleton loading + scroll entry
**File:** `lib/features/feed/screens/feed_screen.dart` (modify)
**Type:** Modify
**Description:**
- Replace loading `CircularProgressIndicator` with 4x `SkeletonCard.article()` in a column
- Wrap each `_ArticleCard` in `ScrollEntryWidget(delay: Duration(milliseconds: 60 * index))`
- Improve empty state with Phosphor `newspaper` icon + "No articles yet" copy
- Add haptic feedback on pull-to-refresh
**Depends on:** Tasks 2, 3

### Task 10: Polish Profile screen — scroll entry
**File:** `lib/features/profile/screens/profile_screen.dart` (modify)
**Type:** Modify
**Description:**
- Wrap each section (role, experience, skills, sources, about) in `ScrollEntryWidget` with staggered delays
- Replace loading spinner with shimmer skeleton matching the section layout
- Improve empty/error state if profile fails to load
**Depends on:** Task 2

### Task 11: Add page transition animation to router
**File:** `lib/app/router.dart` (modify)
**Type:** Modify
**Description:** Add `CustomTransitionPage` with fade transition (200ms) for tab routes in `GoRoute.pageBuilder`. This eliminates the default material push animation between tabs and gives a smoother feel.
**Depends on:** none

### Task 12: Verify
- `flutter analyze` — 0 issues
- `flutter test` — 2/2 passing
- Manual: check scroll animations on all 3 screens, verify offline banner, skeleton loading, haptic feedback

## Validation Steps
1. `flutter analyze` — 0 issues
2. `flutter test` — 2/2 passing
3. Manual: toggle airplane mode → banner appears → cached data still shows → disable airplane mode → banner disappears
4. Manual: open Radar → skeleton shows → brief + gaps animate in with stagger
5. Manual: open Feed → skeleton shows → articles animate in → pull to refresh → haptic fires
6. Manual: profile sections animate in with stagger on load

## Rollback Notes
All changes are UI-only. No data model, Firestore schema, or provider logic changes. Safe to revert any individual task without affecting others (except Task 1 deps).
