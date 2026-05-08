# mapme

Simple Flutter Google Maps app with a single screen and a **Find Me** button.

## Secret handling (no key in git)

1. Create a local `.env` file in the repository root:
   `GOOGLE_MAPS_API_KEY=your_real_key_here`
2. `.env` is gitignored, and native platform secret files are generated from it.

Why this approach: the map SDKs need native build-time keys, so we inject from local runtime config instead of committing constants.

## Local development

1. Install deps:
   `flutter pub get`
2. Generate iOS secret config from `.env`:
   `powershell -ExecutionPolicy Bypass -File .\tool\sync_secrets.ps1`
3. Run:
   `flutter run`

For macOS/Linux shells:
`bash ./tool/sync_secrets.sh .env`

## VS Code debugging

Before first iOS debug session, run `tool/sync_secrets.ps1` (or `.sh`) so `ios/Flutter/Secrets.xcconfig` exists.

Android reads `.env` directly via Gradle each build.

## Codemagic

`codemagic.yaml` expects `GOOGLE_MAPS_API_KEY` to be defined in Codemagic environment variables.

CI writes `.env` at build time, generates iOS xcconfig, runs tests, and builds Android APK.
