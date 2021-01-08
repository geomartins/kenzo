import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/components/custom_flat_button.dart';
import 'package:staff_portal/components/custom_outline_button.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/views/register.dart';

import 'login.dart';

class Welcome extends StatelessWidget {
  static const id = 'welcome';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/images/welcome.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            left: true,
            right: true,
            bottom: true,
            minimum: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              //reverse: true,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      kCompanyName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          kAppName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            letterSpacing: 2.0,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'We deliver water at any point in the earth within 30 minutes',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: CustomFlatButton(
                          color: kPrimaryColor,
                          textColor: Colors.white,
                          title: 'Login',
                          onPressed: () =>
                              Navigator.pushNamed(context, Login.id),
                        )),
                    SizedBox(
                      width: double.infinity,
                      child: CustomOutlineButton(
                        color: kPrimaryColor,
                        title: 'Sign Up',
                        onPressed: () =>
                            Navigator.pushNamed(context, Register.id),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
