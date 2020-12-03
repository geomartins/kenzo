import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String email;
  final String uid;

  UserModel.fromFirebase(User user)
      : email = user.email,
        uid = user.uid;
}
