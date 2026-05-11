Skill: firebase-android-setup

Goal: Reliable, minimal steps to set up Firebase Auth for Android in Flutter without forcing Gradle environment secrets.

Steps:
1. Ensure the FlutterFire CLI is installed: `dart pub global activate flutterfire_cli`
2. Run `flutterfire configure` in the repo root. This will generate `lib/firebase_options.dart` and can add platform files (`android/app/google-services.json`, `ios/GoogleService-Info.plist`).
3. For Android, prefer adding `android/app/google-services.json` (download from Firebase console) and keep it out of git. CI should inject the file during the build or run `flutterfire configure` as part of the pipeline.
4. Ensure `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` is called at app startup (see lib/main.dart). Use firebase_auth as usual.
5. If you need runtime overrides, use a local `.env` for non-Firebase secrets (e.g., Google Maps API key) and keep Firebase keys optional.

Notes:
- Avoid putting Firebase API keys in Gradle build scripts. The Google Services plugin reads the platform files and is the supported flow.
- This skill should be reused when new Firebase-based features are added to ensure consistency.
