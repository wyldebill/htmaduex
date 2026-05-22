import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mapme/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mapme/screens/login_screen.dart';
import 'package:mapme/theme/app_theme.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpLogin(WidgetTester tester, AuthService authService) async {
    final GoRouter router = GoRouter(
      initialLocation: '/login',
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              LoginScreen(authService: authService),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(theme: appTheme, routerConfig: router));
    await tester.pumpAndSettle();
  }

  testWidgets('tapping Forgot? opens bottom sheet', (WidgetTester tester) async {
    final _TestAuthService auth = _TestAuthService();
    await pumpLogin(tester, auth);

    final Finder forgot = find.text('Forgot?');
    expect(forgot, findsOneWidget);

    await tester.tap(forgot);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('forgot-email-field')), findsOneWidget);
  });

  testWidgets('prefills email when username has text', (WidgetTester tester) async {
    final _TestAuthService auth = _TestAuthService();
    await pumpLogin(tester, auth);

    final Finder usernameField = find.byHintText('you@example.com');
    expect(usernameField, findsOneWidget);

    await tester.enterText(usernameField, 'prefill@example.com');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot?'));
    await tester.pumpAndSettle();

    final Finder sheetField = find.byKey(const ValueKey('forgot-email-field'));
    expect(sheetField, findsOneWidget);
    final TextField tf = tester.widget<TextField>(sheetField);
    expect(tf.controller?.text, 'prefill@example.com');
  });

  testWidgets('entering email and tapping Send reset calls auth service', (
    WidgetTester tester,
  ) async {
    final _TestAuthService auth = _TestAuthService();
    await pumpLogin(tester, auth);

    await tester.tap(find.text('Forgot?'));
    await tester.pumpAndSettle();

    final Finder sheetField = find.byKey(const ValueKey('forgot-email-field'));
    await tester.enterText(sheetField, '  user@example.com  ');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('forgot-send-button')));
    await tester.pumpAndSettle();

    expect(auth.lastEmail, 'user@example.com');
  });

  testWidgets('on success sheet closes and snackbar is shown', (
    WidgetTester tester,
  ) async {
    final _TestAuthService auth = _TestAuthService();
    await pumpLogin(tester, auth);

    await tester.tap(find.text('Forgot?'));
    await tester.pumpAndSettle();

    final Finder sheetField = find.byKey(const ValueKey('forgot-email-field'));
    await tester.enterText(sheetField, 'user2@example.com');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('forgot-send-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('forgot-email-field')), findsNothing);
    expect(find.text('Password reset email sent.'), findsOneWidget);
  });

  testWidgets('on failure snackbar shown and sheet remains', (
    WidgetTester tester,
  ) async {
    final _TestAuthService auth = _TestAuthService(shouldThrow: true);
    await pumpLogin(tester, auth);

    await tester.tap(find.text('Forgot?'));
    await tester.pumpAndSettle();

    final Finder sheetField = find.byKey(const ValueKey('forgot-email-field'));
    await tester.enterText(sheetField, 'bad@example.com');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('forgot-send-button')));
    await tester.pumpAndSettle();

    // sheet should remain
    expect(find.byKey(const ValueKey('forgot-email-field')), findsOneWidget);
    // snackbar shows friendly message from exception
    expect(find.text('No such user'), findsOneWidget);
  });
}

class _TestAuthService implements AuthService {
  String? lastEmail;
  final bool shouldThrow;

  _TestAuthService({this.shouldThrow = false});

  @override
  Future<void> signIn({required String email, required String password}) async {}

  @override
  Future<void> signUp({required String email, required String password}) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resendVerification() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    lastEmail = email.trim();
    if (shouldThrow) {
      throw FirebaseAuthException(code: 'user-not-found', message: 'No such user');
    }
    return;
  }

  @override
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> markOnboardingSeen() async {}
}
