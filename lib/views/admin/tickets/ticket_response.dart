import 'package:flutter/material.dart';
import 'package:staff_portal/components/admin/tickets/custom_ticket_response_appbar.dart';
import 'package:staff_portal/components/admin/tickets/custom_ticket_response_bottom_sheet.dart';
import 'package:staff_portal/components/admin/tickets/custom_ticket_response_comments.dart';
import 'package:staff_portal/components/admin/tickets/custom_ticket_response_media_frame.dart';
import 'package:staff_portal/components/admin/tickets/custom_ticket_response_meta_data.dart';
import 'package:staff_portal/components/admin/tickets/custom_ticket_response_status_bar.dart';
import 'package:staff_portal/components/custom_author_box.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/models/profile_model.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/providers/ticket_response_provider.dart';
import 'package:staff_portal/services/firebase_messaging_service.dart';
import 'package:staff_portal/services/firestore_service.dart';
import 'package:staff_portal/utilities/device_file.dart';
import '../../../components/builders/custom_auth_builder.dart';

class TicketResponse extends StatefulWidget with GetSnackbar {
  static const id = 'ticket_response';

  @override
  _TicketResponseState createState() => _TicketResponseState();
}

class _TicketResponseState extends State<TicketResponse> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final scrollController = new ScrollController();

  @override
  void initState() {
    FirebaseMessagingService().configure(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //user department
    //ticketId
    //TicketData
    PreferenceProvider.of(context).activeSink(TicketResponse.id);
    final bloc = TicketResponseProvider.of(context);
    bloc.ticketIDSink(ModalRoute.of(context).settings.arguments);
    bloc.responseTypeSink('outgoing');

    return CustomAuthBuilder(
      child: FutureBuilder<ProfileModel>(
        future: FirestoreService().getProfileByUID(),
        builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Text('Something went wrong in futureBuilder'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: CustomOffstageProgressIndicator(status: false));
          }

          bloc.departmentSink(snapshot.data.department);
          return StreamBuilder<bool>(
              stream: bloc.confirmDepartmentAndTicketID,
              builder: (context, confirmDepartmentAndTicketIDSnapshot) {
                if (confirmDepartmentAndTicketIDSnapshot.hasError) {
                  return Scaffold(
                      body: Text(
                          'Something went wrong in confirmDepartmentAndTicketIDSnapshot'));
                }
                if (confirmDepartmentAndTicketIDSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Scaffold(
                      body: CustomOffstageProgressIndicator(status: false));
                }

                return StreamBuilder<TicketModel>(
                    stream: bloc.ticketData,
                    builder: (context,
                        AsyncSnapshot<TicketModel> ticketDataSnapshot) {
                      if (ticketDataSnapshot.hasError) {
                        return Text('Something went wrong in ticketData');
                      }
                      if (ticketDataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Scaffold(
                            body:
                                CustomOffstageProgressIndicator(status: false));
                      }

                      return Scaffold(
                        key: _drawerKey,
                        bottomNavigationBar: CustomBottomNavigationBar(),
                        appBar: CustomTicketResponseAppbar(
                          bloc: bloc,
                          data: ticketDataSnapshot.data,
                          leadingOnPressed: () => Navigator.of(context).pop(),
                        ),
                        extendBody: true,
                        bottomSheet: CustomTicketResponseBottomSheet(
                          scrollController: scrollController,
                          initialText: bloc.validReply,
                          fileOnPressed: () async {
                            await DeviceFile().openFiles(
                                bloc, context, ['jpg', 'png', 'pdf'], null);
                          },
                        ),
                        body: SafeArea(
                          minimum: EdgeInsets.symmetric(vertical: 20.0),
                          top: true,
                          bottom: true,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: ScrollPhysics(),
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  SizedBox(height: 10.0),
                                  CustomTicketResponseMetaData(
                                    data: ticketDataSnapshot.data,
                                    responseType: bloc.validResponseType,
                                  ),
                                  SizedBox(height: 5.0),
                                  CustomAuthorBox(
                                    author: ticketDataSnapshot
                                            .data.user['firstname'] +
                                        ' ' +
                                        ticketDataSnapshot
                                            .data.user['lastname'],
                                  ),
                                  SizedBox(height: 5.0),
                                  CustomTicketResponseMediaFrame(
                                    data: ticketDataSnapshot.data,
                                  ),
                                  CustomTicketResponseStatusBar(
                                    data: ticketDataSnapshot.data,
                                    bloc: bloc,
                                  ),
                                  SizedBox(height: 10.0),
                                  CustomTicketResponseComments(
                                    bloc: bloc,
                                  ),
                                  SizedBox(height: 150.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              });
        },
      ),
    );
  }
}
