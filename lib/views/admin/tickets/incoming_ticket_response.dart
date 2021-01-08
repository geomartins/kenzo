import 'package:flutter/material.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_response_appbar.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_response_bottom_sheet.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_response_comments.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_response_media_frame.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_response_meta_data.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_response_status_bar.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/providers/incoming_ticket_response_provider.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/services/firebase_messaging_service.dart';
import 'package:staff_portal/utilities/device_file.dart';
import '../../../components/builders/custom_auth_builder.dart';

class IncomingTicketResponse extends StatelessWidget with GetSnackbar {
  static const id = 'incoming_ticket_response';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    FirebaseMessagingService().configure(context);
    PreferenceProvider.of(context).activeSink(id);
    final bloc = IncomingTicketResponseProvider.of(context);
    bloc.ticketIDSink(ModalRoute.of(context).settings.arguments);

    return CustomAuthBuilder(
      child: StreamBuilder<String>(
          stream: bloc.ticketID,
          builder: (context, ticketIDSnapshot) {
            if (ticketIDSnapshot.hasError) {
              return Scaffold(body: Text('Something went wrong'));
            }
            if (ticketIDSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                  body: CustomOffstageProgressIndicator(status: false));
            }

            return StreamBuilder<TicketModel>(
                stream: bloc.ticketData,
                builder: (context, ticketDataSnapshot) {
                  if (ticketDataSnapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (ticketDataSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Scaffold(
                        body: CustomOffstageProgressIndicator(status: false));
                  }
                  return Scaffold(
                    key: _drawerKey,
                    bottomNavigationBar: CustomBottomNavigationBar(),
                    appBar: CustomIncomingTicketResponseAppbar(
                      bloc: bloc,
                      data: ticketDataSnapshot.data,
                      leadingOnPressed: () => Navigator.of(context).pop(),
                    ),
                    extendBody: true,
                    bottomSheet: CustomIncomingTicketResponseBottomSheet(
                      scrollController: scrollController,
                      initialText: bloc.validReply,
                      fileOnPressed: () async {
                        await DeviceFile().openFiles(
                            bloc, context, ['jpg', 'png', 'pdf'], null);
                      },
                    ),
                    body: SingleChildScrollView(
                      controller: scrollController,
                      physics: ScrollPhysics(),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            SizedBox(height: 10.0),
                            CustomIncomingTicketResponseMetaData(
                              data: ticketDataSnapshot.data,
                            ),
                            SizedBox(height: 5.0),
                            CustomIncomingTicketResponseMediaFrame(
                              data: ticketDataSnapshot.data,
                            ),
                            CustomIncomingTicketResponseStatusBar(
                              data: ticketDataSnapshot.data,
                              bloc: bloc,
                            ),
                            SizedBox(height: 10.0),
                            CustomIncomingTicketResponseComments(
                              bloc: bloc,
                            ),
                            SizedBox(height: 150.0),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
