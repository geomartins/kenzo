import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_response_bloc.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/utilities/dates.dart';

import '../../custom_offstage_progress_indicator.dart';

class CustomOutgoingTicketResponseAppbar extends AppBar {
  final VoidCallback leadingOnPressed;
  final OutgoingTicketResponseBloc bloc;

  CustomOutgoingTicketResponseAppbar({this.leadingOnPressed, this.bloc})
      : super(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          title: StreamBuilder<TicketModel>(
              stream: bloc.ticketData,
              builder: (context, ticketDataSnapshot) {
                if (ticketDataSnapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (ticketDataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CustomOffstageProgressIndicator(status: false);
                }
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(ticketDataSnapshot.data.toDepartment
                        .substring(0, 3)
                        .toUpperCase()),
                    backgroundColor: kPrimaryColor,
                  ),
                  title: Text(ticketDataSnapshot.data.toDepartment),
                  subtitle: Text(Dates().timeInSeconds(
                      ticketDataSnapshot.data.createdAt.toDate())),
                  trailing: StreamBuilder<bool>(
                      stream: bloc.isLoading,
                      initialData: false,
                      builder: (context, snapshot) {
                        return Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation(Colors.teal),
                          ),
                        );
                      }),
                );
              }),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios_outlined),
            onTap: () {
              leadingOnPressed();
            },
          ),
          leadingWidth: 10.0,
        );

  Widget build(BuildContext context) {
    return Container();
  }
}
