import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mapme/auth/auth_service.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('FirebaseAuthService', () {
    late _MockFirebaseAuth auth;
    late FirebaseAuthService service;

    setUp(() {
      auth = _MockFirebaseAuth();
      service = FirebaseAuthService(auth: auth);
    });

    test('signIn trims email and delegates to FirebaseAuth', () async {
      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => _MockUserCredential());

      await service.signIn(email: ' test@example.com ', password: 'secret123');

      verify(
        () => auth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'secret123',
        ),
      ).called(1);
    });

    test('signUp trims email and delegates to FirebaseAuth', () async {
      when(
        () => auth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => _MockUserCredential());

      await service.signUp(email: ' new@example.com ', password: 'secret123');

      verify(
        () => auth.createUserWithEmailAndPassword(
          email: 'new@example.com',
          password: 'secret123',
        ),
      ).called(1);
    });
  });
}
