import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/views/login.dart';
import 'package:staff_portal/views/page_not_found.dart';
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
        primarySwatch: kPrimaryColor,
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (BuildContext ctx) => Splash(),
        Welcome.id: (BuildContext ctx) => Welcome(),
        Login.id: (BuildContext ctx) => Login(),
        Register.id: (BuildContext ctx) => Register(),
        PasswordReset.id: (BuildContext ctx) => PasswordReset(),
        PageNotFound.id: (BuildContext ctx) => PageNotFound(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => PageNotFound());
      },
    );
  }
}

//TODO('Work on Dashboard')
//TODO('Add Firestore to this project')
//TODO('Add Bloc to this project')
//TODO('Get auth_bg image from the femi/ezenma')
