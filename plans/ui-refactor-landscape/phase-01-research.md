---
phase: 1
title: Research & UX Auditing
status: completed
effort: 4h
dependencies: []
---

# Phase 1: Research & UX Auditing

## Overview
Conduct an audit of the current UI to identify all text labels that can be converted to icons, and determine the necessary layout changes to force and support full-screen landscape orientation across devices. Apply `ui-ux-pro-max` heuristics.

## Requirements
- Functional: Identify text elements for icon replacement. Determine the method to lock app to landscape (e.g., via `SystemChrome.setPreferredOrientations`).
- Non-functional: Ensure all new icons are vector-based (Flutter `IconData` or SVG), not emojis. Ensure icons have semantic meaning.

## Architecture
- Review Flutter's `SystemChrome.setEnabledSystemUIMode` for full-screen immersive mode.
- Inventory existing UI components (buttons, app bars, dialogs) that currently use text.

## Related Code Files
- Modify: `lib/main.dart` (for orientation and system UI mode).
- Review: all files in `lib/widgets/` and `lib/screens/` containing text buttons.

## Implementation Steps
1. Audit the main game screen and menu for text usage.
2. Select an icon family (e.g., Material Icons, Lucide, or Phosphor) to ensure stroke consistency and style match.
3. Map existing text labels to chosen icons (e.g., "Play" -> `Icons.play_arrow`, "Settings" -> `Icons.settings`).
4. Validate color contrast for the proposed icons against the dark/light mode surface backgrounds (must be ≥4.5:1).

## Success Criteria
- [ ] Comprehensive list of text-to-icon replacements created.
- [ ] Method for locking landscape and full-screen identified.
- [ ] `ui-ux-pro-max` guidelines reviewed (no emoji, safe areas, 44pt touch targets).

## Risk Assessment
- Risk: Icons may not be clear enough for all users without text labels.
  - Mitigation: Add `Tooltip` or `Semantics` (accessibility labels) to all icon-only buttons so long-press or screen readers provide context.
