import 'package:flutter/material.dart';
import 'package:staff_portal/views/splash.dart';
import 'admin/dashboard.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';

class Home extends StatefulWidget {
  static const id = 'home';
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseUserReloader.onAuthStateChangedOrReloaded,
      builder: (BuildContext ctx, snapshot) {
        print('Reloaded or auth state changed: ${snapshot.data}');
        if (snapshot.data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, Dashboard.id);
          });
          return Dashboard();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, Splash.id);
          });
          return Splash();
        }
      },
    );
  }
}
