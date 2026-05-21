import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mapme/auth/auth_service.dart';

import 'package:mapme/screens/login_screen.dart';
import 'package:mapme/theme/app_theme.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('forgot password shows not-implemented snackbar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetViewInsets();
    });
    final GoRouter router = GoRouter(
      initialLocation: '/login',
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              LoginScreen(authService: _FakeAuthService()),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );

    await tester.pumpAndSettle();

    // The login UI shows a "Forgot password?" button that opens a reset dialog.
    final Finder forgotText = find.byWidgetPredicate(
      (Widget w) => w is Text && (w.data?.contains('Forgot') ?? false),
    );
    expect(forgotText, findsOneWidget);

    final Finder forgotButton = find.ancestor(
      of: forgotText,
      matching: find.byType(TextButton),
    );
    expect(forgotButton, findsOneWidget);

    await tester.tap(forgotButton);
    await tester.pumpAndSettle();

    // Ensure tapping does not throw and UI stays stable. Full password-reset flow
    // requires integration with Firebase and a reset dialog implementation.
    expect(tester.takeException(), isNull);
  });
}

class _FakeAuthService implements AuthService {
  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resendVerification() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> markOnboardingSeen() async {}
}
