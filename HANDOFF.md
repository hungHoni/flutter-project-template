# Handoff: AI Skill Radar — Steps 1-6, 7-9 Complete

**Date:** 2026-03-25
**Branch:** main

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
  - firebase_options.dart generated via `flutterfire configure` (project: skillradar-b5774)
  - Anonymous auth Riverpod provider (authStateProvider, authStreamProvider)
  - Auth kicked off in background from app.dart (non-blocking)
  - iOS minimum set to 13.0 (Podfile), Android minSdk set to 23
  - Firebase project created, Anonymous Auth + Firestore enabled in console
- [x] **Step 4: Firestore data model** — all freezed + json_serializable models complete:
  - `UserProfile` — role, skills, level, feedSources, fcmToken, createdAt
  - `Article` — source, sourceName, title, excerpt, url, tags, isSkillGap, timestamps
  - `DailyBrief` — summary, gapCount, embedded list of `SkillGap`
  - `SkillGap` — name, trend, mentionCount, suggestedAction, detectedAt, weekId
  - `WeeklySkillGaps` — gaps list keyed by weekId
  - `TimestampConverter` — Firestore Timestamp ↔ DateTime
  - Barrel export at `lib/models/models.dart`
- [x] **Step 5: RSS feed ingestion** — client-side implementation (no Blaze required):
  - **Firestore provider** — `firestoreProvider` exposing FirebaseFirestore instance
  - **ArticleRepository** — Firestore CRUD for `articles/{id}` with SHA-256 URL hashing, watchArticles stream, upsert, exists check, tagArticlesAsSkillGap batch update
  - **RssService** — Client-side RSS/Atom fetcher via `dio` + `xml`:
    - Reddit: fetches `/r/{sub}/hot.rss` Atom XML with User-Agent header, 60min rate limit
    - Hacker News: fetches top stories via JSON API (topstories + item endpoints)
    - AI Blogs: RSS 2.0 from Google AI Blog, OpenAI Blog
    - HTML stripping + 200-char excerpt truncation
    - Per-source try/catch — partial results on failure
  - **FeedSyncService** — Orchestrates fetch → deduplicate (by URL hash) → write to Firestore
  - **Article Riverpod providers** — `articlesStreamProvider(source)` StreamProvider.family, `feedSyncProvider` for initial sync, `feedSyncNotifierProvider` for pull-to-refresh
  - **UserProfileRepository** — Firestore CRUD for `users/{uid}`, watchProfile stream, saveProfile, updateField
  - **UserProfile provider** — `userProfileProvider` StreamProvider reading current user's profile
  - **timeAgo utility** — DateTime to relative time string ("2h ago", "1d ago", etc.)
  - **Feed screen wired to Firestore** — ConsumerWidget watching articlesStreamProvider per tab, RefreshIndicator for pull-to-refresh, Article model replaces mock _ArticleItem
  - **Profile screen wired to Firestore** — ConsumerWidget watching userProfileProvider, writes changes via updateField
  - **Onboarding writes to Firestore** — completeOnboarding() creates UserProfile in Firestore
  - Added `xml: ^6.5.0` and `crypto: ^3.0.0` dependencies
- [x] **Step 6: Claude API integration** — client-side implementation (no Blaze required):
  - **ClaudeService** — Calls Claude Haiku 4.5 via `anthropic_sdk_dart` package:
    - System prompt from design doc: role + skills + articles → JSON brief + gaps + tagged_articles
    - JSON response parsing with markdown code fence stripping
    - API key via `--dart-define=ANTHROPIC_API_KEY=xxx` (not hardcoded)
    - Graceful error handling (empty articles, invalid JSON, API errors)
  - **BriefRepository** — Firestore CRUD for `users/{uid}/briefs/{date}`:
    - `saveBrief` writes to `briefs/{yyyy-MM-dd}`
    - `watchBrief` streams specific date's brief
    - `watchLatestBrief` streams most recent brief (fallback)
  - **SkillGapRepository** — Firestore CRUD for `users/{uid}/skillGaps/{weekId}`:
    - `saveWeeklyGaps` writes current week's gaps
    - `watchWeek` streams specific week
    - `getPreviousWeeks` reads last N weeks for trend computation
  - **TrendService** — Client-side trend label computation:
    - Hot = 10+ mentions in current batch
    - Rising = mentions increased 2x+ vs. last week
    - New = skill not present in any prior week
  - **Radar providers** — Full orchestration layer:
    - `todaysBriefProvider` StreamProvider watching latest brief from Firestore
    - `RadarRefreshNotifier` orchestrates: read profile → read articles → call Claude → compute trends → save brief + gaps → tag articles
  - **Radar screen wired to live data** — ConsumerStatefulWidget:
    - Auto-triggers analysis on first open if no brief exists
    - Pull-to-refresh triggers new Claude analysis
    - Loading state: "Scanning the AI landscape for you..."
    - Empty state: "Your first radar is brewing..." with Generate button
    - Error state: contextual messages (no API key, no articles, generic)
    - Cached fallback: "Couldn't refresh. Showing last brief."
  - Added `anthropic_sdk_dart: ^1.3.2` dependency
