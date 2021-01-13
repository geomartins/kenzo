import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/incoming_ticket_bloc.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_list_tile.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_loading_container.dart';
import 'package:staff_portal/components/admin/tickets/incoming/custom_incoming_ticket_search.dart';
import 'package:staff_portal/components/builders/custom_approved_user_builder.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/incoming_ticket_scrollers.dart';
import 'package:staff_portal/providers/incoming_ticket_provider.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/services/firebase_messaging_service.dart';
import 'package:staff_portal/views/admin/tickets/incoming_ticket_response.dart';

class IncomingTicket extends StatelessWidget with IncomingTicketScrollers {
  static const id = 'incoming_ticket';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void dependencies(IncomingTicketBloc bloc) async {
    await bloc.fetchDepartment();
    await bloc.fetchOpenedTickets(perPage: 10);
  }

  void scrollers(context, IncomingTicketBloc bloc) {
    openedTicketsScroller(context, bloc);
    pendingTicketsScroller(context, bloc);
    closedTicketsScroller(context, bloc);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessagingService().configure(context);
    PreferenceProvider.of(context).activeSink(id);
    final bloc = IncomingTicketProvider.of(context);
    dependencies(bloc);
    scrollers(context, bloc);

    return CustomAuthBuilder(
      child: CustomApprovedUserBuilder(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: Icon(Icons.arrow_back_ios_outlined),
                onTap: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await showSearch(
                        context: context,
                        delegate: CustomIncomingTicketSearch(bloc: bloc));
                  },
                  icon: Icon(Icons.search),
                )
                // Icon(Icons.search),
                // SizedBox(width: 20.0),
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
                  Tab(
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text('OPENED',
                            style: TextStyle(color: Colors.black54))),
                  ),
                  Tab(
                    child: Text('PENDING',
                        style: TextStyle(color: Colors.black54)),
                  ),
                  Tab(
                    child:
                        Text('CLOSED', style: TextStyle(color: Colors.black54)),
                  ),
                ],
              ),
            ),
            key: _drawerKey,
            bottomNavigationBar: CustomBottomNavigationBar(),
            body: StreamBuilder<String>(
                stream: bloc.department,
                initialData: null,
                builder: (context, departmentSnapshot) {
                  if (departmentSnapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (departmentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CustomIncomingTicketLoadingContainer();
                  }
                  return TabBarView(
                    children: [
                      _buildOpenedTickets(bloc: bloc),
                      _buildPendingTickets(bloc: bloc),
                      _buildClosedTickets(bloc: bloc),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildOpenedTickets({IncomingTicketBloc bloc}) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: bloc.openedTickets,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomIncomingTicketLoadingContainer();
          }

          final datas =
              bloc.convertQueryDocumentSnapshotToTicketModel(snapshot.data);

          return ListView.builder(
              controller: openedTicketsScrollController,
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomIncomingTicketListTile(
                  title: datas[index].title != null
                      ? datas[index].title
                      : 'UnknowX',
                  department: datas[index].fromDepartment,
                  datetime: datas[index].createdAt.toDate(),
                  onPressed: () => Navigator.pushNamed(
                      context, IncomingTicketResponse.id,
                      arguments: datas[index].id),
                );
              });
        });
  }

  Widget _buildClosedTickets({IncomingTicketBloc bloc}) {
    bloc.fetchClosedTickets(perPage: 9);
    return StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: bloc.closedTickets,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomIncomingTicketLoadingContainer();
          }

          final datas =
              bloc.convertQueryDocumentSnapshotToTicketModel(snapshot.data);
          print('Closed :::::::::::::: $datas');

          return ListView.builder(
              controller: closedTicketsScrollController,
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomIncomingTicketListTile(
                  title: datas[index].title != null
                      ? datas[index].title
                      : 'UnknowX',
                  department: datas[index].fromDepartment,
                  datetime: datas[index].createdAt.toDate(),
                  onPressed: () => Navigator.pushNamed(
                      context, IncomingTicketResponse.id,
                      arguments: datas[index].id),
                );
              });
        });
  }

  Widget _buildPendingTickets({IncomingTicketBloc bloc}) {
    bloc.fetchPendingTickets(perPage: 9);
    return StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: bloc.pendingTickets,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomIncomingTicketLoadingContainer();
          }

          final datas =
              bloc.convertQueryDocumentSnapshotToTicketModel(snapshot.data);

          return ListView.builder(
              controller: pendingTicketsScrollController,
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomIncomingTicketListTile(
                  title: datas[index].title != null
                      ? datas[index].title
                      : 'UnknowX',
                  department: datas[index].fromDepartment,
                  datetime: datas[index].createdAt.toDate(),
                  onPressed: () => Navigator.pushNamed(
                      context, IncomingTicketResponse.id,
                      arguments: datas[index].id),
                );
              });
        });
  }
}
