import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/components/builders/custom_guest_builder.dart';
import 'package:staff_portal/components/forms/custom_register_form.dart';
import 'package:staff_portal/config/constants.dart';

class Register extends StatelessWidget {
  static const id = 'register';
  @override
  Widget build(BuildContext context) {
    return CustomGuestBuilder(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
          child: Stack(
            children: <Widget>[
              buildDescriptionLayout(context),
              CustomRegisterForm(),
            ],
          ),
        )),
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
            height: 70.0,
          ),
          Text('Create',
              style: TextStyle(
                fontSize: 27.0,
                letterSpacing: 2.0,
              )),
          Text('Account',
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
