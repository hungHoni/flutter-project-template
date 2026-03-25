# Plan: Step 6 — Claude API Integration

## Overview
Add client-side Claude API integration to generate personalized DailyBriefs and SkillGaps from Firestore articles, replacing the Radar screen's mock data with live AI-generated content. Uses `anthropic_sdk_dart` package to call Claude Haiku 4.5 directly from the app (no Cloud Functions / Blaze plan required).

## Success Criteria
- [ ] Claude API called with user's profile + recent articles → returns brief + skill gaps JSON
- [ ] DailyBrief written to Firestore `users/{uid}/briefs/{date}`
- [ ] WeeklySkillGaps written to Firestore `users/{uid}/skillGaps/{weekId}`
- [ ] Radar screen shows live data from Firestore (no mock data)
- [ ] Trend labels computed client-side (New/Rising/Hot) from historical skill gap data
- [ ] API key injected via `--dart-define` (not hardcoded)
- [ ] Loading, error, and empty states on Radar screen
- [ ] `flutter analyze` = 0 issues, `flutter test` = 2/2 passing

## Architecture Notes

**Why client-side?** Cloud Functions require Firebase Blaze plan. Like the RSS fetching (Step 5), we call Claude API directly from the app. When Blaze is available, this moves to a daily Cloud Function — the Firestore repositories + providers + UI remain unchanged.

**API key security:** For a personal/single-user app, `--dart-define=ANTHROPIC_API_KEY=xxx` at build time is acceptable. The key is compiled into the binary (not in source). For multi-user production, proxy through a backend.

**Model:** Claude Haiku 4.5 (`claude-haiku-4-5-20251001`) — fast, cheap (~$2/month for 20 articles/day), sufficient quality for summarization.

**Prompt design:** Follows the design doc prompt template exactly. Claude returns JSON with `brief`, `gaps[]`, and `tagged_articles[]`. Trend labels are NOT from Claude — they're computed client-side by comparing current gaps against previous weeks' data in Firestore.

**Data flow:**
```
User taps "Refresh" or app opens
    │
    ├─ Read UserProfile from Firestore
    ├─ Read recent articles from Firestore (last 24h)
    │
    ▼
ClaudeService.generateBrief(profile, articles)
    │  POST api.anthropic.com/v1/messages
    │  → JSON { brief, gaps[], tagged_articles[] }
    │
    ▼
BriefRepository.saveBrief(uid, dailyBrief)
SkillGapRepository.saveWeeklyGaps(uid, weekId, gaps)
ArticleRepository.tagArticles(tagged_articles)
    │
    ▼
Radar screen watches briefStreamProvider → live UI
```

## Implementation Tasks

### Task 1: Add anthropic_sdk_dart dependency
**File:** `pubspec.yaml` (modify)
**Description:** Add `anthropic_sdk_dart: ^1.3.2` for Claude API access.
**Depends on:** none

### Task 2: Create ClaudeService
**File:** `lib/features/radar/services/claude_service.dart` (create)
**Description:** Wraps the Claude API call. Takes `UserProfile` + `List<Article>` → calls Haiku 4.5 with the design doc's prompt template → parses JSON response into `ClaudeAnalysisResult` (brief string, gaps list, tagged article IDs). API key from `String.fromEnvironment('ANTHROPIC_API_KEY')`. Handles API errors gracefully (timeout, invalid JSON, empty response).
**Depends on:** Task 1

### Task 3: Create BriefRepository
**File:** `lib/features/radar/repositories/brief_repository.dart` (create)
**Description:** Firestore CRUD for `users/{uid}/briefs/{date}`:
- `saveBrief(String uid, DailyBrief brief)` — writes to `briefs/{yyyy-MM-dd}`
- `watchTodaysBrief(String uid)` — streams today's brief document
- `watchLatestBrief(String uid)` — streams most recent brief (fallback if today's doesn't exist)
**Depends on:** none

### Task 4: Create SkillGapRepository
**File:** `lib/features/radar/repositories/skill_gap_repository.dart` (create)
**Description:** Firestore CRUD for `users/{uid}/skillGaps/{weekId}`:
- `saveWeeklyGaps(String uid, String weekId, List<SkillGap> gaps)` — writes/merges week's gaps
- `watchCurrentWeek(String uid)` — streams current week's gaps
- `getPreviousWeeks(String uid, int count)` — reads last N weeks for trend computation
**Depends on:** none

