# TODOS

## Silent Failure Error Handling
- **What:** Add error handling for 3 silent failure modes: Firestore quota exceeded (CF writes fail), FCM invalid token (notifications drop), onboarding network failure (profile data lost).
- **Why:** These failures are invisible to the user — no error message, no retry, no indication something went wrong. Would surface during demos or with multiple users.
- **Context:** Identified during /plan-eng-review failure mode analysis (2026-03-21). For Firestore quota: catch write errors in Cloud Functions and log to Cloud Logging with alerts. For FCM: validate tokens before send, remove stale tokens. For onboarding: add retry logic with local draft save.
- **Depends on:** Core implementation complete (all 9 steps).

## Expand Test Coverage
- **What:** Add widget tests for onboarding flow, dashboard rendering, feed tab filtering, profile editing. Plus integration tests for offline mode.
- **Why:** MVP ships with 4 critical-path unit tests (trend computation, RSS dedup, Claude JSON parsing, Firestore rules). Widget tests ensure UI doesn't break on refactors.
- **Context:** Test diagram from /plan-eng-review (2026-03-21) identified 21 testable items. 4 critical-path tests chosen for MVP. Remaining 17 are lower priority for solo use but become important if sharing the codebase.
- **Depends on:** UI implementation stable (steps 3-7 complete).

## Create DESIGN.md
- **What:** Create a formal DESIGN.md consolidating typography scale, color system, spacing scale, icon system, and component specs into one file.
- **Why:** Design decisions are currently split between CLAUDE.md (minimalist-flutter-ui reference) and the design doc (color table, typography scale added during /plan-design-review). A single DESIGN.md is the standard source of truth that all skills reference.
- **Context:** Identified during /plan-design-review (2026-03-21). Should extract: typography scale (7 tokens), spacing scale (7 tokens), color system (11 tokens), icon system (Phosphor thin), component specs (chips, cards, buttons, nav), and accessibility basics (contrast, touch targets).
- **Depends on:** Nothing — can be done anytime before or during implementation.
