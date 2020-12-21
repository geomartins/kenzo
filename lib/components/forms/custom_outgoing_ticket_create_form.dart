import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/blocs/outgoing_ticket_create_bloc.dart';
import 'package:staff_portal/components/custom_flat_button.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/providers/outgoing_ticket_create_provider.dart';
import 'package:staff_portal/utilities/camera.dart';

import '../custom_offstage_progress_indicator.dart';

class CustomOutgoingTicketCreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = OutgoingTicketCreateProvider.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDepartmentField(context),
        SizedBox(height: 30.0),
        _buildTitleAndMessageField(context),
        SizedBox(height: 10.0),
        Camera().views(bloc),
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
            child: IconButton(
                color: kTertiaryColor,
                icon: Icon(FontAwesome.camera),
                onPressed: () async {
                  await Camera().openCameraDevice(bloc, context, null);
                })),
        Expanded(
          flex: 6,
          child: CustomFlatButton(
              color: kPrimaryColor,
              textColor: Colors.white,
              radius: 0.0,
              title: 'Create',
              onPressed: () {}),
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

  Widget _buildDepartmentField(context) {
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
        DropdownButtonFormField(
          hint: Text('Department'),
          value: 'ICT',
          onChanged: (String value) {
            print(value);
          },
          items: [
            DropdownMenuItem(
              child: Text('ICT'),
              value: 'ICT',
            ),
            DropdownMenuItem(
              child: Text('MARKETING'),
              value: 'MARKETING',
            )
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: kTertiaryColor.shade200,
            border: new OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(
                const Radius.circular(5.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndMessageField(context) {
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
        TextField(
          decoration: InputDecoration(
            hintText: 'Title',
            filled: true,
            fillColor: kTertiaryColor.shade200,
            border: new OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(
                const Radius.circular(5.0),
              ),
            ),
          ),
        ),
        SizedBox(height: 9.0),
        TextField(
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            filled: true,
            fillColor: kTertiaryColor.shade200,
            hintText: 'Description',
            hintStyle: TextStyle(),
            border: new OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(
                const Radius.circular(5.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
