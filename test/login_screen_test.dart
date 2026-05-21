import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mapme/auth/auth_service.dart';
import 'package:mapme/screens/login_screen.dart';
import 'package:mapme/screens/verification_screen.dart';
import 'package:mapme/theme/app_theme.dart';

class _FakeAuthService implements AuthService {
  _FakeAuthService({
    this.fail = false,
    this.unverified = false,
    bool hasSeenOnboarding = false,
  }) : _hasSeenOnboarding = hasSeenOnboarding;

  final bool fail;
  final bool unverified;
  final bool _hasSeenOnboarding;

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (fail) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Bad credentials',
      );
    }
    if (unverified) {
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify',
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

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resendVerification() async {}

  @override
  Future<bool> hasSeenOnboarding() async => _hasSeenOnboarding;

  @override
  Future<void> markOnboardingSeen() async {}
}

class _DelayedSignUpAuthService implements AuthService {
  final Completer<void> signUpCompleter = Completer<void>();

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signUp({required String email, required String password}) {
    return signUpCompleter.future;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resendVerification() async {}

  @override
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> markOnboardingSeen() async {}
}

class _TooManyRequestsAuthService implements AuthService {
  @override
  Future<void> signIn({required String email, required String password}) async {
    throw FirebaseAuthException(
      code: 'too-many-requests',
      message:
          'We have blocked all requests from this device due to unusual activity. Try again later.',
    );
  }

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
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> markOnboardingSeen() async {}
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('sign in skips onboarding when already seen', (
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
          builder: (BuildContext context, GoRouterState state) => LoginScreen(
            authService: _FakeAuthService(hasSeenOnboarding: true),
          ),
        ),
        GoRoute(
          path: '/map',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Center(child: Text('Map page'))),
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

    expect(find.text('Map page'), findsOneWidget);
  });

  testWidgets('successful sign in navigates to onboarding', (
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
      tester.view.resetViewInsets();
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

  testWidgets('unverified sign in routes to verification screen', (
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
              LoginScreen(authService: _FakeAuthService(unverified: true)),
        ),
        GoRoute(
          path: '/verify',
          builder: (BuildContext context, GoRouterState state) =>
              VerificationScreen(authService: _FakeAuthService()),
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

    expect(find.text('Verify your email'), findsOneWidget);
  });

  testWidgets('focus shift to password avoids overflow on reduced viewport', (
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
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(TextField).at(0));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    tester.view.viewInsets = const FakeViewPadding(bottom: 900);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(TextField).at(1));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping outside text fields removes focus', (
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
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );

    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();

    final EditableTextState editableBefore = tester.state<EditableTextState>(
      find.byType(EditableText).first,
    );
    expect(editableBefore.widget.focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    final EditableTextState editableAfter = tester.state<EditableTextState>(
      find.byType(EditableText).first,
    );
    expect(editableAfter.widget.focusNode.hasFocus, isFalse);
  });

  testWidgets(
    'signup submit shows loading spinner before verification screen',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.view.resetViewInsets();
      });

      final _DelayedSignUpAuthService authService = _DelayedSignUpAuthService();
      final GoRouter router = GoRouter(
        initialLocation: '/login',
        routes: <RouteBase>[
          GoRoute(
            path: '/login',
            builder: (BuildContext context, GoRouterState state) =>
                LoginScreen(authService: authService),
          ),
          GoRoute(
            path: '/verify',
            builder: (BuildContext context, GoRouterState state) =>
                VerificationScreen(authService: authService),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: appTheme, routerConfig: router),
      );

      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'new@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'secret123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create account'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Creating...'), findsOneWidget);

      authService.signUpCompleter.complete();
      await tester.pumpAndSettle();

      expect(find.text('Verify your email'), findsOneWidget);
    },
  );

  testWidgets('too-many-requests sign in shows cooldown message', (
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
              LoginScreen(authService: _TooManyRequestsAuthService()),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pump();

    expect(
      find.text(
        'Too many attempts from this device. Please wait a bit and try again.',
      ),
      findsOneWidget,
    );
  });
}
