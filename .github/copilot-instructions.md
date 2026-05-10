# Copilot instructions for `mapme`

## Build, test, and lint commands

Run these from the repository root:

```bash
flutter pub get
flutter analyze
flutter test
```

Run a single test file:

```bash
flutter test test/explore_navigation_test.dart
```

Run a single test by name:

```bash
flutter test --plain-name "basic smoke test"
```

For local iOS runs, generate native secrets before `flutter run`:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\sync_secrets.ps1
```

macOS/Linux equivalent:

```bash
bash ./tool/sync_secrets.sh .env
```

## High-level architecture

- App entry is `lib/main.dart`, using `MaterialApp.router` + `go_router` for all navigation.
- Route flow is:
  - `/login` (`LoginScreen`)
  - `/onboarding` (`WizardScreen`) with `/wizard` redirecting here
  - `/map` (`MapScreen`) and `/list` (`ListScreen`) as primary browse surfaces
  - `/business/:id` (`DetailScreen`) for place detail
- UI is intentionally screen-driven (no separate data/service layer yet): screens contain local state and currently use in-file demo item collections.
- Shared visual system lives in `lib/theme/app_theme.dart` (`AppColors`, `appTheme`, spacing/shadow tokens) and is expected to drive styling across screens.
- Google Maps key wiring is native-build-time:
  - Android reads `.env` / env vars in `android/app/build.gradle.kts` and injects `manifestPlaceholders`
  - iOS reads `ios/Flutter/Secrets.xcconfig` via `Debug.xcconfig`/`Release.xcconfig`
  - helper scripts in `tool/sync_secrets.ps1` and `tool/sync_secrets.sh` generate iOS secrets from `.env`

## Key conventions in this repository

- Navigation convention: use `context.go(...)` for top-level route switches and `context.push(...)` for drill-down detail navigation.
- Keep route compatibility aliases when present (example: `/wizard` redirecting to `/onboarding`) instead of removing them.
- Prefer theme tokens from `AppColors`/`appTheme` over ad-hoc colors and typography values in new UI code.
- Map support is platform-gated in `MapScreen` (`kIsWeb`/Android/iOS) with a non-map fallback UI for unsupported platforms; preserve this behavior.
- Widget navigation tests can capture framework errors explicitly (see `test/explore_navigation_test.dart`) to guard against layout assertion regressions during route transitions.
- Secrets stay out of source constants: use `.env` + sync scripts / native placeholder config, not hardcoded API keys.
