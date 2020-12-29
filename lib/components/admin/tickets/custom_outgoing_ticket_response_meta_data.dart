import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/outgoing_ticket_response_provider.dart';

class CustomOutgoingTicketResponseMetaData extends StatelessWidget {
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
          if (ticketIDSnapshot.data != null) {
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
                  if (ticketIDSnapshot.data != null) {
                    return ListTile(
                        title: Text(
                          ticketDataSnapshot.data.title,
                          style: TextStyle(letterSpacing: 0.7),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5.0),
                            Text(
                              ticketDataSnapshot.data.description,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Wrap(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(FontAwesome.user_o,
                                        color: kPrimaryColor, size: 20.0),
                                    SizedBox(width: 3.0),
                                    Text(
                                      ticketDataSnapshot
                                                  .data.user['firstname'] !=
                                              null
                                          ? ticketDataSnapshot
                                                  .data.user['firstname'] +
                                              '' +
                                              ticketDataSnapshot
                                                  .data.user['lastname']
                                          : ticketDataSnapshot
                                              .data.user['department'],
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock_clock,
                                        color: kPrimaryColor, size: 20.0),
                                    SizedBox(width: 3.0),
                                    Text(
                                      DateFormat.yMMMEd().format(
                                          ticketDataSnapshot.data.createdAt
                                              .toDate()),
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ));
                  } else {
                    return CustomOffstageProgressIndicator(status: false);
                  }
                });
          } else {
            return CustomOffstageProgressIndicator(status: false);
          }
        });
  }
}
