import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  String? get userId => _user?.uid;
  String? get email => _user?.email;
  bool get isVerified => _user?.emailVerified ?? false;
  bool get isLoggedIn => _user != null;

  Future<String?> signup(String email, String password, String name) async {
    try {
      debugPrint('Creating user in Firebase Auth...');
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      debugPrint('User created: ${cred.user?.uid}');
      
      debugPrint('Sending verification email...');
      await cred.user?.sendEmailVerification();
      
      debugPrint('Creating user document in Firestore...');
      await _db.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('User signup complete!');
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      return e.message ?? e.code;
    } catch (e) {
      debugPrint('Signup Error: $e');
      return 'An error occurred: $e';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await cred.user?.reload();
      _user = _auth.currentUser;
      
      // Allow login but verification check happens in MainNavigation
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.code;
    } catch (e) {
      return 'An error occurred';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> sendVerificationEmail() async {
    await _user?.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    await _user?.reload();
    _user = _auth.currentUser;
    notifyListeners();
  }
}
