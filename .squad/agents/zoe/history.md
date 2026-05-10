# Zoe - Backend Dev history

## Learnings

- 2026-05-09T21:34:49.107-05:00: Added fallback in lib/firebase/app_firebase_options.dart to use FlutterFire-generated firebase_options.dart when native build-time secrets are missing. This prevents 'Missing Firebase API key' errors for contributors who used lutterfire configure but didn't generate native .env/xcconfig files.
