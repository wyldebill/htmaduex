# mapme

Simple Flutter Google Maps app with a single screen and a **Find Me** button.

## Secret handling (no key in git)

1. Create a local `.env` file in the repository root:
   ```
   GOOGLE_MAPS_API_KEY=your_real_key_here
   FIREBASE_API_KEY=your_firebase_web_api_key
   FIREBASE_APP_ID=your_firebase_app_id
   FIREBASE_MESSAGING_SENDER_ID=your_firebase_sender_id
   FIREBASE_PROJECT_ID=your_firebase_project_id
   FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
   FIREBASE_STORAGE_BUCKET=your_project.appspot.com
   FIREBASE_IOS_BUNDLE_ID=com.example.mapme
   ```
2. `.env` is gitignored, and native platform secret files are generated from it.

Why this approach: map and Firebase settings are loaded at native build time from local runtime config, so secrets never land in source control.

If you've used the FlutterFire CLI (`flutterfire configure`) the generated `lib/firebase_options.dart` will also be used as a safe fallback for local development when native secrets are not present.

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

`codemagic.yaml` expects these environment variables:
`GOOGLE_MAPS_API_KEY`, `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID`, `FIREBASE_AUTH_DOMAIN`, `FIREBASE_STORAGE_BUCKET`, `FIREBASE_IOS_BUNDLE_ID`.

CI writes `.env` at build time, generates iOS xcconfig, runs tests, and builds Android APK.
