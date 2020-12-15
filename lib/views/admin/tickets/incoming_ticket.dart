import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/components/custom_incoming_ticket_list_tile.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/providers/preference_provider.dart';

import 'incoming_ticket_response.dart';

class IncomingTicket extends StatelessWidget {
  static const id = 'incoming_ticket';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PreferenceProvider.of(context).activeSink(id);

    return CustomAuthBuilder(
        child: DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios_outlined),
            onTap: () => Navigator.of(context).pop(),
          ),
          actions: [
            Icon(Icons.search),
            SizedBox(width: 20.0),
          ],
          title: Text(
            'Incoming Tickets',
            style: TextStyle(color: Colors.black87, letterSpacing: 1.0),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: kPrimaryColor),
          bottom: TabBar(
            labelStyle: TextStyle(
              fontSize: 15.0,
            ),
            tabs: [
              Tab(child: Text('ALL', style: TextStyle(color: Colors.black54))),
              Tab(
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('OPENED',
                          style: TextStyle(color: Colors.black54)))),
              Tab(
                child: Text(
                  'ONGOING',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'CLOSED',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
        key: _drawerKey,
        bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            _buildAllTickets(context),
            _buildOpenedTickets(context),
            _buildOngoingTickets(context),
            _buildClosedTickets(context),
          ],
        ),
      ),
    ));
  }

  Widget _buildAllTickets(BuildContext context) {
    return ListView(
      children: [
        CustomIncomingTicketListTile(
          onPressed: () =>
              Navigator.pushNamed(context, IncomingTicketResponse.id),
        ),
      ],
    );
  }

  Widget _buildOngoingTickets(BuildContext context) {
    return ListView(
      children: [
        CustomIncomingTicketListTile(
          onPressed: () =>
              Navigator.pushNamed(context, IncomingTicketResponse.id),
        ),
      ],
    );
  }

  Widget _buildClosedTickets(BuildContext context) {
    return ListView(
      children: [
        CustomIncomingTicketListTile(
          onPressed: () =>
              Navigator.pushNamed(context, IncomingTicketResponse.id),
        ),
      ],
    );
  }

  Widget _buildOpenedTickets(BuildContext context) {
    return ListView(
      children: [
        CustomIncomingTicketListTile(
          onPressed: () =>
              Navigator.pushNamed(context, IncomingTicketResponse.id),
        ),
      ],
    );
  }
}
