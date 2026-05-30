import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:htmarevived/auth/auth_service.dart';
import 'package:htmarevived/screens/list_screen.dart';
import 'package:htmarevived/screens/profile_screen.dart';
import 'package:htmarevived/theme/app_theme.dart';

class _FakeAuthService implements AuthService {
  bool didSignOut = false;

  @override
  Future<void> resendVerification() async {}

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {
    didSignOut = true;
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {}

  @override
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> markOnboardingSeen() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}
}

void main() {
  testWidgets('logout button signs out and routes to login', (
    WidgetTester tester,
  ) async {
    final _FakeAuthService authService = _FakeAuthService();
    final GoRouter router = GoRouter(
      initialLocation: '/profile',
      routes: <RouteBase>[
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) =>
              ProfileScreen(authService: authService),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Center(child: Text('Login Page'))),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(authService.didSignOut, isTrue);
    expect(find.text('Login Page'), findsOneWidget);
  });

  testWidgets('list tab profile button navigates to profile page', (
    WidgetTester tester,
  ) async {
    final _FakeAuthService authService = _FakeAuthService();
    final GoRouter router = GoRouter(
      initialLocation: '/list',
      routes: <RouteBase>[
        GoRoute(
          path: '/list',
          builder: (BuildContext context, GoRouterState state) =>
              const ListScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) =>
              ProfileScreen(authService: authService),
        ),
        GoRoute(
          path: '/map',
          builder: (BuildContext context, GoRouterState state) =>
              const SizedBox.shrink(),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Log out'), findsOneWidget);
  });
}