### Task 5: Create TrendService
**File:** `lib/features/radar/services/trend_service.dart` (create)
**Description:** Client-side trend computation per the design doc:
- **Hot** = 10+ mentions in current batch
- **Rising** = mentions increased 2x+ vs. last week
- **New** = skill not present in any prior week
Takes current gaps + previous weeks' gaps → returns gaps with trend labels assigned.
**Depends on:** none

### Task 6: Create Radar Riverpod providers
**File:** `lib/features/radar/providers/radar_providers.dart` (create)
**Description:**
- `briefRepositoryProvider` — exposes BriefRepository
- `skillGapRepositoryProvider` — exposes SkillGapRepository
- `claudeServiceProvider` — exposes ClaudeService
- `todaysBriefProvider` — StreamProvider watching today's brief from Firestore
- `radarRefreshProvider` — AsyncNotifier that orchestrates: fetch profile → fetch articles → call Claude → save brief + gaps → tag articles. Triggers on app open + manual refresh.
**Depends on:** Tasks 2, 3, 4, 5

### Task 7: Wire Radar screen to live data
**File:** `lib/features/radar/screens/radar_screen.dart` (modify)
**Description:**
- Convert from StatelessWidget to ConsumerWidget
- Remove all mock data (`_mockBrief`, `_mockGaps`, `_GapItem`)
- Watch `todaysBriefProvider` with `.when(data/loading/error)` states
- Add RefreshIndicator for manual refresh
- Show shimmer/skeleton loading state
- Show "Your first radar is brewing..." on initial generation
- Show "Couldn't refresh. Showing last brief." on error with cached data
- Use `SkillGap` model (from `daily_brief.dart`) instead of private `_GapItem`
**Depends on:** Task 6

### Task 8: Tag skill-gap articles in Feed
**File:** `lib/features/feed/repositories/article_repository.dart` (modify)
**Description:** Add `tagArticlesAsSkillGap(List<String> articleIds)` method — batch updates `isSkillGap: true` on matching articles. Called after Claude analysis.
**Depends on:** none

### Task 9: Update HANDOFF.md
**File:** `HANDOFF.md` (modify)
**Description:** Mark Step 6 complete, document new files, key decisions (client-side Claude, Haiku model, --dart-define for API key), and update "Current State" section.
**Depends on:** Tasks 1-8

### Task 10: Verify
- `flutter analyze` — 0 issues
- `flutter test` — 2/2 passing
- Manual: open app → Radar screen triggers Claude API → brief + gaps appear → pull-to-refresh works
**Depends on:** Task 9

## New Files (5)
- `lib/features/radar/services/claude_service.dart`
- `lib/features/radar/repositories/brief_repository.dart`
- `lib/features/radar/repositories/skill_gap_repository.dart`
- `lib/features/radar/services/trend_service.dart`
- `lib/features/radar/providers/radar_providers.dart`

## Modified Files (4)
- `pubspec.yaml` — add anthropic_sdk_dart
- `lib/features/radar/screens/radar_screen.dart` — replace mocks with live providers
- `lib/features/feed/repositories/article_repository.dart` — add tagArticlesAsSkillGap
- `HANDOFF.md` — document Step 6 completion

## Validation Steps
1. `flutter analyze` — must pass with zero issues
2. `flutter test` — must pass (2/2)
3. Manual test: `flutter run --dart-define=ANTHROPIC_API_KEY=sk-ant-xxx` → onboard → wait for articles → open Radar tab → brief + gaps should appear

## Run Command
```bash
flutter run --dart-define=ANTHROPIC_API_KEY=sk-ant-api03-YOUR_KEY_HERE
```

## Rollback Notes
All changes are additive. Radar screen can be reverted to mock data by restoring the previous `radar_screen.dart`. No database migrations — new Firestore documents are written to new subcollections (`briefs/`, `skillGaps/`) that don't affect existing data.

## Security Note
The API key is compiled into the app binary via `--dart-define`. This is acceptable for personal use. For production with multiple users, the Claude API call should move to a Cloud Function (Phase B) where the key stays server-side.

## Cost Estimate
- ~20 articles/day × ~2,000 input tokens + ~500 output tokens
- Haiku 4.5: ~$0.07/day = ~$2.10/month
- Well within personal-use budget
