// lib/data/firebase_auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    await user.updateDisplayName(displayName);
    await user.sendEmailVerification();
    // create a simple user document
    await _fs.collection('users').doc(user.uid).set({
      'email': email,
      'displayName': displayName,
      'photoUrl': null,
      'notificationPrefs': {'push': true, 'email': true},
      'createdAt': FieldValue.serverTimestamp(),
    });
    return user;
  }

  Future<User?> signIn({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    // enforce email verification
    await user.reload();
    if (!user.emailVerified) {
      await signOut();
      throw FirebaseAuthException(code: 'email-not-verified', message: 'Please verify your email before signing in.');
    }
    return user;
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() => _auth.signOut();

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
