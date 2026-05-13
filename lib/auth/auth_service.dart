import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> signOut();

  Future<void> resendVerification();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  static const Duration _verificationWindow = Duration(days: 7);

  @override
  Future<void> signIn({required String email, required String password}) async {
    final UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final User? user = cred.user ?? _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'no-user', message: 'No user returned from Firebase.');
    }

    // Ensure we have latest state
    await user.reload();
    final User? refreshed = _auth.currentUser;
    if (refreshed == null) {
      throw FirebaseAuthException(code: 'no-user', message: 'No user after reload.');
    }

    if (!refreshed.emailVerified) {
      final DateTime? created = refreshed.metadata.creationTime;
      if (created != null && DateTime.now().difference(created) > _verificationWindow) {
        // Sign out the unverified expired account and instruct recreation
        await signOut();
        throw FirebaseAuthException(
            code: 'email-not-verified-expired',
            message:
                'Email not verified and verification window has expired. Please create a new account.');
      }

      // Signed in but not verified yet
      await signOut();
      throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Your email address has not been verified. Please verify before signing in.');
    }

    // Email verified — proceed
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    final UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final User? user = cred.user ?? _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'no-user', message: 'Failed to create user.');
    }

    try {
      await user.sendEmailVerification();
    } catch (e) {
      // If sending verification fails, sign the user out and forward the error
      await signOut();
      throw FirebaseAuthException(code: 'verification-send-failed', message: e.toString());
    }

    // Do not keep user signed in until they verify
    await signOut();
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> resendVerification() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'no-user', message: 'No user signed in to resend verification.');
    }

    await user.sendEmailVerification();
  }
}
