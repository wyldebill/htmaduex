import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'email_verification_status_store.dart';
import 'session_service.dart';

abstract class OnboardingStatusStore {
  Future<void> markOnboardingSeen({required String uid});

  Future<bool> hasSeenOnboarding({required String uid});
}

class FirestoreOnboardingStatusStore implements OnboardingStatusStore {
  FirestoreOnboardingStatusStore({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userStateDoc(String uid) =>
      _firestore.collection('user_state').doc(uid);

  @override
  Future<void> markOnboardingSeen({required String uid}) async {
    await _userStateDoc(uid).set(
      <String, dynamic>{
        'onboardingSeen': true,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<bool> hasSeenOnboarding({required String uid}) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _userStateDoc(uid).get();
    final Map<String, dynamic>? data = snapshot.data();
    return data?['onboardingSeen'] == true;
  }
}

abstract class AuthService {
  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> signOut();

  Future<void> resendVerification();

  Future<void> markOnboardingSeen();

  Future<bool> hasSeenOnboarding();

  /// Sends a password reset email to the given address using Firebase Auth.
  Future<void> sendPasswordResetEmail(String email);
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({
    FirebaseAuth? auth,
    OnboardingStatusStore? onboardingStatusStore,
    EmailVerificationStatusStore? verificationStatusStore,
    SessionService? sessionService,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _onboardingStatusStore =
          onboardingStatusStore ?? FirestoreOnboardingStatusStore(),
       _verificationStatusStore =
           verificationStatusStore ?? FirestoreEmailVerificationStatusStore(),
       _sessionService = sessionService ?? SessionService();

  final FirebaseAuth _auth;
  final OnboardingStatusStore _onboardingStatusStore;
  final EmailVerificationStatusStore _verificationStatusStore;
  final SessionService _sessionService;

  static const Duration _verificationWindow = Duration(days: 7);

  @override
  Future<void> signIn({required String email, required String password}) async {
    final UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final User? user = cred.user ?? _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user returned from Firebase.',
      );
    }

    // Ensure we have latest state
    await user.reload();
    final User? refreshed = _auth.currentUser;
    if (refreshed == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user after reload.',
      );
    }

    if (!refreshed.emailVerified) {
      await _markPendingVerification(refreshed, fallbackEmail: email.trim());
      final DateTime? created = refreshed.metadata.creationTime;
      if (created != null &&
          DateTime.now().difference(created) > _verificationWindow) {
        // Sign out the unverified expired account and instruct recreation
        await signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified-expired',
          message:
              'Email not verified and verification window has expired. Please create a new account.',
        );
      }

      // Signed in but not verified yet
      await signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message:
            'Your email address has not been verified. Please verify before signing in.',
      );
    }

    await _markVerified(refreshed);
    await _sessionService.saveLoginTime();
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    final UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final User? user = cred.user ?? _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'Failed to create user.',
      );
    }

    try {
      await user.sendEmailVerification();
    } catch (e) {
      // If sending verification fails, sign the user out and forward the error
      await signOut();
      throw FirebaseAuthException(
        code: 'verification-send-failed',
        message: e.toString(),
      );
    }

    await _markPendingVerification(user, fallbackEmail: email.trim());
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _sessionService.clearSession();
  }

  @override
  Future<void> resendVerification() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No active verification session. Please sign up again.',
      );
    }

    await user.sendEmailVerification();
  }

  @override
  Future<void> markOnboardingSeen() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No active user session.',
      );
    }

    try {
      await _onboardingStatusStore.markOnboardingSeen(uid: user.uid);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(
        code: 'onboarding-status-sync-failed',
        message:
            'Unable to save onboarding status right now. ${e.message ?? ''}'
                .trim(),
      );
    }
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return false;
    }

    try {
      return await _onboardingStatusStore.hasSeenOnboarding(uid: user.uid);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(
        code: 'onboarding-status-sync-failed',
        message:
            'Unable to read onboarding status right now. ${e.message ?? ''}'
                .trim(),
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> _markPendingVerification(
    User user, {
    required String fallbackEmail,
  }) async {
    try {
      await _verificationStatusStore.markPendingVerification(
        uid: user.uid,
        email: user.email ?? fallbackEmail,
      );
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(
        code: 'verification-status-sync-failed',
        message:
            'Unable to save verification status right now. ${e.message ?? ''}'
                .trim(),
      );
    }
  }

  Future<void> _markVerified(User user) async {
    try {
      await _verificationStatusStore.markVerified(uid: user.uid);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(
        code: 'verification-status-sync-failed',
        message:
            'Unable to update verification status right now. ${e.message ?? ''}'
                .trim(),
      );
    }
  }
}
