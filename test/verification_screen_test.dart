import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mapme/auth/auth_service.dart';
import 'package:mapme/screens/verification_screen.dart';
import 'package:mapme/theme/app_theme.dart';

class _NoUserAuthService implements AuthService {
  @override
  Future<void> resendVerification() async {
    throw FirebaseAuthException(
      code: 'no-user',
      message: 'No user signed in to resend verification.',
    );
  }

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

  @override
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> markOnboardingSeen() async {}
}

class _TooManyRequestsResendAuthService implements AuthService {
  @override
  Future<void> resendVerification() async {
    throw FirebaseAuthException(
      code: 'too-many-requests',
      message: 'Too many requests.',
    );
  }

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

  @override
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> markOnboardingSeen() async {}
}

void main() {
  testWidgets(
    'resend shows friendly message when no verification session exists',
    (WidgetTester tester) async {
      final GoRouter router = GoRouter(
        initialLocation: '/verify',
        routes: <RouteBase>[
          GoRoute(
            path: '/verify',
            builder: (BuildContext context, GoRouterState state) =>
                VerificationScreen(authService: _NoUserAuthService()),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: appTheme, routerConfig: router),
      );

      await tester.tap(find.text('Resend verification email'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Your verification session expired. Please go back and sign up again to get a new verification email.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'resend shows cooldown message when Firebase rate limits requests',
    (WidgetTester tester) async {
      final GoRouter router = GoRouter(
        initialLocation: '/verify',
        routes: <RouteBase>[
          GoRoute(
            path: '/verify',
            builder: (BuildContext context, GoRouterState state) =>
                VerificationScreen(
                  authService: _TooManyRequestsResendAuthService(),
                ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: appTheme, routerConfig: router),
      );

      await tester.tap(find.text('Resend verification email'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Too many resend attempts. Please wait a bit before trying again.',
        ),
        findsOneWidget,
      );
    },
  );
}
