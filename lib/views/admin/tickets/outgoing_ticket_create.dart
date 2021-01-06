import 'package:flutter/material.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/components/forms/custom_outgoing_ticket_create_form.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/providers/outgoing_ticket_create_provider.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/services/firebase_messaging_service.dart';

class OutgoingTicketCreate extends StatelessWidget with GetSnackbar {
  static const id = 'outgoing_ticket_create';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  OutgoingTicketCreate() {
    FirebaseMessagingService().topicSubscription(topic: 'ticket');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessagingService().configure(context);
    PreferenceProvider.of(context).activeSink(id);
    final bloc = OutgoingTicketCreateProvider.of(context);

    return CustomAuthBuilder(
      child: Scaffold(
        key: _drawerKey,
        bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text(
            'Create Ticket',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => bloc.clear(),
                  child: Text('Clear', style: TextStyle(color: Colors.black87)),
                ),
                SizedBox(width: 20.0),
              ],
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: kTertiaryColor.shade300,
          elevation: 1.0,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          minimum: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: CustomOutgoingTicketCreateForm(),
          ),
        ),
      ),
    );
  }
}
