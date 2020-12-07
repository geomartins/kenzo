import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:staff_portal/components/builders/custom_guest_builder.dart';
import 'package:staff_portal/views/welcome.dart';

class Splash extends StatefulWidget {
  static const id = 'splash';
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return CustomGuestBuilder(
      child: new SplashScreen(
        seconds: 1,
        navigateAfterSeconds: Welcome(),
        imageBackground: AssetImage('assets/images/auth_bg.png'),
        backgroundColor: Colors.white,
        loaderColor: Colors.white,
      ),
    );
  }
}
