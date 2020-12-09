import 'package:firebase_auth/firebase_auth.dart';

class ProfileModel {
  final String email;
  final String role;
  final String department;

  ProfileModel.fromFirestore(Map<String, dynamic> user)
      : email = user['email'],
        role = user['role'],
        department = user['department'];
}
