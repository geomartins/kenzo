import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:staff_portal/blocs/outgoing_ticket_response_bloc.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_response_model.dart';
import 'package:staff_portal/utilities/dates.dart';

import '../../custom_offstage_progress_indicator.dart';
import 'custom_outgoing_ticket_response_comment_media_frame.dart';

class CustomOutgoingTicketResponseComments extends StatelessWidget {
  final OutgoingTicketResponseBloc bloc;
  CustomOutgoingTicketResponseComments({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TicketResponseModel>>(
        stream: bloc.ticketResponseData,
        builder: (context, ticketResponseDataSnapshot) {
          if (ticketResponseDataSnapshot.hasError) {
            return Text('Something went wrong');
          }
          if (ticketResponseDataSnapshot.connectionState ==
              ConnectionState.waiting) {
            return CustomOffstageProgressIndicator(status: false);
          }

          return ticketResponseDataSnapshot.data.length < 1
              ? Container()
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ticketResponseDataSnapshot.data.length,
                  itemBuilder: (context, int index) {
                    final data = ticketResponseDataSnapshot.data[index];
                    final fullname =
                        data.user['firstname'] + ' ' + data.user['lastname'];
                    final reply = data.reply;
                    final createdAt = data.createdAt;

                    // final List<dynamic> images = data.images;

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(data.user['firstname']
                            .toString()
                            .substring(0, 2)
                            .toUpperCase()),
                        backgroundColor: kPrimaryColor,
                      ),
                      title: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: kTertiaryColor.shade100,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullname ?? 'fffffffff',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              reply,
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        fontSize: 15.0,
                                      ),
                            ),
//            _buildMediaFrame(),
                            CustomOutgoingTicketResponseCommentMediaFrame(
                              data: data,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 5.0),
                                Text(
                                  Dates()
                                      .timeInSeconds(createdAt.toDate())
                                      .toString(),
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          fontSize: 14.0,
                                          fontStyle: FontStyle.italic,
                                          color: kTertiaryColor.shade400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        });
  }
}
