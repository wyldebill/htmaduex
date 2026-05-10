Title: Use FlutterFire-generated firebase_options.dart as a safe fallback

Created: 2026-05-09T21:34:49.107-05:00

Decision: When native build-time Firebase secrets (.env / xcconfig / gradle properties) are missing, the app will fall back to using the FlutterFire CLI generated firebase_options.dart at runtime. This keeps local development friction low for contributors who ran `flutterfire configure` but didn't materialize native secret files.

Rationale:
- Native build-time secrets are preferred for CI and production so API keys don't end up in source control.
- Many contributors follow FlutterFire CLI workflows; having a documented, safe fallback reduces 'missing API key' build failures.

Consequences:
- Developers should still avoid committing production secrets. The fallback is intended for convenience in development and test projects only.
- CI pipelines and release builds must provide native secrets (see README 'Secret handling').

Actions:
- Updated lib/firebase/app_firebase_options.dart to try native config, then generated firebase_options.dart.
- Updated .squad history with the change.

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>