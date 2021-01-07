import 'package:flutter/material.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/services/firebase_messaging_service.dart';

class Opinion extends StatelessWidget {
  static const id = 'opinion';

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    FirebaseMessagingService().configure(context);
    PreferenceProvider.of(context).activeSink(Opinion.id);

    return CustomAuthBuilder(
        child: Scaffold(
      key: _drawerKey,
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: GestureDetector(
              child: Text('Feedback'),
              onTap: () async {},
            ),
          ),
        ),
      ),
    ));
  }
}
