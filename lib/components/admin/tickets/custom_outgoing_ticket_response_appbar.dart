import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_response_bloc.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/utilities/dates.dart';
import '../../custom_offstage_progress_indicator.dart';

class CustomOutgoingTicketResponseAppbar extends AppBar {
  final VoidCallback leadingOnPressed;
  final TicketModel data;
  final OutgoingTicketResponseBloc bloc;

  CustomOutgoingTicketResponseAppbar(
      {this.leadingOnPressed, this.bloc, @required this.data})
      : super(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          title: ListTile(
            leading: CircleAvatar(
              child: Text(data.toDepartment.substring(0, 3).toUpperCase()),
              backgroundColor: kPrimaryColor,
            ),
            title: Text(data.toDepartment),
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
          leadingWidth: 10.0,
        );
}
