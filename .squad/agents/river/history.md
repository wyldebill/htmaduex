## Learnings

- Added widget test `clears fields when toggling sign in and sign up` verifying username and password fields are cleared when toggling between Sign in and Sign up.
- **Map panel dismissal (2026-05-26):** Added coverage for `onTap` dismiss handler on `GoogleMap` widget and `GestureDetector` fallback wrapper in `lib/screens/map_screen.dart`. Developed precise tap coordinate strategy using `tester.tapAt(const Offset(400, 180))` to target open map area while avoiding panel interception. Used `mapSupportedOverride: false` to test non-map platform codepath without native Google Maps. Key learning: platform-gated testing enables comprehensive coverage of platform-specific fallback behaviors.
- Pre-existing failure: `test/login_forgot_password_test.dart` uses `find.byHintText` which is undefined in the current Flutter test SDK — not related to map work. (2026-05-26)
