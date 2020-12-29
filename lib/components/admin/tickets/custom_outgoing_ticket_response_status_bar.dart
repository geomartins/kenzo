import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/outgoing_ticket_response_provider.dart';

import '../../custom_offstage_progress_indicator.dart';

class CustomOutgoingTicketResponseStatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = OutgoingTicketResponseProvider.of(context);

    return StreamBuilder<TicketModel>(
        stream: bloc.ticketData,
        builder: (context, ticketDataSnapshot) {
          if (ticketDataSnapshot.hasError) {
            return Text('Something went wrong');
          }
          if (ticketDataSnapshot.connectionState == ConnectionState.waiting) {
            return CustomOffstageProgressIndicator(status: false);
          }
          if (ticketDataSnapshot.connectionState == ConnectionState.active) {
            String status = ticketDataSnapshot.data.status;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: kTertiaryColor.shade400),
                  bottom:
                      BorderSide(width: 1.0, color: kTertiaryColor.shade400),
                ),
              ),
              height: 40.0,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                          status == 'opened'
                              ? FontAwesome.heart
                              : FontAwesome.heart_o,
                          color: status == 'opened'
                              ? kPrimaryColor
                              : kTertiaryColor),
                      SizedBox(width: 5.0),
                      Text(
                        'Open',
                        style: TextStyle(color: kTertiaryColor),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                          status == 'in-progress'
                              ? FontAwesome.heart
                              : FontAwesome.heart_o,
                          color: status == 'in-progress'
                              ? kPrimaryColor
                              : kTertiaryColor),
                      SizedBox(width: 5.0),
                      Text(
                        'In Progress',
                        style: TextStyle(color: kTertiaryColor),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                          status == 'closed'
                              ? FontAwesome.heart
                              : FontAwesome.heart_o,
                          color: status == 'closed'
                              ? kPrimaryColor
                              : kTertiaryColor),
                      SizedBox(width: 5.0),
                      Text(
                        'Closed',
                        style: TextStyle(color: kTertiaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Container();
        });
  }
}
