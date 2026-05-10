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

## Archive (decisions older than 30 days)

*None yet*
