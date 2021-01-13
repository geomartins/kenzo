import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/blocs/register_bloc.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/providers/register_provider.dart';
import 'package:staff_portal/views/login.dart';
import '../custom_flat_button.dart';
import '../custom_offstage_progress_indicator.dart';
import '../custom_outline_button.dart';

class CustomRegisterForm extends StatelessWidget with GetSnackbar {
  @override
  Widget build(BuildContext context) {
    final bloc = RegisterProvider.of(context);
    bloc.fetchDepartmentList();
    return Positioned(
      child: ClipPath(
        clipper: WaveClipperTwo(reverse: true),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: 40.0),
              buildFirstname(bloc),
              SizedBox(height: 5.0),
              buildMiddlename(bloc),
              SizedBox(height: 5.0),
              buildLastname(bloc),
              SizedBox(height: 5.0),
              buildDepartment(bloc),
              SizedBox(height: 5.0),
              buildEmail(bloc),
              SizedBox(height: 5.0),
              buildPassword(bloc),
              SizedBox(height: 10.0),
              buildSignUpButton(bloc, context),
              buildDivider(),
              buildLoginButton(context),
            ],
          ),
        ),
      ),
      bottom: 0.0,
      left: 0,
      right: 0,
    );
  }

  Widget buildDepartment(RegisterBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.department,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
              stream: bloc.isLoading,
              initialData: false,
              builder: (context, isLoadingSnapshot) {
                return StreamBuilder<List<String>>(
                    stream: bloc.departmentList,
                    builder: (context, departmentListSnapshot) {
                      return DropdownButtonFormField(
                        hint: Text('Select department'),
                        onChanged: (newValue) => bloc.departmentSink(newValue),
                        items: _buildDepartmentDropDownMenu(
                            departmentListSnapshot.data),
                        decoration: InputDecoration(
                          enabled: !isLoadingSnapshot.data,
                          contentPadding: EdgeInsets.all(10.0),
                          prefixIcon: Icon(
                            Icons.home_outlined,
                            size: 25.0,
                          ),
                          errorText: snapshot.error,
                        ),
                      );
                    });
              });
        });
  }

  Widget buildFirstname(RegisterBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.firstname,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
              stream: bloc.isLoading,
              initialData: false,
              builder: (context, snapshotx) {
                return TextField(
                  enabled: !snapshotx.data,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    prefixIcon: Icon(
                      FontAwesome.user_o,
                      size: 20.0,
                    ),
                    labelText: 'First Name',
                    errorText: snapshot.error,
                  ),
                  onChanged: (String newValue) => bloc.firstnameSink(newValue),
                );
              });
        });
  }

  Widget buildMiddlename(RegisterBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.middlename,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
              stream: bloc.isLoading,
              initialData: false,
              builder: (context, snapshotx) {
                return TextField(
                  enabled: !snapshotx.data,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    prefixIcon: Icon(
                      FontAwesome.user_o,
                      size: 20.0,
                    ),
                    labelText: 'Middle Name',
                    errorText: snapshot.error,
                  ),
                  onChanged: (String newValue) => bloc.middlenameSink(newValue),
                );
              });
        });
  }

  Widget buildLastname(RegisterBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.lastname,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
              stream: bloc.isLoading,
              initialData: false,
              builder: (context, snapshotx) {
                return TextField(
                  enabled: !snapshotx.data,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    prefixIcon: Icon(
                      FontAwesome.user_o,
                      size: 20.0,
                    ),
                    labelText: 'Last Name',
                    errorText: snapshot.error,
                  ),
                  onChanged: (String newValue) => bloc.lastnameSink(newValue),
                );
              });
        });
  }

  Widget buildEmail(RegisterBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.email,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
              stream: bloc.isLoading,
              initialData: false,
              builder: (context, snapshotx) {
                return TextField(
                  enabled: !snapshotx.data,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    prefixIcon: Icon(
                      FontAwesome.envelope_o,
                      size: 20.0,
                    ),
                    labelText: 'Email Address',
                    errorText: snapshot.error,
                  ),
                  onChanged: (String newValue) => bloc.emailSink(newValue),
                );
              });
        });
  }

  Widget buildPassword(RegisterBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.password,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
              stream: bloc.isLoading,
              initialData: false,
              builder: (context, snapshot) {
                return StreamBuilder<bool>(
                    stream: bloc.passwordVisibility,
                    initialData: false,
                    builder: (context, snapshotY) {
                      return TextField(
                        enabled: !snapshot.data,
                        obscureText: !snapshotY.data,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(1.0),
                          focusColor: kPrimaryColor,
                          fillColor: kPrimaryColor,
                          hoverColor: kPrimaryColor,
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: GestureDetector(
                            child: Icon(
                              snapshotY.data == false
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onTap: () =>
                                bloc.passwordVisibilitySink(!snapshotY.data),
                          ),
                          labelText: 'Password',
                          errorText: snapshot.error,
                        ),
                        onChanged: (String newValue) =>
                            bloc.passwordSink(newValue),
                      );
                    });
              });
        });
  }

  Widget buildSignUpButton(RegisterBloc bloc, context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: StreamBuilder<bool>(
              stream: bloc.submitValid,
              builder: (context, snapshot) {
                return SizedBox(
                  width: double.infinity,
                  child: StreamBuilder<bool>(
                      stream: bloc.isLoading,
                      initialData: false,
                      builder: (context, snapshotX) {
                        return CustomFlatButton(
                          onPressed: snapshot.data == null ||
                                  snapshot.hasError ||
                                  snapshotX.data == true
                              ? null
                              : () async {
                                  try {
                                    bloc.loadingSink(true);
                                    await bloc.submit();
                                  } on PlatformException catch (e) {
                                    buildCustomSnackbar(
                                        titleText: 'Ooops!!!',
                                        messageText: e.message,
                                        icon: Icons.error,
                                        iconColor: Colors.red);
                                    print(e.code);
                                    print(e.message);
                                  } finally {
                                    bloc.loadingSink(false);
                                  }
                                },
                          color: kPrimaryColor,
                          title: 'Sign up',
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

  Widget buildDivider() {
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

  Widget buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomOutlineButton(
        title: 'Log in',
        color: kPrimaryColor,
        onPressed: () => Navigator.pushNamed(context, Login.id),
      ),
    );
  }

  List<DropdownMenuItem> _buildDepartmentDropDownMenu(List<String> datas) {
    List<DropdownMenuItem> result = [];
    for (String department in datas ?? []) {
      result.add(DropdownMenuItem(
        child: Text(department),
        value: department,
      ));
    }
    return result;
  }
}
