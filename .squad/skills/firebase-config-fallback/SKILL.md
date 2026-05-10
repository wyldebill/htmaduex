# Firebase config fallback

Skill: Document the pattern of using native build-time secrets first and falling back to FlutterFire-generated firebase_options.dart for local development.

When to use:
- Mobile apps that prefer native secret injection (gradle/xcconfig) for CI and production, but want a low-friction local dev experience using FlutterFire CLI.

How it works:
1. Try platform-native config (Android BuildConfig / iOS Info.plist) via platform channel.
2. If native config is missing or contains placeholder values, fall back to the FlutterFire CLI generated DefaultFirebaseOptions.currentPlatform.
3. As a last resort, read values from Dart defines (FIREBASE_API_KEY etc.) when running with --dart-define.

Why:
- Keeps production secrets out of source control while reducing friction for contributors.

Notes:
- CI and release builds MUST still provide native secrets (see README).
