import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/config/constants.dart';
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
  final String ticketID;

  OutgoingTicketResponse({this.ticketID});

  @override
  Widget build(BuildContext context) {
    PreferenceProvider.of(context).activeSink(id);
    final bloc = OutgoingTicketResponseProvider.of(context);
    print('In');

    return Scaffold(
      key: _drawerKey,
      bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
      drawer: CustomDrawer(),
      appBar: CustomOutgoingTicketResponseAppbar(
        leadingOnPressed: () => Navigator.of(context).pop(),
      ),
      bottomSheet: CustomOutgoingTicketResponseBottomSheet(
        cameraOnPressed: () async {
          await Camera().openCameraDevice(bloc, context, _showCameraModal);
        },
        fileOnPressed: () async {
          await _openFile();
        },
      ),
      body: Container(
        width: double.infinity,
        child: ListView(
          children: [
            SizedBox(height: 10.0),
            CustomOutgoingTicketResponseMetaData(),
            CustomOutgoingTicketResponseMediaFrame(),
            CustomOutgoingTicketResponseStatusBar(),
            SizedBox(height: 10.0),
            CustomOutgoingTicketResponseComments(),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }

  void _showCameraModal(BuildContext context, OutgoingTicketResponseBloc bloc) {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: double.infinity,
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Icon(
                        FontAwesome.close,
                        color: kTertiaryColor,
                      ),
                      onTap: () {
                        bloc.imagesSink(null);
                        Navigator.pop(context);
                      },
                    ),
                    CustomOffstageProgressIndicator(status: false),
                  ],
                ),
              ),
              Camera().views(bloc),
              //CustomOutgoingTicketResponseMediaFrame(),
              CustomOutgoingTicketResponseBottomSheet(
                cameraOnPressed: () async {
                  await Camera().openCameraDevice(bloc, context, null);
                },
                responseType: 'camera',
              ),

//              _buildResponseBottomSheet(context),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openFile() async {}
}
