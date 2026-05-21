import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mapme/auth/auth_service.dart';
import 'package:mapme/screens/wizard_screen.dart';
import 'package:mapme/theme/app_theme.dart';

class _FakeAuthService implements AuthService {
  bool markedOnboardingSeen = false;

  @override
  Future<bool> hasSeenOnboarding() async => markedOnboardingSeen;

  @override
  Future<void> markOnboardingSeen() async {
    markedOnboardingSeen = true;
  }

  @override
  Future<void> resendVerification() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {}
}

void main() {
  testWidgets('skip marks onboarding as seen and navigates to map', (
    WidgetTester tester,
  ) async {
    final _FakeAuthService authService = _FakeAuthService();
    final GoRouter router = GoRouter(
      initialLocation: '/onboarding',
      routes: <RouteBase>[
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) =>
              WizardScreen(authService: authService),
        ),
        GoRoute(
          path: '/map',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Center(child: Text('Map Page'))),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(authService.markedOnboardingSeen, isTrue);
    expect(find.text('Map Page'), findsOneWidget);
  });
}
