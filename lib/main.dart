import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/views/login.dart';
import 'package:staff_portal/views/password_reset.dart';
import 'package:staff_portal/views/register.dart';
import 'package:staff_portal/views/splash.dart';
import 'package:staff_portal/views/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (BuildContext ctx) => Splash(),
        Welcome.id: (BuildContext ctx) => Welcome(),
        Login.id: (BuildContext ctx) => Login(),
        Register.id: (BuildContext ctx) => Register(),
        PasswordReset.id: (BuildContext ctx) => PasswordReset(),
      },
    );
  }
}