- [x] **Step 7: Radar dashboard** — now wired to live Claude API data:
  - "Your Radar" serif headline with formatted date subtitle
  - TODAY'S BRIEF card with AI-generated personalized summary
  - Gap cards with HOT/RISING/NEW trend badges (computed from Firestore history)
  - Suggested actions per gap
- [x] **Step 8: Feed screen** — wired to live Firestore data:
  - Tabbed articles (All/Reddit/HN/Blogs) from Firestore streams
  - Pull-to-refresh triggers RSS sync
  - Loading/error/empty states
- [x] **Step 9: Profile screen** — wired to live Firestore data:
  - Reads/writes role, skills, level, feedSources to Firestore in real time
  - About section with app info

## In Progress / Next Steps

- [ ] **Step 10: Push notifications** — FCM for weekly skill brief
- [ ] **Step 11: Polish** — Animations, error states, empty states, offline mode
- [ ] **Phase B: Server-side RSS + Claude** — When Blaze plan active: move RSS fetching + Claude API to scheduled Cloud Functions, delete client-side `rss_service.dart` + `feed_sync_service.dart` + `claude_service.dart`

## Key Decisions

- **Router architecture**: `createRouter(bool)` receives sync bool, App widget handles async SharedPreferences via FutureProvider
- **Anduin Blue `#3FA6EE`**: Fails WCAG AA for text on white — use `primaryDark` (`#2B7AB8`, 4.6:1) for text links
- **Firebase over Supabase**: User chose Firebase for backend
- **Trend labels computed client-side**: New/Rising/Hot classification in Dart, not Claude API
- **freezed + json_serializable**: `TimestampConverter` uses `dynamic` as JSON type
- **Feature-first folder structure**: `lib/features/{feature}/screens/`
- **No Material defaults**: Zero elevation, Phosphor icons only
- **Editorial typography**: Instrument Serif (display), DM Sans (body), JetBrains Mono (meta)
- **Client-side RSS over Cloud Functions**: Blaze plan not required. RssService fetches directly from app via `dio`. Repository + providers remain identical when migrating to server-side — only the writer changes.
- **URL hash as document ID**: `sha256(url).substring(0, 20)` for stable cross-platform dedup
- **60-minute rate limit per source**: In-memory `Map<String, DateTime>` prevents excessive API calls
- **Profile uses Riverpod + Firestore**: ConsumerWidget watches `userProfileProvider`, writes changes via `userProfileRepositoryProvider`
- **Client-side Claude API**: Uses `anthropic_sdk_dart` with Haiku 4.5 (~$2/month). API key injected via `--dart-define` at build time. Will move to Cloud Function in Phase B for key security.
- **Claude Haiku 4.5 model**: `claude-haiku-4-5-20251001` — fast, cheap, sufficient for summarization. ~$0.07/day for 20 articles.

## Dead Ends (Don't Repeat These)

- **FutureProvider in router redirect**: Provider hadn't resolved when redirect ran. Fix: App watches provider, passes resolved bool to router.
- **`find.text('Your AI\nRadar')` in tests**: Use `find.textContaining('Your AI')` instead.
- **Switch.adaptive `activeColor`**: Deprecated. Use `activeTrackColor` + `activeThumbColor`.
- **Browse `file://` URLs**: Serve via `python3 -m http.server` instead.
- **TimestampConverter with `Timestamp` type**: Use `JsonConverter<DateTime, dynamic>` instead.
- **`flutterfire configure` PATH**: Add `$HOME/.pub-cache/bin` to PATH.
- **`flutterfire configure` interactive mode**: Use `--project=skillradar-b5774 --yes` flags.
- **Web blank screen without web config**: firebase_options.dart must include `kIsWeb` check.

