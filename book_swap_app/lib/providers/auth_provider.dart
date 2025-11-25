import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  firebase_auth.User? get user => _auth.currentUser;
  String? get userId => user?.uid;
  String? get email => user?.email;
  bool get isLoggedIn => user != null;
  bool get isVerified => user?.emailVerified ?? false;

  AuthProvider() {
    _auth.authStateChanges().listen((firebase_auth.User? user) {
      notifyListeners();
    });
  }

  // Login with Firebase AND Supabase
  Future<String?> login(String email, String password) async {
    try {
      print('🔐 Starting login process...');

      // 1. Login to Firebase
      print('📧 Logging into Firebase...');
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Firebase login successful');

      // 2. Login to Supabase
      print('📧 Logging into Supabase...');
      try {
        final response = await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user != null) {
          print('✅ Supabase login successful');
          print('👤 Supabase User ID: ${response.user!.id}');
          print('📧 Supabase Email: ${response.user!.email}');
        }
      } on AuthException catch (supabaseError) {
        print('❌ Supabase login failed: ${supabaseError.message}');

        // If "Invalid login credentials", try to create account
        if (supabaseError.message.contains('Invalid login credentials') || 
            supabaseError.message.contains('invalid_credentials')) {
          print('🔄 User not found in Supabase. Creating account...');
          
          try {
            final signUpResponse = await _supabase.auth.signUp(
              email: email,
              password: password,
            );

            if (signUpResponse.user != null) {
              print('✅ Supabase account created and logged in');
              print('👤 Supabase User ID: ${signUpResponse.user!.id}');
            }
          } on AuthException catch (signUpError) {
            // If account already exists, try to sign in one more time
            if (signUpError.message.contains('already registered')) {
              print('⚠️ Account exists but password mismatch. Trying reset...');
              // For now, just log the error - user needs to reset password
              print('❌ Please use password reset if you can\'t login to Supabase');
            } else {
              print('❌ Supabase signup failed: ${signUpError.message}');
            }
          }
        }
      }

      // 3. Verify Supabase session after login/signup
      final currentSession = _supabase.auth.currentSession;
      print('🔍 Final Supabase session check: ${currentSession != null ? "Active" : "None"}');
      if (currentSession != null) {
        print('✅ Supabase user: ${currentSession.user.email}');
      } else {
        print('⚠️ WARNING: No active Supabase session!');
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase error: ${e.code} - ${e.message}');

      if (e.code == 'user-not-found') {
        return 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      } else {
        return 'Login failed: ${e.message}';
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
      return 'An unexpected error occurred.';
    }
  }

  // Signup with Firebase AND Supabase
  Future<String?> signup(String email, String password) async {
    try {
      print('🔐 Starting signup process...');

      // 1. Create Firebase account
      print('📧 Creating Firebase account...');
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Firebase account created');

      // 2. Create Supabase account
      print('📧 Creating Supabase account...');
      try {
        final response = await _supabase.auth.signUp(
          email: email,
          password: password,
        );

        if (response.user != null) {
          print('✅ Supabase account created');
          print('👤 Supabase User ID: ${response.user!.id}');
        } else {
          print('⚠️ Supabase signup returned no user');
        }
      } catch (supabaseError) {
        print('❌ Supabase signup failed: $supabaseError');
      }

      // Send verification email
      await _auth.currentUser?.sendEmailVerification();
      print('✅ Verification email sent');

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase signup error: ${e.code} - ${e.message}');

      if (e.code == 'weak-password') {
        return 'Password is too weak. Use at least 6 characters.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists with this email.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      } else {
        return 'Signup failed: ${e.message}';
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
      return 'An unexpected error occurred.';
    }
  }

  // Logout
  Future<void> logout() async {
    print('🚪 Logging out...');
    await _auth.signOut();
    await _supabase.auth.signOut();
    print('✅ Logged out successfully');
    notifyListeners();
  }

  Future<void> sendVerificationEmail() async {
    await user?.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    await user?.reload();
    notifyListeners();
  }
}
