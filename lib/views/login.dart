import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:staff_portal/components/custom_flat_button.dart';
import 'package:staff_portal/components/custom_outline_button.dart';
import 'package:staff_portal/config/constants.dart';

class Login extends StatelessWidget {
  static const id = 'login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        child: Stack(
          children: <Widget>[
            buildDescriptionLayout(context),
            buildFormLayout(context),
          ],
        ),
      )),
    );
  }

  Widget buildDescriptionLayout(BuildContext context) {
    return Container(
      color: kTertiaryColor,
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

  Widget buildFormLayout(BuildContext context) {
    return Positioned(
      child: ClipPath(
        clipper: WaveClipperOne(reverse: true),
        child: Container(
          //height: MediaQuery.of(context).size.height / 1.5,
          color: Colors.white,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    prefixIcon: Icon(Icons.attach_file),
                    suffixIcon: Icon(Icons.create),
                    hintText: 'water@gmail.com',
                    labelText: 'Email Address'),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(1.0),
                    focusColor: kPrimaryColor,
                    fillColor: kPrimaryColor,
                    hoverColor: kPrimaryColor,
                    prefixIcon: Icon(Icons.security),
                    suffixIcon: Icon(Icons.remove_red_eye),
                    labelText: 'Password'),
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomFlatButton(
                  onPressed: () {},
                  color: kPrimaryColor,
                  title: 'Log In',
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Divider(
                        color: kTertiaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'or',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kTertiaryColor, letterSpacing: 1.0),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Divider(
                        color: kTertiaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomOutlineButton(
                  title: 'Sign Up',
                  color: kPrimaryColor,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: 0.0,
      left: 0,
      right: 0,
    );
  }
}
