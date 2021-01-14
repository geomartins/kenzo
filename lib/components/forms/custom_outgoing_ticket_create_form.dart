import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/blocs/outgoing_ticket_create_bloc.dart';
import 'package:staff_portal/components/custom_flat_button.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/providers/outgoing_ticket_create_provider.dart';
import 'package:staff_portal/utilities/device_file.dart';

import '../custom_offstage_progress_indicator.dart';

class CustomOutgoingTicketCreateForm extends StatelessWidget with GetSnackbar {
  final TextEditingController _titleTextEditingController =
      new TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bloc = OutgoingTicketCreateProvider.of(context);
    bloc.fetchFromDepartment();
    bloc.fetchDepartmentList();
    bloc.editingControllersSink(
        [_titleTextEditingController, _descriptionTextEditingController]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDepartmentField(context, bloc),
        SizedBox(height: 30.0),
        _buildTitleAndMessageField(context, bloc),
        SizedBox(height: 10.0),
        DeviceFile().views(bloc),
        SizedBox(height: 10.0),
        _buildButtonField(context, bloc),
      ],
    );
  }

  Widget _buildButtonField(
      BuildContext context, OutgoingTicketCreateBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: StreamBuilder<bool>(
                stream: bloc.isLoading,
                initialData: false,
                builder: (context, isLoadingSnapshot) {
                  return IconButton(
                      color: kTertiaryColor,
                      icon: Icon(FontAwesome.folder_open_o),
                      onPressed: isLoadingSnapshot.data == true
                          ? null
                          : () async {
                              await DeviceFile()
                                  .openFiles(bloc, context, [], null);
                            });
                })),
        Expanded(
          flex: 6,
          child: StreamBuilder<bool>(
              stream: bloc.submitValid,
              initialData: false,
              builder: (context, snapshot) {
                return StreamBuilder<bool>(
                    stream: bloc.isLoading,
                    initialData: false,
                    builder: (context, isLoadingSnapshot) {
                      return CustomFlatButton(
                          color: kPrimaryColor,
                          textColor: Colors.white,
                          radius: 0.0,
                          title: 'Create',
                          onPressed: snapshot.data != true ||
                                  isLoadingSnapshot.data == true
                              ? null
                              : () async {
                                  bloc.loadingSink(true);

                                  try {
                                    await bloc.submit();
                                    bloc.clear();
                                    buildCustomSnackbar(
                                        titleText: 'Successful!!!',
                                        messageText:
                                            'Ticket Created Successfully',
                                        icon: Icons.info,
                                        iconColor: kPrimaryColor);
                                    Navigator.pop(context);
                                    print('Done Now');
                                  } on PlatformException catch (e) {
                                    buildCustomSnackbar(
                                        titleText: 'Ooops!!!',
                                        messageText: e.message,
                                        icon: Icons.error,
                                        iconColor: Colors.red);
                                  } finally {
                                    bloc.loadingSink(false);
                                  }
                                });
                    });
              }),
        ),
        StreamBuilder<bool>(
            stream: bloc.isLoading,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data) {
                return Expanded(
                    child: CustomOffstageProgressIndicator(
                  status: !snapshot.data,
                ));
              } else {
                return Container();
              }
            })
      ],
    );
  }

  Widget _buildDepartmentField(context, OutgoingTicketCreateBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select department'.toUpperCase(),
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
          ),
        ),
        SizedBox(height: 10.0),
        StreamBuilder<String>(
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
                            onChanged: (newValue) =>
                                bloc.departmentSink(newValue),
                            items: _buildDepartmentDropDownMenu(
                                departmentListSnapshot.data),
                            decoration: InputDecoration(
                              enabled: !isLoadingSnapshot.data,
                              filled: true,
                              fillColor: kTertiaryColor.shade200,
                              errorText: snapshot.error,
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                              ),
                            ),
                          );
                        });
                  });
            }),
      ],
    );
  }

  Widget _buildTitleAndMessageField(context, OutgoingTicketCreateBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Information'.toUpperCase(),
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
          ),
        ),
        SizedBox(height: 9.0),
        StreamBuilder<String>(
            stream: bloc.title,
            builder: (context, snapshot) {
              return StreamBuilder<bool>(
                  stream: bloc.isLoading,
                  initialData: false,
                  builder: (context, isLoadingSnapshot) {
                    return TextField(
                      controller: _titleTextEditingController,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      enabled: !isLoadingSnapshot.data,
                      onChanged: (String newValue) => bloc.titleSink(newValue),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        filled: true,
                        errorText: snapshot.error,
                        fillColor: kTertiaryColor.shade200,
                        border: new OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                      ),
                    );
                  });
            }),
        SizedBox(height: 9.0),
        StreamBuilder<String>(
            stream: bloc.description,
            builder: (context, snapshot) {
              return StreamBuilder<bool>(
                  stream: bloc.isLoading,
                  initialData: false,
                  builder: (context, isLoadingSnapshot) {
                    return TextField(
                      controller: _descriptionTextEditingController,
                      keyboardType: TextInputType.multiline,
                      enabled: !isLoadingSnapshot.data,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kTertiaryColor.shade200,
                        hintText: 'Description',
                        errorText: snapshot.error,
                        hintStyle: TextStyle(),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                      ),
                      onChanged: (String newValue) =>
                          bloc.descriptionSink(newValue),
                    );
                  });
            }),
      ],
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
