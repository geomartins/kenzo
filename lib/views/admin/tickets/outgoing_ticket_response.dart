import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/blocs/outgoing_ticket_response_bloc.dart';

import 'package:staff_portal/providers/outgoing_ticket_response_provider.dart';
import 'package:staff_portal/components/admin/tickets/custom_outgoing_ticket_response_appbar.dart';
import 'package:staff_portal/components/admin/tickets/custom_outgoing_ticket_response_comments.dart';
import 'package:staff_portal/components/admin/tickets/custom_outgoing_ticket_response_media_frame.dart';
import 'package:staff_portal/components/admin/tickets/custom_outgoing_ticket_response_status_bar.dart';
import 'package:staff_portal/components/admin/tickets/custom_outgoing_ticket_response_meta_data.dart';
import 'package:staff_portal/components/admin/tickets/custom_outgoing_ticket_response_bottom_sheet.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/utilities/camera.dart';

class OutgoingTicketResponse extends StatelessWidget with GetSnackbar {
  static const id = 'outgoing_ticket_response';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    PreferenceProvider.of(context).activeSink(id);
    final bloc = OutgoingTicketResponseProvider.of(context);
    print('In');
    bloc.ticketIDSink(ModalRoute.of(context).settings.arguments);

    return StreamBuilder<String>(
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
                  bottomNavigationBar:
                      CustomBottomNavigationBar(drawerKey: _drawerKey),
                  drawer: CustomDrawer(),
                  appBar: CustomOutgoingTicketResponseAppbar(
                    bloc: bloc,
                    data: ticketDataSnapshot.data,
                    leadingOnPressed: () => Navigator.of(context).pop(),
                  ),
                  bottomSheet: CustomOutgoingTicketResponseBottomSheet(
                    scrollController: scrollController,
                    initialText: bloc.validReply,
                    cameraOnPressed: () async {
                      await Camera()
                          .openCameraDevice(bloc, context, _showCameraModal);
                    },
                    fileOnPressed: () async {
                      await _openFile();
                    },
                  ),
                  body: SingleChildScrollView(
                    controller: scrollController,
                    physics: ScrollPhysics(),
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 10.0),
                          CustomOutgoingTicketResponseMetaData(
                            data: ticketDataSnapshot.data,
                          ),
                          SizedBox(height: 5.0),
                          CustomOutgoingTicketResponseMediaFrame(
                            data: ticketDataSnapshot.data,
                          ),
                          CustomOutgoingTicketResponseStatusBar(
                            data: ticketDataSnapshot.data,
                          ),
                          SizedBox(height: 10.0),
                          CustomOutgoingTicketResponseComments(
                            bloc: bloc,
                          ),
                          SizedBox(height: 150.0),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  void _showCameraModal(BuildContext context, OutgoingTicketResponseBloc bloc) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext bc) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<bool>(
                  stream: bloc.isLoading,
                  initialData: false,
                  builder: (context, isLoadingSnapshot) {
                    return new Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Icon(
                                  FontAwesome.close,
                                  color: isLoadingSnapshot.data == false
                                      ? kPrimaryColor
                                      : kTertiaryColor,
                                ),
                                onTap: isLoadingSnapshot.data == false
                                    ? () {
                                        bloc.imagesSink(null);
                                        Navigator.pop(context);
                                      }
                                    : null,
                              ),
                              CustomOffstageProgressIndicator(
                                  status: !isLoadingSnapshot.data)
                            ],
                          ),
                        ),
                        Camera().views(bloc),
                        //CustomOutgoingTicketResponseMediaFrame(),

                        CustomOutgoingTicketResponseBottomSheet(
                          scrollController: scrollController,
                          cameraOnPressed: () async {
                            await Camera()
                                .openCameraDevice(bloc, context, null);
                          },
                          responseType: 'camera',
                          initialText: bloc.validReply,
                        ),

//              _buildResponseBottomSheet(context),
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openFile() async {}
}
