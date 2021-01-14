import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/ticket_response_bloc.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/utilities/dates.dart';
import '../../custom_offstage_progress_indicator.dart';

class CustomTicketResponseAppbar extends AppBar {
  final VoidCallback leadingOnPressed;
  final TicketModel data;
  final TicketResponseBloc bloc;

  CustomTicketResponseAppbar(
      {this.leadingOnPressed, this.bloc, @required this.data})
      : super(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          title: ListTile(
            leading: CircleAvatar(
              child: bloc.validResponseType == 'incoming'
                  ? Text('ITR')
                  : Text('OTR'),
              backgroundColor: kPrimaryColor.shade700,
            ),
            title: Text(data.id.toString()),
            subtitle: Text(Dates().timeInSeconds(data.createdAt.toDate())),
            trailing: StreamBuilder<bool>(
                stream: bloc.isLoading,
                initialData: false,
                builder: (context, isLoadingSnapshot) {
                  return Container(
                    width: 30.0,
                    height: 30.0,
                    child: CustomOffstageProgressIndicator(
                        status: !isLoadingSnapshot.data),
                  );
                }),
          ),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios_outlined),
            onTap: () {
              leadingOnPressed();
            },
          ),
          leadingWidth: 50.0,
          titleSpacing: 0.0,
        );
}
