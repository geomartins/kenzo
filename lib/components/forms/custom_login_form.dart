import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/blocs/login_bloc.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/models/user_model.dart';
import 'package:staff_portal/views/admin/dashboard.dart';
import 'package:staff_portal/views/password_reset.dart';
import 'package:staff_portal/views/register.dart';
import '../../providers/login_provider.dart';
import '../custom_flat_button.dart';
import '../custom_outline_button.dart';

class CustomLoginForm extends StatelessWidget with GetSnackbar {
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
              SizedBox(height: 40.0),
              _buildEmail(bloc),
              SizedBox(height: 5.0),
              _buildPassword(bloc),
              SizedBox(height: 5.0),
              _buildForgetPassword(context),
              SizedBox(height: 10.0),
              _buildLoginButton(bloc, context),
              _buildDivider(),
              _buildRegisterButton(context),
            ],
          ),
        ),
      ),
      bottom: 0.0,
      left: 0,
      right: 0,
    );
  }

  Widget _buildEmail(LoginBloc bloc) {
    return StreamBuilder<String>(
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
    );
  }

  Widget _buildPassword(LoginBloc bloc) {
    return StreamBuilder<String>(
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
                    onTap: () => bloc.passwordVisibilitySink(!snapshotx.data),
                    child: Icon(
                      snapshotx.data == false
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  labelText: 'Password',
                  errorText: snapshot.error,
                ),
                onChanged: (String newValue) => bloc.passwordSink(newValue),
              );
            });
      },
    );
  }

  Widget _buildForgetPassword(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildLoginButton(LoginBloc bloc, BuildContext context) {
    return Row(
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
                                    UserModel user = await bloc.submit();
                                    if (user != null) {
                                      Navigator.pushReplacementNamed(
                                          context, Dashboard.id);
                                    }
                                  } on PlatformException catch (e) {
                                    buildCustomSnackbar(
                                        messageText: e.message,
                                        titleText: "Oops",
                                        iconColor: Colors.red,
                                        icon: Icons.error);
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
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
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
              style: TextStyle(color: kTertiaryColor, letterSpacing: 1.0),
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
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomOutlineButton(
        title: 'Sign Up',
        color: kPrimaryColor,
        onPressed: () => Navigator.pushNamed(context, Register.id),
      ),
    );
  }
}
