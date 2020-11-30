import 'package:flutter/material.dart';
import 'package:staff_portal/components/custom_flat_button.dart';
import 'package:staff_portal/config/constants.dart';

class PageNotFound extends StatelessWidget {
  static const id = 'page_not_found';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                buildBackButton(context),
              ],
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
        Icons.report_off,
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
          'Something Missing?',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'This page is missing or you assemble the link incorrectly',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0, letterSpacing: 1.5, height: 1.5),
        ),
      ],
    );
  }

  Widget buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomFlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: kPrimaryColor,
        title: 'Go back to app',
        textColor: Colors.white,
      ),
    );
  }
}
