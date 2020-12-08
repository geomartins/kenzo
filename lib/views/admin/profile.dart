import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/components/custom_flat_button.dart';
import 'package:staff_portal/components/custom_outline_button.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/services/auth_service.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';

class Profile extends StatelessWidget with GetSnackbar {
  static const id = 'profile';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    PreferenceProvider.of(context).activeSink(id);
    return CustomAuthBuilder(
      child: Scaffold(
        key: _drawerKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Martins Abiodun',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.person_pin,
                color: Colors.black,
                size: 30.0,
              ),
            ),
          ],
          elevation: 0.0,
          centerTitle: true,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
        drawer: CustomDrawer(),
        body: SafeArea(
          minimum: EdgeInsets.all(10.0),
          left: true,
          right: true,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  //SizedBox(height: 30.0),
                  _buildCover(context),
                  Positioned(
                    child: _buildProfileAvatar(),
                    bottom: -30.0,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              _buildListTile(context),
              _buildButtons(context),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildCover(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              scale: 50.0,
              alignment: Alignment.topCenter,
              image: AssetImage(
                'assets/images/martins.jpeg',
              ),
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          height: MediaQuery.of(context).size.height / 3,
        ),
        Positioned(
          child: Container(
            child: Icon(Icons.camera),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
          ),
          bottom: 20.0,
          right: 20.0,
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        new Container(
          width: 100.0,
          height: 100.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: new AssetImage('assets/images/martins.jpeg'),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            border: new Border.all(
              color: Colors.white,
              width: 4.0,
            ),
          ),
        ),
//        ClipOval(
//          child: Image.asset(
//            'assets/images/martins.jpeg',
//            fit: BoxFit.cover,
//            height: 150.0,
//            width: 150.0,
//          ),
//        )
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CustomOutlineButton(
            color: Colors.white,
            title: 'Edit Profile',
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: CustomFlatButton(
            color: Colors.teal,
            title: 'Logout',
            onPressed: () async {
              try {
                await AuthService().logout();
              } on PlatformException catch (e) {
                buildCustomSnackbar(
                    messageText: e.message,
                    titleText: "Oops",
                    iconColor: Colors.red,
                    icon: Icons.error);
              }
            },
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          //contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
          subtitle: Text(
            'Email Address',
            style: TextStyle(letterSpacing: 1.0),
          ),
          title: Text('martinsabiodun94@gmail.com'),
          leading: Icon(
            Icons.email_outlined,
            color: kPrimaryColor,
          ),
          trailing: Icon(Icons.accessibility_new),
        ),
        ListTile(
          dense: true,
          // contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
          subtitle: Text(
            'Department',
            style: TextStyle(letterSpacing: 1.0),
          ),
          title: Text('ClientServices'),
          leading: Icon(
            Icons.email_outlined,
            color: kPrimaryColor,
          ),
          trailing: Icon(Icons.accessibility_new),
        ),
        ListTile(
          dense: true,
          //contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
          subtitle: Text(
            'Job Role',
            style: TextStyle(letterSpacing: 1.0),
          ),
          title: Text('Chief Operating Officer'),
          leading: Icon(
            Icons.email_outlined,
            color: kPrimaryColor,
          ),
          trailing: Icon(Icons.accessibility_new),
        ),
        ListTile(
          dense: true,
//          contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
          subtitle: Text(
            'Job Role',
            style: TextStyle(letterSpacing: 1.0),
          ),
          title: Text('Chief Operating Officer'),
          leading: Icon(
            Icons.email_outlined,
            color: kPrimaryColor,
          ),
          trailing: Icon(Icons.accessibility_new),
        ),
      ],
    );
  }
}
