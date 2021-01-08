import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:staff_portal/blocs/opinion_bloc.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import '../custom_flat_button.dart';

class CustomOpinionForm extends StatelessWidget with GetSnackbar {
  final OpinionBloc bloc;
  final descriptionTextEditingController;
  CustomOpinionForm({this.bloc, this.descriptionTextEditingController});

  @override
  Widget build(BuildContext context) {
    bloc.editingControllersSink([descriptionTextEditingController]);
    return StreamBuilder<String>(
        stream: bloc.description,
        initialData: '',
        builder: (context, descriptionSnapshot) {
          return StreamBuilder<bool>(
              stream: bloc.isLoading,
              initialData: false,
              builder: (context, isLoadingSnapshot) {
                return ClipPath(
                  clipper: OvalTopBorderClipper(),
                  child: SingleChildScrollView(
                    child: Container(
                      height: 300.0,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextField(
                              controller: descriptionTextEditingController,
                              keyboardType: TextInputType.multiline,
                              enabled: !isLoadingSnapshot.data,
                              minLines: 1,
                              maxLines: 3,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kTertiaryColor.shade100,
                                hintText:
                                    'Kindly give us your feedback, complains, improvement and organisation .....',
                                errorText: descriptionSnapshot.error,
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(40.0),
                                  ),
                                ),
                              ),
                              onChanged: (String newValue) =>
                                  bloc.descriptionSink(newValue),
                            ),
                            SizedBox(height: 10.0),
                            SizedBox(
                                width: double.infinity,
                                child: CustomFlatButton(
                                  radius: 40.0,
                                  color: kPrimaryColor,
                                  onPressed: isLoadingSnapshot.data == true ||
                                          !descriptionSnapshot.hasData ||
                                          descriptionTextEditingController
                                                  .text.length <
                                              3
                                      ? null
                                      : () async {
                                          try {
                                            bloc.loadingSink(true);
                                            await bloc.submit();

                                            buildCustomSnackbar(
                                                titleText: 'Successful!!!',
                                                messageText:
                                                    'Feedback submitted Successfully',
                                                icon: Icons.info,
                                                iconColor: kPrimaryColor);
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
                                  title: 'SUBMIT',
                                  textColor: Colors.white,
                                )),
                            SizedBox(height: 100.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
