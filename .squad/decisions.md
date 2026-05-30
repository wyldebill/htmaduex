# Squad Decisions

## Active Decisions

### 2026-05-21T22:30:46.243-05:00: User directive
**By:** wyldebill (via Copilot)
**What:** please quit making pr's on new branches. ask me if i want a new branch or if the fix is to be in the current branch ok?
**Why:** User requested that the coordinator stop creating PRs on new branches without explicit confirmation. Captured as a directive for the squad inbox.

### Forgot-password UI as modal bottom sheet
- Implemented a modal bottom sheet for the "Forgot?" action using showModalBottomSheet with isScrollControlled: true so it slides up on all platforms.
- Prefills email from the login username field when present.
- Uses AnimatedBuilder to react to text changes and manages a local submitting state to avoid duplicate submissions.
- On success: closes sheet and shows SnackBar "Password reset email sent."; on failure: keeps sheet open and shows friendly error message.
- Reasoning: Bottom sheet matches mobile UX expectations and provides a compact, accessible flow without navigating away from the login screen.

### Decision: Splash Screen Entry Point
**Date:** 2026-05-30  
**Author:** Kaylee (Frontend Dev)  
**Branch:** feature/splash-screen

**Decision:** Added an in-app Flutter splash screen as the new app entry point (`/`). The router's `initialLocation` changed from `/login` to `/`.

**Approach:**
- `SplashScreen` widget in `lib/screens/splash_screen.dart`
- Display duration controlled by `kSplashDisplayDuration` const (default `Duration(seconds: 2)`)
- Widget also accepts a `displayDuration` named parameter for per-instance override
- After the delay, navigates to `/login` via `context.go('/login')`
- Fade-in animation on entry for polish
- Image: public-domain map-pin PNG at `assets/images/splash_logo.png`

**Rationale:** No extra packages needed — pure Flutter widget with `Future.delayed` + `mounted` guard covers the use case cleanly. Keeping duration as a top-level const makes it easy to tune without touching widget internals.

### Plan: Reset button state bug
**Date:** 2026-05-21  
**What:** Plan to ensure the "Send reset" button in the forgot-password sheet reliably enables when the email field changes (P1 bug: button state tied to build-time value).

**Goal:** Make the sheet react to text edits so the Send button enables/disables as the user types; add tests and ensure no controller leaks. Do NOT create branches or PRs without user confirmation.

**Approach:**
- Reproduce and confirm current behavior in tests (widget test reproducing empty field -> type -> Send remains disabled unless enter is pressed).
- Implement small UI change inside the modal sheet: attach a listener to the email TextEditingController and call setState (or use ValueListenableBuilder) so the button's enabled state updates on text change. Ensure listener is removed when sheet dismisses.
- Guard finalization callback to avoid calling the sheet's setState after the sheet is dismissed: either (a) check a mounted/active flag before invoking the StatefulBuilder's setState in the finally block, or (b) prevent dismissal while submitting (disable barrierDismissible and Navigator.pop until operation completes). Prefer (a) for minimal UX impact; (b) is optional for a strict atomic UX.
- Add Keys to email field and Send button for deterministic tests (if not present).
- Add/adjust widget tests to verify enabling behavior and that sendPasswordResetEmail is invoked when tapping Send.
- Run flutter analyze and flutter test.

**Target files:**
- lib/screens/login_screen.dart (implement listener + cleanup + mounted guard or submit-lock + keys)
- test/login_forgot_password_test.dart (add/adjust tests)

## Governance

- All meaningful changes require team consensus
- Document architectural decisions here
- Keep history focused on work, decisions focused on direction
