import 'package:flutter/material.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/outgoing_ticket_response_provider.dart';

import '../../custom_offstage_progress_indicator.dart';

class CustomOutgoingTicketResponseMediaFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = OutgoingTicketResponseProvider.of(context);

    return StreamBuilder<String>(
        stream: bloc.ticketID,
        initialData: null,
        builder: (context, ticketIDSnapshot) {
          if (ticketIDSnapshot.hasError) {
            return Text('Something went wrong');
          }
          if (ticketIDSnapshot.connectionState == ConnectionState.waiting) {
            return CustomOffstageProgressIndicator(status: false);
          }

          return StreamBuilder<TicketModel>(
              stream: bloc.ticketData,
              builder: (context, ticketDataSnapshot) {
                if (ticketDataSnapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (ticketDataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CustomOffstageProgressIndicator(status: false);
                }

                if (ticketDataSnapshot.data.images.length < 1) {
                  return Container();
                }
                return Container(
                  width: double.infinity,
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ticketDataSnapshot.data.images.length,
                    itemBuilder: (context, int index) {
                      return Container(
                        margin: EdgeInsets.all(10.0),
                        width: ticketDataSnapshot.data.images.length < 2
                            ? MediaQuery.of(context).size.width
                            : 200,
                        height: 200,
                        color: kTertiaryColor.shade200,
                        child: Image.network(
                            ticketDataSnapshot.data.images[index],
                            fit: BoxFit.cover),
                      );
                    },
                  ),
                );
              });
        });
  }
}
