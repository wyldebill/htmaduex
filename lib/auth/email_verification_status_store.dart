import 'package:cloud_firestore/cloud_firestore.dart';

abstract class EmailVerificationStatusStore {
  Future<void> markPendingVerification({
    required String uid,
    required String email,
  });

  Future<void> markVerified({required String uid});

  Future<void> markOnboardingSeen({required String uid});

  Future<bool> hasSeenOnboarding({required String uid});
}

class FirestoreEmailVerificationStatusStore
    implements EmailVerificationStatusStore {
  FirestoreEmailVerificationStatusStore({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userStateDoc(String uid) =>
      _firestore.collection('user_state').doc(uid);

  @override
  Future<void> markPendingVerification({
    required String uid,
    required String email,
  }) async {
    await _userStateDoc(uid).set(<String, dynamic>{
      'email': email,
      'emailVerificationPending': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> markVerified({required String uid}) async {
    await _userStateDoc(uid).set(<String, dynamic>{
      'emailVerificationPending': false,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> markOnboardingSeen({required String uid}) async {
    await _userStateDoc(uid).set(<String, dynamic>{
      'hasSeenOnboarding': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<bool> hasSeenOnboarding({required String uid}) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _userStateDoc(
      uid,
    ).get();
    final Object? value = snapshot.data()?['hasSeenOnboarding'];
    return value == true;
  }
}
