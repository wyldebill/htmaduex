# Project Context

- **Owner:** William Austin
- **Project:** htmarevived
- **Stack:** Dart, Flutter, Google Maps integrations
- **Created:** 2026-05-08

## Learnings

Initialized as Frontend Dev for Flutter UI and map-facing experiences.

- Cleared username and password TextEditingController values and unfocused input when toggling between Sign in and Sign up to avoid leaking input between modes and to improve UX when switching forms.
- **Map panel dismissal (2026-05-26):** Added `onTap: (_) => setState(() => _selectedId = null)` to `GoogleMap` and a `GestureDetector` wrapping the non-map fallback container for the same behavior. **Moved `IgnorePointer` to wrap the panel `Container` directly (inside `Align`) rather than wrapping `Align` itself** — this ensures taps outside the panel fall through to the map/fallback layer instead of being absorbed by the full-screen `Align`. This minimal structural change reduces regression risk. Key insight: hit-test absorption in Flutter stacks requires careful `IgnorePointer` scoping.
- Key files: `lib/screens/map_screen.dart`, `test/map_screen_test.dart`
