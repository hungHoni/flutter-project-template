# gstack

Use the `/browse` skill from gstack for all web browsing. Never use `mcp__claude-in-chrome__*` tools.

## Available skills

- `/office-hours`
- `/plan-ceo-review`
- `/plan-eng-review`
- `/plan-design-review`
- `/design-consultation`
- `/review`
- `/ship`
- `/browse`
- `/qa`
- `/qa-only`
- `/design-review`
- `/setup-browser-cookies`
- `/retro`
- `/investigate`
- `/document-release`
- `/codex`
- `/careful`
- `/freeze`
- `/guard`
- `/unfreeze`
- `/gstack-upgrade`

If gstack skills aren't working, run `cd .claude/skills/gstack && ./setup` to build the binary and register skills.

## Design System
Always apply `/minimalist-flutter-ui` when writing Flutter UI code. This enforces:
- Warm monochrome palette, no Material defaults
- Editorial typography (serif display, sans-serif body, monospace meta)
- Ultra-flat components with `1px solid #EAEAEA` borders, no elevation
- Phosphor icons, not Material icons
- Generous whitespace and bento-grid layouts
- Subtle scroll-entry animations

Read `.claude/skills/minimalist-flutter-ui/SKILL.md` before making any visual or UI decisions.
