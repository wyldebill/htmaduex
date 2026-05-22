// ignore_for_file: prefer_initializing_formals

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mapme/auth/auth_service.dart';
import 'package:mapme/auth/email_verification_status_store.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUserCredential extends Mock implements UserCredential {}

class _MockUser extends Mock implements User {}
class _MockEmailVerificationStatusStore extends Mock
    implements EmailVerificationStatusStore {}

class _MockEmailVerificationStatusStore extends Mock
    implements EmailVerificationStatusStore {}

class _MockEmailVerificationStatusStore extends Mock
    implements EmailVerificationStatusStore {}

class _FakeUserMetadata implements UserMetadata {
  @override
  final DateTime? creationTime;
  @override
  final DateTime? lastSignInTime;

  _FakeUserMetadata({DateTime? creationTime})
    : creationTime = creationTime,
      lastSignInTime = null;
}

void main() {
  group('FirebaseAuthService', () {
    late _MockFirebaseAuth auth;
    late _MockEmailVerificationStatusStore verificationStatusStore;
    late FirebaseAuthService service;

    setUp(() {
      auth = _MockFirebaseAuth();
      verificationStatusStore = _MockEmailVerificationStatusStore();
      service = FirebaseAuthService(
        auth: auth,
        verificationStatusStore: verificationStatusStore,
      );
      registerFallbackValue(Uri());
    });

    test('signUp sends verification and keeps current user for verification flow', () async {
      final _MockUserCredential cred = _MockUserCredential();
      final _MockUser user = _MockUser();

        when(
          () => auth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => cred);
      when(() => cred.user).thenReturn(user);
      when(() => user.uid).thenReturn('user-1');
      when(() => user.sendEmailVerification()).thenAnswer((_) async {});
      when(() => auth.signOut()).thenAnswer((_) async {});
      when(
        () => verificationStatusStore.markPendingVerification(
          uid: any(named: 'uid'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async {});

        await service.signUp(email: ' new@example.com ', password: 'secret123');

        verify(
          () => auth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'secret123',
          )).called(1);
      verify(() => user.sendEmailVerification()).called(1);
      verify(
        () => verificationStatusStore.markPendingVerification(
          uid: 'user-1',
          email: 'new@example.com',
        ),
      ).called(1);
      verifyNever(() => auth.signOut());
    });

    test('signIn throws when not verified', () async {
      final _MockUserCredential cred = _MockUserCredential();
      final _MockUser user = _MockUser();

      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => cred);
      when(() => cred.user).thenReturn(user);
      when(() => user.reload()).thenAnswer((_) async {});
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.uid).thenReturn('user-2');
      when(() => user.email).thenReturn('a@b.c');
      // Provide metadata object without creationTime so treated as not expired (creationTime null)
      when(
        () => user.metadata,
      ).thenReturn(_FakeUserMetadata(creationTime: null));
      when(() => auth.signOut()).thenAnswer((_) async {});
      when(
        () => verificationStatusStore.markPendingVerification(
          uid: any(named: 'uid'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async {});

      // Simulate not verified
      when(() => user.emailVerified).thenReturn(false);

      await expectLater(
        service.signIn(email: 'a@b.c', password: 'pw'),
        throwsA(isA<FirebaseAuthException>().having((e) => e.code, 'code', 'email-not-verified')),
      );

      verify(() => auth.signOut()).called(1);
    });

    test('signIn clears pending verification status when user is verified', () async {
      final _MockUserCredential cred = _MockUserCredential();
      final _MockUser user = _MockUser();

      when(() => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => cred);
      when(() => cred.user).thenReturn(user);
      when(() => user.reload()).thenAnswer((_) async {});
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.uid).thenReturn('user-3');
      when(() => user.emailVerified).thenReturn(true);
      when(
        () => verificationStatusStore.markVerified(uid: any(named: 'uid')),
      ).thenAnswer((_) async {});

      await service.signIn(email: 'verified@example.com', password: 'pw');

      verify(() => verificationStatusStore.markVerified(uid: 'user-3')).called(1);
      verifyNever(() => auth.signOut());
    });
  });
}
