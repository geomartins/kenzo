import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/components/builders/custom_guest_builder.dart';
import '../components/forms/custom_login_form.dart';
import 'package:staff_portal/config/constants.dart';

class Login extends StatelessWidget {
  static const id = 'login';
  @override
  Widget build(BuildContext context) {
    return CustomGuestBuilder(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: <Widget>[
                buildDescriptionLayout(context),
                CustomLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDescriptionLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kTertiaryColor,
        image: new DecorationImage(
          image: new AssetImage('assets/images/bg.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 120.0,
          ),
          Text('Welcome',
              style: TextStyle(
                fontSize: 27.0,
                letterSpacing: 2.0,
              )),
          Text('Back',
              style: TextStyle(
                fontSize: 27.0,
                letterSpacing: 2.0,
              )),
        ],
      ),
      width: double.infinity,
      height: 700.0,
    );
  }
}
