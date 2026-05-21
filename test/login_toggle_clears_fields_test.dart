import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mapme/auth/auth_service.dart';
import 'package:mapme/screens/login_screen.dart';
import 'package:mapme/theme/app_theme.dart';

class _FakeAuthService implements AuthService {
  @override
  Future<void> signIn({required String email, required String password}) async {}

  @override
  Future<void> signUp({required String email, required String password}) async {}

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

void main() {
  testWidgets('toggling between sign in and sign up clears fields and unfocuses', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetViewInsets();
    });

    await tester.pumpWidget(MaterialApp(theme: appTheme, home: LoginScreen(authService: _FakeAuthService())));

    // Enter text into username and password fields
    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret123');
    await tester.pumpAndSettle();

    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('secret123'), findsOneWidget);

    // Tap the toggle to switch to Sign up
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Fields should be cleared
    expect(find.text('user@example.com'), findsNothing);
    expect(find.text('secret123'), findsNothing);

    // No field should have focus
    final EditableTextState editable = tester.state<EditableTextState>(find.byType(EditableText).first);
    expect(editable.widget.focusNode.hasFocus, isFalse);
  });
}
