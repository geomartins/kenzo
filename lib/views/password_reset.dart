import 'package:flutter/material.dart';
import 'package:staff_portal/components/builders/custom_guest_builder.dart';
import 'package:staff_portal/components/forms/custom_password_reset_form.dart';
import 'package:staff_portal/config/constants.dart';

class PasswordReset extends StatelessWidget {
  static const id = 'password_reset';
  @override
  Widget build(BuildContext context) {
    return CustomGuestBuilder(
      child: Scaffold(
        body: SafeArea(
          left: true,
          right: true,
          minimum: EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: 700.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildBackIcon(context),
                  SizedBox(height: 70.0),
                  buildAvatar(context),
                  SizedBox(height: 30.0),
                  buildText(context),
                  SizedBox(height: 60.0),
                  CustomPasswordResetForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackIcon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget buildAvatar(BuildContext context) {
    return CircleAvatar(
      //foregroundColor: kTertiaryColor,
      backgroundColor: kTertiaryColor.shade200,
      child: Icon(
        Icons.lock_outline,
        color: kPrimaryColor,
        size: 90.0,
      ),
      radius: 90.0,
    );
  }

  Widget buildText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Forget Password?',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Enter the email address associated with your account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0, letterSpacing: 1.5, height: 1.5),
        ),
      ],
    );
  }
}
