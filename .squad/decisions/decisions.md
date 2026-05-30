# Team Decisions

## Active Decisions

### 2026-05-09T21:10:20.811-05:00: User directive
**By:** William Austin (via Copilot)
**What:** Always use Context7 so documentation is as recent as possible.
**Why:** User request — captured for team memory

### 2026-05-09T21:10:57.478-05:00: User directive
**By:** William Austin (via Copilot)
**What:** Copilot should also always use Context7 for up-to-date documentation.
**Why:** User request — captured for team memory

### 2026-05-09T21:34:49.107-05:00: Use FlutterFire-generated firebase_options.dart as a safe fallback
**By:** Zoe (Backend Dev)
**What:** When native build-time Firebase secrets (.env / xcconfig / gradle properties) are missing, the app will fall back to using the FlutterFire CLI generated firebase_options.dart at runtime. This keeps local development friction low for contributors who ran `flutterfire configure` but didn't materialize native secret files.

**Rationale:**
- Native build-time secrets are preferred for CI and production so API keys don't end up in source control.
- Many contributors follow FlutterFire CLI workflows; having a documented, safe fallback reduces 'missing API key' build failures.

**Consequences:**
- Developers should still avoid committing production secrets. The fallback is intended for convenience in development and test projects only.
- CI pipelines and release builds must provide native secrets (see README 'Secret handling').

**Actions:**
- Updated lib/firebase/app_firebase_options.dart to try native config, then generated firebase_options.dart.
- Updated .squad history with the change.

### 2026-05-09T21:45:53.665-05:00: Do not require FIREBASE_* Gradle env vars
**By:** Zoe (Backend Dev)
**What:** Stop enforcing FIREBASE_* values as required Gradle environment variables during Android builds. Instead, prefer the standard Firebase platform files (google-services.json / GoogleService-Info.plist) or the FlutterFire-generated firebase_options.dart.

**Rationale:**
- The standard Firebase setup for Android uses google-services.json; requiring env vars in Gradle causes build failures for developers who use the FlutterFire CLI or the Console flow.
- Keeping Firebase keys optional avoids accidental secret exposure and aligns with FlutterFire best practices.

**Consequences:**
- android/app/build.gradle.kts no longer throws when FIREBASE_* variables are absent; BuildConfig fields are populated with empty strings when not supplied, preserving compatibility with native code.
- Developers should use `flutterfire configure` or add platform files to configure Firebase. CI can still inject env vars if desired.

**Actions:**
- Removed buildscript requirement from android/app/build.gradle.kts.
- Updated README.md with Firebase configuration guidance.
- Updated .squad history with the change.

### 2026-05-09T21:45:53.665-05:00: User directive
**By:** William Austin (via Copilot)
**What:** Gradle should not require a Firebase API key for this setup.
**Why:** User request — captured for team memory

---

### 2026-05-21T07:54:32.710-05:00: Clear login fields on mode toggle
**By:** Kaylee (Frontend Dev)
**What:** When toggling between Sign in and Sign up, clear the username and password fields and unfocus any active input.

**Rationale:**
- Prevent stale credential leakage between modes and avoid accidental submissions.
- Provide a clean form state when switching modes for better UX.

**Actions:**
- Updated lib/screens/login_screen.dart to call FocusScope.of(context).unfocus() and clear both TextEditingController instances inside the same setState call that flips _signInMode.

---

### 2026-05-26T23:20:00.000-05:00: Map background tap dismisses the bottom panel
**By:** Kaylee (Frontend Dev), River (Tester)
**Status:** Implemented

**Context:**
When a user taps a map marker, a slide-up panel appears at the bottom of `MapScreen` showing the selected business. There was no way to dismiss this panel other than selecting a different marker.

**Decision:**
Tapping the empty map background (no marker) deselects the current marker and slides the panel back down.

**Implementation:**
- Added `onTap: (_) => setState(() => _selectedId = null)` to the `GoogleMap` widget in `lib/screens/map_screen.dart`.
- Wrapped the non-map fallback `Container` in a `GestureDetector` with the same dismiss callback, enabling consistent behavior across all platforms and widget testing without native Google Maps.
- Moved `IgnorePointer` to wrap the panel `Container` directly rather than wrapping `Align` itself. This ensures the full-screen `Align` no longer absorbs pointer events outside the visible panel, allowing taps on the map or fallback background to propagate correctly.

**Rationale:**
- The previous `IgnorePointer(child: Align(child: Container))` structure caused `Align` (which fills its parent) to consume all hit-tests in the full screen area when the panel was visible, blocking the underlying map's `onTap`.
- Scoping `IgnorePointer` to only the panel `Container` fixes this with minimal structural change.
- Minimal change approach reduces regression risk for other panel behaviors.

**Test Approach:**
- Widget test (`test/map_screen_test.dart`) uses `mapSupportedOverride: false` and `tester.tapAt(const Offset(400, 180))` to simulate a tap in the open map area.
- Y-coordinate chosen to land between the filter chips overlay (top) and the bottom panel (when visible), which occupies the lower ~270 px of the Stack.

---

## Archive (decisions older than 30 days)

*None yet*
