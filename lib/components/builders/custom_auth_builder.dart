import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/views/login.dart';

class CustomAuthBuilder extends StatelessWidget {
  final Widget child;
  CustomAuthBuilder({@required this.child});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return Login();
          } else {
            return child;
          }
        } else {
          return Scaffold(
            body: CustomOffstageProgressIndicator(status: false),
          );
        }
      },
    );
//    print('Auth Builder');
//    if (FirebaseAuth.instance.currentUser != null) {
//      return child;
//    } else {
//      return Login();
//    }
  }
}

//return StreamBuilder(
//stream: FirebaseAuth.instance.authStateChanges(),
//builder: (BuildContext context, snapshot) {
//if (snapshot.data == null) {
//return Login();
//} else {
//return child;
//}
//},
//);
