import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===========================
  // Sign Up
  // ===========================

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user!.updateDisplayName(name);

      await _firestore.collection("users").doc(credential.user!.uid).set({
        "uid": credential.user!.uid,
        "name": name,
        "email": email,
        "photoUrl": "",
        "createdAt": FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // ===========================
  // Login
  // ===========================
    
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // ===========================
  // Logout
  // ===========================

  Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}

  // ===========================
  // Reset Password
  // ===========================

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

 Future<String?> signInWithGoogle() async {
  try {
    UserCredential userCredential;

    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Android implementation baad me add karenge
      return "Google Sign-In for Android will be configured after Android SDK setup.";
    }

    final user = userCredential.user!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({
      "uid": user.uid,
      "name": user.displayName ?? "",
      "email": user.email,
      "photoUrl": user.photoURL ?? "",
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return null;
  } catch (e) {
    return e.toString();
  }
}
}