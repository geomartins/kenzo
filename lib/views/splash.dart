import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:staff_portal/views/welcome.dart';

class Splash extends StatefulWidget {
  static const id = 'splash';
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 7,
      navigateAfterSeconds: Welcome(),
      title: new Text(
        'Welcome to Staff Portal',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.network(
          'https://flutter.io/images/catalog-widget-placeholder.png'),
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}
