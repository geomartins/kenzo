import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/models/profile_model.dart';
import 'package:staff_portal/views/admin/dashboard.dart';
import '../custom_offstage_progress_indicator.dart';

class CustomApprovedUserBuilder extends StatelessWidget with GetSnackbar {
  final Widget child;
  CustomApprovedUserBuilder({@required this.child});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: CustomOffstageProgressIndicator(status: false));
          }
          ProfileModel profileModel =
              ProfileModel.fromFirestore(snapshot.data.data());
          print(
              '${profileModel.department} --------------------------------------');
          if (profileModel.approved == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              buildCustomSnackbar(
                  messageText: 'Your account is yet to be activated',
                  titleText: "Oops",
                  iconColor: Colors.red,
                  icon: Icons.error);
            });
            return Dashboard();
          }
          return child;
        });
  }
}
