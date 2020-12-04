import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:staff_portal/components/custom_login_form.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/providers/login_provider.dart';

class Login extends StatelessWidget {
  static const id = 'login';
  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    return Scaffold(
      body: StreamBuilder<bool>(
          stream: bloc.isLoading,
          initialData: false,
          builder: (context, snapshot) {
            return LoadingOverlay(
              isLoading: snapshot.data,
              progressIndicator: CircularProgressIndicator(),
              opacity: 0.3,
              color: Colors.black12,
              child: SingleChildScrollView(
                  child: Container(
                child: Stack(
                  children: <Widget>[
                    buildDescriptionLayout(context),
                    CustomLoginForm(),
                  ],
                ),
              )),
            );
          }),
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
}
