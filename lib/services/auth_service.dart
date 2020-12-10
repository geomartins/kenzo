import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<UserModel> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = authResult.user;
      print('Result is $user');
      return UserModel.fromFirebase(user);
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Stream<UserModel> get onAuthStateChanged => auth
      .userChanges()
      .map((firebaseUser) => UserModel.fromFirebase(firebaseUser));

  Future<void> passwordReset(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  String getPhotoUrl() {
    return auth.currentUser.photoURL;
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> createAccount(
      {String email,
      String password,
      String firstname,
      String middlename,
      String lastname}) async {
    try {
      UserCredential credentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel.fromFirebase(credentials.user);

      await firestore.collection('users').doc(user.uid).set({
        'firstname': firstname,
        'middlename': middlename,
        'lastname': lastname,
        'email': user.email,
        'uid': user.uid,
        'dept': 'unknown',
        'role': 'unknown',
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }
}
