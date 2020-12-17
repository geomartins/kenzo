import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';

class OutgoingTicketResponse extends StatelessWidget with GetSnackbar {
  static const id = 'outgoing_ticket_response';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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
          await _openCameraDevice(bloc, context, _showCameraModal);
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                  ],
                ),
              ),
              cameraViews(bloc),
              //CustomOutgoingTicketResponseMediaFrame(),
              CustomOutgoingTicketResponseBottomSheet(
                cameraOnPressed: () async {
                  await _openCameraDevice(bloc, context, null);
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

  Future<void> _openCameraDevice(OutgoingTicketResponseBloc bloc,
      BuildContext context, Function next) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      List<File> testImg = [];
      testImg.add(File(pickedFile.path));
      for (File x in bloc.validImages()) {
        testImg.add(x);
      }
      bloc.imagesSink(testImg);

      if (next != null) {
        next(context, bloc);
      }
    } else {
      buildCustomSnackbar(
          messageText: 'No Asset selected',
          titleText: "Oops",
          iconColor: Colors.red,
          icon: Icons.error);
    }
  }

  Future<void> _openFile() async {}

  Widget cameraViews(bloc) {
    return Container(
      width: double.infinity,
      height: 200.0,
      child: StreamBuilder<List<File>>(
        stream: bloc.images,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data != null) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width / 2,
                    height: 200,
                    color: kTertiaryColor.shade200,
                    child: Image.file(snapshot.data[index], fit: BoxFit.cover),
                  );
                }
                return Text('No Image');
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
