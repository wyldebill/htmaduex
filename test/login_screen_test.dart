import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mapme/auth/auth_service.dart';
import 'package:mapme/screens/login_screen.dart';
import 'package:mapme/theme/app_theme.dart';

class _FakeAuthService implements AuthService {
  _FakeAuthService({this.fail = false});

  final bool fail;

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (fail) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Bad credentials',
      );
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    if (fail) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Bad credentials',
      );
    }
  }
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('successful sign in navigates to onboarding', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final GoRouter router = GoRouter(
      initialLocation: '/login',
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              LoginScreen(authService: _FakeAuthService()),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Center(child: Text('Onboarding page'))),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Onboarding page'), findsOneWidget);
  });

  testWidgets('failed sign in shows auth error message', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final GoRouter router = GoRouter(
      initialLocation: '/login',
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              LoginScreen(authService: _FakeAuthService(fail: true)),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Center(child: Text('Onboarding page'))),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrong-password');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pump();

    expect(find.text('Bad credentials'), findsOneWidget);
  });
}
