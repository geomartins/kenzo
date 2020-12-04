import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/user_model.dart';
import 'package:staff_portal/views/admin/dashboard.dart';
import 'package:staff_portal/views/password_reset.dart';
import '../../providers/login_provider.dart';
import '../custom_flat_button.dart';
import '../custom_outline_button.dart';

class CustomLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    return Positioned(
      child: ClipPath(
        clipper: WaveClipperOne(reverse: true),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              StreamBuilder<String>(
                stream: bloc.email,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  return TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      prefixIcon: Icon(
                        FontAwesome.envelope_o,
                        size: 20.0,
                      ),
                      suffixIcon: snapshot.hasError ? null : Icon(Icons.done),
                      hintText: 'water@gmail.com',
                      labelText: 'Email Address',
                      errorText: snapshot.error,
                    ),
                    onChanged: (String newValue) => bloc.emailSink(newValue),
                  );
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [],
              ),
              StreamBuilder<String>(
                stream: bloc.password,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  return StreamBuilder<bool>(
                      stream: bloc.passwordVisibility,
                      initialData: false,
                      builder: (context, snapshotx) {
                        return TextField(
                          obscureText: !snapshotx.data,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(1.0),
                            focusColor: kPrimaryColor,
                            fillColor: kPrimaryColor,
                            hoverColor: kPrimaryColor,
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: GestureDetector(
                              onTap: () =>
                                  bloc.passwordVisibilitySink(!snapshotx.data),
                              child: Icon(
                                snapshotx.data == false
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            labelText: 'Password',
                            errorText: snapshot.error,
                          ),
                          onChanged: (String newValue) =>
                              bloc.passwordSink(newValue),
                        );
                      });
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, PasswordReset.id),
                    child: Text(
                      'Forget password?',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: StreamBuilder(
                        stream: bloc.submitValid,
                        builder: (context, snapshot) {
                          print(snapshot.data);
                          return SizedBox(
                            width: double.infinity,
                            child: StreamBuilder<bool>(
                                stream: bloc.isLoading,
                                builder: (context, snapshotx) {
                                  return CustomFlatButton(
                                    onPressed: snapshot.hasData &&
                                            snapshot.data == true &&
                                            snapshotx.data != true
                                        ? () async {
                                            bloc.loadingSink(true);

                                            try {
                                              UserModel user =
                                                  await bloc.submit();
                                              if (user != null) {
                                                Navigator.pushNamed(
                                                    context, Dashboard.id);
                                              }
                                            } on PlatformException catch (e) {
                                              Get.snackbar(
                                                "Oops",
                                                'Something Went Wrong',
                                                colorText: Colors.black,
                                                titleText: Text('Ooops!!!',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 2.0)),
                                                messageText: Text(e.message),
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                icon: Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              );
                                              print(e.code);
                                              print(e.message);
                                            } finally {
                                              bloc.loadingSink(false);
                                            }
                                          }
                                        : null,
                                    color: kPrimaryColor,
                                    title: 'Log In',
                                    textColor: Colors.white,
                                  );
                                }),
                          );
                        }),
                  ),
                  StreamBuilder<bool>(
                      stream: bloc.isLoading,
                      initialData: false,
                      builder: (context, snapshot) {
                        return CustomOffstageProgressIndicator(
                          status: !snapshot.data,
                        );
                      }),
                ],
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
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Dashboard();
                    }));
                  },
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
