import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/views/admin/dashboard.dart';
import '../custom_offstage_progress_indicator.dart';

class CustomGuestBuilder extends StatelessWidget {
  final Widget child;
  CustomGuestBuilder({@required this.child});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return child;
          } else {
            return Dashboard();
          }
        } else {
          return Scaffold(
            body: CustomOffstageProgressIndicator(status: false),
          );
        }
      },
    );
  }
}
