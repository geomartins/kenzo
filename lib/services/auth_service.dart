import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/models/user_model.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
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

  //Stream get onCheck =>  auth.userChanges();

  Future<void> logout() async {
    await auth.signOut();
  }
}