## Files Changed

### Step 6 (Claude API integration)
- `pubspec.yaml` — Added anthropic_sdk_dart dependency
- `lib/features/radar/services/claude_service.dart` — NEW: Claude API client, prompt template, JSON parsing
- `lib/features/radar/repositories/brief_repository.dart` — NEW: Firestore CRUD for daily briefs
- `lib/features/radar/repositories/skill_gap_repository.dart` — NEW: Firestore CRUD for weekly skill gaps
- `lib/features/radar/services/trend_service.dart` — NEW: Client-side Hot/Rising/New trend computation
- `lib/features/radar/providers/radar_providers.dart` — NEW: Orchestration providers (todaysBrief, radarRefresh)
- `lib/features/radar/screens/radar_screen.dart` — REWRITTEN: ConsumerStatefulWidget with live Firestore data
- `lib/features/feed/repositories/article_repository.dart` — MODIFIED: Added tagArticlesAsSkillGap batch method

### Step 5 (RSS feed ingestion + Firestore wiring)
- `pubspec.yaml` — Added xml, crypto dependencies
- `lib/app/providers/firestore_provider.dart` — NEW: FirebaseFirestore instance provider
- `lib/features/feed/repositories/article_repository.dart` — NEW: Firestore CRUD for articles, SHA-256 URL hashing
- `lib/features/feed/services/rss_service.dart` — NEW: Client-side RSS/Atom/JSON fetcher (Reddit, HN, Blogs)
- `lib/features/feed/services/feed_sync_service.dart` — NEW: Fetch → dedup → Firestore orchestrator
- `lib/features/feed/providers/article_providers.dart` — NEW: StreamProvider.family + sync notifier
- `lib/shared/utils/time_ago.dart` — NEW: DateTime to relative time string
- `lib/features/profile/repositories/user_profile_repository.dart` — NEW: Firestore CRUD for user profiles
- `lib/features/profile/providers/user_profile_provider.dart` — NEW: StreamProvider for current user profile
- `lib/features/feed/screens/feed_screen.dart` — REWRITTEN: ConsumerWidget with Firestore streams, pull-to-refresh
- `lib/features/profile/screens/profile_screen.dart` — REWRITTEN: ConsumerWidget with Firestore read/write
- `lib/features/onboarding/providers/onboarding_provider.dart` — MODIFIED: Writes UserProfile to Firestore on completion

### Steps 7-9 (UI screens)
- `lib/features/radar/screens/radar_screen.dart` — Full radar dashboard (now Claude API-backed)
- `lib/features/feed/screens/feed_screen.dart` — Tabbed feed (Firestore-backed)
- `lib/features/profile/screens/profile_screen.dart` — Editable settings (Firestore-backed)

### Step 4 (Firestore data model)
- `lib/models/` — All freezed models + generated code

### Step 3 (Firebase setup)
- Firebase initialization, auth providers, platform configs

### Steps 1-2 (Scaffold + Onboarding)
- Theme, router, bottom nav, onboarding flow, shared widgets

## Current State

- **Tests:** 2/2 passing (`flutter test`)
- **Analyze:** 0 issues (`flutter analyze`)
- **Firebase:** Connected to project skillradar-b5774. Anonymous Auth + Firestore enabled.
- **Models:** All 5 Firestore document models generated.
- **Feed:** Live RSS ingestion → Firestore → StreamProvider → UI. Pull-to-refresh supported.
- **Profile:** Reads/writes to Firestore in real time.
- **Radar:** Live Claude API analysis → DailyBrief + SkillGaps → Firestore → StreamProvider → UI.

## Run Command

```bash
flutter run --dart-define=ANTHROPIC_API_KEY=sk-ant-api03-YOUR_KEY_HERE
```

## Context for Next Session

Steps 1-9 are complete (including Step 6). The full data pipeline is live:
1. RSS articles fetched client-side → stored in Firestore
2. Claude Haiku 4.5 analyzes articles against user profile → generates brief + skill gaps
3. Trend labels computed client-side from historical Firestore data
4. Radar screen streams live brief from Firestore with loading/error/empty states

**Next steps:**
1. Step 10: Push notifications (FCM)
2. Step 11: Polish (animations, error states, offline mode)
3. Phase B: Move RSS + Claude to server-side Cloud Functions when Blaze plan is active
