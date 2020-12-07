import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/providers/password_reset_provider.dart';
import 'package:staff_portal/views/login.dart';
import '../custom_flat_button.dart';

class CustomPasswordResetForm extends StatelessWidget with GetSnackbar {
  @override
  Widget build(BuildContext context) {
    final bloc = PasswordResetProvider.of(context);
    return Column(
      children: <Widget>[
        StreamBuilder<String>(
            stream: bloc.email,
            builder: (context, snapshot) {
              return StreamBuilder<bool>(
                  initialData: false,
                  stream: bloc.isLoading,
                  builder: (context, snapshotx) {
                    return TextField(
                      enabled: !snapshotx.data,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'Email Address',
                        errorText: snapshot.error,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (String newValue) => bloc.emailSink(newValue),
                    );
                  });
            }),
        SizedBox(
          height: 25.0,
        ),
        Row(
          children: [
            Expanded(
              flex: 11,
              child: StreamBuilder<String>(
                  stream: bloc.email,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      child: StreamBuilder<bool>(
                          stream: bloc.isLoading,
                          initialData: false,
                          builder: (context, snapshotx) {
                            return CustomFlatButton(
                              onPressed: snapshot.hasError ||
                                      snapshot.data == null ||
                                      snapshotx.data == true
                                  ? null
                                  : () async {
                                      bloc.loadingSink(true);
                                      try {
                                        await bloc.submit();
                                        buildCustomSnackbar(
                                            titleText: 'Successful!!!',
                                            messageText:
                                                'Password Reset link sent to your email',
                                            icon: Icons.info,
                                            iconColor: kPrimaryColor);
                                        Navigator.pushNamed(context, Login.id);
                                      } on PlatformException catch (e) {
                                        buildCustomSnackbar(
                                            titleText: 'Ooops!!!',
                                            messageText: e.message,
                                            icon: Icons.error,
                                            iconColor: Colors.red);
                                      } finally {
                                        bloc.loadingSink(false);
                                      }
                                    },
                              color: kPrimaryColor,
                              title: 'Reset Password',
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
                      status: !snapshot.data);
                }),
          ],
        ),
      ],
    );
  }
}
