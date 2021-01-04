import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/outgoing_ticket_bloc.dart';
import 'package:staff_portal/components/admin/tickets/custom_outgoing_ticket_search.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_outgoing_ticket_loading_container.dart';
import 'package:staff_portal/components/custom_drawer.dart';
import 'package:staff_portal/components/custom_outgoing_ticket_list_tile.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/models/ticket_model.dart';
import 'package:staff_portal/providers/outgoing_ticket_provider.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_create.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_response.dart';

class OutgoingTicket extends StatelessWidget {
  static const id = 'outgoing_ticket';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final ScrollController _openedTicketsScrollController =
      new ScrollController();
  final ScrollController _closedTicketsScrollController =
      new ScrollController();

  void dependencies(OutgoingTicketBloc bloc) async {
    await bloc.fetchDepartment();
    bloc.fetchOpenedTickets(perPage: 10);
    bloc.fetchClosedTickets(perPage: 9);
  }

  openedTicketsScroller(context, OutgoingTicketBloc bloc) {
    _openedTicketsScrollController.addListener(() {
      double maxScroll =
          _openedTicketsScrollController.position.maxScrollExtent;
      double currentScroll = _openedTicketsScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      print(currentScroll);
      if (maxScroll - currentScroll <= delta) {
        bloc.fetchOpenedTickets(perPage: 2, more: true);
      }
    });
  }

  closedTicketsScroller(context, OutgoingTicketBloc bloc) {
    _closedTicketsScrollController.addListener(() {
      double maxScroll =
          _closedTicketsScrollController.position.maxScrollExtent;
      double currentScroll = _closedTicketsScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      print(currentScroll);
      if (maxScroll - currentScroll <= delta) {
        bloc.fetchClosedTickets(perPage: 2, more: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PreferenceProvider.of(context).activeSink(id);
    final bloc = OutgoingTicketProvider.of(context);
    dependencies(bloc);
    openedTicketsScroller(context, bloc);
    closedTicketsScroller(context, bloc);

    return CustomAuthBuilder(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              // await bloc.fetchClosedTickets(perPage: 2);
              // print('done');
              Navigator.of(context).pushNamed(OutgoingTicketCreate.id);
            },
          ),
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
                      delegate: CustomOutgoingTicketSearch(bloc: bloc));
                },
                icon: Icon(Icons.search),
              )
              // Icon(Icons.search),
              // SizedBox(width: 20.0),
            ],
            title: Text(
              'Outgoing Tickets',
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
                  child:
                      Text('PENDING', style: TextStyle(color: Colors.black54)),
                ),
                Tab(
                  child:
                      Text('CLOSED', style: TextStyle(color: Colors.black54)),
                ),
              ],
            ),
          ),
          key: _drawerKey,
          bottomNavigationBar: CustomBottomNavigationBar(drawerKey: _drawerKey),
          drawer: CustomDrawer(),
          body: StreamBuilder<String>(
              stream: bloc.department,
              initialData: null,
              builder: (context, departmentSnapshot) {
                return StreamBuilder<List<TicketModel>>(
                    stream: bloc.allTickets,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TicketModel>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CustomOutgoingTicketLoadingContainer();
                      }

                      return TabBarView(
                        children: [
                          _buildOpenedTickets(bloc: bloc),
                          _buildOpenedTickets(bloc: bloc),
                          _buildClosedTickets(bloc: bloc),
                          // _buildTickets(context, closedTickets),
                        ],
                      );
                    });
              }),
          // body: TabBarView(
          //   children: [
          //     // _buildAllTickets(context),
          //     _buildTickets(context, bloc, 'opened'),
          //     Text('Outgoing'),
          //     Text('Closed')
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _buildOpenedTickets({OutgoingTicketBloc bloc}) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: bloc.openedTickets,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomOutgoingTicketLoadingContainer();
          }

          final datas =
              bloc.convertQueryDocumentSnapshotToTicketModel(snapshot.data);

          return ListView.builder(
              controller: _openedTicketsScrollController,
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomOutgoingTicketListTile(
                  title: datas[index].title != null
                      ? datas[index].title
                      : 'UnknowX',
                  department: datas[index].toDepartment,
                  datetime: datas[index].createdAt.toDate(),
                  onPressed: () => Navigator.pushNamed(
                      context, OutgoingTicketResponse.id,
                      arguments: datas[index].id),
                );
              });
        });
  }

  Widget _buildClosedTickets({OutgoingTicketBloc bloc}) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: bloc.closedTickets,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomOutgoingTicketLoadingContainer();
          }

          final datas =
              bloc.convertQueryDocumentSnapshotToTicketModel(snapshot.data);

          return ListView.builder(
              controller: _closedTicketsScrollController,
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomOutgoingTicketListTile(
                  title: datas[index].title != null
                      ? datas[index].title
                      : 'UnknowX',
                  department: datas[index].toDepartment,
                  datetime: datas[index].createdAt.toDate(),
                  onPressed: () => Navigator.pushNamed(
                      context, OutgoingTicketResponse.id,
                      arguments: datas[index].id),
                );
              });
        });
  }
}
