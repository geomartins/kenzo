import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
      String lastname,
      String department}) async {
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
        'dept': department,
        'role': 'unknown',
        'approved': false,
        'created_at': FieldValue.serverTimestamp(),
      });
      await auth.currentUser
          .updateProfile(displayName: firstname + ' ' + middlename);
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  String getDisplayName({String type}) {
    String displayName = auth.currentUser.displayName;

    if (displayName == null) {
      return null;
    }
    if (type == 'ucwords') {
      String firstname = toBeginningOfSentenceCase(displayName.split(' ')[0]);
      String lastname = toBeginningOfSentenceCase(displayName.split(' ')[1]);
      return firstname + ' ' + lastname;
    }
    if (type == 'first') {
      return toBeginningOfSentenceCase(displayName.split(' ')[0]);
    }
    return displayName;
  }
}
